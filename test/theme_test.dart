import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/core/theme/app_theme.dart';
import 'package:anotai_lista/core/theme/category_style.dart';
import 'package:anotai_lista/core/theme/tokens.dart';

void main() {
  test('pares de cor de texto atendem 4,5:1 (WCAG AA)', () {
    final checks = {
      'texto/fundo': contrastRatio(AppColors.onSurface, AppColors.background),
      'texto/superfície': contrastRatio(AppColors.onSurface, AppColors.surface),
      'secundário/fundo': contrastRatio(
        AppColors.onSurfaceMuted,
        AppColors.background,
      ),
      'secundário/superfície': contrastRatio(
        AppColors.onSurfaceMuted,
        AppColors.surface,
      ),
      'secundário/container': contrastRatio(
        AppColors.onSurfaceMuted,
        AppColors.primaryContainer,
      ),
      'primária/fundo': contrastRatio(AppColors.primary, AppColors.background),
      'primária/superfície': contrastRatio(
        AppColors.primary,
        AppColors.surface,
      ),
      'sobre primária': contrastRatio(AppColors.onPrimary, AppColors.primary),
      'sobre primária escura': contrastRatio(
        AppColors.onPrimary,
        AppColors.primaryDark,
      ),
      'sobre container': contrastRatio(
        AppColors.onPrimaryContainer,
        AppColors.primaryContainer,
      ),
      'sobre destaque': contrastRatio(AppColors.onAccent, AppColors.accent),
      'sobre destaque suave': contrastRatio(
        AppColors.onAccentContainer,
        AppColors.accentContainer,
      ),
      'erro/superfície': contrastRatio(AppColors.error, AppColors.surface),
      'erro/container': contrastRatio(
        AppColors.error,
        AppColors.primaryContainer,
      ),
      'sobre erro': contrastRatio(AppColors.onError, AppColors.error),
      'sobre container de erro': contrastRatio(
        AppColors.onErrorContainer,
        AppColors.errorContainer,
      ),
      'acento sobre primária (spinner)': contrastRatio(
        AppColors.accent,
        AppColors.primaryDark,
      ),
    };
    checks.forEach((name, ratio) {
      expect(ratio, greaterThanOrEqualTo(4.5), reason: '$name = $ratio');
    });
    expect(
      contrastRatio(AppColors.onSurface, AppColors.background),
      greaterThanOrEqualTo(7),
      reason: 'texto principal deve atingir AAA',
    );
  });

  test('contorno de componentes interativos tem >= 3:1 contra o fundo', () {
    expect(
      contrastRatio(AppColors.outline, AppColors.background),
      greaterThanOrEqualTo(3),
    );
    expect(
      contrastRatio(AppColors.outline, AppColors.surface),
      greaterThanOrEqualTo(3),
    );
  });

  test('cada categoria tem texto/ícone com >= 7:1 sobre o seu fundo', () {
    expect(categoryStyles.keys, hasLength(8));
    categoryStyles.forEach((slug, style) {
      expect(
        contrastRatio(style.foreground, style.background),
        greaterThanOrEqualTo(7),
        reason: slug,
      );
      expect(
        contrastRatio(style.foreground, Colors.white),
        greaterThanOrEqualTo(7),
        reason: '$slug (ícone no círculo branco)',
      );
    });
    final backgrounds = categoryStyles.values.map((s) => s.background).toSet();
    expect(backgrounds, hasLength(8), reason: 'cada categoria tem cor própria');
    final icons = categoryStyles.values.map((s) => s.icon).toSet();
    expect(icons, hasLength(8), reason: 'cor nunca é o único diferencial');
  });

  test(
    'tema: todo estilo de texto tem cor escura definida e fonte legível',
    () {
      // Regressão: estilos recriados com TextStyle(...) perdiam a cor e o texto
      // aparecia branco sobre fundo claro.
      final text = buildAppTheme().textTheme;
      final styles = {
        'headlineMedium': text.headlineMedium,
        'headlineSmall': text.headlineSmall,
        'titleLarge': text.titleLarge,
        'titleMedium': text.titleMedium,
        'titleSmall': text.titleSmall,
        'bodyLarge': text.bodyLarge,
        'bodyMedium': text.bodyMedium,
        'bodySmall': text.bodySmall,
        'labelLarge': text.labelLarge,
        'labelMedium': text.labelMedium,
      };
      styles.forEach((name, style) {
        expect(style, isNotNull, reason: name);
        expect(
          style!.color,
          AppColors.onSurface,
          reason: '$name sem cor escura',
        );
        expect(style.fontSize, greaterThanOrEqualTo(16), reason: name);
      });
      expect(text.bodyLarge!.fontSize, greaterThanOrEqualTo(20));
      expect(text.titleLarge!.fontSize, greaterThanOrEqualTo(26));
    },
  );

  test('tema: botões e navegação respeitam alvos grandes', () {
    final theme = buildAppTheme();
    final filled = theme.filledButtonTheme.style!;
    expect(
      filled.minimumSize!.resolve({})!.height,
      greaterThanOrEqualTo(AppSizes.primaryTarget),
    );
    expect(
      theme.textButtonTheme.style!.minimumSize!.resolve({})!.height,
      greaterThanOrEqualTo(AppSizes.minTarget),
    );
    expect(theme.navigationBarTheme.height, greaterThanOrEqualTo(80));
    expect(
      theme.floatingActionButtonTheme.extendedSizeConstraints!.minHeight,
      greaterThanOrEqualTo(AppSizes.primaryTarget),
    );
  });

  test('contraste conhecido: preto sobre branco é 21:1', () {
    expect(
      contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
  });
}
