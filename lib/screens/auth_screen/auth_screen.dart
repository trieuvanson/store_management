import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_management/screens/home_screen/choose_store_screen/choose_store_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/contains.dart';
import '../../widgets/widgets.dart';

class AuthScreen extends StatefulWidget {

  static const String routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);




  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = false;
  DateTime? currentBackPressTime;

  changeLayout() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }
  Future<bool> handleWillPop(BuildContext context) async {
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
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop:() => handleWillPop(context),
        child: SafeArea(
          child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  GestureDetector(
                    onTap: () => isSignIn? changeLayout() : null,
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
                    onTap: () => isSignIn? null : changeLayout(),
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
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.email),
          ),
        ),
        20.heightBox,
        InputCustom(
          hintText: 'Mật khẩu',
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.email),
          ),
          obscureText: true,
        ),
        20.heightBox,
        CustomButton(
          text: 'Đăng nhập',
          onPressed: () => {
            // Fluttertoast.showToast(
            //   msg: 'Đăng nhập thành công',
            //   toastLength: Toast.LENGTH_SHORT,
            //   gravity: ToastGravity.BOTTOM,
            //   timeInSecForIosWeb: 1,
            //   backgroundColor: Colors.green,
            //   textColor: Colors.white,
            //   fontSize: 16.0,
            // ),
            Future.delayed(const Duration(seconds: 2), () {
              Get.offAllNamed(ChooseStoreScreen.routeName);
            }),
          },
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
          children:  [
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
