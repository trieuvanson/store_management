import 'package:connectivity/connectivity.dart';

class ConnectionServices {
  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      return true;
    }
    return false;
  }


  get isOnline => checkConnection();
}

final connectionServices = ConnectionServices();
