import 'package:flutter/cupertino.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType; // Add input type
  final TextInputAction? textInputAction; // Add input action
  final String? autofillHints; // Add autofill hints

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CupertinoTextField(
        controller: controller,
        obscureText: obscureText,
        placeholder: hintText,
        placeholderStyle: const TextStyle(
          color: CupertinoColors.inactiveGray,
        ),
        prefix: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  prefixIcon,
                  color: CupertinoColors.inactiveGray,
                ),
              )
            : null,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: CupertinoColors.black,
        ),
        cursorColor: CupertinoColors.black,
        textInputAction: textInputAction ?? TextInputAction.done,
        keyboardType: keyboardType ?? TextInputType.text,
        autofillHints: autofillHints != null ? [autofillHints!] : null,
      ),
    );
  }
}
