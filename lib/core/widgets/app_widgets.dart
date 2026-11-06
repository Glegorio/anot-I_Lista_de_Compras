import 'package:flutter/material.dart';

import '../theme/category_style.dart';
import '../theme/tokens.dart';

/// Círculo colorido com o ícone da categoria (decorativo: o nome vem ao lado).
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.slug, this.size = 48});

  final String? slug;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = categoryStyleFor(slug);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: style.background,
          shape: BoxShape.circle,
        ),
        child: Icon(style.icon, size: size * 0.55, color: style.foreground),
      ),
    );
  }
}

/// Título de seção com ícone, usado para organizar telas longas.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSizes.sectionGap,
          bottom: AppSizes.spaceMd,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selo de 40: encosta exatamente na margem da tela (alinhado aos cartões).
            ExcludeSemantics(
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(width: AppSizes.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  if (subtitle != null)
                    Text(
                      subtitle!,
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
    );
  }
}

/// Selo informativo (ícone + texto), nunca só cor.
class InfoBadge extends StatelessWidget {
  const InfoBadge({
    super.key,
    required this.icon,
    required this.text,
    this.background = AppColors.accentContainer,
    this.foreground = AppColors.onAccentContainer,
  });

  final IconData icon;
  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: foreground),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ilustração simples para estados vazios: ícone grande em círculo colorido.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 72, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSizes.spaceXl),
            ClampedTitle(
              child: Text(
                title,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSizes.space + 4),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSizes.spaceXl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Carregamento dentro de uma tela (listas, itens).
class LoadingBlock extends StatelessWidget {
  const LoadingBlock({super.key, this.message = 'Carregando…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        liveRegion: true,
        label: message,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
            const SizedBox(height: AppSizes.spaceLg),
            ExcludeSemantics(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ícone + rótulo para usar como `child` de botões. Ao contrário de
/// `FilledButton.icon`, o texto quebra em linhas com fonte ampliada (200%).
class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.semanticsLabel,
  });

  final IconData icon;
  final String label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: AppSizes.space),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            semanticsLabel: semanticsLabel,
          ),
        ),
      ],
    );
  }
}

/// Botão de ação flutuante em destaque (âmbar). Quebra o rótulo em linhas e
/// nunca passa da largura da tela, mesmo com texto a 200%.
class ActionFab extends StatelessWidget {
  const ActionFab({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width - 2 * AppSizes.spaceLg;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          shape: const StadiumBorder(
            side: BorderSide(color: Color(0xFF7A5A00), width: 2),
          ),
        ),
        child: IconLabel(icon: Icons.add_rounded, label: label),
      ),
    );
  }
}

/// Limita a ampliação de textos que já são grandes (títulos), para não
/// ocuparem a tela inteira. O texto de corpo continua ampliando sem limite.
class ClampedTitle extends StatelessWidget {
  const ClampedTitle({
    super.key,
    required this.child,
    this.maxScaleFactor = 1.4,
  });

  final Widget child;
  final double maxScaleFactor;

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    maxScaleFactor: maxScaleFactor,
    child: child,
  );
}

/// Título de barra superior: no máximo 2 linhas e ampliação limitada.
class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ClampedTitle(
    maxScaleFactor: 1.3,
    child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
  );
}

/// Folga no fim de listas rolaveis para o botao flutuante nunca cobrir o ultimo
/// item. Cresce com a fonte ampliada (o botao passa a ter 2 linhas).
double fabClearance(BuildContext context) {
  final scale = MediaQuery.textScalerOf(context).scale(20) / 20;
  return 96 + (scale > 1.3 ? 96 * (scale - 1.3).clamp(0, 1) + 48 : 0);
}

/// Opção de escolha única grande: borda grossa + ícone de "marcado" quando
/// selecionada (não depende só de cor).
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.tint,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final CategoryStyle? tint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = selected
        ? (tint?.background ?? AppColors.primaryContainer)
        : AppColors.surface;
    final foreground = selected
        ? (tint?.foreground ?? AppColors.onPrimaryContainer)
        : AppColors.onSurface;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.outline,
        width: selected ? 3 : 2,
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: background,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.minTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceLg,
                vertical: AppSizes.space,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selected) ...[
                    Icon(
                      Icons.check_circle_rounded,
                      size: 26,
                      color: foreground,
                    ),
                    const SizedBox(width: AppSizes.space),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 26, color: foreground),
                    const SizedBox(width: AppSizes.space),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
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

/// Grade de [ChoiceTile] "justificada": 2 colunas de mesma largura que
/// preenchem a tela (1 coluna com fonte muito grande). Cada linha tem altura
/// única e uma opção final sozinha ocupa a linha inteira.
class ChoiceGrid extends StatelessWidget {
  const ChoiceGrid({super.key, required this.children});

  final List<Widget> children;

  static const double gap = AppSizes.space + 2;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(20) / 20;
    final columns = scale > 1.3 ? 1 : 2;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final slice = children.sublist(
        i,
        (i + columns).clamp(0, children.length),
      );
      if (rows.isNotEmpty) rows.add(const SizedBox(height: gap));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < slice.length; j++) ...[
                if (j > 0) const SizedBox(width: gap),
                Expanded(child: slice[j]),
              ],
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

/// Mostra um aviso com "Desfazer" que SOME sozinho. Desde o Flutter 3.29 um
/// SnackBar com ação não some sem `persist: false`; por isso todo aviso com
/// "Desfazer" deve passar por aqui.
void showUndoSnackBar(
  ScaffoldMessengerState messenger, {
  required String message,
  required VoidCallback onUndo,
  Duration duration = const Duration(seconds: 3),
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        persist: false,
        action: SnackBarAction(label: 'Desfazer', onPressed: onUndo),
      ),
    );
}
