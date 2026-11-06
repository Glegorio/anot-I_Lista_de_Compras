import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/core/database/app_database.dart';

import 'generated_migrations/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('banco novo nasce exatamente no schema v1 do dump', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 1);
  });

  test('banco novo já traz as oito categorias iniciais', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final categories = await db.select(db.localCategories).get();
    expect(categories.map((c) => c.slug), [
      'hortifruti',
      'padaria',
      'carnes',
      'laticinios',
      'mercearia',
      'bebidas',
      'limpeza',
      'higiene',
    ]);
  });
}
