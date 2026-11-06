import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';

class ValidationException implements Exception {
  const ValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

const allowedUnits = ['un', 'kg', 'g', 'l', 'ml'];
const _currentListKey = 'current_list_id';
const _uuid = Uuid();

/// Estados da lista (coluna shopping_state).
abstract final class ShoppingState {
  static const planning = 'planning';
  static const shopping = 'shopping';
  static const finished = 'finished';
}

/// Tipo do snapshot de preço (coluna kind).
abstract final class SnapshotKind {
  static const predicted = 'predicted';
  static const found = 'found';
}

/// Fonte local de listas e itens. Funciona sem rede, conta ou localização.
class ShoppingListRepository {
  ShoppingListRepository(this._db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  // ---- Categorias ----

  Stream<List<LocalCategory>> watchCategories() => (_db.select(
    _db.localCategories,
  )..orderBy([(c) => OrderingTerm.asc(c.sortOrder)])).watch();

  // ---- Listas ----

  Stream<List<ShoppingList>> watchLists() => (_db.select(
    _db.shoppingLists,
  )..orderBy([(l) => OrderingTerm.desc(l.updatedAt)])).watch();

  /// Lista atual (preferência local); null quando não há nenhuma.
  Stream<ShoppingList?> watchCurrentList() {
    final query = _db.select(_db.shoppingLists).join([
      innerJoin(
        _db.preferences,
        _db.preferences.value.equalsExp(_db.shoppingLists.id) &
            _db.preferences.key.equals(_currentListKey),
      ),
    ]);
    return query.watchSingleOrNull().map(
      (r) => r?.readTable(_db.shoppingLists),
    );
  }

  Future<ShoppingList> createList(
    String name, {
    bool makeCurrent = true,
  }) async {
    final clean = _validName(name, 'A lista', 80);
    final now = _now();
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db
          .into(_db.shoppingLists)
          .insert(
            ShoppingListsCompanion.insert(
              id: id,
              name: clean,
              createdAt: now,
              updatedAt: now,
            ),
          );
      if (makeCurrent) await _setCurrent(id);
    });
    return (_db.select(
      _db.shoppingLists,
    )..where((l) => l.id.equals(id))).getSingle();
  }

  /// Garante uma lista atual, criando "Minha lista" no primeiro uso.
  Future<ShoppingList> ensureCurrentList() async {
    final current = await watchCurrentList().first;
    if (current != null) return current;
    final existing =
        await (_db.select(_db.shoppingLists)
              ..orderBy([(l) => OrderingTerm.desc(l.updatedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) {
      await setCurrentList(existing.id);
      return existing;
    }
    return createList('Minha lista');
  }

  Future<void> setCurrentList(String listId) => _setCurrent(listId);

  Future<void> _setCurrent(String listId) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(
        PreferencesCompanion.insert(key: _currentListKey, value: listId),
      );

  Future<void> renameList(String listId, String name) async {
    final clean = _validName(name, 'A lista', 80);
    await (_db.update(
      _db.shoppingLists,
    )..where((l) => l.id.equals(listId))).write(
      ShoppingListsCompanion(name: Value(clean), updatedAt: Value(_now())),
    );
  }

  /// Remove a lista e seus itens (cascata local, escolha explícita do usuário).
  Future<void> deleteList(String listId) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.shoppingLists,
      )..where((l) => l.id.equals(listId))).go();
      await (_db.delete(_db.preferences)..where(
            (p) => p.key.equals(_currentListKey) & p.value.equals(listId),
          ))
          .go();
    });
  }

  // ---- Orçamento e modo compra ----

  /// Define o orçamento (null remove). Deve ser maior que zero.
  Future<void> setBudget(String listId, Decimal? budget) async {
    if (budget != null && budget <= Decimal.zero) {
      throw const ValidationException(
        'O orçamento precisa ser maior que zero.',
      );
    }
    await _updateList(listId, ShoppingListsCompanion(budget: Value(budget)));
  }

  /// Começa a compra: a lista passa a "comprando".
  Future<void> startShopping(String listId) => _updateList(
    listId,
    ShoppingListsCompanion(
      shoppingState: const Value(ShoppingState.shopping),
      startedAt: Value(_now()),
      finishedAt: const Value(null),
    ),
  );

  /// Finaliza a compra. Itens pendentes continuam pendentes (nada é apagado).
  Future<void> finishShopping(String listId) => _updateList(
    listId,
    ShoppingListsCompanion(
      shoppingState: const Value(ShoppingState.finished),
      finishedAt: Value(_now()),
    ),
  );

  /// Volta a montar a lista para uma nova compra: zera coletado, "não
  /// encontrei", substituições e preços encontrados. Preços previstos e o
  /// histórico de snapshots permanecem.
  Future<void> startNewShopping(String listId) async {
    await _db.transaction(() async {
      await (_db.update(
        _db.shoppingListItems,
      )..where((i) => i.listId.equals(listId))).write(
        const ShoppingListItemsCompanion(
          checked: Value(false),
          notFound: Value(false),
          substituteName: Value(null),
          foundPrice: Value(null),
        ),
      );
      await _updateList(
        listId,
        const ShoppingListsCompanion(
          shoppingState: Value(ShoppingState.planning),
          startedAt: Value(null),
          finishedAt: Value(null),
        ),
      );
    });
  }

  Future<void> _updateList(String listId, ShoppingListsCompanion changes) =>
      (_db.update(_db.shoppingLists)..where((l) => l.id.equals(listId))).write(
        changes.copyWith(updatedAt: Value(_now())),
      );

  // ---- Itens ----

  Stream<List<ShoppingListItem>> watchItems(String listId) =>
      (_db.select(_db.shoppingListItems)
            ..where((i) => i.listId.equals(listId))
            ..orderBy([
              (i) => OrderingTerm.asc(i.position),
              (i) => OrderingTerm.asc(i.createdAt),
              (i) => OrderingTerm.asc(i.id),
            ]))
          .watch();

  Future<ShoppingListItem> addItem(
    String listId, {
    required String name,
    required Decimal quantity,
    String unit = 'un',
    String? categorySlug,
    Decimal? unitPrice,
  }) async {
    final item = ShoppingListItem(
      id: _uuid.v4(),
      listId: listId,
      name: _validName(name, 'O item', 120),
      quantity: _validQuantity(quantity),
      unit: _validUnit(unit),
      categorySlug: categorySlug,
      checked: false,
      position: await _nextPosition(listId),
      notFound: false,
      unitPrice: _validPrice(unitPrice),
      createdAt: _now(),
    );
    await _db.transaction(() async {
      await _db.into(_db.shoppingListItems).insert(item);
      if (item.unitPrice != null) {
        await _snapshot(item, item.unitPrice!, SnapshotKind.predicted);
      }
      await _touch(item.listId);
    });
    return item;
  }

  /// Reinsere um item removido (desfazer), preservando id e posição.
  Future<void> restoreItem(ShoppingListItem item) async {
    await _db.transaction(() async {
      await _db.into(_db.shoppingListItems).insertOnConflictUpdate(item);
      await _touch(item.listId);
    });
  }

  /// Grava de volta o estado anterior de um item (desfazer de marcação,
  /// "não encontrei", substituição ou preço encontrado).
  Future<void> replaceItem(ShoppingListItem previous) async {
    await _db.transaction(() async {
      await _db.update(_db.shoppingListItems).replace(previous);
      await _touch(previous.listId);
    });
  }

  /// Atualiza o item. [unitPrice] é o preço PREVISTO por unidade (null =
  /// desconhecido). Cada mudança de preço gera um snapshot; o histórico não é
  /// apagado.
  Future<void> updateItem(
    String itemId, {
    required String name,
    required Decimal quantity,
    required String unit,
    String? categorySlug,
    required Decimal? unitPrice,
  }) async {
    final item = await _item(itemId);
    final price = _validPrice(unitPrice);
    await _db.transaction(() async {
      await (_db.update(
        _db.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).write(
        ShoppingListItemsCompanion(
          name: Value(_validName(name, 'O item', 120)),
          quantity: Value(_validQuantity(quantity)),
          unit: Value(_validUnit(unit)),
          categorySlug: Value(categorySlug),
          unitPrice: Value(price),
        ),
      );
      if (price != null && price != item.unitPrice) {
        await _snapshot(item, price, SnapshotKind.predicted);
      }
      await _touch(item.listId);
    });
  }

  /// Marca/desmarca como coletado (no carrinho). Desmarcar limpa o resultado
  /// da compra do item (preço encontrado, substituição, "não encontrei").
  Future<void> setChecked(String itemId, {required bool checked}) async {
    final item = await _item(itemId);
    await _db.transaction(() async {
      await (_db.update(
        _db.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).write(
        ShoppingListItemsCompanion(
          checked: Value(checked),
          notFound: const Value(false),
          substituteName: checked ? const Value.absent() : const Value(null),
          foundPrice: checked ? const Value.absent() : const Value(null),
        ),
      );
      await _touch(item.listId);
    });
  }

  /// Coletou o item no mercado, com preço encontrado e/ou substituto opcionais.
  /// O preço previsto NÃO é alterado.
  Future<void> collectItem(
    String itemId, {
    Decimal? foundPrice,
    String? substituteName,
  }) async {
    final item = await _item(itemId);
    final price = _validPrice(foundPrice);
    final substitute = substituteName == null || substituteName.trim().isEmpty
        ? null
        : _validName(substituteName, 'O substituto', 120);
    await _db.transaction(() async {
      await (_db.update(
        _db.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).write(
        ShoppingListItemsCompanion(
          checked: const Value(true),
          notFound: const Value(false),
          foundPrice: Value(price),
          substituteName: Value(substitute),
        ),
      );
      if (price != null) {
        await _snapshot(item, price, SnapshotKind.found);
      }
      await _touch(item.listId);
    });
  }

  /// "Não encontrei": sai do previsto e não conta como coletado.
  Future<void> markNotFound(String itemId) async {
    final item = await _item(itemId);
    await _db.transaction(() async {
      await (_db.update(
        _db.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).write(
        const ShoppingListItemsCompanion(
          checked: Value(false),
          notFound: Value(true),
          foundPrice: Value(null),
          substituteName: Value(null),
        ),
      );
      await _touch(item.listId);
    });
  }

  Future<void> deleteItem(String itemId) async {
    final item = await _item(itemId);
    await _db.transaction(() async {
      await (_db.delete(
        _db.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).go();
      await _touch(item.listId);
    });
  }

  /// Histórico de preços (append-only) de um item, do mais antigo ao mais novo.
  Future<List<PriceSnapshot>> snapshotsFor(String itemId) =>
      (_db.select(_db.priceSnapshots)
            ..where((s) => s.itemId.equals(itemId))
            ..orderBy([
              (s) => OrderingTerm.asc(s.capturedAt),
              (s) => OrderingTerm.asc(s.id),
            ]))
          .get();

  // ---- Internos ----

  Future<ShoppingListItem> _item(String itemId) => (_db.select(
    _db.shoppingListItems,
  )..where((i) => i.id.equals(itemId))).getSingle();

  Future<void> _snapshot(ShoppingListItem item, Decimal amount, String kind) =>
      _db
          .into(_db.priceSnapshots)
          .insert(
            PriceSnapshotsCompanion.insert(
              id: _uuid.v4(),
              itemId: item.id,
              amount: amount,
              kind: Value(kind),
              unit: item.unit,
              capturedAt: _now(),
            ),
          );

  Future<void> _touch(String listId) =>
      (_db.update(_db.shoppingLists)..where((l) => l.id.equals(listId))).write(
        ShoppingListsCompanion(updatedAt: Value(_now())),
      );

  Future<int> _nextPosition(String listId) async {
    final maxPosition = _db.shoppingListItems.position.max();
    final row =
        await (_db.selectOnly(_db.shoppingListItems)
              ..addColumns([maxPosition])
              ..where(_db.shoppingListItems.listId.equals(listId)))
            .getSingle();
    return (row.read(maxPosition) ?? -1) + 1;
  }

  String _validName(String raw, String subject, int max) {
    final clean = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (clean.isEmpty) {
      throw ValidationException('$subject precisa de um nome.');
    }
    if (clean.length > max) {
      throw ValidationException('$subject aceita até $max caracteres.');
    }
    return clean;
  }

  Decimal _validQuantity(Decimal quantity) {
    if (quantity <= Decimal.zero) {
      throw const ValidationException(
        'A quantidade precisa ser maior que zero.',
      );
    }
    if (quantity.scale > 4) {
      throw const ValidationException('Use no máximo 4 casas decimais.');
    }
    return quantity;
  }

  String _validUnit(String unit) {
    if (!allowedUnits.contains(unit)) {
      throw ValidationException('Unidade inválida: $unit.');
    }
    return unit;
  }

  /// Preço: ausente é null (desconhecido). Zero não é aceito como valor
  /// provisório; negativo é inválido.
  Decimal? _validPrice(Decimal? price) {
    if (price == null) return null;
    if (price < Decimal.zero) {
      throw const ValidationException('O preço não pode ser negativo.');
    }
    if (price == Decimal.zero) {
      throw const ValidationException(
        'Informe um preço maior que zero ou deixe em branco.',
      );
    }
    if (price.scale > 4) {
      throw const ValidationException(
        'Use no máximo 4 casas decimais no preço.',
      );
    }
    return price;
  }
}
