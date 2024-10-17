
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FindSitterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Find a Sitter',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('BabySitter').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading sitters...'),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No sitters found'));
          }

          var sitters = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sitters.length,
            itemBuilder: (context, index) {
              var sitterData = sitters[index].data() as Map<String, dynamic>;

              // Extract data from Firestore document
              String name = sitterData['Name'] ?? 'Unknown Sitter';
              String availability = sitterData['Availability'] ?? 'Available';
              String distance = 'Unknown Distance'; // Placeholder for future geolocation
              Color iconColor;

              // Set icon color based on availability
              if (availability == 'Available') {
                iconColor = Colors.green;
              } else if (availability == 'Part-time') {
                iconColor = Colors.orange;
              } else {
                iconColor = Colors.red;
              }

              return _buildSitterItem(
                context,
                name: name,
                distance: distance,
                iconColor: iconColor,
                onTap: () {
                  context.pushNamed('sitter-details', queryParameters: {'sitterName': name});
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSitterItem(
    BuildContext context, {
    required String name,
    required String distance,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.person, color: Theme.of(context).scaffoldBackgroundColor),
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            distance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
          ),
          SizedBox(width: 5.w),
          Icon(Icons.location_on, color: iconColor),
        ],
      ),
      onTap: onTap,
    );
  }
}
