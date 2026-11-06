import 'package:decimal/decimal.dart';

/// Resultado da leitura de um número digitado pelo usuário.
sealed class ParsedNumber {
  const ParsedNumber();
}

class ParsedValue extends ParsedNumber {
  const ParsedValue(this.value);
  final Decimal value;
}

class ParsedError extends ParsedNumber {
  const ParsedError(this.message);
  final String message;
}

final _ptBrNumber = RegExp(r'^\d{1,9}(,\d{1,4})?$');

/// Aceita somente vírgula como separador decimal ("0,333"). Ponto é rejeitado
/// de forma explícita para não confundir milhar com decimal ("1.500").
ParsedNumber parseDecimalPtBr(String input) {
  final text = input.trim();
  if (text.isEmpty) return const ParsedError('Informe um valor.');
  if (text.contains('.')) {
    return const ParsedError('Use vírgula para decimais, por exemplo 1,5.');
  }
  if (!_ptBrNumber.hasMatch(text)) {
    return const ParsedError(
      'Valor inválido. Use números, por exemplo 2 ou 0,5.',
    );
  }
  return ParsedValue(Decimal.parse(text.replaceAll(',', '.')));
}

/// Formata quantidade em pt-BR sem zeros à direita: 2 -> "2", 0.333 -> "0,333".
String formatQuantity(Decimal value) => value.toString().replaceAll('.', ',');

const unitLabels = <String, String>{
  'un': 'unidade',
  'kg': 'quilo (kg)',
  'g': 'grama (g)',
  'l': 'litro (l)',
  'ml': 'mililitro (ml)',
};

/// Texto curto falado/exibido: "2 un", "0,5 kg".
String formatQuantityWithUnit(Decimal quantity, String unit) =>
    '${formatQuantity(quantity)} $unit';
