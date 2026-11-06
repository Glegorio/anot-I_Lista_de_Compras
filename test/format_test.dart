import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/core/format.dart';

void main() {
  test('aceita vírgula como separador decimal', () {
    final parsed = parseDecimalPtBr('0,333');
    expect(parsed, isA<ParsedValue>());
    expect((parsed as ParsedValue).value, Decimal.parse('0.333'));
    expect((parseDecimalPtBr(' 2 ') as ParsedValue).value, Decimal.fromInt(2));
  });

  test('rejeita ponto, vazio e lixo com mensagem', () {
    for (final bad in [
      '',
      '1.5',
      '1.500',
      'abc',
      '1,2,3',
      '-1',
      '1,23456',
      ',5',
    ]) {
      expect(parseDecimalPtBr(bad), isA<ParsedError>(), reason: bad);
    }
  });

  test('formata sem zeros à direita e com vírgula', () {
    expect(formatQuantity(Decimal.parse('2.0')), '2');
    expect(formatQuantity(Decimal.parse('0.3330')), '0,333');
    expect(formatQuantityWithUnit(Decimal.parse('1.5'), 'kg'), '1,5 kg');
  });

  test('quantidade fracionária não sofre erro de ponto flutuante', () {
    final third = (parseDecimalPtBr('0,333') as ParsedValue).value;
    expect((third * Decimal.fromInt(3)).toString(), '0.999');
  });
}
