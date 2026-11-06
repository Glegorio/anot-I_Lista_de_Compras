import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// Tema único do app. Importante: ajustar tamanhos com `copyWith` sobre os
/// estilos-base (nunca substituir por `TextStyle(...)` novo), senão a cor e a
/// fonte se perdem e o texto fica ilegível.
ThemeData buildAppTheme({String? fontFamily}) {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    secondaryContainer: AppColors.primaryContainer,
    onSecondaryContainer: AppColors.onPrimaryContainer,
    tertiary: AppColors.primaryDark,
    onTertiary: AppColors.onPrimary,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceMuted,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.surface,
    surfaceContainerHigh: AppColors.surface,
    surfaceContainerHighest: AppColors.primaryContainer,
    outline: AppColors.outline,
    outlineVariant: AppColors.outline,
  );

  final base = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
  );

  TextStyle size(TextStyle? style, double fontSize, FontWeight weight) =>
      (style ?? const TextStyle()).copyWith(
        fontSize: fontSize,
        fontWeight: weight,
        height: 1.3,
      );

  final t = base.textTheme;
  final textTheme = t
      .copyWith(
        headlineMedium: size(t.headlineMedium, 32, FontWeight.w800),
        headlineSmall: size(t.headlineSmall, 28, FontWeight.w800),
        titleLarge: size(t.titleLarge, 26, FontWeight.w800),
        titleMedium: size(t.titleMedium, 22, FontWeight.w700),
        titleSmall: size(t.titleSmall, 20, FontWeight.w700),
        bodyLarge: size(t.bodyLarge, 20, FontWeight.w500),
        bodyMedium: size(t.bodyMedium, 18, FontWeight.w500),
        bodySmall: size(t.bodySmall, 16, FontWeight.w500),
        labelLarge: size(t.labelLarge, 20, FontWeight.w700),
        labelMedium: size(t.labelMedium, 16, FontWeight.w700),
        labelSmall: size(t.labelSmall, 14, FontWeight.w700),
      )
      .apply(bodyColor: AppColors.onSurface, displayColor: AppColors.onSurface);

  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
  );
  const buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.spaceXl,
    vertical: AppSizes.spaceLg,
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      centerTitle: false,
      titleSpacing: AppSizes.screenPadding,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.onPrimary, size: 30),
      actionsIconTheme: const IconThemeData(
        color: AppColors.onPrimary,
        size: 30,
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: AppColors.onPrimary,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(88, AppSizes.primaryTarget),
        padding: buttonPadding,
        textStyle: textTheme.labelLarge,
        shape: buttonShape,
        iconSize: 28,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(88, AppSizes.minTarget),
        padding: buttonPadding,
        textStyle: textTheme.labelLarge,
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: buttonShape,
        iconSize: 26,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(88, AppSizes.minTarget),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
        textStyle: textTheme.labelLarge,
        shape: buttonShape,
        iconSize: 26,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(AppSizes.minTarget, AppSizes.minTarget),
        iconSize: 30,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.onAccent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      extendedSizeConstraints: const BoxConstraints.tightFor(
        height: AppSizes.primaryTarget,
      ),
      extendedTextStyle: textTheme.labelLarge?.copyWith(
        color: AppColors.onAccent,
      ),
      extendedIconLabelSpacing: AppSizes.space,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: const BorderSide(color: Color(0xFF7A5A00), width: 2),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceLg,
        vertical: AppSizes.spaceLg,
      ),
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.onSurfaceMuted,
      ),
      floatingLabelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceMuted),
      helperStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.onSurfaceMuted,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.w700,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.outline, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.outline, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.primary, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.error, width: 3),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 88,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 32,
          color: states.contains(WidgetState.selected)
              ? AppColors.primaryDark
              : AppColors.onSurfaceMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelMedium?.copyWith(
          fontSize: 16,
          color: states.contains(WidgetState.selected)
              ? AppColors.primaryDark
              : AppColors.onSurfaceMuted,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        side: const BorderSide(color: AppColors.cardBorder, width: 2),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.onSurface,
      contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white),
      actionTextColor: AppColors.accent,
      behavior: SnackBarBehavior.floating,
      // Acima do botão flutuante (64 + margens), para nunca cobri-lo.
      insetPadding: const EdgeInsets.fromLTRB(
        AppSizes.spaceLg,
        0,
        AppSizes.spaceLg,
        96,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.primaryContainer,
      circularTrackColor: AppColors.primaryContainer,
    ),
  );
}
