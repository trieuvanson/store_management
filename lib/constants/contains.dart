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
const kTextAveRom10 = TextStyle(
  fontFamily: 'avenir-roman',
  fontWeight: FontWeight.w400,
  fontSize: 10.0,
);

const kTextAveRom12 = TextStyle(
  fontFamily: 'avenir-roman',
  fontWeight: FontWeight.w400,
  fontSize: 12.0,
);

const kTextAveRom14 = TextStyle(
  fontFamily: 'avenir-roman',
  fontWeight: FontWeight.w400,
  fontSize: 14.0,
);

const kTextAveRom16 = TextStyle(
  fontFamily: 'avenir-roman',
  fontWeight: FontWeight.w400,
  fontSize: 16.0,
);

const kTextAveRom18 = TextStyle(
  fontFamily: 'avenir-roman',
  fontWeight: FontWeight.w400,
  fontSize: 18.0,
);

//AVENIR-HEAVY
const kTextAveHev14 = TextStyle(
  fontFamily: 'avenir-heavy',
  fontWeight: FontWeight.w700,
  fontSize: 14.0,
);

const kTextAveHev16 = TextStyle(
  fontFamily: 'avenir-heavy',
  fontWeight: FontWeight.w700,
  fontSize: 16.0,
);

const kTextAveHev18 = TextStyle(
  fontFamily: 'avenir-heavy',
  fontWeight: FontWeight.w700,
  fontSize: 18.0,
);

const kColorDark = Color(0xFF3d3e51);
const kColorMuted = Color(0xFF969393);
const kColorBlack = Color(0xff000000);
const kColorWhite = Color(0xffffffff);
const kColorGreen= Color(0xff008000);
const kColorRed=Color(0xffFF0000);
const kColorWhiteSmoke = Color(0xFFF4F4F4);

