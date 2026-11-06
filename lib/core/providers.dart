import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/lists/data/shopping_list_repository.dart';
import 'database/app_database.dart';

/// Sem repetição automática de providers que falham. O Riverpod 3 refaz sozinho e, enquanto
/// refaz, o estado continua "carregando": sem rede a tela ficava para sempre em "Procurando…".
/// Aqui falha é falha: a tela mostra o erro e a pessoa escolhe "Tentar de novo".
Duration? noAutomaticRetry(int retryCount, Object error) => null;

/// Banco local. Testes sobrescrevem com banco em memória.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.persistent();
  ref.onDispose(db.close);
  return db;
});

final shoppingListRepositoryProvider = Provider<ShoppingListRepository>(
  (ref) => ShoppingListRepository(ref.watch(databaseProvider)),
);

final categoriesProvider = StreamProvider<List<LocalCategory>>(
  (ref) => ref.watch(shoppingListRepositoryProvider).watchCategories(),
);

final currentListProvider = StreamProvider<ShoppingList?>(
  (ref) => ref.watch(shoppingListRepositoryProvider).watchCurrentList(),
);

final allListsProvider = StreamProvider<List<ShoppingList>>(
  (ref) => ref.watch(shoppingListRepositoryProvider).watchLists(),
);

final listItemsProvider = StreamProvider.family<List<ShoppingListItem>, String>(
  (ref, listId) => ref.watch(shoppingListRepositoryProvider).watchItems(listId),
);

/// Tempo mínimo da tela de carregamento, contado a partir do primeiro quadro
/// do Flutter. A abertura nativa (verde, com o logotipo) cobre o tempo anterior,
/// então a pessoa vê uma sequência contínua e legível, nunca um "piscar".
/// Testes sobrescrevem com Duration.zero.
const splashMinDuration = Duration(milliseconds: 1600);

final splashMinDurationProvider = Provider<Duration>(
  (ref) => splashMinDuration,
);

/// Pronto quando o banco local abriu (e migrou) e as categorias estão disponíveis.
final appReadyProvider = FutureProvider<void>((ref) async {
  final minimum = ref.watch(splashMinDurationProvider);
  final db = ref.watch(databaseProvider);
  await Future.wait([
    db.customSelect('SELECT 1').get(),
    ref.watch(categoriesProvider.future),
    Future<void>.delayed(minimum),
  ]);
});
