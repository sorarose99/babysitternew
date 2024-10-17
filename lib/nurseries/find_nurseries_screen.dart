import 'package:babysit/nurseries/nursery_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

// Import the new widget

class FindNurseriesScreen extends StatefulWidget {
  @override
  _FindNurseriesScreenState createState() => _FindNurseriesScreenState();
}

class _FindNurseriesScreenState extends State<FindNurseriesScreen> {
  Position? _currentUserPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentUserPosition = position;
    });
  }

  String _calculateStatus(
      List<String> workingDays, String startTime, String endTime) {
    DateTime now = DateTime.now();
    String currentDay = DateFormat('EEEE').format(now);

    if (workingDays.contains(currentDay)) {
      try {
        // Clean the time strings
        startTime = startTime
            .trim()
            .replaceAll('\u00A0', ' ')
            .replaceAll(RegExp(r'[^\x20-\x7E]'), '');
        endTime = endTime
            .trim()
            .replaceAll('\u00A0', ' ')
            .replaceAll(RegExp(r'[^\x20-\x7E]'), '');

        // Parse the times
        DateTime start = DateFormat.jm().parse(startTime);
        DateTime end = DateFormat.jm().parse(endTime);

        TimeOfDay currentTime = TimeOfDay.fromDateTime(now);
        DateTime current = DateFormat.jm().parse(currentTime.format(context));

        if (current.isAfter(start) && current.isBefore(end)) {
          return 'Open';
        } else {
          return 'Closed';
        }
      } catch (e) {
        print(
            'Time Parsing Error: $e, startTime: "$startTime", endTime: "$endTime"');
        return 'Closed';
      }
    } else {
      return 'Closed';
    }
  }

  double _calculateDistance(GeoPoint? nurseryLocation) {
    if (_currentUserPosition == null || nurseryLocation == null) {
      return -1.0;
    }

    double distanceInMeters = Geolocator.distanceBetween(
      _currentUserPosition!.latitude,
      _currentUserPosition!.longitude,
      nurseryLocation.latitude,
      nurseryLocation.longitude,
    );

    double distanceInKm = distanceInMeters / 1000;
    return distanceInKm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find a Nursery',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Nurseries').snapshots(),
          builder: (context, snapshot) {
            // Handle snapshot data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No nurseries found'));
            }

            var nurseries = snapshot.data!.docs;

            return ListView.builder(
              itemCount: nurseries.length,
              itemBuilder: (context, index) {
                var nurseryData =
                    nurseries[index].data() as Map<String, dynamic>;

                // Extract data
                GeoPoint? location = nurseryData['Location'];
                List<String> workingDays =
                    List<String>.from(nurseryData['Days'] ?? []);
                String startTime = nurseryData['StartTime'] ?? '';
                String endTime = nurseryData['EndTime'] ?? '';
                String name = nurseryData['Name'] ?? 'Unknown Nursery';
                String imageUrl = nurseryData['ImageUrl'] ?? '';
                String moreInfo =
                    nurseryData['MoreInfo'] ?? 'No additional information.';
                double rating = nurseryData['Rating'] != null
                    ? (nurseryData['Rating'] as num).toDouble()
                    : 0.0;

                // Ensure imageUrl is a valid URL
                if (!Uri.tryParse(imageUrl)!.hasAbsolutePath ?? true) {
                  imageUrl = ''; // Set to empty if invalid
                }

                // Calculate status and distance
                String status =
                    _calculateStatus(workingDays, startTime, endTime);
                double distance =
                    location != null ? _calculateDistance(location) : -1.0;
                String distanceText = distance >= 0
                    ? '${distance.toStringAsFixed(1)} km away'
                    : 'Unknown Distance';

                return NurseryItemWidget(
                  imageUrl: imageUrl,
                  name: name,
                  rating: rating,
                  distance: distanceText,
                  status: status,
                  location: location,
                  workingDays: workingDays,
                  startTime: startTime,
                  endTime: endTime,
                  moreInfo: moreInfo,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
