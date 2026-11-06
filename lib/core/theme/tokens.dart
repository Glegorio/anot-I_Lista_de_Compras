import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Tokens semânticos de design (cores, tamanhos e espaçamentos);
/// os pares de texto são verificados em test/theme_test.dart (>= 4,5:1, a maioria >= 7:1).
abstract final class AppColors {
  // Superfícies e texto
  static const background = Color(0xFFF2F7F3);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF13201A);
  static const onSurfaceMuted = Color(0xFF3D4D44);

  // Marca (verde): ações principais, cabeçalhos, seleção
  static const primary = Color(0xFF0B6B3A);
  static const primaryDark = Color(0xFF064D28);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFD5F0DE);
  static const onPrimaryContainer = Color(0xFF05361D);

  // Destaque (âmbar): ação rápida "Adicionar"
  static const accent = Color(0xFFFFC107);
  static const onAccent = Color(0xFF2B1D00);
  static const accentContainer = Color(0xFFFFF0C2);
  static const onAccentContainer = Color(0xFF4A3500);

  // Erro / ação destrutiva
  static const error = Color(0xFFB3261E);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF5C0A06);

  // Bordas de componentes interativos (não-texto >= 3:1)
  static const outline = Color(0xFF5E7066);

  // Contorno suave de cartões (agrupamento visual; sem sombras pesadas)
  static const cardBorder = Color(0xFFA9BBAF);
}

abstract final class AppSizes {
  /// Texto base (unidades lógicas); o sistema ainda pode ampliar.
  static const baseFont = 20.0;

  /// Altura mínima de qualquer alvo de toque.
  static const minTarget = 56.0;

  /// Ação principal da tela.
  static const primaryTarget = 64.0;

  // Escala de espaço (múltiplos de 4): 8 · 12 · 16 · 24.
  static const space = 8.0;
  static const spaceMd = 12.0;
  static const spaceLg = 16.0;
  static const spaceXl = 24.0;

  /// Margem lateral ÚNICA de todas as telas: cabeçalho, cartões, campos,
  /// títulos de seção e botões começam e terminam nesta linha.
  static const screenPadding = 20.0;

  /// Espaço entre cartões/itens empilhados.
  static const cardGap = spaceMd;

  /// Espaço acima de cada título de seção.
  static const sectionGap = spaceXl;

  static const radius = 20.0;
  static const radiusSm = 14.0;
}

/// Razão de contraste WCAG entre duas cores opacas.
double contrastRatio(Color a, Color b) {
  double lum(Color c) {
    double channel(double v) => v <= 0.03928
        ? v / 12.92
        : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * channel(c.r) +
        0.7152 * channel(c.g) +
        0.0722 * channel(c.b);
  }

  final l1 = lum(a);
  final l2 = lum(b);
  final hi = math.max(l1, l2);
  final lo = math.min(l1, l2);
  return (hi + 0.05) / (lo + 0.05);
}
