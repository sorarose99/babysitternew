

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NurseryItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final String distance;
  final String status;
  final GeoPoint? location;
  final List<String> workingDays;
  final String startTime;
  final String endTime;
  final String moreInfo;

  const NurseryItemWidget({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.distance,
    required this.status,
    required this.location,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    required this.moreInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 100.w,
                  height: 100.h,
                  color: Colors.grey[300],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/nursery3.jpg',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                    SizedBox(width: 2.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        '• $distance',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14.sp,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).iconTheme.color,
              size: 24.sp,
            ),
            onPressed: () {
              context.pushNamed(
                'nursery-details',
                extra: {
                  'nurseryName': name,
                  'nurseryLocation': location != null
                      ? LatLng(location!.latitude, location!.longitude)
                      : null,
                  'workingDays': workingDays,
                  'startTime': startTime,
                  'endTime': endTime,
                  'moreInfo': moreInfo,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
