
// import 'package:flutter/foundation.dart' show kIsWeb; // Import to check for web
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // Only needed for non-web platforms
// import 'package:firebase_storage/firebase_storage.dart';

// class ChildrenScreen extends StatefulWidget {
//   @override
//   _ChildrenScreenState createState() => _ChildrenScreenState();
// }

// class _ChildrenScreenState extends State<ChildrenScreen> {
//   String? parentId;
//   dynamic _imageFile; // Can be File or XFile depending on platform (mobile/web)
//   final picker = ImagePicker();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController specialConditionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchParentId();
//   }

//   Future<void> _fetchParentId() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // Fetch Parent ID from the parent collection
//       DocumentSnapshot parentDoc = await FirebaseFirestore.instance
//           .collection('Parent')
//           .doc(user.uid)
//           .get();

//       setState(() {
//         parentId = parentDoc.id; // Store the Parent ID
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _imageFile = pickedFile;
//       }
//     });
//   }

//   Future<String> _uploadImageToFirebase(String childId) async {
//     if (_imageFile == null) return '';

//     final String fileName = 'child_images/$childId.jpg';

//     // Upload image to Firebase Storage
//     final storageRef = FirebaseStorage.instance.ref().child(fileName);

//     if (kIsWeb) {
//       // For web platforms, use XFile
//       await storageRef.putData(await _imageFile.readAsBytes());
//     } else {
//       // For mobile platforms, use File
//       await storageRef.putFile(File(_imageFile.path));
//     }

//     return await storageRef.getDownloadURL();
//   }

//   Future<void> _addChild() async {
//     if (parentId == null) return;

//     final String name = nameController.text.trim();
//     final int age = int.parse(ageController.text.trim());
//     final String specialCondition = specialConditionController.text.trim();

//     // Add child to Firebase Firestore
//     DocumentReference childRef = await FirebaseFirestore.instance
//         .collection('Child')
//         .add({
//       'Parent_ID': FirebaseFirestore.instance.collection('Parent').doc(parentId), // Reference to parent
//       'Name': name,
//       'Age': age,
//       'SpecialCondition': specialCondition,
//     });

//     // Upload child image and get URL
//     String imageUrl = await _uploadImageToFirebase(childRef.id);

//     // Update the child document with the image URL
//     await childRef.update({'PhotoUrl': imageUrl});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Children',
//           style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: _buildChildrenList(), // Fetch children from Firebase and display
//             ),
//             _buildAddChildForm(context), // Form to add new child
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChildrenList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('Child')
//           .where('Parent_ID', isEqualTo: FirebaseFirestore.instance.collection('Parent').doc(parentId))
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         List<DocumentSnapshot> children = snapshot.data!.docs;

//         if (children.isEmpty) {
//           return Center(child: Text('No children added yet.'));
//         }

//         return ListView.builder(
//           itemCount: children.length,
//           itemBuilder: (context, index) {
//             var childData = children[index].data() as Map<String, dynamic>;
//             return _buildChildItem(
//               context,
//               imageUrl: childData['PhotoUrl'] ?? 'assets/placeholder.png',
//               name: childData['Name'],
//               color: Colors.blueGrey[300],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildChildItem(BuildContext context,
//       {required String imageUrl, required String name, required Color? color}) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 30.r,
//           backgroundImage: imageUrl.isNotEmpty
//               ? NetworkImage(imageUrl)
//               : AssetImage('assets/placeholder.png') as ImageProvider,
//         ),
//         SizedBox(width: 10.w),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Text(
//             name,
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   color: Colors.white,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAddChildForm(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: nameController,
//           decoration: InputDecoration(
//             labelText: 'Child Name',
//             labelStyle: TextStyle(fontSize: 16.sp),
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 10.h),
//         TextFormField(
//           controller: ageController,
//           decoration: InputDecoration(
//             labelText: 'Age',
//             labelStyle: TextStyle(fontSize: 16.sp),
//             border: OutlineInputBorder(),
//           ),
//           keyboardType: TextInputType.number,
//         ),
//         SizedBox(height: 10.h),
//         TextFormField(
//           controller: specialConditionController,
//           decoration: InputDecoration(
//             labelText: 'Special Condition',
//             labelStyle: TextStyle(fontSize: 16.sp),
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 10.h),
//         _imageFile == null
//             ? TextButton.icon(
//                 icon: Icon(Icons.add_a_photo),
//                 label: Text('Upload Photo'),
//                 onPressed: _pickImage,
//               )
//             : (kIsWeb
//                 ? Image.network(_imageFile.path, height: 100.h) // Web-specific image display
//                 : Image.file(File(_imageFile.path), height: 100.h)), // Non-web display
//         SizedBox(height: 20.h),
//         Center(
//           child: ElevatedButton(
//             onPressed: _addChild,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               minimumSize: Size(300.w, 50.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//             ),
//             child: Text(
//               'Add Child',
//               style: TextStyle(fontSize: 18.sp, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ChildrenScreen extends StatefulWidget {
  final String role; // Role: Parent, Babysitter, Nursery

  ChildrenScreen({required this.role});

  @override
  _ChildrenScreenState createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  String? parentId;
  dynamic _imageFile;
  final picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController specialConditionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.role == 'Parent') {
      _fetchParentId();
    }
  }

  Future<void> _fetchParentId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot parentDoc = await FirebaseFirestore.instance
          .collection('Parent')
          .doc(user.uid)
          .get();

      setState(() {
        parentId = parentDoc.id;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
      }
    });
  }

  Future<String> _uploadImageToFirebase(String childId) async {
    if (_imageFile == null) return '';
    final String fileName = 'child_images/$childId.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    if (kIsWeb) {
      await storageRef.putData(await _imageFile.readAsBytes());
    } else {
      await storageRef.putFile(File(_imageFile.path));
    }

    return await storageRef.getDownloadURL();
  }

  Future<void> _addChild() async {
    if (parentId == null) return;

    final String name = nameController.text.trim();
    final int age = int.parse(ageController.text.trim());
    final String specialCondition = specialConditionController.text.trim();

    DocumentReference childRef = await FirebaseFirestore.instance
        .collection('Child')
        .add({
      'Parent_ID': FirebaseFirestore.instance.collection('Parent').doc(parentId),
      'Name': name,
      'Age': age,
      'SpecialCondition': specialCondition,
    });

    String imageUrl = await _uploadImageToFirebase(childRef.id);
    await childRef.update({'PhotoUrl': imageUrl});
  }

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
          'Children',
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildChildrenList(), // List of children
            ),
            if (widget.role == 'Parent') _buildAddChildForm(context), // Only parents can add children
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenList() {
    Stream<QuerySnapshot> childrenStream;

    if (widget.role == 'Parent') {
      childrenStream = FirebaseFirestore.instance
          .collection('Child')
          .where('Parent_ID', isEqualTo: FirebaseFirestore.instance.collection('Parent').doc(parentId))
          .snapshots();
    } else {
      childrenStream = FirebaseFirestore.instance.collection('Child').snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: childrenStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> children = snapshot.data!.docs;

        if (children.isEmpty) {
          return Center(child: Text('No children available.'));
        }

        return ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            var childData = children[index].data() as Map<String, dynamic>;
            return _buildChildItem(
              context,
              imageUrl: childData['PhotoUrl'] ?? 'assets/placeholder.png',
              name: childData['Name'],
              color: widget.role == 'Parent' ? Colors.blue[300] : Colors.grey[300],
            );
          },
        );
      },
    );
  }

  Widget _buildChildItem(BuildContext context,
      {required String imageUrl, required String name, required Color? color}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : AssetImage('assets/placeholder.png') as ImageProvider,
        ),
        SizedBox(width: 10.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddChildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Child Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10.h),
        TextFormField(
          controller: ageController,
          decoration: InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10.h),
        TextFormField(
          controller: specialConditionController,
          decoration: InputDecoration(
            labelText: 'Special Condition',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10.h),
        _imageFile == null
            ? TextButton.icon(
                icon: Icon(Icons.add_a_photo),
                label: Text('Upload Photo'),
                onPressed: _pickImage,
              )
            : (kIsWeb
                ? Image.network(_imageFile.path, height: 100.h)
                : Image.file(File(_imageFile.path), height: 100.h)),
        SizedBox(height: 20.h),
        Center(
          child: ElevatedButton(
            onPressed: _addChild,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: Size(300.w, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Text(
              'Add Child',
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
