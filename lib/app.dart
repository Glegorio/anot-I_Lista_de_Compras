import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/tokens.dart';
import 'features/home/home_screen.dart';
import 'features/lists/presentation/my_list_screen.dart';
import 'features/splash/splash_screen.dart';

GoRouter createRouter() => GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => Scaffold(
        body: shell,
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 2),
            ),
          ),
          child: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (i) =>
                shell.goBranch(i, initialLocation: i == shell.currentIndex),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_basket_outlined),
                selectedIcon: Icon(Icons.shopping_basket_rounded),
                label: 'Minha lista',
              ),
            ],
          ),
        ),
      ),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/lista', builder: (_, _) => const MyListScreen()),
          ],
        ),
      ],
    ),
  ],
);

class AnotAiApp extends StatefulWidget {
  const AnotAiApp({super.key, this.fontFamily});

  /// Só para capturas de tela em testes; em produção usa a fonte do sistema.
  final String? fontFamily;

  @override
  State<AnotAiApp> createState() => _AnotAiAppState();
}

class _AnotAiAppState extends State<AnotAiApp> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'anotAI',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(fontFamily: widget.fontFamily),
      routerConfig: _router,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) => _StartupGate(child: child),
    );
  }
}

/// Mostra a tela de carregamento até o banco local estar pronto.
class _StartupGate extends ConsumerWidget {
  const _StartupGate({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(appReadyProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: ready.when(
        data: (_) => KeyedSubtree(
          key: const ValueKey('app'),
          child: child ?? const SizedBox.shrink(),
        ),
        loading: () => const SplashScreen(key: ValueKey('splash')),
        error: (_, _) => SplashScreen(
          key: const ValueKey('splash-error'),
          onRetry: () => ref.invalidate(appReadyProvider),
        ),
      ),
    );
  }
}
