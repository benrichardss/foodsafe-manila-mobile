// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextformfield extends StatelessWidget {
  CustomTextformfield({
    super.key,
    required this.validator,
    required this.onSaved,
    this.controller = TextEditingController,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
    this.toggleIcon,
  });

  final validator;
  final onSaved;
  final controller;
  final isObscure;
  final fontSize;
  final fontColor;
  final double height, width;
  final hintTextSize;
  final hintText;
  TextInputType keyboardType;
  int maxLength;
  final VoidCallback? toggleIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      style: TextStyle(fontSize: fontSize, color: fontColor),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, height, width, height),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(fontFamily: 'Frutiger'),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: Colors.grey,
          fontSize: hintTextSize,
          fontWeight: FontWeight.w400
        ),
        hintText: hintText,
        suffixIcon: toggleIcon != null
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: toggleIcon,
              )
            : null,
      ),
    );
  }
}
