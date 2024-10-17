import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {},
          ),
        ],
        title: Container(
          height: 40.h,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              hintText: 'Search',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 40.r,
                      backgroundImage:
                          AssetImage('assets/image${index + 1}.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100.h),
            SizedBox(
              width: 200.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  context.goNamed('find-sitter');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text('Find a Sitter', style: TextStyle(fontSize: 18.sp)),
              ),
            ),
            SizedBox(height: 50.h),
            SizedBox(
              width: 200.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  context.goNamed('find-nurseries');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child:
                    Text('Find a Nurseries', style: TextStyle(fontSize: 18.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
