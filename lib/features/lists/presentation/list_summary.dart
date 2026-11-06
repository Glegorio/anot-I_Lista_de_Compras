import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/format.dart';
import '../../../core/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_widgets.dart';
import '../data/shopping_list_repository.dart';
import '../domain/list_totals.dart';

/// Adapta os itens do banco para o cálculo puro de totais.
ListTotals totalsOf(Iterable<ShoppingListItem> items) => ListTotals.from(
  items.map(
    (i) => PricedLine(
      quantity: i.quantity,
      predictedPrice: i.unitPrice,
      foundPrice: i.foundPrice,
      collected: i.checked,
      notFound: i.notFound,
      substituted: i.substituteName != null,
    ),
  ),
);

String itemCountText(int count) => count == 1 ? '1 item' : '$count itens';

/// "2 de 5 no carrinho". Coletado NÃO significa pago.
String progressText(ListTotals totals) =>
    '${totals.collectedCount} de ${totals.activeCount} no carrinho';

/// "3 itens sem preço": preço ausente é desconhecido, nunca zero.
String unpricedText(ListTotals totals) => totals.unpricedCount == 1
    ? '1 item sem preço (fora da soma)'
    : '${totals.unpricedCount} itens sem preço (fora da soma)';

String predictedText(ListTotals totals) => totals.hasPredicted
    ? 'Previsto: ${formatBrl(totals.predictedTotal)}'
    : 'Previsto: nenhum preço informado';

/// Linha do orçamento: sobra ou estouro, com aviso de cobertura parcial.
String budgetText(BudgetStatus status) => status.exceeded
    ? 'Passou ${formatBrl(status.difference)} do orçamento'
    : 'Sobram ${formatBrl(status.difference)} do orçamento';

/// Cartão de resumo no topo (enxuto, para a lista continuar visível):
/// progresso, avisos de cobertura e orçamento. Totais e o botão principal
/// ficam na barra fixa da base ([ListActionBar]).
class ListSummaryCard extends ConsumerWidget {
  const ListSummaryCard({super.key, required this.list, required this.items});

  final ShoppingList list;
  final List<ShoppingListItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totals = totalsOf(items);
    final budget = list.budget;
    final status = budget == null ? null : BudgetStatus.of(budget, totals);
    final shopping = list.shoppingState == ShoppingState.shopping;
    final progress = totals.activeCount == 0
        ? 0.0
        : totals.collectedCount / totals.activeCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceLg,
          AppSizes.spaceLg,
          AppSizes.spaceLg,
          AppSizes.space,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shopping) ...[
                    const InfoBadge(
                      icon: Icons.shopping_cart_rounded,
                      text: 'Comprando agora',
                      background: AppColors.primary,
                      foreground: AppColors.onPrimary,
                    ),
                    const SizedBox(height: AppSizes.space),
                  ],
                  ClampedTitle(
                    child: Text(
                      progressText(totals),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                    ),
                  ),
                  if (totals.unpricedCount > 0 || totals.notFoundCount > 0) ...[
                    const SizedBox(height: AppSizes.spaceMd),
                    Wrap(
                      spacing: AppSizes.space,
                      runSpacing: AppSizes.space,
                      children: [
                        if (totals.unpricedCount > 0)
                          InfoBadge(
                            icon: Icons.sell_outlined,
                            text: unpricedText(totals),
                          ),
                        if (totals.notFoundCount > 0)
                          InfoBadge(
                            icon: Icons.search_off_rounded,
                            text: totals.notFoundCount == 1
                                ? '1 item não encontrado'
                                : '${totals.notFoundCount} itens não encontrados',
                            background: AppColors.errorContainer,
                            foreground: AppColors.onErrorContainer,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSizes.space),
            // Orçamento: uma linha que se toca para definir/alterar.
            InkWell(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              onTap: () => editBudget(context, ref, list),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTarget,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.savings_outlined,
                      size: 28,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSizes.spaceMd),
                    Expanded(
                      child: status == null
                          ? Text(
                              'Definir orçamento',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orçamento: ${formatBrl(status.budget)}',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  'Toque para alterar',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra fixa na base: totais sempre visíveis (sem rolar) e a ação principal
/// da compra: "Iniciar compra" ou "Finalizar compra".
class ListActionBar extends ConsumerWidget {
  const ListActionBar({
    super.key,
    required this.list,
    required this.items,
    this.inline = false,
  });

  final ShoppingList list;
  final List<ShoppingListItem> items;

  /// Com fonte muito ampliada a barra não cabe fixa na base: ela passa a
  /// aparecer como um cartão dentro da rolagem.
  final bool inline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totals = totalsOf(items);
    final repo = ref.read(shoppingListRepositoryProvider);
    final shopping = list.shoppingState == ShoppingState.shopping;
    final budget = list.budget;
    final status = budget == null ? null : BudgetStatus.of(budget, totals);
    return Container(
      padding: inline
          ? const EdgeInsets.all(AppSizes.spaceLg)
          : const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.spaceMd,
              AppSizes.screenPadding,
              AppSizes.spaceMd,
            ),
      decoration: inline
          ? BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radius),
              border: Border.all(color: AppColors.cardBorder, width: 2),
            )
          : const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.cardBorder, width: 2),
              ),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(predictedText(totals), style: theme.textTheme.titleSmall),
                if (status != null) ...[
                  Text(
                    budgetText(status),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: status.exceeded
                          ? AppColors.error
                          : AppColors.primaryDark,
                    ),
                  ),
                  if (status.partial)
                    Text(
                      'Conta só os itens que têm preço.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                    ),
                ],
                if (shopping && totals.collectedCount > 0)
                  Text(
                    totals.foundPricedCount == 0
                        ? 'No carrinho: nenhum preço informado'
                        : 'No carrinho: ${formatBrl(totals.foundTotal)}'
                              '${totals.collectedWithoutFoundPrice > 0 ? ' (${totals.collectedWithoutFoundPrice} sem preço)' : ''}',
                    style: theme.textTheme.titleSmall,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.space),
          if (shopping)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
              ),
              onPressed: () => finishShoppingFlow(
                context,
                repo,
                list.id,
                totals.pendingCount,
              ),
              child: const IconLabel(
                icon: Icons.flag_rounded,
                label: 'Finalizar compra',
              ),
            )
          else
            FilledButton(
              onPressed: () => repo.startShopping(list.id),
              child: const IconLabel(
                icon: Icons.shopping_cart_checkout_rounded,
                label: 'Iniciar compra',
              ),
            ),
        ],
      ),
    );
  }
}

/// Finaliza a compra; com itens pendentes pede confirmação (nada é apagado).
Future<void> finishShoppingFlow(
  BuildContext context,
  ShoppingListRepository repo,
  String listId,
  int pendingCount,
) async {
  if (pendingCount > 0) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.help_outline_rounded,
          size: 48,
          color: AppColors.primary,
        ),
        title: const Text('Finalizar a compra?'),
        content: Text(
          pendingCount == 1
              ? 'Ainda falta 1 item. Ele continua na lista.'
              : 'Ainda faltam $pendingCount itens. Eles continuam na lista.',
        ),
        actionsOverflowDirection: VerticalDirection.down,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar comprando'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(88, AppSizes.minTarget),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
  }
  await repo.finishShopping(listId);
}

/// Resumo da compra finalizada (somente leitura) com a ação de recomeçar.
class FinishedCard extends ConsumerWidget {
  const FinishedCard({super.key, required this.list, required this.items});

  final ShoppingList list;
  final List<ShoppingListItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totals = totalsOf(items);
    final budget = list.budget;
    final status = budget == null ? null : BudgetStatus.of(budget, totals);
    return Card(
      color: AppColors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: ClampedTitle(
                child: Row(
                  children: [
                    const Icon(
                      Icons.task_alt_rounded,
                      size: 36,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSizes.space),
                    Expanded(
                      child: Text(
                        'Compra finalizada',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Text(progressText(totals), style: theme.textTheme.titleMedium),
            if (totals.pendingCount > 0)
              Text(
                totals.pendingCount == 1
                    ? '1 item ficou sem pegar'
                    : '${totals.pendingCount} itens ficaram sem pegar',
                style: theme.textTheme.bodyLarge,
              ),
            if (totals.notFoundCount > 0)
              Text(
                totals.notFoundCount == 1
                    ? '1 item não encontrado'
                    : '${totals.notFoundCount} itens não encontrados',
                style: theme.textTheme.bodyLarge,
              ),
            if (totals.substitutedCount > 0)
              Text(
                totals.substitutedCount == 1
                    ? '1 item trocado por outro'
                    : '${totals.substitutedCount} itens trocados por outro',
                style: theme.textTheme.bodyLarge,
              ),
            const SizedBox(height: AppSizes.spaceMd),
            Text(predictedText(totals), style: theme.textTheme.titleMedium),
            Text(
              totals.foundPricedCount == 0
                  ? 'No carrinho: nenhum preço informado'
                  : 'No carrinho: ${formatBrl(totals.foundTotal)}',
              style: theme.textTheme.titleMedium,
            ),
            if (totals.collectedWithoutFoundPrice > 0 &&
                totals.foundPricedCount > 0)
              Text(
                '${totals.collectedWithoutFoundPrice} no carrinho sem preço informado (fora da soma)',
                style: theme.textTheme.bodyMedium,
              ),
            if (totals.unpricedCount > 0)
              Text(unpricedText(totals), style: theme.textTheme.bodyMedium),
            if (status != null) ...[
              const SizedBox(height: AppSizes.space),
              Text(
                budgetText(status),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: status.exceeded
                      ? AppColors.error
                      : AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.spaceLg),
            FilledButton(
              onPressed: () => ref
                  .read(shoppingListRepositoryProvider)
                  .startNewShopping(list.id),
              child: const IconLabel(
                icon: Icons.replay_rounded,
                label: 'Começar nova compra',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diálogo de orçamento: salvar, remover ou cancelar.
Future<void> editBudget(
  BuildContext context,
  WidgetRef ref,
  ShoppingList list,
) async {
  final repo = ref.read(shoppingListRepositoryProvider);
  final result = await showDialog<_BudgetResult>(
    context: context,
    builder: (_) => _BudgetDialog(initial: list.budget),
  );
  if (result == null) return;
  await repo.setBudget(list.id, result.clear ? null : result.value);
}

class _BudgetResult {
  const _BudgetResult.save(Decimal this.value) : clear = false;
  const _BudgetResult.clear() : value = null, clear = true;

  final Decimal? value;
  final bool clear;
}

class _BudgetDialog extends StatefulWidget {
  const _BudgetDialog({required this.initial});

  final Decimal? initial;

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial == null ? '' : formatQuantity(widget.initial!),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final parsed = parseDecimalPtBr(_controller.text);
    if (parsed is ParsedError) {
      setState(() => _error = parsed.message);
    } else if (parsed is ParsedValue) {
      if (parsed.value <= Decimal.zero) {
        setState(() => _error = 'O orçamento precisa ser maior que zero.');
      } else {
        Navigator.pop(context, _BudgetResult.save(parsed.value));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Orçamento'),
      content: SingleChildScrollView(
        child: TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Quanto você quer gastar?',
            prefixText: 'R\$ ',
            hintText: 'Ex.: 200',
            errorText: _error,
          ),
          onSubmitted: (_) => _save(),
        ),
      ),
      actionsOverflowDirection: VerticalDirection.down,
      actions: [
        if (widget.initial != null)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () =>
                Navigator.pop(context, const _BudgetResult.clear()),
            child: const Text('Remover orçamento'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(88, AppSizes.minTarget),
          ),
          onPressed: _save,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
