import 'package:babysit/reusable_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SitterDetailsScreen extends StatefulWidget {
  final String sitterName;
  final LatLng sitterLocation;
  final List<String> skills;
  final String moreInfo;

  SitterDetailsScreen({
    required this.sitterName,
    required this.sitterLocation,
    required this.skills,
    required this.moreInfo,
  });

  @override
  _SitterDetailsScreenState createState() => _SitterDetailsScreenState();
}

class _SitterDetailsScreenState extends State<SitterDetailsScreen> {
  Position? _userPosition;
  double? _distanceInMeters;
  bool _isSkillsExpanded = false;
  bool _isMoreInfoExpanded = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle case when user permanently denies location access
        _showPermissionDeniedDialog();
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userPosition = position;
      });
      _calculateDistance();
    } catch (e) {
      print('Error: $e');
      // Optionally show an alert to inform the user of the error
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location Permission Denied'),
          content: Text('Please enable location permission in settings.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _calculateDistance() {
    if (_userPosition == null) return;

    double distance = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      widget.sitterLocation.latitude,
      widget.sitterLocation.longitude,
    );

    setState(() {
      _distanceInMeters = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    String distanceText = _distanceInMeters != null
        ? '${(_distanceInMeters! / 1000).toStringAsFixed(2)} km away'
        : 'Calculating distance...';

    if (_userPosition == null) {
      return Center(child: CircularProgressIndicator());
    }

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
          'Sitter Details',
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
                  child: Icon(Icons.person, color: Colors.white, size: 30.r),
                ),
                title: Text(
                  widget.sitterName,
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
                        Icon(Icons.star, color: Colors.amber, size: 20.sp),
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
                    target: widget.sitterLocation,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('sitter_location'),
                      position: widget.sitterLocation,
                    ),
                  },
                ),
              ),
              SizedBox(height: 20.h),
              CustomWidgets.buildExpandableSection(
                context,
                title: 'Skills',
                isExpanded: _isSkillsExpanded,
                onTap: () {
                  setState(() {
                    _isSkillsExpanded = !_isSkillsExpanded;
                  });
                },
                content: widget.skills.isNotEmpty
                    ? Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: widget.skills.map((skill) {
                          return Chip(
                            label: Text(skill),
                          );
                        }).toList(),
                      )
                    : Text('No skills available.'),
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
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(
                      'booking',
                      extra: {
                        'serviceType': 'Sitter',
                        'dateTime': '31 May 2024, 11:30 AM',
                        'location': widget.sitterName,
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
                  child: Text('Book Now', style: TextStyle(fontSize: 18.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
