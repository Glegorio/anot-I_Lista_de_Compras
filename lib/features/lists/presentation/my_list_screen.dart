import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/format.dart';
import '../../../core/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/category_style.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_widgets.dart';
import '../data/shopping_list_repository.dart';
import 'item_form_screen.dart';
import 'item_outcome_screen.dart';
import 'list_summary.dart';
import 'lists_screen.dart';

void openItemForm(
  BuildContext context, {
  ShoppingListItem? item,
  String? initialName,
  String? initialCategorySlug,
}) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => ItemFormScreen(
        item: item,
        initialName: initialName,
        initialCategorySlug: initialCategorySlug,
      ),
    ),
  );
}

void openItemOutcome(BuildContext context, ShoppingListItem item) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => ItemOutcomeScreen(item: item),
    ),
  );
}

/// Texto ampliado a ponto de a barra fixa da base não caber.
bool _largeText(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(20) / 20 > 1.3;

class MyListScreen extends ConsumerWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(currentListProvider).value;
    final items = list == null
        ? null
        : ref.watch(listItemsProvider(list.id)).value;
    final isEmpty = list == null || (items != null && items.isEmpty);
    final finished = list?.shoppingState == ShoppingState.finished;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(list?.name ?? 'Minha lista'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.onPrimary),
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<void>(builder: (_) => const ListsScreen()),
            ),
            child: const IconLabel(
              icon: Icons.list_alt_rounded,
              label: 'Listas',
            ),
          ),
          const SizedBox(width: AppSizes.space),
        ],
      ),
      // Lista vazia já tem um botão grande no centro; compra finalizada é
      // somente leitura. Nos demais casos: um único botão de adicionar.
      floatingActionButton: (isEmpty || finished)
          ? null
          : ActionFab(
              label: 'Adicionar item',
              onPressed: () => openItemForm(context),
            ),
      // Fonte muito ampliada: a barra vai para dentro da rolagem (não cabe fixa).
      bottomNavigationBar:
          (list == null ||
              items == null ||
              items.isEmpty ||
              finished ||
              _largeText(context))
          ? null
          : ListActionBar(list: list, items: items),
      body: list == null ? const _EmptyList() : _ItemsView(list: list),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_basket_outlined,
      title: 'Sua lista está vazia',
      message: 'Adicione o que você precisa comprar.',
      action: FilledButton(
        onPressed: () => openItemForm(context),
        child: const IconLabel(
          icon: Icons.add_rounded,
          label: 'Adicionar primeiro item',
        ),
      ),
    );
  }
}

class _ItemsView extends ConsumerWidget {
  const _ItemsView({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(listItemsProvider(list.id)).value;
    if (items == null) {
      return const LoadingBlock(message: 'Carregando sua lista…');
    }
    if (items.isEmpty) return const _EmptyList();

    final names = {
      for (final c
          in ref.watch(categoriesProvider).value ?? const <LocalCategory>[])
        c.slug: c.name,
    };
    final pending = items.where((i) => !i.checked && !i.notFound).toList();
    final inCart = items.where((i) => i.checked).toList();
    final missing = items.where((i) => i.notFound).toList();
    final mode = list.shoppingState;

    Widget card(ShoppingListItem item) => _ItemCard(
      item: item,
      mode: mode,
      categoryName: names[item.categorySlug],
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.spaceLg,
        AppSizes.screenPadding,
        fabClearance(context),
      ),
      children: [
        if (mode == ShoppingState.finished)
          FinishedCard(list: list, items: items)
        else ...[
          ListSummaryCard(list: list, items: items),
          if (_largeText(context)) ...[
            const SizedBox(height: AppSizes.cardGap),
            ListActionBar(list: list, items: items, inline: true),
          ],
        ],
        if (pending.isNotEmpty) ...[
          SectionHeader(
            icon: Icons.shopping_cart_outlined,
            title: 'Para comprar',
            subtitle: itemCountText(pending.length),
          ),
          for (final item in pending) card(item),
        ],
        if (inCart.isNotEmpty) ...[
          SectionHeader(
            icon: Icons.check_circle_outline,
            title: 'No carrinho',
            subtitle: itemCountText(inCart.length),
          ),
          for (final item in inCart) card(item),
        ],
        if (missing.isNotEmpty) ...[
          SectionHeader(
            icon: Icons.search_off_rounded,
            title: 'Não encontrados',
            subtitle: itemCountText(missing.length),
          ),
          for (final item in missing) card(item),
        ],
      ],
    );
  }
}

/// Cartão do item: tocar no cartão marca/desmarca (coletado = no carrinho, não
/// pago). Fora da compra finalizada há UM botão: "Editar" (montando a lista) ou
/// "Opções" (comprando: peguei, troquei, não encontrei, preço encontrado).
class _ItemCard extends ConsumerWidget {
  const _ItemCard({required this.item, required this.mode, this.categoryName});

  final ShoppingListItem item;
  final String mode;
  final String? categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(shoppingListRepositoryProvider);
    final theme = Theme.of(context);
    final quantity = formatQuantityWithUnit(item.quantity, item.unit);
    final style = categoryStyleFor(item.categorySlug);
    final done = item.checked;
    final missing = item.notFound;
    final readOnly = mode == ShoppingState.finished;
    final muted = done || missing;
    // Com fonte muito ampliada o botão desce para baixo do texto.
    final stacked = MediaQuery.textScalerOf(context).scale(20) > 28;

    final price = item.unitPrice;
    final found = item.foundPrice;
    final priceLine = price == null
        ? 'Sem preço'
        : '${formatBrl(price)} por ${item.unit} · '
              'total ${formatBrl(lineSubtotal(item.quantity, price))}';
    final foundLine = found == null
        ? null
        : 'Encontrado: ${formatBrl(found)} por ${item.unit} · '
              'total ${formatBrl(lineSubtotal(item.quantity, found))}';
    final semanticDetails = [
      quantity,
      ?categoryName,
      if (missing) 'não encontrado',
      if (item.substituteName != null) 'trocado por ${item.substituteName}',
      price == null ? 'sem preço' : priceLine,
    ].join(', ');

    final info = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: done ? TextDecoration.lineThrough : null,
              color: muted ? AppColors.onSurfaceMuted : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          // Quantidade (em destaque) e categoria em linhas que quebram inteiras.
          Wrap(
            spacing: AppSizes.spaceMd,
            children: [
              Text(
                quantity,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: muted ? AppColors.onSurfaceMuted : style.foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (categoryName != null)
                Text(
                  categoryName!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
            ],
          ),
          Text(
            priceLine,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
          ),
          if (foundLine != null)
            Text(
              foundLine,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (missing || item.substituteName != null) ...[
            const SizedBox(height: AppSizes.space),
            if (missing)
              const InfoBadge(
                icon: Icons.search_off_rounded,
                text: 'Não encontrei',
                background: AppColors.errorContainer,
                foreground: AppColors.onErrorContainer,
              ),
            if (item.substituteName != null)
              InfoBadge(
                icon: Icons.swap_horiz_rounded,
                text: 'Trocado por ${item.substituteName}',
              ),
          ],
        ],
      ),
    );

    Future<void> toggle() async {
      final previous = item;
      await repo.setChecked(item.id, checked: !done);
      if (mode == ShoppingState.shopping && context.mounted) {
        showUndoSnackBar(
          ScaffoldMessenger.of(context),
          message: done
              ? '“${item.name}” voltou para “Para comprar”.'
              : '“${item.name}” no carrinho.',
          onUndo: () => repo.replaceItem(previous),
        );
      }
    }

    final toggleArea = InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      onTap: readOnly ? null : toggle,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Semantics(
          container: true,
          checked: done,
          label: '${item.name}, $semanticDetails',
          excludeSemantics: true,
          onTap: readOnly ? null : toggle,
          child: Row(
            children: [
              SizedBox(
                width: AppSizes.minTarget,
                height: AppSizes.minTarget,
                child: Icon(
                  missing
                      ? Icons.search_off_rounded
                      : done
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 40,
                  color: missing
                      ? AppColors.error
                      : done
                      ? AppColors.primary
                      : AppColors.onSurfaceMuted,
                ),
              ),
              CategoryAvatar(slug: item.categorySlug, size: 48),
              const SizedBox(width: AppSizes.spaceMd),
              info,
            ],
          ),
        ),
      ),
    );

    final action = readOnly
        ? null
        : _ItemAction(
            item: item,
            shopping: mode == ShoppingState.shopping,
            wide: stacked,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.cardGap),
      child: Card(
        color: done ? AppColors.primaryContainer : AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.space),
          child: stacked || action == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    toggleArea,
                    if (action != null)
                      Align(alignment: Alignment.centerRight, child: action),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: toggleArea),
                    const SizedBox(width: AppSizes.space),
                    action,
                  ],
                ),
        ),
      ),
    );
  }
}

/// Botão do cartão com ícone + palavra: "Editar" (montando) ou "Opções"
/// (comprando). Nunca só ícone.
class _ItemAction extends StatelessWidget {
  const _ItemAction({
    required this.item,
    required this.shopping,
    this.wide = false,
  });

  final ShoppingListItem item;
  final bool shopping;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final word = shopping ? 'Opções' : 'Editar';
    final icon = shopping ? Icons.tune_rounded : Icons.edit_outlined;
    void open() => shopping
        ? openItemOutcome(context, item)
        : openItemForm(context, item: item);
    if (wide) {
      return TextButton(
        onPressed: open,
        child: IconLabel(
          icon: icon,
          label: word,
          semanticsLabel: '$word ${item.name}',
        ),
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      onTap: open,
      child: SizedBox(
        width: 72,
        height: 72,
        child: ClampedTitle(
          maxScaleFactor: 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              Text(
                word,
                semanticsLabel: '$word ${item.name}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
