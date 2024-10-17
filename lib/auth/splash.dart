
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    Future.delayed(Duration(seconds: 3), () {
      context.goNamed('choose-role'); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/rainbow.png',
                width: 150.w,
                height: 150.h,
              ),
            ),
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'B', style: TextStyle(color: Color(0xFFB2DFDB))),
                  TextSpan(
                      text: 'A', style: TextStyle(color: Color(0xFFFFCDD2))),
                  TextSpan(
                      text: 'B', style: TextStyle(color: Color(0xFFB39DDB))),
                  TextSpan(
                      text: 'Y', style: TextStyle(color: Color(0xFFFFF176))),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'C', style: TextStyle(color: Color(0xFF4DB6AC))),
                  TextSpan(
                      text: 'A', style: TextStyle(color: Color(0xFF9575CD))),
                  TextSpan(
                      text: 'R', style: TextStyle(color: Color(0xFFF06292))),
                  TextSpan(
                      text: 'E', style: TextStyle(color: Color(0xFF7986CB))),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 100.w,
              height: 4.h,
              color: Theme.of(context).primaryColor, 
            ),
          ],
        ),
      ),
    );
  }
}
