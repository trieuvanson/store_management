import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? radius;
  final double? elevation;
  final bool? isOutline;
  final bool? isDisabled;
  final Icon? icon;

  const CustomButton(
      {Key? key,
      this.text = '',
      this.onPressed,
      this.color = Colors.blue,
      this.textColor = Colors.white,
      this.width,
      this.height,
      this.fontSize = 16,
      this.fontWeight = FontWeight.normal,
      this.radius = 8,
      this.elevation = 0,
      this.isOutline = false,
      this.isDisabled = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
          ),
          elevation: elevation,
        ),
        onPressed: () => onPressed!(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            Text(
              text!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
