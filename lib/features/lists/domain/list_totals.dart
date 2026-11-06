import 'package:decimal/decimal.dart';

import '../../../core/money.dart';

/// Dados mínimos de um item para calcular totais (independe do banco).
class PricedLine {
  const PricedLine({
    required this.quantity,
    this.predictedPrice,
    this.foundPrice,
    this.collected = false,
    this.notFound = false,
    this.substituted = false,
  });

  final Decimal quantity;

  /// Preço previsto por unidade (null = desconhecido, nunca zero).
  final Decimal? predictedPrice;

  /// Preço encontrado no mercado (null = não informado).
  final Decimal? foundPrice;

  /// Coletado = está no carrinho. NÃO significa pago.
  final bool collected;
  final bool notFound;
  final bool substituted;
}

/// Totais e cobertura de uma lista.
///
/// - **Previsto**: soma dos itens que ainda se espera comprar (exclui
///   "não encontrei") e que têm preço previsto. Itens sem preço NÃO entram
///   como zero: aparecem em [unpricedCount].
/// - **Encontrado**: soma dos itens no carrinho que têm preço encontrado.
class ListTotals {
  const ListTotals({
    required this.activeCount,
    required this.pricedCount,
    required this.predictedTotal,
    required this.collectedCount,
    required this.notFoundCount,
    required this.substitutedCount,
    required this.pendingCount,
    required this.foundPricedCount,
    required this.foundTotal,
  });

  factory ListTotals.from(Iterable<PricedLine> lines) {
    var active = 0, priced = 0, collected = 0, notFound = 0;
    var substituted = 0, pending = 0, foundPriced = 0;
    var predicted = Decimal.zero, found = Decimal.zero;
    for (final line in lines) {
      if (line.notFound) {
        notFound++;
        continue;
      }
      active++;
      final price = line.predictedPrice;
      if (price != null) {
        priced++;
        predicted += lineSubtotal(line.quantity, price);
      }
      if (line.collected) {
        collected++;
        if (line.substituted) substituted++;
        final foundPrice = line.foundPrice;
        if (foundPrice != null) {
          foundPriced++;
          found += lineSubtotal(line.quantity, foundPrice);
        }
      } else {
        pending++;
      }
    }
    return ListTotals(
      activeCount: active,
      pricedCount: priced,
      predictedTotal: predicted,
      collectedCount: collected,
      notFoundCount: notFound,
      substitutedCount: substituted,
      pendingCount: pending,
      foundPricedCount: foundPriced,
      foundTotal: found,
    );
  }

  /// Itens ativos (todos menos "não encontrei").
  final int activeCount;
  final int pricedCount;
  final Decimal predictedTotal;
  final int collectedCount;
  final int notFoundCount;
  final int substitutedCount;
  final int pendingCount;
  final int foundPricedCount;
  final Decimal foundTotal;

  int get unpricedCount => activeCount - pricedCount;

  /// Coletados sem preço encontrado (o total encontrado não os inclui).
  int get collectedWithoutFoundPrice => collectedCount - foundPricedCount;

  /// O previsto cobre todos os itens ativos?
  bool get predictedIsComplete => activeCount > 0 && unpricedCount == 0;

  /// Há algum preço previsto para mostrar?
  bool get hasPredicted => pricedCount > 0;
}

/// Situação do orçamento frente ao previsto (só com os preços conhecidos).
class BudgetStatus {
  const BudgetStatus({
    required this.budget,
    required this.difference,
    required this.exceeded,
    required this.partial,
  });

  factory BudgetStatus.of(Decimal budget, ListTotals totals) {
    final diff = budget - totals.predictedTotal;
    return BudgetStatus(
      budget: budget,
      difference: diff < Decimal.zero ? -diff : diff,
      exceeded: diff < Decimal.zero,
      partial: !totals.predictedIsComplete,
    );
  }

  final Decimal budget;

  /// Valor absoluto da sobra ou do estouro.
  final Decimal difference;
  final bool exceeded;

  /// O previsto ignora itens sem preço (a conta pode estar incompleta).
  final bool partial;
}
