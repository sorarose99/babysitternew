
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PaymentScreen extends StatefulWidget {
//   final String sessionId;
//   final double totalAmount;

//   PaymentScreen({required this.sessionId, required this.totalAmount});

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   String _selectedPaymentMethod = 'Credit card';
//   bool _isProcessing = false;

//   Future<String> _createBill() async {
//     // Create a bill document and get its generated ID
//     DocumentReference billRef = await FirebaseFirestore.instance.collection('Bill').add({
//       'session_id': widget.sessionId,
//       'amount': widget.totalAmount,
//       'payment_method': _selectedPaymentMethod,
//       'timestamp': Timestamp.now(),
//     });

//     return billRef.id;
//   }

//   Future<void> _processPayment() async {
//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       final billId = await _createBill(); // Create the bill and get bill_id

//       // Show success dialog with bill details
//       _showPaymentSuccessDialog(billId);
//     } catch (e) {
//       print('Error during payment: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment failed. Please try again.')),
//       );
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   void _showPaymentSuccessDialog(String billId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Text('The payment was successful! Bill ID: $billId'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//                 Navigator.of(context).pop(); // Go back to previous screen
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         title: Text('Payment process', style: Theme.of(context).appBarTheme.titleTextStyle),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPaymentMethods(),
//             SizedBox(height: 20.h),
//             _buildSummary(),
//             SizedBox(height: 20.h),
//             _isProcessing
//                 ? Center(child: CircularProgressIndicator())
//                 : ElevatedButton(
//                     onPressed: _processPayment,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       minimumSize: Size(double.infinity, 50.h),
//                     ),
//                     child: Text('Confirm payment', style: TextStyle(fontSize: 18.sp)),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentMethods() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           leading: Icon(Icons.credit_card),
//           title: Text('Credit card'),
//           trailing: Radio<String>(
//             value: 'Credit card',
//             groupValue: _selectedPaymentMethod,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPaymentMethod = value!;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           leading: Icon(Icons.money),
//           title: Text('Cash'),
//           trailing: Radio<String>(
//             value: 'Cash',
//             groupValue: _selectedPaymentMethod,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPaymentMethod = value!;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSummary() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Summary', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//         ListTile(title: Text('Items Price'), trailing: Text('150.75 SAR')),
//         ListTile(title: Text('Driver fees'), trailing: Text('15 SAR')),
//         ListTile(
//           title: Text('Total includes tax'),
//           trailing: Text('${widget.totalAmount.toStringAsFixed(2)} SAR'),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends StatefulWidget {
  final String sessionId;
  final double totalAmount;

  PaymentScreen({required this.sessionId, required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Credit card'; 
  bool _isProcessing = false;

  Future<String> _createBill() async {
    DocumentReference billRef = await FirebaseFirestore.instance.collection('Bill').add({
      'session_id': widget.sessionId,
      'amount': widget.totalAmount,
      'payment_method': _selectedPaymentMethod,
      'timestamp': Timestamp.now(),
    });

    return billRef.id;
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final billId = await _createBill();
      _showPaymentSuccessDialog(billId);
    } catch (e) {
      print('Error during payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Please try again.')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showPaymentSuccessDialog(String billId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('The payment was successful! Bill ID: $billId'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                context.goNamed('booking', extra: {'hasBooking': false});
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Payment process',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentMethods(),
            SizedBox(height: 20.h),
            _buildSummary(),
            SizedBox(height: 20.h),
            _isProcessing
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: Text(
                      'Confirm payment',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.credit_card),
          title: Text('Credit card'),
          trailing: Radio<String>(
            value: 'Credit card',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.money),
          title: Text('Cash'),
          trailing: Radio<String>(
            value: 'Cash',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ListTile(title: Text('Items Price'), trailing: Text('150.75 SAR')),
        ListTile(title: Text('Driver fees'), trailing: Text('15 SAR')),
        ListTile(
          title: Text('Total includes tax'),
          trailing: Text('${widget.totalAmount.toStringAsFixed(2)} SAR'),
        ),
      ],
    );
  }
}
