import 'package:flutter/material.dart';

class StaggeredEnter extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration totalDuration;
  final Curve curve;
  final double slideOffset;

  const StaggeredEnter({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 80),
    this.totalDuration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = 20,
  });

  @override
  State<StaggeredEnter> createState() => _StaggeredEnterState();
}

class _StaggeredEnterState extends State<StaggeredEnter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _opacities;
  late List<Animation<Offset>> _translations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration + widget.itemDelay * widget.children.length,
    );

    _opacities = List.generate(widget.children.length, (i) {
      return CurvedAnimation(
        parent: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * widget.itemDelay.inMilliseconds / _controller.duration!.inMilliseconds,
            1,
            curve: widget.curve,
          ),
        )),
        curve: widget.curve,
      );
    });

    _translations = List.generate(widget.children.length, (i) {
      return Tween<Offset>(
        begin: Offset(0, widget.slideOffset / (i + 1)),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          i * widget.itemDelay.inMilliseconds / _controller.duration!.inMilliseconds,
          1,
          curve: widget.curve,
        ),
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.children.length, (i) {
            return Opacity(
              opacity: _opacities[i].value,
              child: Transform.translate(
                offset: _translations[i].value,
                child: widget.children[i],
              ),
            );
          }),
        );
      },
    );
  }
}

class FadeSlideEnter extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration totalDuration;

  const FadeSlideEnter({
    super.key,
    required this.child,
    this.index = 0,
    this.totalDuration = const Duration(milliseconds: 500),
  });

  @override
  State<FadeSlideEnter> createState() => _FadeSlideEnterState();
}

class _FadeSlideEnterState extends State<FadeSlideEnter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _controller.value)),
            child: widget.child,
          ),
        );
      },
    );
  }
}
