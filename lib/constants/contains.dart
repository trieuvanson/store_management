import 'package:flutter/cupertino.dart';


const kPrimaryColor = Color(0xFF0c9869);
const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF9F8FD);

const double kDefaultPadding = 20.0;

Map<int, Color> get kPrimaryColorMap => const {
  50: Color(0xFFF8F9FA),
  100: Color(0xFFF1F3F5),
  200: Color(0xFFE9ECEF),
  300: Color(0xFFD6D9DC),
  400: Color(0xFFBEC0C4),
  500: Color(0xFFA1A6AB),
  600: Color(0xFF868A8F),
  700: Color(0xFF6B6F73),
  800: Color(0xFF54595E),
  900: Color(0xFF3C4245),
};


String convertCurrencyToVND(int amount) {
  return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
}