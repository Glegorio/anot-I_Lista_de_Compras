import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/app_widgets.dart';

/// Tela de carregamento (capa) do anotAI, exibida enquanto o banco local abre.
///
/// O ícone fica exatamente no CENTRO da tela, no mesmo tamanho (132) e sobre o mesmo fundo
/// branco da abertura nativa do Android; assim a passagem da abertura nativa para esta tela é
/// contínua. A marca e o lema ficam abaixo. Se a abertura falhar, mostra a mensagem e
/// "Tentar de novo".
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.onRetry});

  /// Não nulo = falhou ao abrir os dados locais.
  final VoidCallback? onRetry;

  static const double logoSize = 132;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final failed = onRetry != null;
    return Scaffold(
      backgroundColor: AppColors.surface,
      // Sem SafeArea: o ícone fica no centro EXATO da janela, como na abertura nativa.
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          // Estica na largura toda; cada bloco se centraliza sozinho.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: SizedBox.shrink()),
            Center(
              child: ExcludeSemantics(
                child: failed
                    ? const Icon(
                        Icons.error_outline,
                        size: logoSize * 0.6,
                        color: AppColors.error,
                      )
                    : Image.asset(
                        'assets/brand/icon.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                        // Decodifica em 3x (nítido em telas Full HD) sem carregar 1024 px na memória.
                        cacheWidth: (logoSize * 3).round(),
                      ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.screenPadding,
                  AppSizes.spaceXl,
                  AppSizes.screenPadding,
                  AppSizes.spaceXl + MediaQuery.viewPaddingOf(context).bottom,
                ),
                child: Column(
                  children: [
                    ClampedTitle(
                      child: Image.asset(
                        'assets/brand/wordmark.png',
                        height: 56,
                        cacheHeight: 168,
                        semanticLabel: 'anotAI',
                      ),
                    ),
                    const SizedBox(height: AppSizes.space),
                    Text(
                      failed
                          ? 'Não foi possível abrir seus dados neste aparelho.'
                          : 'Sua lista de compras inteligente',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceXl),
                    if (failed)
                      FilledButton(
                        onPressed: onRetry,
                        child: const IconLabel(
                          icon: Icons.refresh,
                          label: 'Tentar de novo',
                        ),
                      )
                    else
                      Semantics(
                        liveRegion: true,
                        label: 'Carregando o anotAI',
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                color: AppColors.primary,
                                backgroundColor: AppColors.primaryContainer,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spaceLg),
                            ExcludeSemantics(
                              child: Text(
                                'Carregando…',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
