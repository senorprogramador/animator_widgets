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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as Math;

import 'package:flutter_animator/flutter_animator.dart';

final builder =
    (BuildContext context, Animator animator, Widget child) => AnimatedBuilder(
          animation: animator.controller,
          child: child,
          builder: (BuildContext context, Widget child) {
            return Transform(
              transform: Matrix4.translationValues(
                      animator.get('translationX').value, 0.0, 0.0) *
                  Matrix4.rotationZ(animator.get("rotationZ").value),
              alignment: Alignment.center,
              child: child,
            );
          },
        );

class FlyOutMenuButtonInAnimation extends AnimationDefinition {
  FlyOutMenuButtonInAnimation({
    AnimationPreferences preferences = const AnimationPreferences(),
  }) : super(preferences: preferences);

  @override
  Widget build(BuildContext context, Animator animator, Widget child) {
    return builder(context, animator, child);
  }

  @override
  Map<String, TweenList> getDefinition({Size screenSize, Size widgetSize}) {
    return {
      "translationX": TweenList<double>(
        [
          TweenPercentage(percent: 0, value: 0.0, curve: Curves.easeOut),
          TweenPercentage(percent: 25, value: -30.0, curve: Curves.easeInOut),
          TweenPercentage(percent: 40, value: 0.0, curve: Curves.easeIn),
        ],
      ),
      "rotationZ": TweenList<double>([
        TweenPercentage(
            percent: 0, value: Math.radians(0.0), curve: Curves.easeOut),
        TweenPercentage(
            percent: 25, value: Math.radians(-50.0), curve: Curves.easeInOut),
        TweenPercentage(
            percent: 100, value: Math.radians(1440.0), curve: Curves.easeIn),
      ]),
    };
  }
}

class FlyOutMenuButtonOutAnimation extends AnimationDefinition {
  FlyOutMenuButtonOutAnimation({
    AnimationPreferences preferences = const AnimationPreferences(),
  }) : super(preferences: preferences);

  @override
  Widget build(BuildContext context, Animator animator, Widget child) {
    return builder(context, animator, child);
  }

  @override
  Map<String, TweenList> getDefinition({Size screenSize, Size widgetSize}) {
    return {
      "translationX": TweenList<double>(
        [
          TweenPercentage(percent: 0, value: 0.0),
        ],
      ),
      "rotationZ": TweenList<double>([
        TweenPercentage(
            percent: 0, value: Math.radians(360.0), curve: Curves.easeOut),
        TweenPercentage(
            percent: 100, value: Math.radians(0.0), curve: Curves.easeIn),
      ]),
    };
  }
}

class FlyOutMenuButton extends StatefulWidget {
  final Function onPress;
  final IconData defaultIcon;
  final IconData activeIcon;

  FlyOutMenuButton({
    Key key,
    @required this.onPress,
    this.defaultIcon = Icons.add,
    this.activeIcon = Icons.close,
  }) : super(key: key);

  @override
  FlyOutMenuButtonState createState() => FlyOutMenuButtonState();
}

class FlyOutMenuButtonState extends State<FlyOutMenuButton> {
  final GlobalKey<InOutAnimationState> _key = GlobalKey<InOutAnimationState>();
  final GlobalKey<CrossFadeABState> _iconKey = GlobalKey<CrossFadeABState>();

  toggle() {
    switch (_key.currentState.status) {
      case InOutAnimationStatus.None:
      case InOutAnimationStatus.Out:
        open();
        break;
      case InOutAnimationStatus.In:
        close();
        break;
    }
  }

  open() {
    _key.currentState.animateIn();
    _iconKey.currentState.crossToB();
  }

  close() {
    _key.currentState.animateOut();
    _iconKey.currentState.crossToA();
  }

  @override
  Widget build(BuildContext context) {
    return InOutAnimation(
      key: _key,
      inDefinition: FlyOutMenuButtonInAnimation(),
      outDefinition: FlyOutMenuButtonOutAnimation(),
      autoPlay: InOutAnimationStatus.None,
      child: FloatingActionButton(
        onPressed: widget.onPress,
        child: CrossFadeAB(
          key: _iconKey,
          childA: Icon(
            widget.defaultIcon,
            size: 30,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
          childB: Icon(
            widget.activeIcon,
            size: 30,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
        ),
      ),
    );
  }
}
/*


 */
//750, 500
