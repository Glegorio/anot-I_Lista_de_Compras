import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/core/database/app_database.dart';
import 'package:anotai_lista/features/lists/data/shopping_list_repository.dart';

Decimal d(String v) => Decimal.parse(v);

void main() {
  late AppDatabase db;
  late ShoppingListRepository repo;
  var tick = 0;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tick = 0;
    repo = ShoppingListRepository(
      db,
      clock: () => DateTime.utc(2026, 11, 4).add(Duration(seconds: tick++)),
    );
  });
  tearDown(() => db.close());

  test('categorias iniciais vêm da especificação de UX, em ordem', () async {
    final categories = await repo.watchCategories().first;
    expect(categories.map((c) => c.name), [
      'Hortifrúti',
      'Padaria',
      'Carnes',
      'Laticínios',
      'Mercearia',
      'Bebidas',
      'Limpeza',
      'Higiene',
    ]);
  });

  test('ensureCurrentList cria "Minha lista" uma única vez', () async {
    expect(await repo.watchCurrentList().first, isNull);
    final first = await repo.ensureCurrentList();
    final second = await repo.ensureCurrentList();
    expect(first.name, 'Minha lista');
    expect(second.id, first.id);
    expect((await repo.watchLists().first).length, 1);
  });

  test(
    'CRUD de itens livres com quantidade fracionária e sem produto',
    () async {
      final list = await repo.ensureCurrentList();
      final rice = await repo.addItem(
        list.id,
        name: '  Arroz   integral ',
        quantity: d('0.333'),
        unit: 'kg',
        categorySlug: 'mercearia',
      );
      await repo.addItem(list.id, name: 'Banana', quantity: d('2'));

      var items = await repo.watchItems(list.id).first;
      expect(items.map((i) => i.name), ['Arroz integral', 'Banana']);
      expect(items.first.quantity, d('0.333'));
      expect(items.first.unitPrice, isNull); // preço desconhecido, não zero

      await repo.updateItem(
        rice.id,
        name: 'Arroz',
        quantity: d('2'),
        unit: 'kg',
        categorySlug: null,
        unitPrice: null,
      );
      await repo.setChecked(rice.id, checked: true);
      items = await repo.watchItems(list.id).first;
      expect(items.first.name, 'Arroz');
      expect(items.first.checked, isTrue);
      expect(items.first.categorySlug, isNull);

      await repo.deleteItem(rice.id);
      items = await repo.watchItems(list.id).first;
      expect(items.map((i) => i.name), ['Banana']);
    },
  );

  test('desfazer remoção restaura item com o mesmo id e posição', () async {
    final list = await repo.ensureCurrentList();
    final a = await repo.addItem(list.id, name: 'A', quantity: d('1'));
    await repo.addItem(list.id, name: 'B', quantity: d('1'));
    await repo.deleteItem(a.id);
    await repo.restoreItem(a);
    final items = await repo.watchItems(list.id).first;
    expect(items.map((i) => i.name), ['A', 'B']);
    expect(items.first.id, a.id);
  });

  test('validações rejeitam dados inválidos', () async {
    final list = await repo.ensureCurrentList();
    Future<void> add({String name = 'X', String q = '1', String unit = 'un'}) =>
        repo.addItem(list.id, name: name, quantity: d(q), unit: unit);
    await expectLater(add(name: '   '), throwsA(isA<ValidationException>()));
    await expectLater(
      add(name: 'x' * 121),
      throwsA(isA<ValidationException>()),
    );
    await expectLater(add(q: '0'), throwsA(isA<ValidationException>()));
    await expectLater(add(q: '1.23456'), throwsA(isA<ValidationException>()));
    await expectLater(add(unit: 'caixa'), throwsA(isA<ValidationException>()));
    await expectLater(
      repo.addItem(list.id, name: 'P', quantity: d('1'), unitPrice: d('-1')),
      throwsA(isA<ValidationException>()),
    );
    await expectLater(
      repo.createList(' '),
      throwsA(isA<ValidationException>()),
    );
    expect(await repo.watchItems(list.id).first, isEmpty);
  });

  test(
    'banco rejeita quantidade zero e preço negativo mesmo sem o repositório',
    () async {
      final list = await repo.ensureCurrentList();
      Future<void> raw(String q, String? price) => db.customInsert(
        'INSERT INTO shopping_list_items (id, list_id, name, quantity, unit, '
        'position, unit_price, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        variables: [
          Variable.withString('id-$q-$price'),
          Variable.withString(list.id),
          Variable.withString('x'),
          Variable.withString(q),
          Variable.withString('un'),
          Variable.withInt(0),
          price == null
              ? const Variable<String>(null)
              : Variable.withString(price),
          Variable.withInt(0),
        ],
      );
      await expectLater(raw('0', null), throwsA(anything));
      await expectLater(raw('1', '-0.01'), throwsA(anything));
      await raw('1', '0.00'); // gratuidade explícita é válida; ausência é null
    },
  );

  test('preço ausente é null; zero e negativo são recusados', () async {
    final list = await repo.ensureCurrentList();
    final item = await repo.addItem(list.id, name: 'Leite', quantity: d('1'));
    expect(item.unitPrice, isNull);
    for (final bad in ['0', '-1', '1.23456']) {
      await expectLater(
        repo.addItem(list.id, name: 'X', quantity: d('1'), unitPrice: d(bad)),
        throwsA(isA<ValidationException>()),
        reason: bad,
      );
    }
  });

  test(
    'snapshots de preço previsto são append-only e guardam o histórico',
    () async {
      final list = await repo.ensureCurrentList();
      final item = await repo.addItem(
        list.id,
        name: 'Leite',
        quantity: d('1'),
        unit: 'l',
        unitPrice: d('5.49'),
      );
      await repo.updateItem(
        item.id,
        name: 'Leite',
        quantity: d('1'),
        unit: 'l',
        unitPrice: d('5.99'),
      );
      // Mesmo preço de novo: não duplica o snapshot.
      await repo.updateItem(
        item.id,
        name: 'Leite',
        quantity: d('2'),
        unit: 'l',
        unitPrice: d('5.99'),
      );
      final snapshots = await repo.snapshotsFor(item.id);
      expect(snapshots.map((s) => s.amount), [d('5.49'), d('5.99')]);
      expect(snapshots.every((s) => s.kind == SnapshotKind.predicted), isTrue);
      expect(snapshots.first.currency, 'BRL');
      expect(snapshots.first.unit, 'l');

      // Remover o preço do item NÃO apaga o histórico.
      await repo.updateItem(
        item.id,
        name: 'Leite',
        quantity: d('2'),
        unit: 'l',
        unitPrice: null,
      );
      final items = await repo.watchItems(list.id).first;
      expect(items.single.unitPrice, isNull);
      expect(await repo.snapshotsFor(item.id), hasLength(2));
    },
  );

  test(
    'coletar com preço encontrado NÃO altera o previsto e grava snapshot',
    () async {
      final list = await repo.ensureCurrentList();
      final item = await repo.addItem(
        list.id,
        name: 'Arroz',
        quantity: d('2'),
        unitPrice: d('10.25'),
      );
      await repo.collectItem(item.id, foundPrice: d('11.40'));
      final row = (await repo.watchItems(list.id).first).single;
      expect(row.checked, isTrue);
      expect(row.unitPrice, d('10.25')); // previsto preservado
      expect(row.foundPrice, d('11.40'));
      final snapshots = await repo.snapshotsFor(item.id);
      expect(snapshots.map((s) => (s.kind, s.amount)), [
        (SnapshotKind.predicted, d('10.25')),
        (SnapshotKind.found, d('11.40')),
      ]);
    },
  );

  test('não encontrei, substituição e desfazer', () async {
    final list = await repo.ensureCurrentList();
    final a = await repo.addItem(list.id, name: 'Leite', quantity: d('1'));
    final b = await repo.addItem(list.id, name: 'Pão', quantity: d('1'));

    final beforeA = (await repo.watchItems(list.id).first).first;
    await repo.markNotFound(a.id);
    var rows = await repo.watchItems(list.id).first;
    expect(rows.first.notFound, isTrue);
    expect(rows.first.checked, isFalse);

    await repo.replaceItem(beforeA); // desfazer
    rows = await repo.watchItems(list.id).first;
    expect(rows.first.notFound, isFalse);

    await repo.collectItem(
      b.id,
      foundPrice: d('9.90'),
      substituteName: '  Pão   integral ',
    );
    rows = await repo.watchItems(list.id).first;
    expect(rows.last.substituteName, 'Pão integral');
    expect(rows.last.checked, isTrue);

    // Desmarcar limpa o resultado da compra do item.
    await repo.setChecked(b.id, checked: false);
    rows = await repo.watchItems(list.id).first;
    expect(rows.last.checked, isFalse);
    expect(rows.last.substituteName, isNull);
    expect(rows.last.foundPrice, isNull);

    // Marcar "não encontrei" depois de coletar remove o coletado.
    await repo.collectItem(b.id, foundPrice: d('9.90'));
    await repo.markNotFound(b.id);
    rows = await repo.watchItems(list.id).first;
    expect(rows.last.checked, isFalse);
    expect(rows.last.notFound, isTrue);
    expect(rows.last.foundPrice, isNull);
    // E coletar de novo tira o "não encontrei".
    await repo.collectItem(b.id);
    rows = await repo.watchItems(list.id).first;
    expect(rows.last.notFound, isFalse);
    expect(rows.last.checked, isTrue);
  });

  test('substituto vazio vira null; nome longo demais é recusado', () async {
    final list = await repo.ensureCurrentList();
    final a = await repo.addItem(list.id, name: 'Leite', quantity: d('1'));
    await repo.collectItem(a.id, substituteName: '   ');
    expect(
      (await repo.watchItems(list.id).first).single.substituteName,
      isNull,
    );
    await expectLater(
      repo.collectItem(a.id, substituteName: 'x' * 121),
      throwsA(isA<ValidationException>()),
    );
  });

  test('orçamento: definir, remover e recusar zero/negativo', () async {
    final list = await repo.ensureCurrentList();
    await repo.setBudget(list.id, d('200'));
    expect((await repo.watchCurrentList().first)!.budget, d('200'));
    await repo.setBudget(list.id, null);
    expect((await repo.watchCurrentList().first)!.budget, isNull);
    for (final bad in ['0', '-5']) {
      await expectLater(
        repo.setBudget(list.id, d(bad)),
        throwsA(isA<ValidationException>()),
        reason: bad,
      );
    }
  });

  test('compra: planejar -> comprar -> finalizar -> nova compra', () async {
    final list = await repo.ensureCurrentList();
    expect(list.shoppingState, ShoppingState.planning);
    final item = await repo.addItem(
      list.id,
      name: 'Arroz',
      quantity: d('2'),
      unitPrice: d('10.25'),
    );
    await repo.setBudget(list.id, d('100'));

    await repo.startShopping(list.id);
    var current = (await repo.watchCurrentList().first)!;
    expect(current.shoppingState, ShoppingState.shopping);
    expect(current.startedAt, isNotNull);

    await repo.collectItem(item.id, foundPrice: d('11'));
    await repo.finishShopping(list.id);
    current = (await repo.watchCurrentList().first)!;
    expect(current.shoppingState, ShoppingState.finished);
    expect(current.finishedAt, isNotNull);

    await repo.startNewShopping(list.id);
    current = (await repo.watchCurrentList().first)!;
    expect(current.shoppingState, ShoppingState.planning);
    expect(current.startedAt, isNull);
    expect(current.finishedAt, isNull);
    expect(current.budget, d('100')); // orçamento permanece
    final row = (await repo.watchItems(list.id).first).single;
    expect(row.checked, isFalse);
    expect(row.foundPrice, isNull);
    expect(row.unitPrice, d('10.25')); // previsto permanece
    expect(
      await repo.snapshotsFor(item.id),
      hasLength(2),
    ); // histórico permanece
  });

  test('finalizar com pendentes não apaga nada', () async {
    final list = await repo.ensureCurrentList();
    await repo.addItem(list.id, name: 'Leite', quantity: d('1'));
    await repo.startShopping(list.id);
    await repo.finishShopping(list.id);
    final rows = await repo.watchItems(list.id).first;
    expect(rows.single.checked, isFalse);
  });

  test('várias listas: trocar atual, renomear e excluir com cascata', () async {
    final a = await repo.createList('Feira');
    final b = await repo.createList('Mês');
    expect((await repo.watchCurrentList().first)!.id, b.id);
    await repo.addItem(a.id, name: 'Tomate', quantity: d('1'));
    await repo.setCurrentList(a.id);
    expect((await repo.watchCurrentList().first)!.name, 'Feira');

    await repo.renameList(a.id, 'Feira de sábado');
    expect((await repo.watchCurrentList().first)!.name, 'Feira de sábado');

    await repo.deleteList(a.id);
    expect(await repo.watchCurrentList().first, isNull);
    expect(await db.select(db.shoppingListItems).get(), isEmpty);
    expect((await repo.watchLists().first).single.id, b.id);
  });

  test('dados persistem ao fechar e reabrir o arquivo do banco', () async {
    final dir = Directory.systemTemp.createTempSync('anotai_lista_test');
    final file = File('${dir.path}/app.sqlite');
    addTearDown(() => dir.deleteSync(recursive: true));

    var first = AppDatabase(NativeDatabase(file));
    var firstRepo = ShoppingListRepository(first);
    final list = await firstRepo.createList('Offline');
    final bean = await firstRepo.addItem(
      list.id,
      name: 'Feijão',
      quantity: d('1.5'),
      unit: 'kg',
      unitPrice: d('8.99'),
    );
    await firstRepo.setBudget(list.id, d('150'));
    await firstRepo.startShopping(list.id);
    await firstRepo.collectItem(
      bean.id,
      foundPrice: d('9.49'),
      substituteName: 'Feijão preto',
    );
    await first.close();

    first = AppDatabase(NativeDatabase(file)); // "reinício" do app
    firstRepo = ShoppingListRepository(first);
    final current = await firstRepo.watchCurrentList().first;
    expect(current!.name, 'Offline');
    final items = await firstRepo.watchItems(current.id).first;
    expect(items.single.name, 'Feijão');
    expect(items.single.quantity, d('1.5'));
    // Estado da compra sobrevive ao reinício (offline, sem rede).
    expect(current.shoppingState, ShoppingState.shopping);
    expect(current.budget, d('150'));
    expect(items.single.checked, isTrue);
    expect(items.single.unitPrice, d('8.99'));
    expect(items.single.foundPrice, d('9.49'));
    expect(items.single.substituteName, 'Feijão preto');
    expect((await firstRepo.watchCategories().first), hasLength(8));
    await first.close();
  });
}
