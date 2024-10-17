// import 'package:babysit/auth/profile_screen.dart';
// import 'package:babysit/booking/booking_screen.dart';
// import 'package:babysit/booking/payment_screen.dart';
// import 'package:babysit/core/auth_provider.dart';
// import 'package:babysit/nurseries/nurseries_details_screen.dart';
// import 'package:babysit/pages/main_page.dart';
// import 'package:go_router/go_router.dart';
// import 'package:babysit/auth/chooseRoleScreen.dart';
// import 'package:babysit/auth/login.dart';
// import 'package:babysit/auth/signup.dart';
// import 'package:babysit/auth/splash.dart';
// import 'package:babysit/pages/home.dart';
// import 'package:babysit/setters/find_sitter_screen.dart';
// import 'package:babysit/nurseries/find_nurseries_screen.dart';
// import 'package:babysit/setters/sitter_details_screen.dart';
// import 'package:babysit/setters/children_screen.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// const String splashPath = '/';
// const String chooseRolePath = '/choose-role';
// const String signUpPath = '/sign-up';
// const String loginPath = '/login';
// const String homePath = '/home';
// const String findSitterPath = '/find-sitter';
// const String findNurseriesPath = '/find-nurseries';

// const String sitterDetailsPath = '/sitter-details';
// const String nurseryDetailsPath = '/nursery-details';
// const String childrenPath = '/children';
// const String bookingPath = '/booking';
// const String profilePath = '/profile';
// const String paymentPath = '/payment';

// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: splashPath,
//     routes: [
//       GoRoute(
//         path: splashPath,
//         name: 'splash',
//         builder: (context, state) => SplashScreen(),
//       ),
//       GoRoute(
//         path: homePath,
//         name: 'home',
//         builder: (context, state) => MainPage(child: HomeScreen()),
//       ),
//       GoRoute(
//         path: chooseRolePath,
//         name: 'choose-role',
//         builder: (context, state) => MainPage(child: ChooseRoleScreen()),
//       ),
//       GoRoute(
//         path: signUpPath,
//         name: 'sign-up',
//         builder: (context, state) {
//           final role = state.uri.queryParameters['role'] ?? 'Parent';
//           return MainPage(child: SignUpScreen(role: role));
//         },
//       ),
//       GoRoute(
//         path: paymentPath,
//         name: 'payment',
//         builder: (context, state) {
//           final sessionId = state.uri.queryParameters['session_id'] ?? '';
//           final amount =
//               double.tryParse(state.uri.queryParameters['amount'] ?? '0') ??
//                   0.0;
//           return PaymentScreen(sessionId: sessionId, totalAmount: amount);
//         },
//       ),
//       GoRoute(
//         path: profilePath,
//         name: 'profile',
//         builder: (context, state) {
//           final role = state.pathParameters['role'] ?? 'Parent';
//           final authProvider =
//               Provider.of<AuthProvider>(context, listen: false);

//           if (!authProvider.isAuthenticated) {
//             return MainPage(
//                 child:
//                     ChooseRoleScreen()); // Redirect to ChooseRole if not authenticated
//           }
//           return MainPage(child: ProfileScreen());
//         },
//       ),
//       GoRoute(
//         path: loginPath,
//         name: 'login',
//         builder: (context, state) {
//           final role = state.uri.queryParameters['role'] ?? 'Parent';
//           return MainPage(child: LoginScreen());
//         },
//       ),
//       GoRoute(
//         path: findSitterPath,
//         name: 'find-sitter',
//         builder: (context, state) => MainPage(child: FindSitterScreen()),
//       ),
//       GoRoute(
//         path: findNurseriesPath,
//         name: 'find-nurseries',
//         builder: (context, state) => MainPage(child: FindNurseriesScreen()),
//       ),
//       GoRoute(
//         path: bookingPath,
//         name: 'booking',
//         builder: (context, state) {
//           final bookingData = state.extra as Map<String, dynamic>? ?? {};
//           return BookingScreen(
//             serviceType: bookingData['serviceType'] ?? 'Unknown',
//             dateTime: bookingData['dateTime'] ?? 'No date',
//             location: bookingData['location'] ?? 'No location',
//             hasBooking: bookingData['hasBooking'] ?? true,
//           );
//         },
//       ),
//       GoRoute(
//         path: sitterDetailsPath,
//         name: 'sitter-details',
//         builder: (context, state) {
//           final sitterData = state.extra as Map<String, dynamic>? ?? {};
//           final LatLng? sitterLocation = sitterData['sitterLocation'] ?? null;

//           return MainPage(
//             child: SitterDetailsScreen(
//               sitterName: sitterData['sitterName'] ?? 'Sitter',
//               sitterLocation:
//                   sitterLocation ?? LatLng(0, 0), // Fallback if null
//               skills: sitterData['skills'] ?? [],
//               moreInfo: sitterData['moreInfo'] ?? '',
//             ),
//           );
//         },
//       ),
//       GoRoute(
//         path: nurseryDetailsPath,
//         name: 'nursery-details',
//         builder: (context, state) {
//           final nurseryData = state.extra as Map<String, dynamic>? ?? {};
//           final LatLng? nurseryLocation =
//               nurseryData['nurseryLocation'] ?? null;

//           return MainPage(
//             child: NurseryDetailsScreen(
//               nurseryName: nurseryData['nurseryName'] ?? 'Nursery',
//               nurseryLocation:
//                   nurseryLocation ?? LatLng(0, 0), // Fallback if null
//               workingDays: nurseryData['workingDays'] ?? [],
//               startTime: nurseryData['startTime'] ?? '',
//               endTime: nurseryData['endTime'] ?? '',
//               moreInfo: nurseryData['moreInfo'] ?? '',
//             ),
//           );
//         },
//       ),
//       GoRoute(
//           path: childrenPath,
//           name: 'children',
//           builder: (context, state) {
//             final role = state.uri.queryParameters['role'] ?? 'Parent';

//             return MainPage(
//                 child: ChildrenScreen(
//               role: role
//             ));
//           }),
//     ],
//   );
// }
import 'package:babysit/auth/profile_screen.dart';
import 'package:babysit/booking/booking_details_screen.dart';
import 'package:babysit/booking/booking_screen.dart';
import 'package:babysit/booking/payment_screen.dart';
import 'package:babysit/booking/previous_booking.dart';
import 'package:babysit/core/auth_provider.dart';
import 'package:babysit/nurseries/nurseries_details_screen.dart';
import 'package:babysit/pages/main_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth/chooseRoleScreen.dart';
import '../auth/login.dart';
import '../auth/signup.dart';
import '../auth/splash.dart';
import '../pages/home.dart';
import '../setters/find_sitter_screen.dart';
import '../nurseries/find_nurseries_screen.dart';
import '../setters/sitter_details_screen.dart';
import '../setters/children_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String splashPath = '/';
const String chooseRolePath = '/choose-role';
const String signUpPath = '/sign-up';
const String loginPath = '/login';
const String homePath = '/home';
const String findSitterPath = '/find-sitter';
const String findNurseriesPath = '/find-nurseries';
const String sitterDetailsPath = '/sitter-details';
const String nurseryDetailsPath = '/nursery-details';
const String childrenPath = '/children';
const String bookingPath = '/booking';
const String profilePath = '/profile';
const String paymentPath = '/payment';
const String previousBookingsPath = '/previous-bookings';
const String bookingDetailsPath = '/booking-details';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    routes: [
      GoRoute(
        path: findSitterPath,
        name: 'find-sitter',
        builder: (context, state) => MainPage(child: FindSitterScreen()),
      ),
      GoRoute(
        path: findNurseriesPath,
        name: 'find-nurseries',
        builder: (context, state) => MainPage(child: FindNurseriesScreen()),
      ),
      GoRoute(
        path: sitterDetailsPath,
        name: 'sitter-details',
        builder: (context, state) {
          final sitterData = state.extra as Map<String, dynamic>? ?? {};
          final LatLng? sitterLocation = sitterData['sitterLocation'] ?? null;

          return MainPage(
            child: SitterDetailsScreen(
              sitterName: sitterData['sitterName'] ?? 'Sitter',
              sitterLocation:
                  sitterLocation ?? LatLng(0, 0), // Fallback if null
              skills: sitterData['skills'] ?? [],
              moreInfo: sitterData['moreInfo'] ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: nurseryDetailsPath,
        name: 'nursery-details',
        builder: (context, state) {
          final nurseryData = state.extra as Map<String, dynamic>? ?? {};
          final LatLng? nurseryLocation =
              nurseryData['nurseryLocation'] ?? null;

          return MainPage(
            child: NurseryDetailsScreen(
              nurseryName: nurseryData['nurseryName'] ?? 'Nursery',
              nurseryLocation:
                  nurseryLocation ?? LatLng(0, 0), // Fallback if null
              workingDays: nurseryData['workingDays'] ?? [],
              startTime: nurseryData['startTime'] ?? '',
              endTime: nurseryData['endTime'] ?? '',
              moreInfo: nurseryData['moreInfo'] ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: splashPath,
        name: 'splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: homePath,
        name: 'home',
        builder: (context, state) => MainPage(child: HomeScreen()),
      ),
      GoRoute(
        path: chooseRolePath,
        name: 'choose-role',
        builder: (context, state) => MainPage(child: ChooseRoleScreen()),
      ),
      GoRoute(
        path: signUpPath,
        name: 'sign-up',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'Parent';
          return MainPage(child: SignUpScreen(role: role));
        },
      ),
      GoRoute(
        path: loginPath,
        name: 'login',
        builder: (context, state) {
          final redirectTo =
              state.uri.queryParameters['redirectTo'] ?? homePath;
          return MainPage(
            child: LoginScreen(
              onLoginSuccess: () =>
                  context.go(redirectTo), // Redirect after login
            ),
          );
        },
      ),
      GoRoute(
        path: bookingPath,
        name: 'booking',
        builder: (context, state) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);

          if (!authProvider.isAuthenticated) {
            // Trigger navigation asynchronously to avoid returning void
            Future.microtask(() {
              context.goNamed(
                'login',
                queryParameters: {'redirectTo': bookingPath},
              );
            });
            // Return a temporary placeholder widget
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final bookingData = state.extra as Map<String, dynamic>? ?? {};
          return BookingScreen(
            serviceType: bookingData['serviceType'] ?? 'Unknown',
            dateTime: bookingData['dateTime'] ?? 'No date',
            location: bookingData['location'] ?? 'No location',
            hasBooking: bookingData['hasBooking'] ?? true,
          );
        },
      ),
      GoRoute(
        path: paymentPath,
        name: 'payment',
        builder: (context, state) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);

          if (!authProvider.isAuthenticated) {
            // Trigger navigation asynchronously to avoid returning void
            Future.microtask(() {
              context.goNamed(
                'login',
                queryParameters: {'redirectTo': paymentPath},
              );
            });
            // Return a temporary placeholder widget
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final sessionId = state.uri.queryParameters['session_id'] ?? '';
          final amount =
              double.tryParse(state.uri.queryParameters['amount'] ?? '0') ??
                  0.0;

          return PaymentScreen(sessionId: sessionId, totalAmount: amount);
        },
      ),
      GoRoute(
        path: bookingDetailsPath,
        name: 'booking-details',
        builder: (context, state) {
          final sessionId = state.extra as String;
          return BookingDetailsScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: previousBookingsPath,
        name: 'previous-bookings',
        builder: (context, state) => PreviousBookingsScreen(),
      ),
      GoRoute(
        path: profilePath,
        name: 'profile',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'Parent';
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);

          if (!authProvider.isAuthenticated) {
            return MainPage(child: ChooseRoleScreen());
          }
          return MainPage(child: ProfileScreen());
        },
      ),
      GoRoute(
        path: childrenPath,
        name: 'children',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'Parent';
          return MainPage(child: ChildrenScreen(role: role));
        },
      ),
    ],
  );
}
