# animator_widgets

Provides awesome stylable animated widgets.

__Please note that there is currently only one awesome widget: FlyOutMenu, but others will soon follow!__

#### Null safety:
*For null safety please use flutter_animator_widgets: ^1.0.2, without null safety: flutter_animator_widgets: 1.0.1*

This project uses the [flutter_animator](https://pub.dev/packages/flutter_animator) project for it's animations.
Be sure to check it out.

## Getting Started

### FlyOutMenu
![FlyOutMenu](https://raw.githubusercontent.com/sharp3dges/animator_widgets/master/gifs/fly_out_menu.gif)

#### Basic example
```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(pressedItem != null
            ? "Last pressed: $pressedItem"
            : "No items pressed"),
      ),
      floatingActionButton: FlyOutMenu(
        key: _flyoutMenuKey,
        ///^-- use a global key to call _flyoutMenuKey.currentState.close() on buttonPress.
        buttons: buttons,
        ///^-- List<Widget> so you can add your own widgets and handle the press yourself.
        animation: FlyOutAnimation.flipperCard,
        ///^-- multiple fancy animations available.
        defaultIcon: Icons.add,
        ///^-- icon for standard (closed) state.
        activeIcon: Icons.close,
        ///^-- icon for active (open) state.
      ),
    );
  }
```

Full working Examples can be found at the example tab.
If you like you can also download the example folder to see how this works
