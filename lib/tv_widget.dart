// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnFocusChange = void Function(bool hasFocus);
typedef OnClick = void Function();

class AndroidTVWidget extends StatefulWidget {
  final Widget child;
  final OnFocusChange focusChange;
  final OnClick onClick;
  final bool hasDecoration;
  final bool requestFocus;
  final BoxDecoration decoration;

  const AndroidTVWidget({super.key,
    required this.child,
    required this.focusChange,
    required this.onClick,
    required this.decoration,
    this.hasDecoration = true,
    this.requestFocus = false});

  @override
  State<StatefulWidget> createState() {
    return AndroidTVState();
  }
}

class AndroidTVState extends State<AndroidTVWidget> {
  FocusNode? _focusNode;
  bool hasInit = false;
  var defalutDecoration = BoxDecoration(
    border: Border.all(
      width: 3,
       color: Colors.deepOrange),
     borderRadius: const BorderRadius.all(Radius.circular(5)));
  BoxDecoration? _decoration;
  @override
  void initState() {
    super.initState();
    final focusNode = FocusNode();
    _focusNode = focusNode;
    
    focusNode.addListener(() {
      widget.focusChange(focusNode.hasFocus);
      if (focusNode.hasFocus) {
        setState(() {
          if (widget.hasDecoration) {
            _decoration = widget.decoration;
          }
        });
      } else {
        setState(() {
            _decoration = null;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (widget.requestFocus && !hasInit) {
      FocusScope.of(context).requestFocus(_focusNode);
      hasInit = true;
    }
    return RawKeyboardListener(
      focusNode: _focusNode!, 
      onKey: (value) {
      if (value is RawKeyDownEvent && value.data is RawKeyEventDataAndroid) {
        final RawKeyDownEvent event = value;
        final RawKeyEventDataAndroid data = event.data as RawKeyEventDataAndroid;
        switch (data.keyCode) {
          case KeyCode.UP:
            FocusScope.of(context).focusInDirection(TraversalDirection.up);
          break;

          case KeyCode.DOWN:
            FocusScope.of(context).focusInDirection(TraversalDirection.down);
          break;

          case KeyCode.LEFT:
            FocusScope.of(context).focusInDirection(TraversalDirection.up);
          break;

          case KeyCode.RIGHT:
            FocusScope.of(context).focusInDirection(TraversalDirection.right);
          break;

          case KeyCode.NUM_CENTER:
            widget.onClick();
          break;

          case KeyCode.ENTER:
            widget.onClick();
          break;
        }
      }
    }, child: Container(
      margin: const EdgeInsets.all(8),
       decoration: _decoration,
        child: widget.child,));
  }
}