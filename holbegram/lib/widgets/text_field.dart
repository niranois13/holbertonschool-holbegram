import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const TextFieldInput({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.hintText,
    this.suffixIcon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: Color.fromARGB(218, 226, 37, 24),
      textInputAction: TextInputAction.next,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color : Colors.transparent,
            style: BorderStyle.none,
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.none,
          ),
        ),
      filled: true,
      contentPadding: const EdgeInsets.all(8),
      suffixIcon: suffixIcon,
      ),
    );
  }
}