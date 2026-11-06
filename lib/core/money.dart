import 'package:decimal/decimal.dart';

/// Regras de dinheiro. Nunca usa double.
///
/// Subtotal de cada linha = quantidade × preço unitário, arredondado para
/// duas casas com HALF_UP (metade para cima); o total é a soma das linhas.
Decimal roundMoney(Decimal value) => value.round(scale: 2);

Decimal lineSubtotal(Decimal quantity, Decimal unitPrice) =>
    roundMoney(quantity * unitPrice);

/// "R$ 1.234,50" (pt-BR, duas casas, milhar com ponto). Aceita negativos.
String formatBrl(Decimal value) {
  final rounded = roundMoney(value);
  final negative = rounded < Decimal.zero;
  final parts = (negative ? -rounded : rounded).toStringAsFixed(2).split('.');
  final digits = parts[0];
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write('.');
    grouped.write(digits[i]);
  }
  return '${negative ? '−' : ''}R\$ $grouped,${parts[1]}';
}
