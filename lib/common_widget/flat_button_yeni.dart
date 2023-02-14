import 'package:flutter/material.dart';

class FlatButtonYeni extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Color backGroundColor;
  final Color textColor;
  FlatButtonYeni(
      {this.onPressed, this.child, this.backGroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: backGroundColor,
      textStyle: TextStyle(color: textColor),
      foregroundColor: Colors.black87,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: child,
    );
  }
}
