/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2020 Sjoerd van den Berg
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_animator/flutter_animator.dart';

import 'fly_out_menu.dart';

class FlyOutMenuItem extends StatefulWidget {
  final int index;
  final bool active;
  final Widget button;
  final FlyOutAnimation animation;
  final AnimationStatusListener animationStatusListener;
  final Duration offset;
  final Duration duration;
  final double marginBottom;

  FlyOutMenuItem({
    Key key,
    @required this.index,
    @required this.active,
    @required this.button,
    this.animation = FlyOutAnimation.flipperCard,
    this.animationStatusListener,
    this.offset = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.marginBottom = 4.0,
  }) : super(key: key);

  @override
  FlyOutMenuItemState createState() => FlyOutMenuItemState();
}

class FlyOutMenuItemState extends State<FlyOutMenuItem> {
  bool _active = true;

  @override
  void initState() {
    _active = widget.active;
    super.initState();
  }

  close() {
    setState(() {
      _active = false;
    });
  }

  Widget _renderAnimation() {
    Widget child = Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom),
      child: widget.button,
    );

    switch (widget.animation) {
      case FlyOutAnimation.flipperCard:
        return FlipInX(
          from:
              widget.index % 2 == 0 ? FlipInXOrigin.front : FlipInXOrigin.back,
          alignment: Alignment.topCenter,
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
      case FlyOutAnimation.lightSpeed:
        return LightSpeedIn(
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
      case FlyOutAnimation.bounceIn:
        return BounceIn(
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
      case FlyOutAnimation.fadeInUp:
        return FadeInUp(
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
      case FlyOutAnimation.fadeInLeft:
        return FadeInLeft(
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
      case FlyOutAnimation.fadeInRight:
        return FadeInRight(
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
      case FlyOutAnimation.fadeInDown:
        return FadeInDown(
          offset: widget.offset,
          duration: widget.duration,
          animationStatusListener: widget.animationStatusListener,
          child: child,
        );
    }
    return widget.button;
  }

  @override
  Widget build(BuildContext context) {
    if (_active) {
      return _renderAnimation();
    }
    return IgnorePointer(
      ignoring: true,
      child: FadeOutRight(
        animationStatusListener: widget.animationStatusListener,
        offset: widget.offset,
        duration: widget.duration,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.marginBottom),
          child: widget.button,
        ),
      ),
    );
  }
}
