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

import 'package:flutter_animator/flutter_animator.dart';

import './fly_out_menu_item.dart';
import './fly_out_menu_button.dart';

enum FlyOutAnimation {
  flipperCard,
  lightSpeed,
  bounceIn,
  fadeInUp,
  fadeInLeft,
  fadeInRight,
  fadeInDown,
}

class FlyOutMenu extends StatefulWidget {
  final List<Widget> buttons;
  final double buttonSpacing;
  final FlyOutAnimation animation;
  final IconData defaultIcon;
  final IconData activeIcon;

  FlyOutMenu({
    Key? key,
    required this.buttons,
    this.animation = FlyOutAnimation.flipperCard,
    this.defaultIcon = Icons.add,
    this.activeIcon = Icons.close,
    this.buttonSpacing = 4.0,
  }) : super(key: key);

  @override
  FlyOutMenuState createState() => FlyOutMenuState();
}

class FlyOutMenuState extends State<FlyOutMenu> {
  GlobalKey<FlyOutMenuButtonState> _button = GlobalKey<FlyOutMenuButtonState>();
  List<GlobalKey<FlyOutMenuItemState>> _buttons = [];
  GlobalKey<InOutAnimationState> _overlayEntryAnimator =
      GlobalKey<InOutAnimationState>();

  late OverlayEntry _overlayEntry;
  bool _active = false;

  toggle() {
    setState(() {
      _active = !_active;
      _applyActiveState();
    });
  }

  open() {
    if (_active) return;
    setState(() {
      _active = true;
      _applyActiveState();
    });
  }

  close() {
    if (!_active) return;
    setState(() {
      _active = false;
      _applyActiveState();
    });
  }

  _applyActiveState() {
    if (_active) {
      _button.currentState!.open();
      _buttons = List.generate(
          widget.buttons.length, (index) => GlobalKey<FlyOutMenuItemState>());
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context)!.insert(this._overlayEntry);
    } else {
      _overlayEntryAnimator.currentState!.animateOut();
      _button.currentState!.close();
      _buttons.forEach((button) {
        button.currentState!.animateOut();
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var screenSize = MediaQuery.of(context).size;
    return OverlayEntry(builder: (BuildContext context) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: close,
            child: InOutAnimation(
              key: _overlayEntryAnimator,
              inDefinition: FadeInAnimation(),
              outDefinition: FadeOutAnimation(),
              child: Container(
                color: Colors.black.withAlpha(50),
                width: screenSize.width,
                height: screenSize.height,
              ),
              autoPlay: InOutAnimationStatus.In,
            ),
          ),
          Positioned(
            left: 0.0,
            top: 0.0,
            width: offset.dx + renderBox.size.width,
            height: offset.dy - 0.5 * widget.buttonSpacing,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.buttons
                  .asMap()
                  .map(
                    (index, button) => MapEntry(
                      index,
                      FlyOutMenuItem(
                        key: _buttons.length > index ? _buttons[index] : null,
                        index: index,
                        child: button,
                        marginBottom: widget.buttonSpacing,
                        preferences: AnimationPreferences(
                          offset: Duration(
                              milliseconds:
                                  ((index / widget.buttons.length) * 750.0)
                                      .toInt()),
                          duration: Duration(milliseconds: 500),
                          animationStatusListener: (AnimationStatus status) {
                            if (status == AnimationStatus.completed &&
                                index == widget.buttons.length - 1) {
                              if (!_active) {
                                this._overlayEntry.remove();
                              }
                            }
                          },
                        ),
                        animation: widget.animation,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlyOutMenuButton(
      key: _button,
      defaultIcon: widget.defaultIcon,
      activeIcon: widget.activeIcon,
      onPress: toggle,
    );
  }
}
