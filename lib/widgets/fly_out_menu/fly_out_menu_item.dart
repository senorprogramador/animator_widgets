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
  final Widget child;
  final FlyOutAnimation animation;
  final double marginBottom;
  final AnimationPreferences preferences;

  FlyOutMenuItem({
    Key key,
    @required this.index,
    @required this.child,
    this.animation = FlyOutAnimation.flipperCard,
    this.marginBottom = 4.0,
    this.preferences = const AnimationPreferences(),
  }) : super(key: key);

  @override
  FlyOutMenuItemState createState() => FlyOutMenuItemState();
}

class FlyOutMenuItemState extends State<FlyOutMenuItem> {
  final GlobalKey<InOutAnimationState> _key = GlobalKey<InOutAnimationState>();

  void animateIn() {
    _key.currentState.animateIn();
  }

  void animateOut() {
    _key.currentState.animateOut();
  }

  AnimationDefinition _getInDefinition() {
    final AnimationPreferences preferences = widget.preferences;

    switch (widget.animation) {
      case FlyOutAnimation.flipperCard:
        return FlipInXAnimation(
          from:
              widget.index % 2 == 0 ? FlipInXOrigin.front : FlipInXOrigin.back,
          alignment: Alignment.topCenter,
          preferences: preferences,
        );
      case FlyOutAnimation.lightSpeed:
        return LightSpeedInAnimation(preferences: preferences);
      case FlyOutAnimation.bounceIn:
        return BounceInAnimation(preferences: preferences);
      case FlyOutAnimation.fadeInUp:
        return FadeInUpAnimation(preferences: preferences);
      case FlyOutAnimation.fadeInLeft:
        return FadeInLeftAnimation(preferences: preferences);
      case FlyOutAnimation.fadeInRight:
        return FadeInRightAnimation(preferences: preferences);
      case FlyOutAnimation.fadeInDown:
        return FadeInDownAnimation(preferences: preferences);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InOutAnimation(
      key: _key,
      child: widget.child,
      inDefinition: _getInDefinition(),
      outDefinition: FadeOutRightAnimation(
        preferences: widget.preferences.copyWith(
          duration: Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
