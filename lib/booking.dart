// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class MyBookingsPage extends StatelessWidget {
//   final String studentId;

//   const MyBookingsPage({super.key, required this.studentId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Bookings")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('bookings')
//             .where('userId', isEqualTo: studentId)
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final bookings = snapshot.data!.docs;

//           if (bookings.isEmpty) {
//             return Center(child: Text("No bookings yet 😥"));
//           }

//           return ListView.builder(
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final booking = bookings[index];
//               final courseId = booking['courseId'].toString().trim();
//               print("Loading courseId: '${booking['courseId']}'");
//               final time = booking['time'];

//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('course')
//                     .doc('ENT101')
//                     .get() .catchError((e) {
//       print("Error fetching course: $e");
//       throw e;
//     }),
//                 builder: (context, courseSnap) {
//                   if (courseSnap.connectionState == ConnectionState.waiting) {
//                     return ListTile(title: Text("Loading course info..."));
//                   }

//                   if (!courseSnap.hasData || !courseSnap.data!.exists) {
//                     return ListTile(
//                       title: Text("Course not found for ID: $courseId"),
//                       subtitle: Text("Please check Firestore document ID"),
//                       leading: Icon(Icons.warning, color: Colors.red),
//                     );
//                   }

//                   final courseData = courseSnap.data!;
//                   return Card(
//                     margin: EdgeInsets.all(10),
//                     child: ListTile(
//                       title:
//                           Text("${courseData['name']} (${courseData['code']})"),
//                       //subtitle: Text("Slot: ${booking['time']}"),
//                       trailing: Icon(Icons.check_circle, color: Colors.green),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class MyBookingsPage extends StatelessWidget {
//   final String studentId;

//   const MyBookingsPage({super.key, required this.studentId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Bookings")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('bookings')
//             .where('userId', isEqualTo: studentId)
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final bookings = snapshot.data!.docs;

//           if (bookings.isEmpty) {
//             return Center(child: Text("No bookings yet 😥"));
//           }

//           return ListView.builder(
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               final booking = bookings[index];
//               final courseId = booking['courseId'].toString().trim();
//               final slotTime = booking['time'].toDate(); // Timestamp from Firebase
//               final bookingId = booking.id;

//               final now = DateTime.now();
//               final timeLeft = slotTime.difference(now);

//               // ⛔ Skip showing expired bookings
//               if (slotTime.isBefore(now)) {
//                 return Text("data");
//               }

//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('course')
//                     .doc(courseId)
//                     .get(),
//                 builder: (context, courseSnap) {
//                   if (courseSnap.connectionState == ConnectionState.waiting) {
//                     return ListTile(title: Text("Loading course info..."));
//                   }

//                   if (!courseSnap.hasData || !courseSnap.data!.exists) {
//                     return ListTile(
//                       title: Text("Course not found for ID: $courseId"),
//                       subtitle: Text("Please check Firestore document ID"),
//                       leading: Icon(Icons.warning, color: Colors.red),
//                     );
//                   }

//                   final courseData = courseSnap.data!;

//                   return Card(
//                     margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       title: Text(
//                         "${courseData['name']} (${courseData['code']})",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text("Slot: ${slotTime.toLocal()}"),
//                       trailing: timeLeft.inMinutes > 30
//                           ? IconButton(
//                               icon: Icon(Icons.cancel, color: Colors.red),
//                               tooltip: "Cancel Booking",
//                               onPressed: () => _cancelBooking(
//                                 context,
//                                 bookingId,
//                                 courseId,
//                                 booking['slotId'], // assuming slotId is stored in booking
//                               ),
//                             )
//                           : Icon(Icons.lock_clock, color: Colors.grey),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _cancelBooking(BuildContext context, String bookingId, String courseId, String slotId) async {
//     final bookingRef = FirebaseFirestore.instance.collection('bookings').doc(bookingId);
//     final slotRef = FirebaseFirestore.instance
//         .collection('course')
//         .doc(courseId)
//         .collection('slots')
//         .doc(slotId);

//     try {
//       // Delete the booking
//       await bookingRef.delete();

//       // Increase the available slot
//       await slotRef.update({
//         'available': FieldValue.increment(1),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Booking cancelled successfully")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to cancel booking: $e")),
//       );
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyBookingsPage extends StatelessWidget {
  final String studentId;

  const MyBookingsPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Bookings")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: studentId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return Center(child: Text("No bookings yet 😥"));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final courseId = booking['courseId'].toString().trim();
              final slotTime = booking['time'].toDate(); // actual slot time
              final bookingId = booking.id;

              final now = DateTime.now();
              final timeLeft = slotTime.difference(now);

              print("⏰ slotTime: $slotTime");
              print("🕓 now: $now");
              print("⏱️ Difference: ${slotTime.difference(now)}");

              // Hide past bookings
              if (slotTime.isBefore(now)) return SizedBox.shrink();

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('course')
                    .doc(courseId)
                    .get(),
                builder: (context, courseSnap) {
                  if (courseSnap.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text("Loading course info..."));
                  }

                  if (!courseSnap.hasData || !courseSnap.data!.exists) {
                    return ListTile(
                      title: Text("Course not found for ID: $courseId"),
                      subtitle: Text("Please check Firestore document ID"),
                      leading: Icon(Icons.warning, color: Colors.red),
                    );
                  }

                  final courseData = courseSnap.data!;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        "${courseData['name']} (${courseData['code']})",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Slot: ${slotTime.toLocal()}"),
                      trailing: timeLeft.inMinutes > 30
                          ? IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              tooltip: "Cancel Booking",
                              onPressed: () => _cancelBooking(
                                context,
                                bookingId,
                                courseId,
                                booking['slotId'],
                              ),
                            )
                          : Icon(Icons.lock_clock, color: Colors.grey),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _cancelBooking(BuildContext context, String bookingId, String courseId,
      String slotId) async {
    final bookingRef =
        FirebaseFirestore.instance.collection('bookings').doc(bookingId);

    // Adjusted this: If your slots are stored directly under `slot` collection
    final slotRef = FirebaseFirestore.instance.collection('slot').doc(slotId);

    try {
      await bookingRef.delete();
      await slotRef.update({'bookedCount': FieldValue.increment(-1)});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking cancelled successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel booking: $e")),
      );
    }
  }
}
