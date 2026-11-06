import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/features/lists/domain/list_totals.dart';

Decimal d(String v) => Decimal.parse(v);

PricedLine line(
  String qty, {
  String? price,
  String? found,
  bool collected = false,
  bool notFound = false,
  bool substituted = false,
}) => PricedLine(
  quantity: d(qty),
  predictedPrice: price == null ? null : d(price),
  foundPrice: found == null ? null : d(found),
  collected: collected,
  notFound: notFound,
  substituted: substituted,
);

void main() {
  group('previsto e cobertura', () {
    test(
      'arroz 2 × 10,25 + item sem preço: 20,50 conhecidos e 1 sem preço',
      () {
        final totals = ListTotals.from([line('2', price: '10.25'), line('1')]);
        expect(totals.predictedTotal, d('20.5'));
        expect(totals.pricedCount, 1);
        expect(totals.unpricedCount, 1);
        expect(totals.activeCount, 2);
        expect(totals.hasPredicted, isTrue);
        expect(totals.predictedIsComplete, isFalse);
      },
    );

    test('nenhum preço: não há total (não é "R\$ 0,00")', () {
      final totals = ListTotals.from([line('1'), line('2')]);
      expect(totals.hasPredicted, isFalse);
      expect(totals.unpricedCount, 2);
      expect(totals.predictedTotal, Decimal.zero);
    });

    test('todos com preço: previsto completo', () {
      final totals = ListTotals.from([
        line('0.333', price: '29.90'),
        line('3', price: '1.10'),
      ]);
      expect(totals.predictedTotal, d('13.26')); // 9,96 + 3,30
      expect(totals.predictedIsComplete, isTrue);
    });

    test('lista vazia', () {
      final totals = ListTotals.from(const []);
      expect(totals.activeCount, 0);
      expect(totals.predictedIsComplete, isFalse);
      expect(totals.pendingCount, 0);
    });

    test('"não encontrei" sai do previsto e da cobertura', () {
      final totals = ListTotals.from([
        line('1', price: '5'),
        line('1', price: '100', notFound: true),
        line('1', notFound: true),
      ]);
      expect(totals.predictedTotal, d('5'));
      expect(totals.activeCount, 1);
      expect(totals.notFoundCount, 2);
      expect(totals.unpricedCount, 0);
    });
  });

  group('compra: coletados, pendentes e preço encontrado', () {
    test(
      'contagens e total encontrado só com itens que têm preço encontrado',
      () {
        final totals = ListTotals.from([
          line('2', price: '10', found: '11', collected: true), // 22,00
          line(
            '1',
            price: '5',
            collected: true,
          ), // coletado sem preço encontrado
          line('1', price: '8'), // pendente
          line('1', found: '9.99', collected: true, substituted: true), // 9,99
        ]);
        expect(totals.collectedCount, 3);
        expect(totals.pendingCount, 1);
        expect(totals.substitutedCount, 1);
        expect(totals.foundPricedCount, 2);
        expect(totals.foundTotal, d('31.99'));
        expect(totals.collectedWithoutFoundPrice, 1);
        // Previsto não muda por causa do encontrado.
        expect(totals.predictedTotal, d('33')); // 20 + 5 + 8
      },
    );

    test('encontrado de item pendente não entra no total', () {
      final totals = ListTotals.from([line('1', found: '50')]);
      expect(totals.foundTotal, Decimal.zero);
      expect(totals.foundPricedCount, 0);
    });
  });

  group('orçamento', () {
    test(
      'sobra com cobertura parcial avisa que a conta pode estar incompleta',
      () {
        final totals = ListTotals.from([line('2', price: '10.25'), line('1')]);
        final status = BudgetStatus.of(d('100'), totals);
        expect(status.exceeded, isFalse);
        expect(status.difference, d('79.5'));
        expect(status.partial, isTrue);
      },
    );

    test('estouro mostra a diferença em valor absoluto', () {
      final totals = ListTotals.from([line('3', price: '10')]);
      final status = BudgetStatus.of(d('25.50'), totals);
      expect(status.exceeded, isTrue);
      expect(status.difference, d('4.5'));
      expect(status.partial, isFalse);
    });

    test('igual ao orçamento: sobra zero, sem estouro', () {
      final totals = ListTotals.from([line('1', price: '10')]);
      final status = BudgetStatus.of(d('10'), totals);
      expect(status.exceeded, isFalse);
      expect(status.difference, Decimal.zero);
    });
  });
}
