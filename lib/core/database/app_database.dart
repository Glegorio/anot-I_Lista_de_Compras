import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Categorias iniciais (slug, nome, ícone).
const initialCategories = <(String, String, String)>[
  ('hortifruti', 'Hortifrúti', 'produce'),
  ('padaria', 'Padaria', 'bakery'),
  ('carnes', 'Carnes', 'meat'),
  ('laticinios', 'Laticínios', 'dairy'),
  ('mercearia', 'Mercearia', 'pantry'),
  ('bebidas', 'Bebidas', 'drinks'),
  ('limpeza', 'Limpeza', 'cleaning'),
  ('higiene', 'Higiene', 'hygiene'),
];

@DriftDatabase(
  tables: [
    LocalCategories,
    ShoppingLists,
    ShoppingListItems,
    PriceSnapshots,
    Preferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Banco persistente do aparelho. Nunca é recriado para "resolver" migração.
  AppDatabase.persistent() : super(driftDatabase(name: 'anotai_lista'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await batch((b) {
        b.insertAll(localCategories, [
          for (var i = 0; i < initialCategories.length; i++)
            LocalCategoriesCompanion.insert(
              slug: initialCategories[i].$1,
              name: initialCategories[i].$2,
              iconKey: initialCategories[i].$3,
              sortOrder: i,
            ),
        ]);
      });
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
