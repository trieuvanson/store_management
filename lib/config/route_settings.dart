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
            builder: (_) => CheckSheetProductsScreen(
                  branchId: settings.arguments as int,
                ));
      case CheckingLoginPage.routeName:
        return MaterialPageRoute(builder: (_) => const CheckingLoginPage());
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
      //beautiful 404 page
      body: Container(
        padding:
            EdgeInsets.symmetric(vertical: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.4, 0.6],
            colors: [
              Colors.green,
              Colors.green.shade200,
            ],
          ),
        ),
        child: Center(
          child: Text(
            message ??
                '404 NOT FOUND\n'
                    'Không tìm thấy trang này.\n',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
