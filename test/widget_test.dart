import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/app.dart';
import 'package:anotai_lista/core/database/app_database.dart';
import 'package:anotai_lista/core/providers.dart';
import 'package:anotai_lista/core/theme/tokens.dart';
import 'package:anotai_lista/features/lists/presentation/my_list_screen.dart';
import 'package:anotai_lista/features/splash/splash_screen.dart';

// Tela alta nos testes: a lista é preguiçosa e só constrói o que está visível.
const defaultSize = Size(400, 1400);

/// O Drift conclui operações no event loop real; cede a ele e depois renderiza.
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pumpAndSettle();
}

Future<void> mountApp(
  WidgetTester tester,
  AppDatabase db, {
  double textScale = 1,
  Size size = defaultSize,
  Duration splash = Duration.zero,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: [
        databaseProvider.overrideWithValue(db),
        splashMinDurationProvider.overrideWithValue(splash),
      ],
      child: MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScale),
        ),
        child: const AnotAiApp(),
      ),
    ),
  );
  await settle(tester);
}

/// Monta o app com banco em memória e encerra os streams do Drift antes de
/// fechar o banco, evitando timers pendentes.
void appTest(
  String name,
  Future<void> Function(WidgetTester tester, AppDatabase db) body, {
  double textScale = 1,
  Size size = defaultSize,
}) {
  testWidgets(name, (tester) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    try {
      await mountApp(tester, db, textScale: textScale, size: size);
      await body(tester, db);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(
        const Duration(seconds: 1),
      ); // descarrega timers dos streams
      await db.close();
    }
  });
}

Future<void> openMyList(WidgetTester tester) async {
  await tester.tap(find.byType(NavigationDestination).at(1)); // um toque
  await settle(tester);
}

/// Abre o formulário de novo item: lista vazia usa o botão central; com itens,
/// o botão flutuante.
Future<void> openNewItemForm(WidgetTester tester) async {
  final fab = find.text('Adicionar item');
  final target = fab.evaluate().isNotEmpty
      ? fab
      : find.text('Adicionar primeiro item');
  await tester.ensureVisible(
    target,
  ); // em tela pequena o botão fica abaixo da dobra
  await tester.pumpAndSettle();
  await tester.tap(target);
  await settle(tester);
}

Future<void> addItemThroughUi(
  WidgetTester tester,
  String name, {
  String? qty,
  String? price,
}) async {
  await openNewItemForm(tester);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Nome do item'),
    name,
  );
  if (qty != null) {
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quantidade'),
      qty,
    );
  }
  if (price != null) {
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Preço por unidade'),
      price,
    );
  }
  await tapVisible(tester, find.text('Adicionar à lista'));
}

Finder priceField() => find.widgetWithText(TextFormField, 'Preço por unidade');

/// Abre "Opções" do item (modo compra) e escolhe o resultado.
Future<void> openOutcome(WidgetTester tester, String itemName) async {
  await tester.ensureVisible(find.bySemanticsLabel('Opções $itemName'));
  await tester.pumpAndSettle();
  await tester.tap(find.bySemanticsLabel('Opções $itemName'));
  await settle(tester);
  expect(find.text('Como foi?'), findsOneWidget);
}

/// Rola a lista da tela "Minha lista" aos poucos até o alvo ser construído
/// (a lista é preguiçosa: em tela pequena/fonte grande parte fica fora).
Future<void> scrollListTo(WidgetTester tester, Finder target) async {
  final scrollable = find.descendant(
    of: find.byType(MyListScreen),
    matching: find.byType(Scrollable),
  );
  final position = tester.state<ScrollableState>(scrollable).position;
  for (var i = 0; i < 30 && target.evaluate().isEmpty; i++) {
    position.jumpTo(
      (position.pixels + 120).clamp(0, position.maxScrollExtent).toDouble(),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

Future<void> startShopping(WidgetTester tester) async {
  await tapVisible(tester, find.text('Iniciar compra'));
  expect(find.text('Comprando agora'), findsOneWidget);
}

/// Rola até o alvo (como o usuário faria) e toca.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await settle(tester);
  await tester.tap(finder);
  await settle(tester);
}

void main() {
  appTest('abre offline com as duas áreas e atalho para Minha lista', (
    tester,
    db,
  ) async {
    expect(find.text('O que vamos comprar hoje?'), findsOneWidget);
    for (final label in ['Início', 'Minha lista']) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.text('Hortifrúti'), findsOneWidget);
    expect(find.text('Higiene'), findsOneWidget);

    await openMyList(tester);
    expect(find.text('Sua lista está vazia'), findsOneWidget);
  });

  appTest('cria lista e itens offline, marca, remove e desfaz', (
    tester,
    db,
  ) async {
    await openMyList(tester);
    await addItemThroughUi(tester, 'Arroz', qty: '0,5');
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('0,5 un'), findsOneWidget);
    expect(find.text('0 de 1 no carrinho'), findsWidgets);
    expect(find.text('1 item sem preço (fora da soma)'), findsWidgets);

    await tester.tap(find.text('Arroz'));
    await settle(tester);
    expect(find.text('1 de 1 no carrinho'), findsWidgets);

    // Remover fica dentro da edição (longe do toque de marcar).
    await tester.tap(find.bySemanticsLabel('Editar Arroz'));
    await settle(tester);
    await tapVisible(tester, find.text('Remover este item'));
    expect(find.text('Sua lista está vazia'), findsOneWidget);
    await tester.tap(find.text('Desfazer'));
    await settle(tester);
    expect(find.text('Arroz'), findsOneWidget);
  });

  appTest('rejeita quantidade com ponto e quantidade zero', (tester, db) async {
    await openMyList(tester);
    await addItemThroughUi(tester, 'Queijo', qty: '1.5');
    expect(find.textContaining('Use vírgula'), findsWidgets);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quantidade'),
      '0',
    );
    await tapVisible(tester, find.text('Adicionar à lista'));
    expect(find.textContaining('maior que zero'), findsWidgets);
    expect(await db.select(db.shoppingListItems).get(), isEmpty);
  });

  appTest('categoria na Início abre formulário já categorizado', (
    tester,
    db,
  ) async {
    await tapVisible(tester, find.text('Bebidas'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome do item'),
      'Suco',
    );
    await tapVisible(tester, find.text('Adicionar à lista'));
    final items = await db.select(db.shoppingListItems).get();
    expect(items.single.categorySlug, 'bebidas');
  });

  appTest(
    'texto a 200% em tela pequena e nome longo sem overflow',
    (tester, db) async {
      const longName =
          'Biscoito recheado sabor chocolate com cobertura crocante edição '
          'especial família grande';
      expect(tester.takeException(), isNull);
      await openMyList(tester);
      await addItemThroughUi(tester, longName, qty: '12,5');
      expect(tester.takeException(), isNull);
      // A mensagem "Item adicionado" (grande a 200%) some sozinha após alguns segundos.
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      // Com texto a 200% o item fica abaixo da dobra: rola a lista até o fim.
      final listScrollable = find.descendant(
        of: find.byType(MyListScreen),
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(listScrollable).position;
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(find.text(longName), findsOneWidget);

      await tapVisible(tester, find.text('Editar'));
      expect(tester.takeException(), isNull);
      expect(find.text('Salvar alterações'), findsOneWidget);
    },
    textScale: 2,
    size: const Size(320, 568),
  );

  appTest('alvos de toque >= 56 e rótulos semânticos', (tester, db) async {
    await openMyList(tester);
    await addItemThroughUi(tester, 'Pão');

    for (final finder in [
      find
          .ancestor(of: find.text('Editar'), matching: find.byType(InkWell))
          .first,
      find.ancestor(
        of: find.text('Adicionar item'),
        matching: find.byType(FilledButton),
      ),
    ]) {
      expect(tester.getSize(finder).height, greaterThanOrEqualTo(56));
      expect(tester.getSize(finder).width, greaterThanOrEqualTo(56));
    }
    expect(find.bySemanticsLabel('Pão, 1 un, sem preço'), findsOneWidget);
    expect(find.bySemanticsLabel('Editar Pão'), findsOneWidget);
  });

  appTest('lista persiste ao reabrir o app com o mesmo banco', (
    tester,
    db,
  ) async {
    await openMyList(tester);
    await addItemThroughUi(tester, 'Café');

    // Reabre: árvore de widgets e providers novos, mesmo banco.
    await tester.pumpWidget(const SizedBox());
    await mountApp(tester, db);
    expect(find.text('0 de 1 no carrinho'), findsWidgets);
    await openMyList(tester);
    expect(find.text('Café'), findsOneWidget);
  });

  appTest('cria, troca, renomeia e exclui listas pela interface', (
    tester,
    db,
  ) async {
    await openMyList(tester);
    await tester.tap(find.text('Listas'));
    await settle(tester);
    expect(find.text('Minhas listas'), findsOneWidget);

    await tester.tap(find.text('Nova lista'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'Feira');
    await tester.tap(find.text('Salvar'));
    await settle(tester);
    expect(find.text('Feira'), findsOneWidget);
    expect(find.text('Atual'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Renomear Feira'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'Feira de sábado');
    await tester.tap(find.text('Salvar'));
    await settle(tester);
    expect(find.text('Feira de sábado'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Excluir Feira de sábado'));
    await settle(tester);
    expect(
      find.textContaining('serão apagados deste aparelho'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
    await settle(tester);
    expect(find.text('Feira de sábado'), findsNothing);
    expect(await db.select(db.shoppingLists).get(), isEmpty);
  });

  appTest('mostra a tela de carregamento e depois o início', (
    tester,
    db,
  ) async {
    await tester.pumpWidget(const SizedBox()); // desmonta o app já carregado
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          splashMinDurationProvider.overrideWithValue(
            const Duration(milliseconds: 600),
          ),
        ],
        child: const AnotAiApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Carregando…'), findsOneWidget);
    expect(find.bySemanticsLabel('Carregando o anotAI'), findsOneWidget);
    expect(find.text('O que vamos comprar hoje?'), findsNothing);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Carregando…'), findsNothing);
    expect(find.text('O que vamos comprar hoje?'), findsOneWidget);
  });

  testWidgets('se o banco falhar ao abrir, oferece tentar de novo', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appReadyProvider.overrideWith((ref) async {
            attempts++;
            if (attempts == 1) throw StateError('falha simulada');
          }),
        ],
        child: const AnotAiApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Tentar de novo'), findsOneWidget);
    expect(
      find.text('Não foi possível abrir seus dados neste aparelho.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tentar de novo'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(attempts, 2);
    expect(find.text('Tentar de novo'), findsNothing);
  });

  appTest('adição rápida pelo Início: 1 unidade e desfazer', (
    tester,
    db,
  ) async {
    await tester.enterText(find.byType(TextField), 'Leite integral');
    await tapVisible(tester, find.text('Adicionar'));
    var items = await db.select(db.shoppingListItems).get();
    expect(items.single.name, 'Leite integral');
    expect(items.single.quantity.toString(), '1');
    expect(items.single.unit, 'un');
    expect(find.textContaining('adicionado à lista'), findsOneWidget);

    await tester.tap(find.text('Desfazer'));
    await settle(tester);
    items = await db.select(db.shoppingListItems).get();
    expect(items, isEmpty);

    await tapVisible(tester, find.text('Adicionar')); // campo vazio
    expect(await db.select(db.shoppingListItems).get(), isEmpty);
  });

  appTest('botões + e − ajustam a quantidade conforme a unidade', (
    tester,
    db,
  ) async {
    await openMyList(tester);
    await openNewItemForm(tester);

    Finder quantity() => find.widgetWithText(TextFormField, 'Quantidade');
    String shown() => tester.widget<TextFormField>(quantity()).controller!.text;

    await tester.tap(find.byTooltip('Aumentar quantidade'));
    await tester.pump();
    expect(shown(), '2');
    await tester.tap(find.byTooltip('Diminuir quantidade'));
    await tester.tap(find.byTooltip('Diminuir quantidade')); // não passa de 1
    await tester.pump();
    expect(shown(), '1');

    await tester.tap(find.text('quilo (kg)'));
    await tester.pump();
    await tester.tap(find.byTooltip('Aumentar quantidade'));
    await tester.pump();
    expect(shown(), '1,5');

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome do item'),
      'Maçã',
    );
    // Tira o foco do nome (o campo focado reposiciona a rolagem) e rola até o fim:
    // a lista de categorias fica abaixo da dobra.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(10000);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hortifrúti').last);
    await tester.pump();
    await tapVisible(tester, find.text('Adicionar à lista'));
    final item = (await db.select(db.shoppingListItems).get()).single;
    expect(item.unit, 'kg');
    expect(item.quantity.toString(), '1.5');
    expect(item.categorySlug, 'hortifruti');
  });

  appTest('itens coletados vão para a seção "No carrinho"', (tester, db) async {
    await openMyList(tester);
    await addItemThroughUi(tester, 'Arroz');
    await addItemThroughUi(tester, 'Feijão');
    expect(find.text('Para comprar'), findsOneWidget);
    expect(find.text('No carrinho'), findsNothing);

    await tester.tap(find.text('Arroz'));
    await settle(tester);
    expect(find.text('No carrinho'), findsOneWidget);
    expect(find.text('1 de 2 no carrinho'), findsWidgets);
  });

  appTest('lista vazia mostra um único botão de adicionar (sem duplicado)', (
    tester,
    db,
  ) async {
    await openMyList(tester);
    expect(find.text('Adicionar primeiro item'), findsOneWidget);
    expect(find.text('Adicionar item'), findsNothing);
    await addItemThroughUi(tester, 'Pão');
    expect(find.text('Adicionar item'), findsOneWidget);
    expect(find.text('Adicionar primeiro item'), findsNothing);
  });

  appTest('remover pelo formulário de edição oferece desfazer', (
    tester,
    db,
  ) async {
    await openMyList(tester);
    await addItemThroughUi(tester, 'Queijo');
    await tester.pump(const Duration(seconds: 6));
    await tester.tap(find.bySemanticsLabel('Editar Queijo'));
    await settle(tester);
    expect(find.text('Remover este item'), findsOneWidget);
    await tapVisible(tester, find.text('Remover este item'));
    expect(await db.select(db.shoppingListItems).get(), isEmpty);
    await tester.tap(find.text('Desfazer'));
    await settle(tester);
    expect((await db.select(db.shoppingListItems).get()).single.name, 'Queijo');
  });

  appTest('o formulário de NOVO item não oferece remover', (tester, db) async {
    await openMyList(tester);
    await openNewItemForm(tester);
    expect(find.text('Remover este item'), findsNothing);
  });

  group('alinhamento: margem única de ${AppSizes.screenPadding}', () {
    const margin = AppSizes.screenPadding;
    const width = 400.0;

    void expectInside(WidgetTester tester, Finder finder, String what) {
      final rect = tester.getRect(finder.first);
      expect(rect.left, closeTo(margin, 0.6), reason: '$what: borda esquerda');
      expect(
        rect.right,
        closeTo(width - margin, 0.6),
        reason: '$what: borda direita',
      );
    }

    void expectLeft(WidgetTester tester, Finder finder, String what) {
      expect(
        tester.getRect(finder.first).left,
        closeTo(margin, 0.6),
        reason: '$what: borda esquerda',
      );
    }

    appTest('Início: cabeçalho, cartão, títulos e categorias na mesma margem', (
      tester,
      db,
    ) async {
      expectInside(tester, find.byType(TextField), 'campo do cabeçalho');
      expectInside(
        tester,
        find.ancestor(
          of: find.text('Adicionar'),
          matching: find.byType(FilledButton),
        ),
        'botão Adicionar',
      );
      expectInside(tester, find.byType(Card), 'cartão da lista');
      expectLeft(
        tester,
        find.ancestor(
          of: find.byIcon(Icons.category_rounded),
          matching: find.byType(Container),
        ),
        'selo do título de seção',
      );
      final tile = find.ancestor(
        of: find.text('Hortifrúti'),
        matching: find.byType(Material),
      );
      expectLeft(tester, tile, 'categoria (coluna esquerda)');
      final right = find.ancestor(
        of: find.text('Padaria'),
        matching: find.byType(Material),
      );
      expect(
        tester.getRect(right.first).right,
        closeTo(width - margin, 0.6),
        reason: 'categoria (coluna direita)',
      );
      expect(
        tester.getRect(right.first).left - tester.getRect(tile.first).right,
        closeTo(AppSizes.spaceMd, 0.6),
        reason: 'espaço entre colunas',
      );
    });

    appTest('Minha lista: título, cartões e itens na mesma margem', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz');
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      expectLeft(
        tester,
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Minha lista'),
        ),
        'título da barra',
      );
      final cards = find.descendant(
        of: find.byType(MyListScreen),
        matching: find.byType(Card),
      );
      expect(cards, findsNWidgets(2)); // progresso + item
      for (final i in [0, 1]) {
        final r = tester.getRect(cards.at(i));
        expect(r.left, closeTo(margin, 0.6), reason: 'cartão $i esquerda');
        expect(
          r.right,
          closeTo(width - margin, 0.6),
          reason: 'cartão $i direita',
        );
      }
      final gap =
          tester.getRect(cards.at(1)).top - tester.getRect(cards.at(0)).bottom;
      expect(gap, greaterThan(0));
    });

    appTest('Novo item: campos, opções e botão fixo na mesma margem', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await openNewItemForm(tester);
      expectInside(
        tester,
        find.widgetWithText(TextFormField, 'Nome do item'),
        'campo nome',
      );
      expectLeft(
        tester,
        find.ancestor(of: find.text('unidade'), matching: find.byType(InkWell)),
        'opção de unidade',
      );
      final button = find.ancestor(
        of: find.text('Adicionar à lista'),
        matching: find.byType(FilledButton),
      );
      expectInside(tester, button, 'botão fixo');
    });

    appTest('Minhas listas: cartões na mesma margem', (tester, db) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz');
      await tester.pump(const Duration(seconds: 6));
      await tester.tap(find.text('Listas'));
      await settle(tester);
      expectInside(
        tester,
        find.descendant(of: find.byType(ListView), matching: find.byType(Card)),
        'cartão da lista',
      );
    });
  });

  group('correções de uso', () {
    appTest('aviso com "Desfazer" some sozinho', (tester, db) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz');
      await tester.tap(find.bySemanticsLabel('Editar Arroz'));
      await settle(tester);
      await tapVisible(tester, find.text('Remover este item'));
      expect(find.text('Desfazer'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Desfazer'), findsNothing);
    });

    appTest('Unidade e Categoria: cartões alinhados e preenchem a largura', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await tester.tap(find.text('Adicionar primeiro item'));
      await settle(tester);
      for (final label in [
        'unidade',
        'quilo (kg)',
        'Sem categoria',
        'Bebidas',
      ]) {
        await tester.ensureVisible(find.text(label));
      }
      Rect tile(String label) => tester.getRect(
        find
            .ancestor(of: find.text(label), matching: find.byType(Material))
            .first,
      );
      final a = tile('unidade'), b = tile('quilo (kg)');
      expect(a.top, b.top);
      expect(a.width, closeTo(b.width, 0.5));
      expect(a.height, b.height);
      final full = tile('Sem categoria').left;
      expect(a.left, closeTo(full, 0.5));
      // Último da linha termina na mesma borda direita do campo.
      final field = tester.getRect(find.byType(TextFormField).first);
      expect(b.right, closeTo(field.right, 0.5));
    });
  });

  group('tela de carregamento', () {
    appTest('logotipo no centro exato e permanência mínima de 1,6 s', (
      tester,
      db,
    ) async {
      expect(
        splashMinDuration,
        greaterThanOrEqualTo(const Duration(milliseconds: 1500)),
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const AnotAiApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Carregando…'), findsOneWidget);

      // O primeiro Image da capa é o ícone anotAI (o logotipo vem depois, abaixo).
      final logo = find
          .descendant(
            of: find.byType(SplashScreen),
            matching: find.byType(Image),
          )
          .first;
      final center = tester.getCenter(logo);
      expect(center.dx, closeTo(defaultSize.width / 2, 0.6));
      expect(
        center.dy,
        closeTo(defaultSize.height / 2, 0.6),
        reason: 'igual à abertura nativa',
      );
      // Tudo centralizado na horizontal (a captura pegou um deslocamento antes).
      for (final text in ['Sua lista de compras inteligente', 'Carregando…']) {
        expect(
          tester.getCenter(find.text(text)).dx,
          closeTo(defaultSize.width / 2, 0.6),
          reason: '"$text" deve estar centralizado',
        );
      }
      expect(
        tester.getCenter(find.byType(CircularProgressIndicator)).dx,
        closeTo(defaultSize.width / 2, 0.6),
      );
      final wordmark = find.descendant(
        of: find.byType(SplashScreen),
        matching: find.byType(Image),
      );
      expect(wordmark, findsNWidgets(2)); // ícone + marca anotAI
      expect(
        tester.getCenter(wordmark.last).dx,
        closeTo(defaultSize.width / 2, 0.6),
        reason: 'a marca anotAI deve estar centralizada',
      );

      // Banco responde rápido, mas a tela continua visível até o mínimo.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 1200));
      expect(find.text('Carregando…'), findsOneWidget);
      expect(find.text('O que vamos comprar hoje?'), findsNothing);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Carregando…'), findsNothing);
      expect(find.text('O que vamos comprar hoje?'), findsOneWidget);
    });
  });

  group('previsto, orçamento e cobertura', () {
    appTest('previsto soma só itens com preço e mostra a cobertura', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz', qty: '2', price: '10,25');
      await addItemThroughUi(tester, 'Feijão');
      expect(find.text('Previsto: R\$ 20,50'), findsOneWidget);
      expect(find.text('1 item sem preço (fora da soma)'), findsOneWidget);
      expect(find.text('R\$ 10,25 por un · total R\$ 20,50'), findsOneWidget);
      expect(find.text('Sem preço'), findsOneWidget);
      final rice = (await db.select(db.shoppingListItems).get()).firstWhere(
        (i) => i.name == 'Arroz',
      );
      expect(rice.unitPrice.toString(), '10.25'); // decimal exato no banco
    });

    appTest('sem nenhum preço não mostra total zerado', (tester, db) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz');
      expect(find.text('Previsto: nenhum preço informado'), findsOneWidget);
      expect(find.textContaining('R\$ 0,00'), findsNothing);
    });

    appTest('formulário mostra o total do item ao digitar quantidade e preço', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await openNewItemForm(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Quantidade'),
        '0,333',
      );
      await tester.enterText(priceField(), '29,90');
      await tester.pump();
      expect(find.text('Total deste item: R\$ 9,96'), findsOneWidget);
    });

    appTest('preço com ponto, zero ou texto é recusado com mensagem', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await openNewItemForm(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome do item'),
        'Leite',
      );
      for (final (bad, message) in [
        ('10.25', 'Use vírgula'),
        ('0', 'maior que zero'),
        ('abc', 'Valor inválido'),
      ]) {
        await tester.enterText(priceField(), bad);
        await tapVisible(tester, find.text('Adicionar à lista'));
        expect(find.textContaining(message), findsWidgets, reason: bad);
      }
      expect(await db.select(db.shoppingListItems).get(), isEmpty);
    });

    appTest('orçamento: definir, sobra, aviso de cobertura e remover', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz', qty: '2', price: '10,25');
      await addItemThroughUi(tester, 'Feijão');
      await tapVisible(tester, find.text('Definir orçamento'));
      final field = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );
      for (final (bad, message) in [
        ('0', 'maior que zero'),
        ('1.5', 'Use vírgula'),
      ]) {
        await tester.enterText(field, bad);
        await tester.tap(find.text('Salvar'));
        await tester.pump();
        expect(find.textContaining(message), findsOneWidget, reason: bad);
      }
      await tester.enterText(field, '100');
      await tester.tap(find.text('Salvar'));
      await settle(tester);
      expect(find.text('Orçamento: R\$ 100,00'), findsOneWidget);
      expect(find.text('Sobram R\$ 79,50 do orçamento'), findsOneWidget);
      expect(find.text('Conta só os itens que têm preço.'), findsOneWidget);

      await tapVisible(tester, find.text('Toque para alterar'));
      await tester.tap(find.text('Remover orçamento'));
      await settle(tester);
      expect(find.textContaining('Orçamento:'), findsNothing);
      expect(find.text('Definir orçamento'), findsOneWidget);
    });

    appTest('orçamento estourado mostra quanto passou', (tester, db) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Carne', qty: '3', price: '10');
      await tapVisible(tester, find.text('Definir orçamento'));
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        '25,50',
      );
      await tester.tap(find.text('Salvar'));
      await settle(tester);
      expect(find.text('Passou R\$ 4,50 do orçamento'), findsOneWidget);
      expect(find.text('Conta só os itens que têm preço.'), findsNothing);
    });
  });

  group('barra de compra', () {
    appTest('com fonte normal a barra com totais e ação fica fixa na base', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz', price: '10');
      final button = tester.getRect(find.text('Iniciar compra'));
      final navBar = tester.getRect(find.byType(NavigationBar));
      expect(
        button.bottom,
        lessThanOrEqualTo(navBar.top),
      ); // logo acima da navegação
      expect(button.top, greaterThan(defaultSize.height * 0.6)); // base da tela
      expect(find.text('Previsto: R\$ 10,00'), findsOneWidget);
    });

    appTest(
      'a 200% em tela pequena a barra vai para a rolagem e a compra inicia',
      (tester, db) async {
        await openMyList(tester);
        await addItemThroughUi(tester, 'Arroz', price: '10');
        await tester.pump(const Duration(seconds: 6));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await scrollListTo(tester, find.text('Iniciar compra'));
        await tapVisible(tester, find.text('Iniciar compra'));
        expect(tester.takeException(), isNull);
        expect(find.text('Finalizar compra'), findsOneWidget);
        // O selo "Comprando agora" está no topo do resumo: volta ao topo.
        tester
            .state<ScrollableState>(
              find.descendant(
                of: find.byType(MyListScreen),
                matching: find.byType(Scrollable),
              ),
            )
            .position
            .jumpTo(0);
        await tester.pumpAndSettle();
        expect(find.text('Comprando agora'), findsOneWidget);
      },
      textScale: 2,
      size: const Size(320, 568),
    );
  });

  group('modo compra offline', () {
    appTest(
      'compra completa: peguei com preço, não encontrei, finalizar e recomeçar',
      (tester, db) async {
        await openMyList(tester);
        await addItemThroughUi(tester, 'Arroz', qty: '2', price: '10,25');
        await addItemThroughUi(tester, 'Feijão');
        await tester.pump(const Duration(seconds: 6));
        await tester.pumpAndSettle();
        await startShopping(tester);

        // Peguei o arroz por 11,00 (previsto 10,25 continua).
        await openOutcome(tester, 'Arroz');
        await tapVisible(tester, find.text('Peguei'));
        await tester.enterText(priceField(), '11');
        await tapVisible(tester, find.text('Salvar'));
        expect(
          find.text('Encontrado: R\$ 11,00 por un · total R\$ 22,00'),
          findsOneWidget,
        );
        expect(find.text('No carrinho: R\$ 22,00'), findsOneWidget);
        expect(find.text('Previsto: R\$ 20,50'), findsOneWidget);
        expect(find.text('R\$ 10,25 por un · total R\$ 20,50'), findsOneWidget);
        await tester.pump(const Duration(seconds: 7));
        await tester.pumpAndSettle();

        // Não encontrei o feijão.
        await openOutcome(tester, 'Feijão');
        await tapVisible(tester, find.text('Não encontrei'));
        await tapVisible(tester, find.text('Salvar'));
        expect(find.text('1 item não encontrado'), findsOneWidget);
        expect(find.text('Não encontrados'), findsOneWidget);
        await tester.pump(const Duration(seconds: 7));
        await tester.pumpAndSettle();

        // Sem pendentes: finaliza direto.
        await tapVisible(tester, find.text('Finalizar compra'));
        expect(find.text('Compra finalizada'), findsOneWidget);
        expect(find.text('1 de 1 no carrinho'), findsWidgets);
        expect(find.text('Previsto: R\$ 20,50'), findsOneWidget);
        expect(find.text('No carrinho: R\$ 22,00'), findsOneWidget);
        expect(find.text('Adicionar item'), findsNothing); // somente leitura
        expect(find.bySemanticsLabel('Opções Arroz'), findsNothing);

        // Nova compra: zera resultado, mantém previsto.
        await tapVisible(tester, find.text('Começar nova compra'));
        expect(find.text('Iniciar compra'), findsOneWidget);
        expect(find.textContaining('Encontrado:'), findsNothing);
        expect(find.text('Previsto: R\$ 20,50'), findsOneWidget);
        expect(find.text('0 de 2 no carrinho'), findsWidgets);
        final rows = await db.select(db.shoppingListItems).get();
        expect(rows.every((r) => !r.checked && !r.notFound), isTrue);
        expect(
          rows.firstWhere((r) => r.name == 'Arroz').unitPrice.toString(),
          '10.25',
        );
      },
    );

    appTest('troquei por outro exige o nome e mostra a substituição', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Feijão carioca', price: '8');
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await startShopping(tester);
      await openOutcome(tester, 'Feijão carioca');
      await tapVisible(tester, find.text('Troquei por outro'));
      await tapVisible(tester, find.text('Salvar'));
      expect(find.text('Informe o que levou no lugar.'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nome do que levou'),
        'Feijão preto',
      );
      await tester.enterText(priceField(), '9,5');
      await tapVisible(tester, find.text('Salvar'));
      expect(find.text('Trocado por Feijão preto'), findsOneWidget);
      expect(find.textContaining('Encontrado: R\$ 9,50'), findsOneWidget);
      final row = (await db.select(db.shoppingListItems).get()).single;
      expect(row.substituteName, 'Feijão preto');
      expect(
        row.unitPrice.toString(),
        '8',
      ); // previsto do item original intacto
    });

    appTest('desfazer o resultado devolve o item como estava', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Leite', price: '5');
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await startShopping(tester);
      await openOutcome(tester, 'Leite');
      await tapVisible(tester, find.text('Peguei'));
      await tapVisible(tester, find.text('Salvar'));
      expect(find.text('No carrinho'), findsWidgets);
      await tester.tap(find.text('Desfazer'));
      await settle(tester);
      final row = (await db.select(db.shoppingListItems).get()).single;
      expect(row.checked, isFalse);
      expect(find.text('Para comprar'), findsOneWidget);
    });

    appTest('tocar no cartão marca e desfaz durante a compra', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Pão');
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await startShopping(tester);
      await tester.tap(find.text('Pão'));
      await settle(tester);
      expect(
        (await db.select(db.shoppingListItems).get()).single.checked,
        isTrue,
      );
      await tester.tap(find.text('Desfazer'));
      await settle(tester);
      expect(
        (await db.select(db.shoppingListItems).get()).single.checked,
        isFalse,
      );
    });

    appTest('finalizar com itens pendentes pede confirmação e não apaga nada', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz');
      await addItemThroughUi(tester, 'Feijão');
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await startShopping(tester);

      await tapVisible(tester, find.text('Finalizar compra'));
      expect(
        find.text('Ainda faltam 2 itens. Eles continuam na lista.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Continuar comprando'));
      await settle(tester);
      expect(find.text('Comprando agora'), findsOneWidget);

      await tapVisible(tester, find.text('Finalizar compra'));
      await tester.tap(find.text('Finalizar'));
      await settle(tester);
      expect(find.text('Compra finalizada'), findsOneWidget);
      expect(find.text('2 itens ficaram sem pegar'), findsOneWidget);
      expect(await db.select(db.shoppingListItems).get(), hasLength(2));
    });

    appTest('compra em andamento sobrevive ao reinício do app', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz', qty: '2', price: '10,25');
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('Definir orçamento'));
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        '50',
      );
      await tester.tap(find.text('Salvar'));
      await settle(tester);
      await startShopping(tester);
      await openOutcome(tester, 'Arroz');
      await tapVisible(tester, find.text('Peguei'));
      await tester.enterText(priceField(), '11');
      await tapVisible(tester, find.text('Salvar'));

      // Reinício: árvore e providers novos, mesmo banco, sem rede.
      await tester.pumpWidget(const SizedBox());
      await mountApp(tester, db);
      await openMyList(tester);
      expect(find.text('Comprando agora'), findsOneWidget);
      expect(find.text('Orçamento: R\$ 50,00'), findsOneWidget);
      expect(find.text('Previsto: R\$ 20,50'), findsOneWidget);
      expect(find.text('No carrinho: R\$ 22,00'), findsOneWidget);
    });

    appTest('"No carrinho" nunca é chamado de pago nem de comprado', (
      tester,
      db,
    ) async {
      await openMyList(tester);
      await addItemThroughUi(tester, 'Arroz');
      await tester.tap(find.text('Arroz'));
      await settle(tester);
      expect(find.textContaining('pago'), findsNothing);
      expect(find.textContaining('comprado'), findsNothing);
      expect(find.text('1 de 1 no carrinho'), findsWidgets);
    });
  });
}
