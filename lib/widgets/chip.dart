import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final bool hasBorder;
  final double fontSize;
  final double padding;
  final String fontFamily;
  final double borderRadius;
  const CustomChip(
      {required this.text,
      required this.textColor,
      required this.backgroundColor,
      required this.hasBorder,
      required this.padding,
      required this.fontSize,
      required this.fontFamily,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Chip(
      side: hasBorder
          ? BorderSide.none
          : const BorderSide(color: Colors.black, width: 1.0),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      label: Text(text,
          style: TextStyle(
              fontSize: fontSize, color: textColor, fontFamily: fontFamily)),
      padding: EdgeInsets.all(padding),
    );
  }
}
