import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/providers.dart';
import '../../core/theme/category_style.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_widgets.dart';
import '../lists/data/shopping_list_repository.dart';
import '../lists/presentation/list_summary.dart';
import '../lists/presentation/my_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _quickAdd = TextEditingController();
  @override
  void dispose() {
    _quickAdd.dispose();
    super.dispose();
  }

  /// Adicionar rápido: 1 unidade, sem formulário. Detalhes se editam depois.
  Future<void> _addQuickly() async {
    final name = _quickAdd.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(shoppingListRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final list = await repo.ensureCurrentList();
      final item = await repo.addItem(
        list.id,
        name: name,
        quantity: Decimal.one,
      );
      _quickAdd.clear();
      showUndoSnackBar(
        messenger,
        message: '“${item.name}” adicionado à lista.',
        onUndo: () => repo.deleteItem(item.id),
      );
    } on ValidationException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories =
        ref.watch(categoriesProvider).value ?? const <LocalCategory>[];
    final list = ref.watch(currentListProvider).value;
    final items = list == null
        ? null
        : ref.watch(listItemsProvider(list.id)).value;
    final hasItems = items != null && items.isNotEmpty;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Hero(controller: _quickAdd, onAdd: _addQuickly),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.spaceXl,
              AppSizes.screenPadding,
              AppSizes.spaceXl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ListCard(list: list, items: hasItems ? items : null),
                const SectionHeader(
                  icon: Icons.category_rounded,
                  title: 'Ou escolha uma categoria',
                  subtitle: 'Toque para adicionar um item dela',
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const gap = AppSizes.spaceMd;
                    final width = (constraints.maxWidth - gap) / 2;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final c in categories)
                          SizedBox(
                            width: width,
                            child: _CategoryTile(category: c),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSizes.sectionGap),
                Text(
                  'Seus dados ficam neste aparelho e funcionam sem internet.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.controller, required this.onAdd});

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.spaceLg,
            AppSizes.screenPadding,
            AppSizes.spaceXl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: ClampedTitle(
                        child: Text(
                          'O que vamos comprar hoje?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceLg),
              TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                style: theme.textTheme.titleSmall,
                decoration: const InputDecoration(
                  labelText: 'Digite um item',
                  hintText: 'Ex.: arroz, leite, pão',
                  prefixIcon: Icon(Icons.edit_rounded, size: 28),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                onSubmitted: (_) => onAdd(),
              ),
              const SizedBox(height: AppSizes.spaceMd),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                ),
                onPressed: onAdd,
                child: const IconLabel(
                  icon: Icons.add_rounded,
                  label: 'Adicionar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.list, required this.items});

  final ShoppingList? list;
  final List<ShoppingListItem>? items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = list?.name ?? 'Minha lista';
    final hasItems = items != null;
    final done = hasItems ? items!.where((i) => i.checked).length : 0;
    final progress = hasItems ? done / items!.length : 0.0;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: () => context.go('/lista'),
        child: Semantics(
          button: true,
          label: 'Abrir $name',
          excludeSemantics: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 96),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_basket_rounded,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceLg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: theme.textTheme.titleMedium),
                            Text(
                              hasItems
                                  ? progressText(totalsOf(items!))
                                  : 'Nenhum item ainda',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.onSurfaceMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  if (hasItems) ...[
                    const SizedBox(height: AppSizes.spaceMd),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final LocalCategory category;

  @override
  Widget build(BuildContext context) {
    final style = categoryStyleFor(category.slug);
    final theme = Theme.of(context);
    return Material(
      color: style.background,
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: () => openItemForm(context, initialCategorySlug: category.slug),
        child: Semantics(
          button: true,
          label: 'Adicionar item em ${category.name}',
          excludeSemantics: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 128),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceMd),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(style.icon, size: 38, color: style.foreground),
                  ),
                  const SizedBox(height: AppSizes.space),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: style.foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
