import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String sessionId;

  BookingDetailsScreen({required this.sessionId});

  Future<Map<String, dynamic>> _fetchBookingDetails() async {
    final sessionSnapshot = await FirebaseFirestore.instance
        .collection('Sessions')
        .doc(sessionId)
        .get();

    if (!sessionSnapshot.exists) {
      throw Exception('Session not found.');
    }

    final sessionData = sessionSnapshot.data()!;
    final parentId = sessionData['parent_id'];
    final babysitterId = sessionData['babysitter_id'];
    final nurseryId = sessionData['nursery_id'];

    // Fetch parent data
    final parentSnapshot = await FirebaseFirestore.instance
        .collection('Parent')
        .doc(parentId)
        .get();

    // Fetch babysitter or nursery data if available
    DocumentSnapshot? sitterOrNurserySnapshot;
    if (babysitterId != null) {
      sitterOrNurserySnapshot = await FirebaseFirestore.instance
          .collection('BabySitter')
          .doc(babysitterId)
          .get();
    } else if (nurseryId != null) {
      sitterOrNurserySnapshot = await FirebaseFirestore.instance
          .collection('Nurseries')
          .doc(nurseryId)
          .get();
    }

    // Fetch billing information
    final billSnapshot = await FirebaseFirestore.instance
        .collection('Bill')
        .where('session_id', isEqualTo: sessionId)
        .get();

    return {
      'session': sessionData,
      'parent': parentSnapshot.data(),
      'sitterOrNursery': sitterOrNurserySnapshot?.data(),
      'bill': billSnapshot.docs.isNotEmpty ? billSnapshot.docs.first.data() : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Booking Details',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchBookingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading booking details.'),
            );
          }

          final data = snapshot.data!;
          return _buildDetailsView(data);
        },
      ),
    );
  }

  Widget _buildDetailsView(Map<String, dynamic> data) {
    final session = data['session'];
    final parent = data['parent'];
    final sitterOrNursery = data['sitterOrNursery'];
    final bill = data['bill'];

    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Session Details'),
          _buildDetailRow('Service Type', session['service_type']),
          _buildDetailRow('Date and Time', session['date_time']),
          _buildDetailRow('Location', session['location']),
          SizedBox(height: 10.h),

          _buildSectionTitle('Parent Information'),
          _buildDetailRow('Name', parent['name']),
          _buildDetailRow('Email', parent['email']),
          SizedBox(height: 10.h),

          if (sitterOrNursery != null) ...[
            _buildSectionTitle(
                sitterOrNursery.containsKey('experience') ? 'Babysitter Details' : 'Nursery Details'),
            _buildDetailRow('Name', sitterOrNursery['name']),
            _buildDetailRow('Email', sitterOrNursery['email']),
            if (sitterOrNursery.containsKey('experience'))
              _buildDetailRow('Experience', sitterOrNursery['experience']),
            if (sitterOrNursery.containsKey('ratings'))
              _buildDetailRow('Ratings', sitterOrNursery['ratings'].toString()),
            SizedBox(height: 10.h),
          ],

          if (bill != null) ...[
            _buildSectionTitle('Billing Information'),
            _buildDetailRow('Amount', '${bill['amount']} SAR'),
            _buildDetailRow('Payment Method', bill['payment_method']),
            _buildDetailRow('Bill ID', bill['session_id']),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16.sp)),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
