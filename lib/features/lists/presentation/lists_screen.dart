import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_widgets.dart';
import '../data/shopping_list_repository.dart';

/// Gerencia listas locais: trocar, criar, renomear e excluir.
class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lists = ref.watch(allListsProvider).value;
    final current = ref.watch(currentListProvider).value;
    final repo = ref.read(shoppingListRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppBarTitle('Minhas listas'),
      ),
      floatingActionButton: ActionFab(
        label: 'Nova lista',
        onPressed: () => _askName(context, repo),
      ),
      body: lists == null
          ? const LoadingBlock(message: 'Carregando suas listas…')
          : lists.isEmpty
          ? const EmptyState(
              icon: Icons.list_alt_rounded,
              title: 'Nenhuma lista ainda',
              message: 'Toque em “Nova lista” para criar a primeira.',
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.screenPadding,
                AppSizes.spaceLg,
                AppSizes.screenPadding,
                fabClearance(context),
              ),
              children: [
                for (final list in lists)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.cardGap),
                    child: Card(
                      color: list.id == current?.id
                          ? AppColors.primaryContainer
                          : AppColors.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.space),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSm,
                              ),
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                await repo.setCurrentList(list.id);
                                navigator.pop();
                              },
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: AppSizes.primaryTarget,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSizes.space),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.list_alt_rounded,
                                        size: 36,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: AppSizes.spaceLg),
                                      Expanded(
                                        child: Text(
                                          list.name,
                                          style: theme.textTheme.titleMedium,
                                        ),
                                      ),
                                      if (list.id == current?.id)
                                        const InfoBadge(
                                          icon: Icons.check_circle_rounded,
                                          text: 'Atual',
                                          background: AppColors.primary,
                                          foreground: AppColors.onPrimary,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _askName(context, repo, list: list),
                                  child: IconLabel(
                                    icon: Icons.edit_outlined,
                                    label: 'Renomear',
                                    semanticsLabel: 'Renomear ${list.name}',
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(context, repo, list),
                                  child: IconLabel(
                                    icon: Icons.delete_outline,
                                    label: 'Excluir',
                                    semanticsLabel: 'Excluir ${list.name}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _askName(
    BuildContext context,
    ShoppingListRepository repo, {
    ShoppingList? list,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (context) =>
          _NameDialog(initial: list?.name ?? '', renaming: list != null),
    );
    if (name == null) return;
    try {
      if (list == null) {
        await repo.createList(name);
      } else {
        await repo.renameList(list.id, name);
      }
    } on ValidationException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ShoppingListRepository repo,
    ShoppingList list,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          size: 48,
          color: AppColors.error,
        ),
        title: const Text('Excluir lista?'),
        content: Text(
          '“${list.name}” e todos os itens dela serão apagados deste aparelho.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(88, AppSizes.minTarget),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) await repo.deleteList(list.id);
  }
}

/// Dono do controller: ele só é descartado quando o diálogo termina de sair.
class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial, required this.renaming});

  final String initial;
  final bool renaming;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.renaming ? 'Renomear lista' : 'Nova lista'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 80,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'Nome da lista'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(88, AppSizes.minTarget),
          ),
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
