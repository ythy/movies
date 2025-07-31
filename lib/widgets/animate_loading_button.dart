import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movies/widgets/ring.dart';

typedef AnimateButtonTapCallback = void Function();

class AnimatedLoadingButton extends StatefulWidget {

  AnimatedLoadingButton({
    required this.text,
    required this.onPressed,
    required this.controller,
    this.loadingController,
    super.key,
    this.loadingColor,
    this.color,
  });

  /// The label displayed inside the button.
  final String text;

  /// The background color of the button.
  final Color? color;

  /// The color of the loading spinner when active.
  final Color? loadingColor;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Controls the loading animation for the button.
  ///
  /// When provided, this controller should drive animation states such as
  /// loading progress or success.
  final AnimationController? controller;

  final AnimationController? loadingController;

  @override
  State<AnimatedLoadingButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedLoadingButton>
    with SingleTickerProviderStateMixin {

  late Animation<double> _sizeAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<double> _ringThicknessAnimation;
  late Animation<double> _ringOpacityAnimation;
  late Animation<Color?> _colorAnimation;
  var _isLoading = false;
  var _hover = false;
  var _width = 120.0;

  Color? _color;
  Color? _loadingColor;

  static const _height = 40.0;
  static const double _loadingCircleRadius = _height / 2;
  static const _loadingCircleThickness = 4.0;

  @override
  void initState() {
    super.initState();

    _textOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(0, .25),
      ),
    );

    _buttonOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Threshold(.65),
      ),
    );

    _ringThicknessAnimation =
        Tween<double>(begin: _loadingCircleRadius, end: _loadingCircleThickness)
            .animate(
          CurvedAnimation(
            parent: widget.controller!,
            curve: const Interval(.65, .85),
          ),
        );
    _ringOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(.85, 1),
      ),
    );

    widget.controller!.addStatusListener(handleStatusChanged);
  }

  @override
  void didChangeDependencies() {
    _updateColorAnimation();
    _updateWidth();
    super.didChangeDependencies();
  }

  void _updateColorAnimation() {
    final theme = Theme.of(context);
    _color = widget.color ?? theme.colorScheme.primary;
    _loadingColor = widget.loadingColor ?? theme.colorScheme.secondary;

    _colorAnimation = ColorTween(
      begin: _color,
      end: _loadingColor,
    ).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(0, .65, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  @override
  void didUpdateWidget(AnimatedLoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.color ||
        oldWidget.loadingColor != widget.loadingColor) {
      _updateColorAnimation();
    }

    if (oldWidget.text != widget.text) {
      _updateWidth();
    }
  }

  @override
  void dispose() {
    widget.controller!.removeStatusListener(handleStatusChanged);
    super.dispose();
  }

  void handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      setState(() => _isLoading = true);
    }
    if (status == AnimationStatus.dismissed) {
      setState(() => _isLoading = false);
    }
  }

  /// sets width and size animation
  void _updateWidth() {
    final theme = Theme.of(context);
    final fontSize = theme.textTheme.labelLarge!.fontSize!;
    final renderParagraph = RenderParagraph(
      TextSpan(
        text: widget.text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: theme.textTheme.labelLarge!.fontWeight,
          letterSpacing: theme.textTheme.labelLarge!.letterSpacing,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(const BoxConstraints(minWidth: 120));

    // text width based on fontSize, plus 45.0 for padding
    final textWidth =
        renderParagraph.getMinIntrinsicWidth(fontSize).ceilToDouble() + 45.0;

    // button width is min 120.0 and max 240.0
    _width = textWidth > 120.0 && textWidth < 240.0
        ? textWidth
        : textWidth >= 240.0
        ? 240.0
        : 120.0;

    _sizeAnimation = Tween<double>(begin: 1, end: _height / _width).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(0, .65, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  Widget _buildButtonText(ThemeData theme) {
    return FadeTransition(
      opacity: _textOpacityAnimation,
      child: Text(
        widget.text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary
          ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme) {
    return FadeTransition(
      opacity: _buttonOpacityAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) => Material(
            color: _colorAnimation.value,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: child,
          ),
          child: InkWell(
            onTap: !_isLoading ? widget.onPressed : null,
            onHighlightChanged: (value) => setState(() => _hover = value),
            child: SizeTransition(
              sizeFactor: _sizeAnimation,
              axis: Axis.horizontal,
              child: Container(
                width: _width,
                height: _height,
                alignment: Alignment.center,
                child: _buildButtonText(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FadeTransition(
          opacity: _ringOpacityAnimation,
          child: AnimatedBuilder(
            animation: _ringThicknessAnimation,
            builder: (context, child) => Ring(
              color: widget.loadingColor,
              thickness: _ringThicknessAnimation.value,
            ),
          ),
        ),
        if (_isLoading)
          SizedBox(
            width: _height - _loadingCircleThickness,
            height: _height - _loadingCircleThickness,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color?>(widget.loadingColor),
            ),
          ),
        _buildButton(theme),
    ]);

  }

}

