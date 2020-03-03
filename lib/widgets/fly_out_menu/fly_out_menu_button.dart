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

class FlyOutMenuButtonState extends State<FlyOutMenuButton>
    with AnimatorStateMixin {
  Animator _activeAnimator;

  open() {
    animations['close'].controller.stop();

    setState(() {
      _activeAnimator = animations['open'];
    });

    _activeAnimator.controller.forward(from: 0.0);
  }

  close() {
    animations['open'].controller.stop();

    setState(() {
      _activeAnimator = animations['close'];
    });

    _activeAnimator.controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _activeAnimator.controller,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.translationValues(
                  _activeAnimator.get('translationX').value, 0.0, 0.0) *
              Matrix4.rotationZ(_activeAnimator.get("rotationZ").value),
          alignment: Alignment.center,
          child: FloatingActionButton(
            onPressed: widget.onPress,
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: _activeAnimator.get("iconOpacity").value,
                  child: Icon(
                    widget.defaultIcon,
                    size: 30,
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                  ),
                ),
                Opacity(
                  opacity: 1.0 - _activeAnimator.get("iconOpacity").value,
                  child: Icon(
                    widget.activeIcon,
                    size: 30,
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Map<String, Animator> createAnimations() {
    final animations = {
      "open": Animator.sync(this, autoPlay: false)
          .at(duration: Duration(milliseconds: 750))
          .add(
              key: "iconOpacity",
              tweens: TweenList<double>([
                TweenPercentage(percent: 25, value: 1.0),
                TweenPercentage(percent: 75, value: 0.0)
              ]))
          .add(
            key: "translationX",
            tweens: TweenList<double>(
              [
                TweenPercentage(percent: 0, value: 0.0, curve: Curves.easeOut),
                TweenPercentage(
                    percent: 25, value: -30.0, curve: Curves.easeInOut),
                TweenPercentage(percent: 40, value: 0.0, curve: Curves.easeIn),
              ],
            ),
          )
          .add(
            key: "rotationZ",
            tweens: TweenList<double>([
              TweenPercentage(
                  percent: 0, value: Math.radians(0.0), curve: Curves.easeOut),
              TweenPercentage(
                  percent: 25,
                  value: Math.radians(-50.0),
                  curve: Curves.easeInOut),
              TweenPercentage(
                  percent: 100,
                  value: Math.radians(1440.0),
                  curve: Curves.easeIn),
            ]),
          )
          .generate(),
      "close": Animator.sync(this, autoPlay: false)
          .at(duration: Duration(milliseconds: 500))
          .add(
              key: "iconOpacity",
              tweens: TweenList<double>([
                TweenPercentage(percent: 25, value: 0.0),
                TweenPercentage(percent: 75, value: 1.0)
              ]))
          .add(
            key: "translationX",
            tweens: TweenList<double>(
              [
                TweenPercentage(percent: 0, value: 0.0),
              ],
            ),
          )
          .add(
            key: "rotationZ",
            tweens: TweenList<double>([
              TweenPercentage(
                  percent: 0,
                  value: Math.radians(360.0),
                  curve: Curves.easeOut),
              TweenPercentage(
                  percent: 100, value: Math.radians(0.0), curve: Curves.easeIn),
            ]),
          )
          .generate()
    };
    setState(() {
      _activeAnimator = animations['open'];
    });
    return animations;
  }
}
