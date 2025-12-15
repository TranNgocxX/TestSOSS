// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../data/models/booking_model.dart';
// import '../widgets/booking_card.dart';
// import 'package:ngoctran/core/presentation/widget/app_drawer.dart';

// class MyBookingsPage extends StatelessWidget {
//   const MyBookingsPage({super.key});

//   Stream<List<BookingModel>> _bookingsStream() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return const Stream.empty();

//     return FirebaseFirestore.instance
//         .collection('bookings')
//         .where('userId', isEqualTo: user.uid)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
//               .toList(),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Phòng đã đặt'),
//         //backgroundColor: const Color.fromARGB(255, 173, 107, 184),
//         backgroundColor: const Color(0xFFBDCFFF),
//         centerTitle: true,
//       ),
//       drawer: AppDrawer(user: user),
//       body: StreamBuilder<List<BookingModel>>(
//         stream: _bookingsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final bookings = snapshot.data ?? [];
//           if (bookings.isEmpty) {
//             return const Center(
//               child: Text(
//                 '📭 Bạn chưa đặt phòng nào!',
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               return BookingCard(booking: bookings[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
