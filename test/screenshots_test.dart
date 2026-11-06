// Gera capturas PNG para revisão visual. Só executa com SCREENSHOT_DIR definido:
//   SCREENSHOT_DIR=/caminho flutter test test/screenshots_test.dart
// Usa as fontes Roboto/MaterialIcons do SDK para renderizar texto e ícones reais.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anotai_lista/app.dart';
import 'package:anotai_lista/core/database/app_database.dart';
import 'package:anotai_lista/core/providers.dart';
import 'package:anotai_lista/features/lists/data/shopping_list_repository.dart';

final _dir = Platform.environment['SCREENSHOT_DIR'];
final _shotKey = GlobalKey();

Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'] ?? 'C:/src/flutter';
  final base = '$root/bin/cache/artifacts/material_fonts';
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(
        File('$base/$f').readAsBytes().then((b) => ByteData.sublistView(b)),
      );
    }
    await loader.load();
  }

  await load('Roboto', [
    'roboto-regular.ttf',
    'roboto-medium.ttf',
    'roboto-bold.ttf',
  ]);
  await load('MaterialIcons', ['materialicons-regular.otf']);
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 30)),
  );
  await tester.pumpAndSettle();
}

Future<void> _shot(
  WidgetTester tester,
  String name, {
  bool settle = true,
}) async {
  if (settle) {
    await _settle(tester);
  } else {
    await tester.pump(const Duration(milliseconds: 400));
  }
  final boundary =
      _shotKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  File('$_dir/$name.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);
}

void main() {
  if (_dir == null) {
    test('capturas (defina SCREENSHOT_DIR para gerar)', () {}, skip: true);
    return;
  }

  testWidgets('capturas das telas principais', (tester) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await tester.runAsync(_loadFonts);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Decimal d(String v) => Decimal.parse(v);

    Future<AppDatabase> newDb() async => (await tester.runAsync(
      () async => AppDatabase(NativeDatabase.memory()),
    ))!;

    Future<void> mount(
      AppDatabase db, {
      double scale = 1,
      Size size = const Size(390, 844),
      Duration splash = Duration.zero,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            splashMinDurationProvider.overrideWithValue(splash),
          ],
          child: RepaintBoundary(
            key: _shotKey,
            child: MediaQuery(
              data: MediaQueryData(
                size: size,
                textScaler: TextScaler.linear(scale),
                padding: const EdgeInsets.only(top: 24),
              ),
              child: const AnotAiApp(fontFamily: 'Roboto'),
            ),
          ),
        ),
      );
      if (splash == Duration.zero) await _settle(tester);
    }

    Future<void> unmount(AppDatabase db) async {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(db.close);
      await tester.pump(
        const Duration(seconds: 1),
      ); // descarrega o timer do Drift
    }

    final empty = await newDb();
    await mount(empty, splash: const Duration(minutes: 5));
    await _shot(tester, '00_carregando', settle: false);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 6)); // vence o timer da abertura
    await mount(empty);
    await _shot(tester, '01_inicio_vazio');
    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '01b_lista_vazia');
    await unmount(empty);

    final db = await newDb();
    await tester.runAsync(() async {
      final repo = ShoppingListRepository(db);
      final list = await repo.ensureCurrentList();
      final items = [
        ('Arroz branco 5 kg', '1', 'un', 'mercearia'),
        ('Banana prata', '1.5', 'kg', 'hortifruti'),
        ('Leite integral', '6', 'un', 'laticinios'),
        ('Pão francês', '10', 'un', 'padaria'),
        ('Detergente', '2', 'un', 'limpeza'),
      ];
      for (final (name, qty, unit, cat) in items) {
        await repo.addItem(
          list.id,
          name: name,
          quantity: d(qty),
          unit: unit,
          categorySlug: cat,
        );
      }
      final all = await repo.watchItems(list.id).first;
      await repo.setChecked(all[1].id, checked: true);
      await repo.setChecked(all[3].id, checked: true);
    });

    await mount(db);
    await _shot(tester, '02_inicio_com_lista');

    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '03_minha_lista');

    await tester.tap(find.text('Adicionar item'));
    await _shot(tester, '04_novo_item');
    tester.state<NavigatorState>(find.byType(Navigator).last).pop();
    await _settle(tester);

    await tester.pumpWidget(const SizedBox());
    await mount(db, scale: 1.6);
    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '06_minha_lista_fonte_grande');
    await unmount(db);

    // Texto a 200% em tela pequena (320x568): Início e formulário.
    tester.view.physicalSize = const Size(320, 568);
    final big = await newDb();
    await tester.runAsync(() async {
      final repo = ShoppingListRepository(big);
      final list = await repo.ensureCurrentList();
      await repo.addItem(
        list.id,
        name: 'Biscoito recheado sabor chocolate com cobertura crocante',
        quantity: d('12.5'),
        unit: 'kg',
        categorySlug: 'padaria',
      );
    });
    await mount(big, scale: 2, size: const Size(320, 568));
    await _shot(tester, '07_inicio_200');
    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '08_lista_200');
    await tester.tap(find.text('Adicionar item'));
    await _shot(tester, '09_form_200');
    await unmount(big);

    // Modo compra. O banco é preparado ANTES de montar o app (misturar
    // gravações em runAsync com streams ativos trava o teste).
    tester.view.physicalSize = const Size(390, 844);
    Future<AppDatabase> shopDb(int stage) async {
      final db = await newDb();
      await tester.runAsync(() async {
        final repo = ShoppingListRepository(db);
        final list = await repo.ensureCurrentList();
        final arroz = await repo.addItem(
          list.id,
          name: 'Arroz branco 5 kg',
          quantity: d('2'),
          categorySlug: 'mercearia',
          unitPrice: d('10.25'),
        );
        final feijao = await repo.addItem(
          list.id,
          name: 'Feijão carioca',
          quantity: d('1'),
          categorySlug: 'mercearia',
        );
        await repo.addItem(
          list.id,
          name: 'Leite integral',
          quantity: d('6'),
          categorySlug: 'laticinios',
          unitPrice: d('5.99'),
        );
        final pao = await repo.addItem(
          list.id,
          name: 'Pão francês',
          quantity: d('0.5'),
          unit: 'kg',
          categorySlug: 'padaria',
          unitPrice: d('14.90'),
        );
        await repo.setBudget(list.id, d('100'));
        if (stage >= 1) {
          await repo.startShopping(list.id);
          await repo.collectItem(arroz.id, foundPrice: d('11'));
          await repo.markNotFound(feijao.id);
          await repo.collectItem(
            pao.id,
            foundPrice: d('15.9'),
            substituteName: 'Pão integral',
          );
        }
        if (stage >= 2) await repo.finishShopping(list.id);
      });
      return db;
    }

    final planning = await shopDb(0);
    await mount(planning);
    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '10_planejando_com_precos');
    await unmount(planning);

    final shopping = await shopDb(1);
    await mount(shopping);
    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '11_comprando');
    await tester.tap(find.bySemanticsLabel('Opções Leite integral'));
    await _shot(tester, '12_resultado_do_item');
    await unmount(shopping);

    final finished = await shopDb(2);
    await mount(finished);
    await tester.tap(find.byType(NavigationDestination).at(1));
    await _shot(tester, '13_compra_finalizada');
    await unmount(finished);
  });
}
