import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/core/money.dart';

Decimal d(String v) => Decimal.parse(v);

void main() {
  group('subtotal da linha (quantidade × preço, HALF_UP em 2 casas)', () {
    test('2 × 10,25 = 20,50', () {
      expect(lineSubtotal(d('2'), d('10.25')), d('20.5'));
      expect(formatBrl(lineSubtotal(d('2'), d('10.25'))), 'R\$ 20,50');
    });

    test('quantidade fracionária de peso: 0,333 kg × 29,90', () {
      // 0,333 × 29,90 = 9,9567 -> 9,96
      expect(lineSubtotal(d('0.333'), d('29.90')), d('9.96'));
      // 1,5 kg × 7,99 = 11,985 -> 11,99 (metade sobe)
      expect(lineSubtotal(d('1.5'), d('7.99')), d('11.99'));
    });

    test('metade sempre sobe, sem erro binário de ponto flutuante', () {
      expect(roundMoney(d('0.005')), d('0.01'));
      expect(roundMoney(d('1.005')), d('1.01')); // com double daria 1.00
      expect(roundMoney(d('2.675')), d('2.68')); // com double daria 2.67
      expect(roundMoney(d('0.004')), d('0'));
      expect(roundMoney(d('0.994')), d('0.99'));
    });

    test(
      'arredonda cada linha e depois soma (não soma e depois arredonda)',
      () {
        final lines = [
          for (var i = 0; i < 3; i++) lineSubtotal(d('1'), d('0.005')),
        ];
        final sum = lines.fold(Decimal.zero, (a, b) => a + b);
        expect(sum, d('0.03')); // 3 × 0,01 (e não 0,015 → 0,02)
      },
    );

    test('preço com 4 casas e quantidade decimal ficam exatos', () {
      expect(
        lineSubtotal(d('0.1'), d('0.2')),
        d('0.02'),
      ); // 0,1×0,2 = 0,02 exato
      expect(lineSubtotal(d('3'), d('0.3333')), d('1')); // 0,9999 -> 1,00
    });
  });

  group('formatBrl', () {
    test('duas casas, vírgula e milhar com ponto', () {
      expect(formatBrl(d('0')), 'R\$ 0,00');
      expect(formatBrl(d('5')), 'R\$ 5,00');
      expect(formatBrl(d('20.5')), 'R\$ 20,50');
      expect(formatBrl(d('999.995')), 'R\$ 1.000,00');
      expect(formatBrl(d('1234567.891')), 'R\$ 1.234.567,89');
    });

    test('valores negativos usam sinal de menos', () {
      expect(formatBrl(d('-5.5')), '−R\$ 5,50');
    });
  });
}
