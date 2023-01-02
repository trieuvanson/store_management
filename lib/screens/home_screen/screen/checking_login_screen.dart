import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '/constants/contains.dart';
import '/screens/screens.dart';

import '../../auth_screen/core/auth_bloc.dart';

class CheckingLoginPage extends StatefulWidget {
  static const String routeName = '/checking_login_page';

  const CheckingLoginPage({Key? key}) : super(key: key);

  @override
  _CheckingLoginPageState createState() => _CheckingLoginPageState();
}

class _CheckingLoginPageState extends State<CheckingLoginPage> with TickerProviderStateMixin {

  late AnimationController _animationController;

  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_animationController)..addStatusListener((status) {
      if( status == AnimationStatus.completed ){
        _animationController.reverse();
      } else if ( status == AnimationStatus.dismissed ){
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {

        Future.delayed(const Duration(seconds: 1), () {
          if( state is LoadingAuthState ){
            Get.toNamed(CheckingLoginPage.routeName);
          } else if ( state is LogOutAuthState ){
            Get.offAllNamed(AuthScreen.routeName);
          } else if (state.auth != null) {
            Get.offAllNamed(ChooseStoreScreen.routeName);
          }
        });
      },
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child)
                => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/logo-white.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
