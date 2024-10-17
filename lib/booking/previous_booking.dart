import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class PreviousBookingsScreen extends StatelessWidget {
  const PreviousBookingsScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchPreviousBookings() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Sessions')
        .where('parent_id', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => {
              'session_id': doc.id,
              'service_type': doc['service_type'],
              'date_time': doc['date_time'],
              'location': doc['location'],
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Previous Bookings',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPreviousBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading bookings. Please try again.'),
            );
          } else if (snapshot.data?.isEmpty ?? true) {
            return Center(
              child: Text('No previous bookings found.'),
            );
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildBookingItem(context, booking);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, Map<String, dynamic> booking) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: ListTile(
        title: Text(
          booking['service_type'],
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Text('Date and Time: ${booking['date_time']}'),
            SizedBox(height: 5.h),
            Text('Location: ${booking['location']}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          context.pushNamed('booking-details',
              extra: {'sessionId': booking['session_id']});
        },
      ),
    );
  }
}
