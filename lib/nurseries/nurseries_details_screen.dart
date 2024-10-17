import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../reusable_widgets/custom_widgets.dart';

class NurseryDetailsScreen extends StatefulWidget {
  final String nurseryName;
  final LatLng nurseryLocation;
  final List<String> workingDays;
  final String startTime;
  final String endTime;
  final String moreInfo;

  NurseryDetailsScreen({
    required this.nurseryName,
    required this.nurseryLocation,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    required this.moreInfo,
  });

  @override
  _NurseryDetailsScreenState createState() => _NurseryDetailsScreenState();
}

class _NurseryDetailsScreenState extends State<NurseryDetailsScreen> {
  Position? _userPosition;
  double? _distanceInMeters;
  bool _isWorkingHoursExpanded = false;
  bool _isMoreInfoExpanded = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle permission denied
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userPosition = position;
      });

      // Calculate distance
      _calculateDistance();
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  void _calculateDistance() {
    if (_userPosition == null) return;

    double distance = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      widget.nurseryLocation.latitude,
      widget.nurseryLocation.longitude,
    );

    setState(() {
      _distanceInMeters = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    String distanceText = _distanceInMeters != null
        ? (_distanceInMeters! / 1000).toStringAsFixed(2) + ' km away'
        : 'Calculating distance...';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Nursery Details',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SingleChildScrollView(
          // Add scrolling if content overflows
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.home, color: Colors.white, size: 30.r),
                ),
                title: Text(
                  widget.nurseryName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20.sp),
                        Icon(Icons.star, color: Colors.amber, size: 20.sp),
                        Icon(Icons.star, color: Colors.amber, size: 20.sp),
                        Icon(Icons.star_half, color: Colors.amber, size: 20.sp),
                        Icon(Icons.star_border, size: 20.sp),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      distanceText,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomWidgets.buildSectionHeader(
                context,
                'Location',
                isExpanded: false,
                onTap: () {},
              ),
              SizedBox(height: 10.h),
              Container(
                height: 200.h,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.nurseryLocation,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('nursery_location'),
                      position: widget.nurseryLocation,
                    ),
                  },
                ),
              ),
              SizedBox(height: 20.h),
              CustomWidgets.buildExpandableSection(
                context,
                title: 'Working Hours',
                isExpanded: _isWorkingHoursExpanded,
                onTap: () {
                  setState(() {
                    _isWorkingHoursExpanded = !_isWorkingHoursExpanded;
                  });
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Days: ${widget.workingDays.join(', ')}',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Time: ${widget.startTime} - ${widget.endTime}',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomWidgets.buildExpandableSection(
                context,
                title: 'More Information',
                isExpanded: _isMoreInfoExpanded,
                onTap: () {
                  setState(() {
                    _isMoreInfoExpanded = !_isMoreInfoExpanded;
                  });
                },
                content: Text(
                  widget.moreInfo,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
             
              
              
             child:  ElevatedButton(
  onPressed: () {
    context.pushNamed(
      'booking',
      extra: {
        'serviceType': 'Nursery',
        'dateTime': '${widget.startTime} - ${widget.endTime}',
        'location': widget.nurseryName,
        'hasBooking': true,
      },
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,
    minimumSize: Size(150.w, 50.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.r),
    ),
  ),
  child: Text('Enroll Now', style: TextStyle(fontSize: 18.sp)),
),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
