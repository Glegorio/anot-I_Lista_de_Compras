import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

/// Dinheiro e quantidades ficam em TEXT decimal exato; nunca double.
class DecimalConverter extends TypeConverter<Decimal, String> {
  const DecimalConverter();

  @override
  Decimal fromSql(String fromDb) => Decimal.parse(fromDb);

  @override
  String toSql(Decimal value) => value.toString();
}

@DataClassName('LocalCategory')
class LocalCategories extends Table {
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get iconKey => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {slug};
}

class ShoppingLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Orçamento da compra (null = não definido). Dinheiro em decimal exato.
  TextColumn get budget => text().map(const DecimalConverter()).nullable()();

  /// 'planning' (montando a lista), 'shopping' (comprando) ou 'finished'.
  TextColumn get shoppingState =>
      text().withDefault(const Constant('planning'))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingListItems extends Table {
  TextColumn get id => text()();
  TextColumn get listId =>
      text().references(ShoppingLists, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get quantity => text().map(const DecimalConverter())();
  TextColumn get unit => text()();

  TextColumn get categorySlug => text().nullable().references(
    LocalCategories,
    #slug,
    onDelete: KeyAction.setNull,
  )();

  /// Coletado = no carrinho. NÃO significa pago.
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();

  /// "Não encontrei" no mercado (exclui o item do previsto).
  BoolColumn get notFound => boolean().withDefault(const Constant(false))();

  /// Substituição explícita: nome do que foi levado no lugar.
  TextColumn get substituteName => text().nullable()();

  /// Preço encontrado no mercado (por unidade); separado do previsto.
  TextColumn get foundPrice =>
      text().map(const DecimalConverter()).nullable()();

  /// Preço pessoal do item; null = desconhecido (nunca zero como placeholder).
  TextColumn get unitPrice => text().map(const DecimalConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (CAST(quantity AS REAL) > 0)',
    'CHECK (unit_price IS NULL OR CAST(unit_price AS REAL) >= 0)',
  ];
}

/// Histórico de preços (append-only) de cada item, com tipo e momento.
class PriceSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get itemId =>
      text().references(ShoppingListItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get amount => text().map(const DecimalConverter())();
  TextColumn get currency => text().withDefault(const Constant('BRL'))();
  TextColumn get unit => text()();

  /// 'predicted' (preço previsto da lista) ou 'found' (encontrado na compra).
  TextColumn get kind => text().withDefault(const Constant('predicted'))();
  DateTimeColumn get capturedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Preferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
