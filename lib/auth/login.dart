
// import 'package:babysit/core/auth_provider.dart' as customAuth;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String selectedRole = 'Parent'; // Default selected role

//   // Handle Firebase Social Login
//   Future<void> _loginWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return; // User canceled the sign-in

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);
//       context.goNamed('home'); // Navigate to home after successful login
//     } catch (e) {
//       _showErrorSnackbar(context, 'Google sign-in failed: $e');
//     }
//   }

//   Future<void> _resetPassword(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//           email: emailController.text.trim());
//       _showErrorSnackbar(context, 'Password reset email sent.');
//     } catch (e) {
//       _showErrorSnackbar(context, 'Error: ${e.toString()}');
//     }
//   }

//   void _showErrorSnackbar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: TextStyle(fontSize: 16.sp)),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Future<void> _loginUser(BuildContext context) async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         final userCredential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//         final User? user = userCredential.user;
//         if (user != null) {
//           final authProvider =
//               Provider.of<customAuth.AuthProvider>(context, listen: false);
//           await authProvider.login(selectedRole);
//           context.goNamed('home'); // Navigate to home screen
//         }
//       } catch (e) {
//         _showErrorSnackbar(context, e.toString());
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, size: 24.sp),
//           onPressed: () => context.pop(),
//         ),
//         title: Text(
//           '$selectedRole Sign In',
//           style: TextStyle(fontSize: 24.sp),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildRoleSlider(), // Role slider
//                 SizedBox(height: 20.h),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(labelText: 'Email Address'),
//                   validator: (value) =>
//                       value?.isEmpty ?? true ? 'Enter your email' : null,
//                 ),
//                 SizedBox(height: 10.h),
//                 TextFormField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     suffixIcon: Icon(Icons.visibility),
//                   ),
//                   obscureText: true,
//                   validator: (value) =>
//                       value?.isEmpty ?? true ? 'Enter your password' : null,
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () => _resetPassword(context),
//                     child: Text(
//                       'Forgot password?',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.blue,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 ElevatedButton(
//                   onPressed: () => _loginUser(context),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     backgroundColor: Theme.of(context).primaryColor,
//                   ),
//                   child: Text(
//                     'Sign In',
//                     style: TextStyle(fontSize: 18.sp),
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Center(child: Text('Or', style: TextStyle(fontSize: 16.sp))),
//                 SizedBox(height: 10.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SignInButton(
//                       Buttons.Google,
//                       onPressed: () => _loginWithGoogle(context),
//                     ),
//                     SizedBox(width: 10.w),
//                     SignInButton(
//                       Buttons.Apple,
//                       onPressed: () {
//                         // Apple login logic here
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('New to Babysit?'),
//                     SizedBox(width: 5.w),
//                     GestureDetector(
//                       onTap: () {
//                         context.goNamed('sign-up', queryParameters: {
//                           'role': selectedRole,
//                         });
//                       },
//                       child: Text(
//                         'Sign up',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleSlider() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: ['Parent', 'Sitter', 'Nursery'].map((role) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedRole = role;
//             });
//           },
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.w),
//             child: Text(
//               role,
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: selectedRole == role ? FontWeight.bold : FontWeight.normal,
//                 color: selectedRole == role
//                     ? Theme.of(context).primaryColor
//                     : Colors.grey,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
import 'package:babysit/core/auth_provider.dart' as customAuth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess; // New callback for successful login

  LoginScreen({required this.onLoginSuccess}); // Add it to constructor

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedRole = 'Parent'; // Default selected role

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      widget.onLoginSuccess(); // Call the callback after login success
    } catch (e) {
      _showErrorSnackbar(context, 'Google sign-in failed: $e');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      _showErrorSnackbar(context, 'Password reset email sent.');
    } catch (e) {
      _showErrorSnackbar(context, 'Error: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 16.sp)),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final User? user = userCredential.user;
        if (user != null) {
          final authProvider =
              Provider.of<customAuth.AuthProvider>(context, listen: false);
          await authProvider.login(selectedRole);
          widget.onLoginSuccess(); // Call the callback after login success
        }
      } catch (e) {
        _showErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '$selectedRole Sign In',
          style: TextStyle(fontSize: 24.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoleSlider(), // Role slider
                SizedBox(height: 20.h),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email Address'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter your email' : null,
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.visibility),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter your password' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _resetPassword(context),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => _loginUser(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(child: Text('Or', style: TextStyle(fontSize: 16.sp))),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton(
                      Buttons.Google,
                      onPressed: () => _loginWithGoogle(context),
                    ),
                    SizedBox(width: 10.w),
                    SignInButton(
                      Buttons.Apple,
                      onPressed: () {
                        // Apple login logic here
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New to Babysit?'),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        context.goNamed('sign-up', queryParameters: {
                          'role': selectedRole,
                        });
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Parent', 'Sitter', 'Nursery'].map((role) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedRole = role;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: selectedRole == role ? FontWeight.bold : FontWeight.normal,
                color: selectedRole == role
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
