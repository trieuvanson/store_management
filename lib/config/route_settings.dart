//create route settings

import 'package:flutter/material.dart';

import '../screens/screens.dart';

class RouteSettingsWithArguments extends RouteSettings {
  final RouteSettings settings;

  const RouteSettingsWithArguments({
    required this.settings,
  });

  @override
  String? get name => settings.name;

  @override
  dynamic get arguments => settings.arguments;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case ChooseStoreScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ChooseStoreScreen());
      case CheckSheetProductsScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const CheckSheetProductsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const NotFound(
                  message: '404 NOT FOUND\n'
                      'Không tìm thấy trang này.\n',
                ));
    }
  }
}

class NotFound extends StatelessWidget {
  final String? message;

  const NotFound({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(message!)),
    );
  }
}
