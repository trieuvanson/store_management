import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/auth_screen/core/auth_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/contains.dart';
import '../../../utils/connection_alert.dart';
import '../../../utils/connection_services.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = false;
  late AuthBloc _authBloc;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController();
    _passwordController = TextEditingController();
    _loadSharedPreferences();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _usernameController.text = _prefs!.getString('username') ?? '';
    _passwordController.text = _prefs!.getString('password') ?? '';
  }

  changeLayout() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  handleLogin() async {
    try {
      _prefs?.setString('username', _usernameController.text);
      _prefs?.setString('password', _passwordController.text);

      final isOnline = await connectionServices.isOnline;
      if (isOnline) {
        _authBloc.add(
          LoginEvent(
            userName: _usernameController.text,
            passWord: _passwordController.text,
          ),
        );
      } else {
        connectionAlertSupport.showAlertBottom(
            title: "Thông báo",
            message: "Không có kết nối mạng, vui lòng kiểm tra lại",
            color: Colors.red);
      }
    } catch (e) {
      // print(e);
    }
  }

  DateTime? currentBackPressTime;

  handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      currentBackPressTime = now;
      Get.snackbar(
        'Thông báo',
        'Nhấn lần nữa để thoát',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 2),
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      );
      return false;
    }
    SystemNavigator.pop();
    return null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(),
            ),
            barrierDismissible: false,
          );
        } else if (state is FailureAuthState) {
          Get.back();
          Get.snackbar(
              "Thông báo", "Đăng nhập thất bại.\nLý do: ${state.error}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(10),
              borderRadius: 10,
              snackStyle: SnackStyle.FLOATING,
              animationDuration: const Duration(milliseconds: 300),
              duration: const Duration(seconds: 2),
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              mainButton: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ));
        } else if (state.auth != null) {
          Get.snackbar(
            "Thông báo",
            "Đăng nhập thành công",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            snackStyle: SnackStyle.FLOATING,
            animationDuration: const Duration(milliseconds: 300),
            duration: const Duration(seconds: 2),
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            mainButton: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            snackbarStatus: (status) {
              if (status == SnackbarStatus.CLOSED) {
                Get.offAllNamed(ChooseStoreScreen.routeName);
              }
            },
          );
        }
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () => handleWillPop(),
          child: SingleChildScrollView(

            child: Container(
              height: context.screenHeight,
              constraints: const BoxConstraints(
                minHeight: 600,
              ),
              decoration: const BoxDecoration(
                //shadow light
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFFFFFFF),
                    Color(0xFF8CB68D),
                  ],
                ),
              ),
              //padding.top
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => isSignIn ? changeLayout() : null,
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: isSignIn ? 20 : 30,
                              fontWeight: FontWeight.bold,
                              color: isSignIn ? Colors.grey : kPrimaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => isSignIn ? null : changeLayout(),
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: isSignIn ? 30 : 20,
                              fontWeight: FontWeight.bold,
                              color: isSignIn ? kPrimaryColor : Colors.grey,
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 20),
                  IndexedStack(
                    index: isSignIn ? 1 : 0,
                    children: [_signInView(context), _signUpView(context)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signInView(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Xin chào! Bạn đã đăng xuất. \nHãy đăng nhập để tiếp tục.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        InputCustom(
          hintText: 'Tài khoản',
          controller: _usernameController,
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.person),
          ),
        ),
        20.heightBox,
        InputCustom(
          hintText: 'Mật khẩu',
          controller: _passwordController,
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        20.heightBox,
        CustomButton(
          text: 'Đăng nhập',
          onPressed: () => handleLogin(),
          color: kPrimaryColor,
          textColor: Colors.white,
          width: double.infinity,
          height: 50,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          radius: 8,
          elevation: 0,
          isOutline: false,
          isDisabled: false,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quên mật khẩu?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: kPrimaryColor.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _signUpView(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Bạn chưa có tài khoản?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Đăng ký tại đây',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Mật khẩu',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Nhập lại mật khẩu',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Đăng ký',
          onPressed: () {},
          color: kPrimaryColor,
          textColor: Colors.white,
          width: double.infinity,
          height: 50,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          radius: 8,
          elevation: 0,
          isOutline: false,
          isDisabled: false,
        ),
      ],
    );
  }
}
