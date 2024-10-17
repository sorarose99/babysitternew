import 'package:babysit/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({Key? key, required this.child}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  bool _isFullScreenMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bool isKeyboardVisible =
        WidgetsBinding.instance.window.viewInsets.bottom > 0;
    setState(() {
      _isKeyboardVisible = isKeyboardVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          final String location = GoRouterState.of(context).uri.toString();
          if (!location.startsWith('/home')) {
            _onItemTapped(0, context);
          }
          return true;
        },
        child: widget.child,
      ),
      bottomNavigationBar: (_isKeyboardVisible || _isFullScreenMode)
          ? SizedBox.shrink()
          : BottomNavigationBar(
              currentIndex: _getSelectedIndex(context),
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).iconTheme.color,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.layers),
                  label: 'Booking',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  label: 'Children',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onTap: (index) => _onItemTapped(index, context),
            ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/booking')) {
      return 1;
    }
    if (location.startsWith('/children')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go(homePath);
      break;
    case 1:
  context.go(bookingPath);
        break;
    case 2:
      context.go(childrenPath);
      break;
    case 3:
      context.go(profilePath); // Navigate to Profile Screen
      break;
  }

  }

  void _handleFullScreenToggle(bool isFullScreen) {
    setState(() {
      _isFullScreenMode = isFullScreen;
    });
  }
}
