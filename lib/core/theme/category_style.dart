import 'package:flutter/material.dart';

/// Cor + ícone de cada categoria. A cor nunca é o único indicador: sempre
/// acompanha ícone e nome.
class CategoryStyle {
  const CategoryStyle({
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final IconData icon;

  /// Fundo suave do cartão/avatar.
  final Color background;

  /// Texto e ícone sobre [background] (contraste >= 7:1).
  final Color foreground;
}

const _neutral = CategoryStyle(
  icon: Icons.label_outline,
  background: Color(0xFFE3EAE5),
  foreground: Color(0xFF26352D),
);

const categoryStyles = <String, CategoryStyle>{
  'hortifruti': CategoryStyle(
    icon: Icons.eco,
    background: Color(0xFFD6F2D9),
    foreground: Color(0xFF0B4F1B),
  ),
  'padaria': CategoryStyle(
    icon: Icons.bakery_dining,
    background: Color(0xFFFFEFB0),
    foreground: Color(0xFF5A4200),
  ),
  'carnes': CategoryStyle(
    icon: Icons.kebab_dining,
    background: Color(0xFFFFD6D2),
    foreground: Color(0xFF7A1410),
  ),
  'laticinios': CategoryStyle(
    icon: Icons.icecream,
    background: Color(0xFFD3E6FD),
    foreground: Color(0xFF0B3A73),
  ),
  'mercearia': CategoryStyle(
    icon: Icons.shopping_basket,
    background: Color(0xFFE6D9F7),
    foreground: Color(0xFF45186F),
  ),
  'bebidas': CategoryStyle(
    icon: Icons.local_drink,
    background: Color(0xFFFFDDC6),
    foreground: Color(0xFF6E2A00),
  ),
  'limpeza': CategoryStyle(
    icon: Icons.cleaning_services,
    background: Color(0xFFCDEFF2),
    foreground: Color(0xFF05505A),
  ),
  'higiene': CategoryStyle(
    icon: Icons.soap,
    background: Color(0xFFFFD9EA),
    foreground: Color(0xFF7D0F48),
  ),
};

CategoryStyle categoryStyleFor(String? slug) =>
    categoryStyles[slug] ?? _neutral;
