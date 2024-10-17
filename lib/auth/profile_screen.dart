import 'package:babysit/core/app_router.dart';
import 'package:babysit/core/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
          onPressed: () {}, // Open drawer or additional menu
        ),
        title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ListView(
          children: [
            _buildExpandableSection('Addresses', ['Home', 'Office']),
            _buildExpandableSection('Setting', ['Country', 'Language', 'Notification']),
            _buildExpandableSection('Connect with us', ['Help']),
            _buildExpandableSection('Messages', ["Customer's Service", 'Chat']),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                context.go(loginPath); // Navigate to login after logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text('Logout', style: TextStyle(fontSize: 18.sp)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, List<String> options) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      children: options.map((option) => ListTile(title: Text(option))).toList(),
    );
  }
}
