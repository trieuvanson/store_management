import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSignIn = false;

  changeLayout() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                      color: isSignIn ? Colors.grey : Colors.blue,
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
                      color: isSignIn ? Colors.blue : Colors.grey,
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
    );
  }

  _signInView(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Xin chào! Bạn đã đăng xuất. Hãy đăng nhập để tiếp tục.',
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
          onPressed: () {},
          color: Colors.blue,
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
          children: const [
            Text(
              'Quên mật khẩu?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
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
          'Đăng ký ngay',
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
          color: Colors.blue,
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
