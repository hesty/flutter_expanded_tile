library flutter_expanded_tile;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'tileController.dart';

class ExpandedTile extends StatefulWidget {
  // header
  final Color headerColor;
  final Color headerSplashColor;
  final EdgeInsetsGeometry headerPadding;
  // leading
  final Widget? leading;
  // title
  final Widget title;
  final bool centerHeaderTitle;
  final EdgeInsetsGeometry titlePadding;
  // trailing
  final bool showTrailingIcon;
  final Icon? expandIcon;
  final bool rotateExpandIcon;
  // Checkbox
  final bool checkable;
  final Color checkBoxColor;
  final Color checkBoxActiveColor;
  final Function(bool? value)? onChecked;
  // Content
  final Widget content;
  final Color contentBackgroundColor;
  final EdgeInsetsGeometry contentPadding;
  // Misc
  final ExpandedTileController controller;
  final Curve expansionAnimationCurve;
  final Duration expansionDuration;
  final VoidCallback onPressed;

  const ExpandedTile({
    key,
    // Requirds
    required this.title,
    required this.content,
    required this.controller,
    required this.onPressed,
    // header
    this.headerColor = const Color(0xfffafafa),
    this.headerSplashColor = const Color(0xffeeeeee),
    this.headerPadding = const EdgeInsets.all(16.0),
    // leading
    this.leading,
    // title
    this.centerHeaderTitle = false,
    this.titlePadding = const EdgeInsets.all(8),
    // trailing
    this.showTrailingIcon = true,
    this.checkable = false,
    this.expandIcon,
    this.rotateExpandIcon = true,
    // checkbox
    this.checkBoxColor = const Color(0xffffffff),
    this.checkBoxActiveColor = const Color(0xff039be5),
    this.onChecked,
    // Content
    this.contentBackgroundColor = const Color(0xffeeeeee),
    this.contentPadding = const EdgeInsets.all(16.0),
    // Misc
    this.expansionDuration = const Duration(milliseconds: 200),
    this.expansionAnimationCurve = Curves.ease,
  })  : assert(expandIcon == null || checkable == false),
        assert((checkable == true || onChecked == null)),
        super(key: key);
  @override
  _ExpandedTileState createState() => _ExpandedTileState();
}

class _ExpandedTileState extends State<ExpandedTile>
    with SingleTickerProviderStateMixin {
  late ExpandedTileController tileController;
  bool? _isExpanded;
  bool? checkboxValue;
  @override
  void initState() {
    _isExpanded = false;
    checkboxValue = false;
    tileController = widget.controller;
    tileController.addListener(() {
      if (this.mounted)
        setState(() {
          _isExpanded = tileController.isExpanded;
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    tileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //* collapsed row
          Material(
            color: widget.headerColor,
            child: InkWell(
              splashColor: widget.headerSplashColor,
              onTap: () {
                tileController.toggle();
              },
              child: InkWell(
                onTap: widget.onPressed,
                child: Container(
                  padding: widget.headerPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (widget.leading != null) widget.leading!,
                      Expanded(
                        child: Container(
                          padding: widget.titlePadding,
                          alignment: widget.centerHeaderTitle
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: widget.title,
                        ),
                      ),
                      Visibility(
                        visible: widget.showTrailingIcon,
                        child: Transform.rotate(
                          angle: widget.checkable
                              ? 0
                              : widget.rotateExpandIcon
                                  ? _isExpanded!
                                      ? math.pi / 2
                                      : 0
                                  : 0,
                          child: widget.checkable
                              ? Checkbox(
                                  checkColor: widget.checkBoxColor,
                                  activeColor: widget.checkBoxActiveColor,
                                  value: checkboxValue,
                                  onChanged: (v) {
                                    setState(() {
                                      checkboxValue = v;
                                      if (widget.onChecked != null)
                                        return widget.onChecked!(v);
                                    });
                                  })
                              : widget.expandIcon ??
                                  Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          AnimatedSize(
            vsync: this,
            duration: widget.expansionDuration,
            curve: widget.expansionAnimationCurve,
            child: Container(
              child: Container(
                child: !_isExpanded!
                    ? null
                    : Container(
                        padding: widget.contentPadding,
                        color: widget.contentBackgroundColor,
                        width: double.infinity,
                        child: widget.content),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
