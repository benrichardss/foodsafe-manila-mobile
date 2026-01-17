import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomInkwellButton extends StatelessWidget {
  final onTap;
  final double height, width, fontSize;
  final String buttonName;
  final Icon icon;
  FontWeight fontWeight;
  Color bgColor, fontColor;

  CustomInkwellButton({
    super.key,
    required this.onTap,
    required this.height,
    required this.width,
    this.buttonName = '',
    this.bgColor = Colors.white,
    this.fontColor = Colors.white,
    this.fontSize = 1,
    this.icon = const Icon(null),
    this.fontWeight = FontWeight.normal
    });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        splashColor: Colors.grey,
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: buttonName == ''
                ? icon
                : Text( 
                    buttonName,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: fontColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
