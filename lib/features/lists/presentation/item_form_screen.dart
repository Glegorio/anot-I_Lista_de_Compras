import 'package:decimal/decimal.dart';
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

/// Passo do botão +/− conforme a unidade (0,5 kg, 100 g, 1 unidade...).
Decimal stepFor(String unit) => switch (unit) {
  'kg' || 'l' => Decimal.parse('0.5'),
  'g' || 'ml' => Decimal.fromInt(100),
  _ => Decimal.one,
};

/// Valida um preço digitado (opcional): vazio = sem preço (null).
/// Devolve a mensagem de erro, ou null se está válido.
String? validateOptionalPrice(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final parsed = parseDecimalPtBr(raw);
  if (parsed is ParsedError) return parsed.message;
  if (parsed is ParsedValue && parsed.value <= Decimal.zero) {
    return 'Informe um preço maior que zero ou deixe em branco.';
  }
  return null;
}

/// Lê um preço digitado já validado (vazio = null).
Decimal? readOptionalPrice(String raw) {
  if (raw.trim().isEmpty) return null;
  final parsed = parseDecimalPtBr(raw);
  return parsed is ParsedValue ? parsed.value : null;
}

/// Cria ou edita um item livre (sem produto remoto). Salva localmente.
class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({
    super.key,
    this.item,
    this.initialName,
    this.initialCategorySlug,
  });

  final ShoppingListItem? item;
  final String? initialName;
  final String? initialCategorySlug;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _quantity;
  late final TextEditingController _price;
  late String _unit;
  String? _categorySlug;
  bool _saving = false;

  bool get _editing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? widget.initialName ?? '');
    _quantity = TextEditingController(
      text: item == null ? '1' : formatQuantity(item.quantity),
    );
    _price = TextEditingController(
      text: item?.unitPrice == null ? '' : formatQuantity(item!.unitPrice!),
    );
    _unit = item?.unit ?? 'un';
    _categorySlug = item?.categorySlug ?? widget.initialCategorySlug;
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _price.dispose();
    super.dispose();
  }

  void _step(int direction) {
    final parsed = parseDecimalPtBr(_quantity.text);
    final current = parsed is ParsedValue ? parsed.value : Decimal.zero;
    final next = current + stepFor(_unit) * Decimal.fromInt(direction);
    if (next <= Decimal.zero) return;
    setState(() => _quantity.text = formatQuantity(next));
  }

  /// "Total deste item: R$ 20,50" quando quantidade e preço são válidos.
  String? get _lineTotalText {
    final q = parseDecimalPtBr(_quantity.text);
    final price = readOptionalPrice(_price.text);
    if (q is! ParsedValue || q.value <= Decimal.zero || price == null) {
      return null;
    }
    if (validateOptionalPrice(_price.text) != null) return null;
    return 'Total deste item: ${formatBrl(lineSubtotal(q.value, price))}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final quantity = parseDecimalPtBr(_quantity.text);
    if (quantity is! ParsedValue) return;
    final price = readOptionalPrice(_price.text);
    setState(() => _saving = true);
    final repo = ref.read(shoppingListRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final item = widget.item;
      if (item == null) {
        final list = await repo.ensureCurrentList();
        await repo.addItem(
          list.id,
          name: _name.text,
          quantity: quantity.value,
          unit: _unit,
          categorySlug: _categorySlug,
          unitPrice: price,
        );
      } else {
        await repo.updateItem(
          item.id,
          name: _name.text,
          quantity: quantity.value,
          unit: _unit,
          categorySlug: _categorySlug,
          unitPrice: price,
        );
      }
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(_editing ? 'Item atualizado.' : 'Item adicionado.'),
        ),
      );
    } on ValidationException catch (e) {
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Remove o item e oferece "Desfazer" (nunca apaga sem volta).
  Future<void> _remove() async {
    final item = widget.item;
    if (item == null) return;
    setState(() => _saving = true);
    final repo = ref.read(shoppingListRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await repo.deleteItem(item.id);
    navigator.pop();
    showUndoSnackBar(
      messenger,
      message: '“${item.name}” removido.',
      onUndo: () => repo.restoreItem(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories =
        ref.watch(categoriesProvider).value ?? const <LocalCategory>[];
    final total = _lineTotalText;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Fechar sem salvar',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppBarTitle(_editing ? 'Editar item' : 'Novo item'),
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
            onPressed: _saving ? null : _save,
            child: IconLabel(
              icon: _editing ? Icons.check_rounded : Icons.add_rounded,
              label: _editing ? 'Salvar alterações' : 'Adicionar à lista',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding,
          0,
          AppSizes.screenPadding,
          AppSizes.spaceXl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                icon: Icons.edit_rounded,
                title: 'O que você precisa?',
              ),
              TextFormField(
                controller: _name,
                autofocus: !_editing && widget.initialName == null,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                style: theme.textTheme.titleSmall,
                decoration: const InputDecoration(labelText: 'Nome do item'),
                maxLength: 120,
                buildCounter: (
                  _, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => null,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe o nome do item.'
                    : null,
              ),
              const SectionHeader(
                icon: Icons.scale_rounded,
                title: 'Quanto?',
                subtitle: 'Toque em − ou +, ou digite (ex.: 0,5)',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepButton(
                    icon: Icons.remove_rounded,
                    label: 'Diminuir quantidade',
                    onPressed: () => _step(-1),
                  ),
                  const SizedBox(width: AppSizes.space),
                  Expanded(
                    child: TextFormField(
                      controller: _quantity,
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: theme.textTheme.headlineSmall,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        final parsed = parseDecimalPtBr(v ?? '');
                        if (parsed is ParsedError) return parsed.message;
                        if (parsed is ParsedValue &&
                            parsed.value <= Decimal.zero) {
                          return 'A quantidade precisa ser maior que zero.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSizes.space),
                  _StepButton(
                    icon: Icons.add_rounded,
                    label: 'Aumentar quantidade',
                    onPressed: () => _step(1),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceLg),
              ChoiceGrid(
                children: [
                  for (final entry in unitLabels.entries)
                    ChoiceTile(
                      label: entry.value,
                      selected: _unit == entry.key,
                      onTap: () => setState(() => _unit = entry.key),
                    ),
                ],
              ),
              SectionHeader(
                icon: Icons.sell_outlined,
                title: 'Preço',
                subtitle: 'Opcional. Sem preço, o item fica fora da soma.',
              ),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: theme.textTheme.titleSmall,
                decoration: InputDecoration(
                  labelText: 'Preço por ${_unit == 'un' ? 'unidade' : _unit}',
                  prefixText: 'R\$ ',
                  hintText: 'Ex.: 10,25',
                ),
                onChanged: (_) => setState(() {}),
                validator: validateOptionalPrice,
              ),
              if (total != null) ...[
                const SizedBox(height: AppSizes.spaceMd),
                InfoBadge(
                  icon: Icons.calculate_outlined,
                  text: total,
                  background: AppColors.primaryContainer,
                  foreground: AppColors.onPrimaryContainer,
                ),
              ],
              const SectionHeader(
                icon: Icons.category_rounded,
                title: 'Categoria',
                subtitle: 'Opcional',
              ),
              ChoiceGrid(
                children: [
                  ChoiceTile(
                    label: 'Sem categoria',
                    icon: Icons.block_rounded,
                    selected: _categorySlug == null,
                    onTap: () => setState(() => _categorySlug = null),
                  ),
                  for (final c in categories)
                    ChoiceTile(
                      label: c.name,
                      icon: categoryStyleFor(c.slug).icon,
                      tint: categoryStyleFor(c.slug),
                      selected: _categorySlug == c.slug,
                      onTap: () => setState(() => _categorySlug = c.slug),
                    ),
                ],
              ),
              if (_editing) ...[
                const SizedBox(height: AppSizes.sectionGap + AppSizes.spaceLg),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 2),
                  ),
                  onPressed: _saving ? null : _remove,
                  child: const IconLabel(
                    icon: Icons.delete_outline,
                    label: 'Remover este item',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon, size: 36),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        fixedSize: const Size(AppSizes.primaryTarget, AppSizes.primaryTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}
