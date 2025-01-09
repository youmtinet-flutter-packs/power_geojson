import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'clippers/theme_switcher_circle_clipper.dart';
import 'clippers/theme_switcher_clipper.dart';

typedef ThemeBuilder = Widget Function(BuildContext, ThemeData theme);

class ThemeProvider extends StatefulWidget {
  const ThemeProvider({
    Key? key,
    this.builder,
    this.child,
    required this.initTheme,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final ThemeBuilder? builder;
  final Widget? child;
  final ThemeData initTheme;
  final Duration duration;

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late ThemeModel model;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    model = ThemeModel(
      startTheme: widget.initTheme,
      controller: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModelInheritedNotifier(
      notifier: model,
      child: Builder(builder: (BuildContext context) {
        ThemeModel model = ThemeModelInheritedNotifier.of(context);
        return RepaintBoundary(
          key: model.previewContainer,
          child: widget.child ?? widget.builder!(context, model.theme),
        );
      }),
    );
  }
}

class ThemeModelInheritedNotifier extends InheritedNotifier<ThemeModel> {
  const ThemeModelInheritedNotifier({
    Key? key,
    required ThemeModel notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ThemeModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThemeModelInheritedNotifier>()!
        .notifier!;
  }
}

class ThemeModel extends ChangeNotifier {
  ThemeData _theme;

  late GlobalKey switcherGlobalKey;
  ui.Image? image;
  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();

  Timer? timer;
  ThemeSwitcherClipper clipper = const ThemeSwitcherCircleClipper();
  final AnimationController controller;

  ThemeModel({
    required ThemeData startTheme,
    required this.controller,
  }) : _theme = startTheme;

  ThemeData get theme => _theme;
  ThemeData? oldTheme;

  bool isReversed = false;
  late Offset switcherOffset;

  void changeTheme({
    required ThemeData theme,
    required GlobalKey key,
    ThemeSwitcherClipper? clipper,
    required bool isReversed,
    required BuildContext context,
    Offset? offset,
    VoidCallback? onAnimationFinish,
  }) async {
    if (controller.isAnimating) {
      return;
    }

    if (clipper != null) {
      this.clipper = clipper;
    }
    this.isReversed = isReversed;

    oldTheme = _theme;
    _theme = theme;
    switcherOffset = _getSwitcherCoordinates(key, offset);
    await _saveScreenshot(context);

    if (isReversed) {
      await controller
          .reverse(from: 1.0)
          .then((void value) => onAnimationFinish?.call());
    } else {
      await controller
          .forward(from: 0.0)
          .then((void value) => onAnimationFinish?.call());
    }
    // Notify listeners when the animation finishes.
    notifyListeners();
  }

  Future<void> _saveScreenshot(BuildContext context) async {
    final RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    image =
        await boundary.toImage(pixelRatio: View.of(context).devicePixelRatio);
    // ignore: deprecated_member_use
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Offset _getSwitcherCoordinates(
      GlobalKey<State<StatefulWidget>> switcherGlobalKey,
      [Offset? tapOffset]) {
    final RenderBox renderObject =
        switcherGlobalKey.currentContext!.findRenderObject()! as RenderBox;
    final ui.Size size = renderObject.size;
    return renderObject.localToGlobal(Offset.zero).translate(
          tapOffset?.dx ?? (size.width / 2),
          tapOffset?.dy ?? (size.height / 2),
        );
  }
}
