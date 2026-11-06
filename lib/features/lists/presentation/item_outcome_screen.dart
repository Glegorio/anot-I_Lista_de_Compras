import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/format.dart';
import '../../../core/money.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_widgets.dart';
import '../data/shopping_list_repository.dart';
import 'item_form_screen.dart' show readOptionalPrice, validateOptionalPrice;

enum ItemOutcome { took, swapped, notFound, pending }

/// Resultado do item no mercado: peguei, troquei, não encontrei ou ainda não
/// peguei. Salva localmente e oferece Desfazer. Coletado NÃO significa pago.
class ItemOutcomeScreen extends ConsumerStatefulWidget {
  const ItemOutcomeScreen({super.key, required this.item});

  final ShoppingListItem item;

  @override
  ConsumerState<ItemOutcomeScreen> createState() => _ItemOutcomeScreenState();
}

class _ItemOutcomeScreenState extends ConsumerState<ItemOutcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _price;
  late final TextEditingController _substitute;
  late ItemOutcome? _outcome;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _price = TextEditingController(
      text: item.foundPrice == null ? '' : formatQuantity(item.foundPrice!),
    );
    _substitute = TextEditingController(text: item.substituteName ?? '');
    _outcome = item.notFound
        ? ItemOutcome.notFound
        : item.checked
        ? (item.substituteName != null ? ItemOutcome.swapped : ItemOutcome.took)
        : null;
  }

  @override
  void dispose() {
    _price.dispose();
    _substitute.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final outcome = _outcome;
    if (outcome == null) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(shoppingListRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final previous = widget.item;
    try {
      switch (outcome) {
        case ItemOutcome.took:
          await repo.collectItem(
            previous.id,
            foundPrice: readOptionalPrice(_price.text),
          );
        case ItemOutcome.swapped:
          await repo.collectItem(
            previous.id,
            foundPrice: readOptionalPrice(_price.text),
            substituteName: _substitute.text,
          );
        case ItemOutcome.notFound:
          await repo.markNotFound(previous.id);
        case ItemOutcome.pending:
          await repo.setChecked(previous.id, checked: false);
      }
      navigator.pop();
      showUndoSnackBar(
        messenger,
        message: _confirmation(outcome, previous.name),
        onUndo: () => repo.replaceItem(previous),
      );
    } on ValidationException catch (e) {
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  String _confirmation(ItemOutcome outcome, String name) => switch (outcome) {
    ItemOutcome.took => '“$name” no carrinho.',
    ItemOutcome.swapped => '“$name” trocado por outro.',
    ItemOutcome.notFound => '“$name” marcado como não encontrado.',
    ItemOutcome.pending => '“$name” voltou para “Para comprar”.',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final unitLabel = item.unit == 'un' ? 'unidade' : item.unit;
    final outcome = _outcome;
    final showsPrice =
        outcome == ItemOutcome.took || outcome == ItemOutcome.swapped;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Fechar sem salvar',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppBarTitle('Como foi?'),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: AppSizes.spaceLg,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: FilledButton(
            onPressed: (_saving || outcome == null) ? null : _save,
            child: const IconLabel(icon: Icons.check_rounded, label: 'Salvar'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding,
          AppSizes.spaceLg,
          AppSizes.screenPadding,
          AppSizes.spaceXl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.spaceLg),
                  child: Row(
                    children: [
                      CategoryAvatar(slug: item.categorySlug, size: 48),
                      const SizedBox(width: AppSizes.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: theme.textTheme.titleMedium),
                            Text(
                              formatQuantityWithUnit(item.quantity, item.unit),
                              style: theme.textTheme.bodyLarge,
                            ),
                            Text(
                              item.unitPrice == null
                                  ? 'Sem preço previsto'
                                  : 'Previsto: ${formatBrl(item.unitPrice!)} por $unitLabel',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SectionHeader(
                icon: Icons.help_outline_rounded,
                title: 'O que aconteceu?',
              ),
              ChoiceGrid(
                children: [
                  ChoiceTile(
                    label: 'Peguei',
                    icon: Icons.shopping_cart_outlined,
                    selected: outcome == ItemOutcome.took,
                    onTap: () => setState(() => _outcome = ItemOutcome.took),
                  ),
                  ChoiceTile(
                    label: 'Troquei por outro',
                    icon: Icons.swap_horiz_rounded,
                    selected: outcome == ItemOutcome.swapped,
                    onTap: () => setState(() => _outcome = ItemOutcome.swapped),
                  ),
                  ChoiceTile(
                    label: 'Não encontrei',
                    icon: Icons.search_off_rounded,
                    selected: outcome == ItemOutcome.notFound,
                    onTap: () =>
                        setState(() => _outcome = ItemOutcome.notFound),
                  ),
                  ChoiceTile(
                    label: 'Ainda não peguei',
                    icon: Icons.undo_rounded,
                    selected: outcome == ItemOutcome.pending,
                    onTap: () => setState(() => _outcome = ItemOutcome.pending),
                  ),
                ],
              ),
              if (outcome == ItemOutcome.swapped) ...[
                const SectionHeader(
                  icon: Icons.swap_horiz_rounded,
                  title: 'Levou o quê no lugar?',
                ),
                TextFormField(
                  controller: _substitute,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.titleSmall,
                  decoration: const InputDecoration(
                    labelText: 'Nome do que levou',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o que levou no lugar.'
                      : null,
                ),
              ],
              if (showsPrice) ...[
                const SectionHeader(
                  icon: Icons.sell_outlined,
                  title: 'Quanto custou?',
                  subtitle: 'Opcional. Não muda o preço previsto.',
                ),
                TextFormField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: theme.textTheme.titleSmall,
                  decoration: InputDecoration(
                    labelText: 'Preço por $unitLabel',
                    prefixText: 'R\$ ',
                    hintText: 'Ex.: 10,25',
                  ),
                  validator: validateOptionalPrice,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
