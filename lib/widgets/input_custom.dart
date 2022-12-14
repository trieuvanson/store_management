import 'package:flutter/material.dart';

class InputCustom extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool validation;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextStyle? textStyle;
  final String? validationErrorMsg;
  final bool? obscureText;
  final double radius;

  //prefixIcon
  final Widget? prefixIcon;

  const InputCustom({
    Key? key,
    this.labelText,
    this.hintText,
    this.validation = false,
    this.controller,
    this.keyboardType,
    this.textStyle,
    this.validationErrorMsg,
    this.prefixIcon,
    this.obscureText = false,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      style: textStyle,
      controller: controller,
      validator: (String? value) {
        if (validation) {
          if (value!.isEmpty) {
            return validationErrorMsg;
          }
        }
        return null;
      },
      obscureText: obscureText!,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        labelStyle: textStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
