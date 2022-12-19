import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config/route_settings.dart';
import 'constants/contains.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e);
  }
  setPathUrlStrategy();
  runApp(const StoreManagementApp());
}

class StoreManagementApp extends StatefulWidget {
  const StoreManagementApp({Key? key}) : super(key: key);

  @override
  State<StoreManagementApp> createState() => _StoreManagementAppState();
}

class _StoreManagementAppState extends State<StoreManagementApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lix Shop',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        primarySwatch: MaterialColor(kPrimaryColor.value, kPrimaryColorMap),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: GoogleFonts.openSans().fontFamily,
              bodyColor: kTextColor,
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      initialRoute: AuthScreen.routeName,
      onGenerateRoute: RouteSettingsWithArguments.generateRoute,
      // routes: {
      //   '/': (context) => const MainScreen(),
      // },
      // onGenerateRoute: RouteSettingsWithArguments.generateRoute,
    );
  }
}
