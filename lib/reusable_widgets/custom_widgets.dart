import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomWidgets {
  static Widget buildExpandableSection(
    BuildContext context, {
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeader(
          context,
          title,
          isExpanded: isExpanded,
          onTap: onTap,
        ),
        if (isExpanded) ...[
          SizedBox(height: 10.h),
          content,
        ],
      ],
    );
  }

  static Widget buildSectionHeader(
    BuildContext context,
    String title, {
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    );
  }
}




