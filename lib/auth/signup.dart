import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  final String role;

  SignUpScreen({required this.role});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController childrenNumberController =
      TextEditingController();
  final TextEditingController statusController = TextEditingController();
  String availability = 'Available';
  LatLng? selectedLocation;
  File? selectedImage;
  String? selectedImageUrl;
  List<String> selectedDays = [];
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isUploading = false;
  bool agreeToTerms = false;
  void showAuthError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 16.sp),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        setState(() {
          selectedImageUrl = pickedFile.path;
        });
      } else {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> pickTime({required bool isStartTime}) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      setState(() {
        isUploading = true;
      });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      await storageReference.putFile(image);
      String downloadUrl = await storageReference.getDownloadURL();

      setState(() {
        isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      print('Image upload error: $e');
      showAuthError('Failed to upload image. Please try again.');
      setState(() {
        isUploading = false;
      });
      return null;
    }
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildGoogleMap() {
    return Container(
      height: 300.h,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default location
          zoom: 10,
        ),
        onTap: (LatLng latLng) {
          setState(() {
            selectedLocation = latLng;
          });
        },
        markers: selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }

  Widget buildSignUpButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // Validate passwords
          if (!agreeToTerms) {
            showAuthError('Please agree to the terms and conditions.');
            return;
          }
          if (passwordController.text != confirmPasswordController.text) {
            showAuthError('Passwords do not match.');
            return;
          }

          // Validate location and image
          if (selectedLocation == null ||
              (selectedImage == null && selectedImageUrl == null)) {
            showAuthError('Please select a location and upload an image.');
            return;
          }

          // Validate age
          int? age = int.tryParse(ageController.text.trim());
          if (age == null) {
            showAuthError('Please enter a valid age.');
            return;
          }

          // Additional validation for Parent role
          if (widget.role == 'Parent') {
            int? childrenNumber =
                int.tryParse(childrenNumberController.text.trim());
            if (childrenNumber == null) {
              showAuthError('Please enter a valid number of children.');
              return;
            }
          }

          try {
            setState(() {
              isUploading = true;
            });

            // Upload image
            String? imageUrl;
            if (selectedImage != null) {
              imageUrl = await uploadImage(selectedImage!);
            } else {
              imageUrl = selectedImageUrl;
            }
            if (imageUrl == null) {
              showAuthError('Image upload failed.');
              setState(() {
                isUploading = false;
              });
              return;
            }

            // Create user
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
            User? user = userCredential.user;

            if (user == null) {
              showAuthError('User authentication failed.');
              setState(() {
                isUploading = false;
              });
              return;
            }

            print('User authenticated with UID: ${user.uid}');

            GeoPoint location = GeoPoint(
                selectedLocation!.latitude, selectedLocation!.longitude);

            // Prepare data to be written to Firestore
            Map<String, dynamic> userData = {
              'Name': nameController.text.trim(),
              'Age': age,
              'Location': location,
              'Email': emailController.text.trim(),
              'ImageUrl': imageUrl,
            };

            // Role-specific data
            if (widget.role == 'Parent') {
              int childrenNumber =
                  int.parse(childrenNumberController.text.trim());
              userData.addAll({
                'ChildrenNumber': childrenNumber,
                'Children': [],
              });

              await FirebaseFirestore.instance
                  .collection('Parent')
                  .doc(user.uid)
                  .set(userData);
              print('Parent data written to Firestore.');
            } else if (widget.role == 'Sitter') {
              userData.addAll({
                'Experience': experienceController.text.trim(),
                'Availability': availability,
              });

              await FirebaseFirestore.instance
                  .collection('BabySitter')
                  .doc(user.uid)
                  .set(userData);
              print('BabySitter data written to Firestore.');
            } else if (widget.role == 'Nursery') {
              userData.addAll({
                'Days': selectedDays,
                'StartTime': startTime?.format(context) ?? '',
                'EndTime': endTime?.format(context) ?? '',
              });

              await FirebaseFirestore.instance
                  .collection('Nurseries')
                  .doc(user.uid)
                  .set(userData);
              print('Nursery data written to Firestore.');
            }

            setState(() {
              isUploading = false;
            });

            context.goNamed('home');
          } catch (e) {
            print('An error occurred: $e');
            String errorMessage =
                'An unexpected error occurred. Please try again.';
            if (e is FirebaseAuthException) {
              switch (e.code) {
                case 'email-already-in-use':
                  errorMessage = 'The email address is already in use.';
                  break;
                case 'invalid-email':
                  errorMessage = 'The email address is invalid.';
                  break;
                case 'weak-password':
                  errorMessage = 'The password is too weak.';
                  break;
                default:
                  errorMessage = e.message ?? errorMessage;
              }
            } else if (e is FirebaseException) {
              errorMessage = e.message ?? errorMessage;
            }
            showAuthError(errorMessage);
            setState(() {
              isUploading = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: Size(300.w, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: isUploading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil initialization (if not already initialized elsewhere)
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '${widget.role} Sign Up',
          style: TextStyle(
              fontSize: 24.sp,
              color: Theme.of(context).appBarTheme.titleTextStyle?.color),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                TextButton(
                  
                  onPressed: () => context.go('/login?role=${widget.role}'),
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(fontSize: 14.sp, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 20.h),
                buildTextFormField(
                    controller: nameController, labelText: 'Full Name'),
                buildTextFormField(
                  controller: ageController,
                  labelText: 'Age',
                  keyboardType: TextInputType.number,
                ),
                if (widget.role == 'Parent')
                  buildTextFormField(
                    controller: childrenNumberController,
                    labelText: 'Number of Children',
                    keyboardType: TextInputType.number,
                  ),
                buildGoogleMap(),
                SizedBox(height: 10.h),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: Icon(Icons.image),
                  label: Text('Upload Image'),
                ),
                if (selectedImage != null && !kIsWeb)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Image.file(selectedImage!,
                        width: 100.w, height: 100.h, fit: BoxFit.cover),
                  ),
                if (selectedImageUrl != null && kIsWeb)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Image.network(selectedImageUrl!,
                        width: 100.w, height: 100.h, fit: BoxFit.cover),
                  ),
                if (widget.role == 'Sitter')
                  Column(
                    children: [
                      buildTextFormField(
                          controller: experienceController,
                          labelText: 'Experience'),
                      DropdownButtonFormField<String>(
                        value: availability,
                        decoration: InputDecoration(
                          labelText: 'Availability',
                          labelStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                          border: OutlineInputBorder(),
                        ),
                        items: <String>[
                          'Available',
                          'Not Available',
                          'Busy',
                          'Part-time'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            availability = newValue ?? 'Available';
                          });
                        },
                      ),
                    ],
                  ),
                if (widget.role == 'Nursery')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        'Select Working Days:',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday'
                        ].map((day) {
                          return ChoiceChip(
                            label: Text(day),
                            selected: selectedDays.contains(day),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedDays.add(day);
                                } else {
                                  selectedDays.remove(day);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => pickTime(isStartTime: true),
                              child: Text(startTime == null
                                  ? 'Select Start Time'
                                  : 'Start: ${startTime!.format(context)}'),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => pickTime(isStartTime: false),
                              child: Text(endTime == null
                                  ? 'Select End Time'
                                  : 'End: ${endTime!.format(context)}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                buildTextFormField(
                    controller: emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress),
                buildTextFormField(
                    controller: passwordController,
                    labelText: 'Password',
                    obscureText: true),
                buildTextFormField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    obscureText: true),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the terms and conditions.',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
