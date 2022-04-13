import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../widgets/auth/auth_form.dart';
import '../../view_models/user_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));

    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    userViewModel.isLogin ? 'Welcome back!' : 'Sign up',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 28,
                      letterSpacing:
                          -1, // color: Color.fromRGBO(24, 50, 169, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    userViewModel.isLogin
                        ? 'Please login to continue'
                        : 'Create an account here',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black26,
                      letterSpacing:
                          -1, // color: Color.fromRGBO(24, 50, 169, 1),
                    ),
                  ),
                ),
              ),
              if (userViewModel.isLogin)
                Expanded(
                  child: SvgPicture.asset(
                    'assets/images/wfh_9.svg',
                    //height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
              SizedBox(
                height: 12,
              ),
              Expanded(child: AuthForm()),
            ],
          ),
        ),
      ),
    );
  }
}
