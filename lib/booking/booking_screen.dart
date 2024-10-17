
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/auth_provider.dart';

class BookingScreen extends StatelessWidget {
  final String serviceType;
  final String dateTime;
  final String location;
  final bool hasBooking;

  BookingScreen({
    required this.serviceType,
    required this.dateTime,
    required this.location,
    this.hasBooking = true,
  });

  Future<String> _createSession() async {
    // Create session document and get its generated ID
    DocumentReference sessionRef =
        await FirebaseFirestore.instance.collection('Sessions').add({
      'service_type': serviceType,
      'date_time': dateTime,
      'location': location,
      'parent_id': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': Timestamp.now(),
    });

    return sessionRef.id; // Return session_id
  }

  void _handlePayment(BuildContext context) async {
    final sessionId =
        await _createSession(); // Create session and get session_id

    // Redirect to PaymentScreen with the generated session_id
    context.pushNamed(
      'payment',
      extra: {
        'sessionId': sessionId,
        'totalAmount': 165.75, // Example amount
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('My Booking',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: hasBooking
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingDetails(),
                  SizedBox(height: 20.h),
                  _buildCancelButton(),
                  SizedBox(height: 10.h),
                  _buildPayButton(context),
                ],
              )
            : _buildNoBookingView(context),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handlePayment(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Text('Paying off', style: TextStyle(fontSize: 18.sp)),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.green),
            title: Text(
              'Service type',
              style: TextStyle(fontSize: 16.sp, color: Colors.green),
            ),
            subtitle: Text(
              serviceType,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.green),
            title: Text(
              'Date and time',
              style: TextStyle(fontSize: 16.sp, color: Colors.green),
            ),
            subtitle: Text(
              dateTime,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.h),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.green),
            title: Text(
              'Location',
              style: TextStyle(fontSize: 16.sp, color: Colors.green),
            ),
            subtitle: TextButton(
              onPressed: () {
                // Handle map view
              },
              child: Text('Show on map', style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle booking cancellation
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: Size(double.infinity, 50.h),
      ),
      child: Text('Cancellation of booking', style: TextStyle(fontSize: 18.sp)),
    );
  }

 Widget _buildNoBookingView(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.layers_outlined, size: 100.sp, color: Colors.grey),
        SizedBox(height: 10.h),
        Text('No Bookings', style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 20.h),
        
        ElevatedButton(




          
       onPressed: () {
    context.pushNamed('previous-bookings');
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    minimumSize: Size(200.w, 50.h),
  ),
  child: Text('Previous Booked', style: TextStyle(fontSize: 18.sp)),

        ),
      ],
    ),
  );

  }
}
