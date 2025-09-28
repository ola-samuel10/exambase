import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exambase/admin.dart';
import 'package:exambase/adminpage.dart';
import 'package:exambase/booking.dart';
import 'package:exambase/edit.dart';
import 'package:exambase/newpage.dart';
import 'package:exambase/submit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dropdownList = [
    'Mathemaitcs ',
    'Physics 101',
    ' chemistry 401',
    'Four',
    'Agric',
    'Socio-science',
    'Seven',
    'Eight',
    'Nine',
    'Ten'
  ];
  //String? selectedCourseId;
  String dropdownvalue1 = "";
  String dropdownvalue2 = "";
  var timeLIst = [
    '2:00 am ',
    '4:34 pm',
    ' 1:00 pm',
    '7: 30 am : 8 :00am',
    'Agric',
    '9:am',
    'Seven',
    'Eight',
    'Nine',
    'Ten'
  ];
  String? selectedCourseId;
  String? selectedSlotId;
  

  List<DocumentSnapshot> courseDocs = [];
  List<DocumentSnapshot> slotDocs = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  String generateRandomId() {
    final rand = Random();
    return 'STD${rand.nextInt(1000000).toString().padLeft(6, '0')}';
  }

  void fetchCourses() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('course').get();
    setState(() {
      courseDocs = snapshot.docs;
    });
  }

  void fetchSlotsForCourse(String courseId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('slot')
        .where('courseId', isEqualTo: courseId)
        .get();
    setState(() {
      slotDocs = snapshot.docs;
      selectedSlotId = null; // reset previously selected slot
    });
  }

  Future<void> bookSlot() async {
    final slotRef =
        FirebaseFirestore.instance.collection('slot').doc(selectedSlotId);
    final slotSnapshot = await slotRef.get();
    print("object");

    if (!slotSnapshot.exists) return;

    final slotData = slotSnapshot.data()!;
    final maxCapacity = slotData['maxCapacity'];
    final bookedCount = slotData['bookedCount'];
    final courseId = slotData['courseId'];

    // ✅ Parse slot date from string like "13 May 2025"
    //DateTime slotDate = DateFormat("d MMM yyyy").parse(slotData['date']);
    DateTime slotDate = slotData['date'].toDate();
    print(slotDate);
    // ✅ Extract time range and get start time only (e.g. "10:30 AM")
    String selectedRange = slotData['time']; // from dropdown or slot data
    String startTimeStr = selectedRange.split(" - ")[0];

    // ✅ Combine date + time
    String slotDateTimeStr =
        "${DateFormat("d MMM yyyy").format(slotDate)} $startTimeStr";
    DateTime slotDateTime =
        DateFormat("d MMM yyyy hh:mm").parse(slotDateTimeStr);

    // Check if full
    if (bookedCount >= maxCapacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("This slot is full. Please choose another one.")),
      );
      return;
    }

    final userId = "user_123";
    String studentId = generateRandomId();

    // Check if already booked this course
    final existing = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have already booked this course.")),
      );
      return;
    }

    // ✅ Save booking
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': userId,
      'courseId': selectedCourseId,
      'slotId': selectedSlotId,
      'time': Timestamp.fromDate(slotDateTime), // ✅ real slot date + time
      'timestamp': FieldValue.serverTimestamp(), // optional
    });

    // Update booked count
    await slotRef.update({'bookedCount': bookedCount + 1});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Slot booked successfully 🎉")),
    );
  }

  // Future<void> bookSlot() async {
  //   final slotRef =
  //       FirebaseFirestore.instance.collection('slot').doc(selectedSlotId);
  //   final slotSnapshot = await slotRef.get();

  //   if (!slotSnapshot.exists) return;

  //   final slotData = slotSnapshot.data()!;
  //   final maxCapacity = slotData['maxCapacity'];
  //   final bookedCount = slotData['bookedCount'];
  //   final courseId = slotData['courseId'];
  //   String selectedRange = "10:30 AM - 11:00 AM"; // from dropdown or slot data
  //   String startTimeStr = selectedRange.split(" - ")[0];

  //   DateTime finalDate = DateFormat("d MMM yyyy").parse(slotData['date']);
  //   print(finalDate);
  //   String fullDateTimeStrs =
  //       "${DateFormat("d MMM yyyy").format(finalDate)} 10:00 AM";
  //   DateTime fullDateTime =
  //       DateFormat("d MMM yyyy hh:mm a").parse(fullDateTimeStrs);

  //   DateTime now = DateTime.now();
  //   String todayStr = DateFormat('yyyy-MM-dd').format(now); // e.g. 2025-07-13
  //   String fullDateTimeStr = "$todayStr $startTimeStr"; // "2025-07-13 10:30 AM"

  //   DateTime slotTime = DateFormat("yyyy-MM-dd hh:mm a").parse(fullDateTimeStr);
  //   //print("Booking time: $time (${time.runtimeType})");
  //   if (bookedCount >= maxCapacity) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("This slot is full. Please choose another one.")));
  //     return;
  //   }

  //   // TODO: Replace with real user ID from FirebaseAuth
  //   final userId = "user_123";
  //   String studentId = generateRandomId();

  //   // Check if user already booked this course
  //   final existing = await FirebaseFirestore.instance
  //       .collection('bookings')
  //       .where('userId', isEqualTo: userId)
  //       .where('courseId', isEqualTo: courseId)
  //       .get();

  //   if (existing.docs.isNotEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("You have already booked this course.")));
  //     return;
  //   }

  //   // Save booking in 'user' collection
  //   await FirebaseFirestore.instance.collection('bookings').add({
  //     'userId': userId,
  //     'courseId': selectedCourseId,
  //     'slotId': selectedSlotId,
  //     'time': Timestamp.fromDate(slotTime),
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });

  //   // Update slot's bookedCount
  //   await slotRef.update({'bookedCount': bookedCount + 1});

  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text("Slot booked successfully 🎉")));
  // }

  @override
  Widget build(BuildContext context) {
     final DateTime now = DateTime.now();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Course Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Course'),
              value: selectedCourseId,
              items: courseDocs.map((doc) {
                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(doc['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourseId = value;
                  print(selectedCourseId);
                });
                if (value != null) fetchSlotsForCourse(value);
              },
            ),

            SizedBox(height: 20),

            // Slot Time Dropdown
           //final DateTime now = DateTime.now();


DropdownButtonFormField(
  value: selectedSlotId,
  items: slotDocs.where((slot) {
    final slotData = slot.data() as Map<String, dynamic>;

    final dynamic dateRaw = slotData['date']; // Must be a Timestamp
    final int maxCapacity = slotData['maxCapacity'] ?? 0;
    final int bookedCount = slotData['bookedCount'] ?? 0;

    // ❌ If date is missing or not Timestamp, skip this slot
    if (dateRaw == null || dateRaw is! Timestamp) return false;

    final DateTime slotDate = dateRaw.toDate();

    return slotDate.isAfter(now) && bookedCount < maxCapacity;
  }).map((slot) {
    final slotId = slot.id;
    final slotData = slot.data() as Map<String, dynamic>;

    final DateTime slotDate = (slotData['date'] as Timestamp).toDate();
    final String timeRange = slotData['time'] ?? "Time Unknown";

    final String formattedDate =
        DateFormat("d MMM yyyy").format(slotDate); // e.g. 13 Jul 2025

    return DropdownMenuItem(
      value: slotId,
      child: Text("$formattedDate — $timeRange"),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedSlotId = value;
    });
  },
  decoration: InputDecoration(
    labelText: "Choose a time slot",
    border: OutlineInputBorder(),
  ),
),



            // DropdownButtonFormField(
            //   value: selectedSlotId,
            //   items: slotDocs.where((slot) {
               
            //     final slotData = slot.data() as Map<String, dynamic>;
            //     final Timestamp startTime = slotData['startTime'];
            //     final int maxCapacity = slotData['maxCapacity'] ?? 0;
            //     final int bookedCount = slotData['bookedCount'] ?? 0;

            //     // ✅ Show only future slots that are not fully booked
            //     return startTime.toDate().isAfter(now) &&
            //         bookedCount < maxCapacity;
            //   }).map((slot) {
            //     final slotId = slot.id;
            //     final slotData = slot.data() as Map<String, dynamic>;

            //     final Timestamp startTime = slotData['date'];
            //     final String timeRange = slotData['time'];
            //     final String formattedDate =
            //         DateFormat("d MMM yyyy").format(startTime.toDate());

            //     return DropdownMenuItem(
            //       value: slotId,
            //       child: Text("$formattedDate — $timeRange"),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedSlotId = value;
            //     });
            //   },
            //   decoration: InputDecoration(
            //     labelText: "Choose a time slot",
            //     border: OutlineInputBorder(),
            //   ),
            // ),

            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(labelText: 'Select Slot Time'),
            //   value: selectedSlotId,
            //   items: slotDocs.map((doc) {
            //     int remaining = doc['maxCapacity'] - doc['bookedCount'];
            //     return DropdownMenuItem<String>(
            //       value: doc.id,
            //       child:Text("${DateFormat('d MMM yyyy hh:mm a').format(startTime.toDate())}")
            //           //Text("${doc['date']} ${doc['time']} (Left: $remaining)"),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       //print(value);
            //       selectedSlotId = value;
            //     });
            //   },
            // ),

            ElevatedButton(
              onPressed: () async {
                if (selectedCourseId != null && selectedSlotId != null) {
                  await bookSlot();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please select both course and slot")));
                }
              },
              child: Text("Book Now"),
            ),

            ElevatedButton(
              onPressed: () async {
                final userId = "user_123";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyBookingsPage(studentId: userId),
                  ),
                );
              },
              child: Text("Book Now"),
            ),

             ElevatedButton(
              onPressed: () async {
                final userId = "user_123";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSlotPage(),
                  ),
                );
              },
              child: Text("Book Now"),
            ),

            
             ElevatedButton(
              onPressed: () async {
                final userId = "user_123";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSlotListPage(),
                  ),
                );
              },
              child: Text("Admin Now"),
            ),

             ElevatedButton(
              onPressed: () async {
                final userId = "user_123";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditSlotPage( slotId: "ENT101", slotData: {},),
                  ),
                );
              },
              child: Text("EDIT Now"),
            ),
            ElevatedButton(
              onPressed: () async {
                final userId = "user_123";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPage( ),
                  ),
                );
              },
              child: Text("NEw admini"),
            ),
          ],
        ),
      ),
    );
    // Column(
    //   children: [
    //     Expanded(
    //       child: StreamBuilder<QuerySnapshot>(
    //         stream: FirebaseFirestore.instance.collection('course').snapshots(), // ✅ check collection name
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             return Center(child: CircularProgressIndicator());
    //           }

    //           if (snapshot.hasError) {
    //             return Center(child: Text('Error: ${snapshot.error}'));
    //           }

    //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //             return Center(child: Text('No courses found'));
    //           }

    //           final courses = snapshot.data!.docs;

    //           return ListView.builder(
    //             itemCount: courses.length,
    //             itemBuilder: (context, index) {
    //               final course = courses[index];

    //               return ListTile(
    //                 title: Text(course['name']),
    //                 subtitle: Text(course['code']),
    //                 onTap: () {
    //                   setState(() {
    //                     selectedCourseId = course.id;
    //                   });
    //                 },
    //               );
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //     if (selectedCourseId != null)
    //       Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Text(
    //           'Selected Course: $selectedCourseId',
    //           style: TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //   ],
    // ),

    //   SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const Text(
    //             "EXAM BASE",
    //             style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
    //           ),
    //           const Text(
    //             "welcome Back Sam!",
    //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Container(
    //             height: 150,
    //             width: MediaQuery.of(context).size.width,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               color: Colors.black,
    //             ),
    //             child: const Padding(
    //               padding: EdgeInsets.all(15.0),
    //               child: Column(
    //                 children: [
    //                   Text(
    //                     "Daily Quotes:",
    //                     style: TextStyle(
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.w600,
    //                         color: Colors.white),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Text(
    //                     "every single codes ,matters and go a long way to many otherevery single codes ,matters a every single codes ,matters a",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         fontSize: 15,
    //                         fontWeight: FontWeight.w500,
    //                         color: Colors.white),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),

    //           const SizedBox(
    //             height: 20,
    //           ),
    //           // DropdownButtonFormField(items: dropdownList.map((String value) {
    //           //         return DropdownMenuItem<String>(
    //           //           value: value,
    //           //           child: Text(value),
    //           //         );
    //           //       }).toList(),
    //           // onChanged: ( value){
    //           //   dropdownList = value as List<String>;
    //           // }),
    //           DropdownButtonFormField(
    //             decoration: InputDecoration(
    //               contentPadding: const EdgeInsets.all(6),
    //               focusedBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               hintText: 'Select Subjet',
    //               filled: true,
    //               border: const OutlineInputBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(10)),
    //               ),
    //             ),
    //             icon: const Icon(
    //               Icons.keyboard_arrow_down,
    //               color: Colors.black,
    //             ),
    //             isExpanded: true,
    //             hint: const Text('Choose SUject'),
    //             //value: dropdownvalue1,
    //             onChanged: (value) {
    //               setState(() {
    //                 dropdownvalue1 = value!;
    //               });
    //             },
    //             items: dropdownList.map((String value) {
    //               return DropdownMenuItem<String>(
    //                 value: value,
    //                 child: Text(value),
    //               );
    //             }).toList(),
    //           ),

    //           const SizedBox(
    //             height: 20,
    //           ),
    //           DropdownButtonFormField(
    //             decoration: InputDecoration(
    //               contentPadding: const EdgeInsets.all(6),
    //               focusedBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               //hintText: 'Select data plan',
    //               filled: true,
    //               border: const OutlineInputBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(10)),
    //               ),
    //             ),
    //             icon: const Icon(
    //               Icons.keyboard_arrow_down,
    //               color: Colors.black,
    //             ),
    //             isExpanded: true,
    //             hint: const Text('Select TIme Available'),
    //             //value: dropdownvalue1,
    //             onChanged: (value) {
    //               setState(() {
    //                 dropdownvalue2 = value!;
    //               });
    //             },
    //             items: timeLIst.map((String value) {
    //               return DropdownMenuItem<String>(
    //                 value: value,
    //                 child: Text(value),
    //               );
    //             }).toList(),
    //           ),

    //           const SizedBox(
    //             height: 40,
    //           ),
    //           GestureDetector(
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (_) => SubmitScreen(
    //                     time: dropdownvalue2,
    //                     course: dropdownvalue1,
    //                   ),
    //                 ),
    //               );
    //             },
    //             child: Container(
    //               height: 60,
    //               width: MediaQuery.of(context).size.width * 0.95,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(10),
    //                   color: Colors.black),
    //               child: const Center(
    //                   child: Text(
    //                 "Submit",
    //                 style: TextStyle(color: Colors.white, fontSize: 20),
    //               )),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}








// Future<void> bookSlot() async {
//   final slotRef =
//       FirebaseFirestore.instance.collection('slot').doc(selectedSlotId);
//   final slotSnapshot = await slotRef.get();

//   if (!slotSnapshot.exists) return;

//   final slotData = slotSnapshot.data()!;
//   final maxCapacity = slotData['maxCapacity'];
//   final bookedCount = slotData['bookedCount'];
//   final courseId = slotData['courseId'];
//   final String timeRange = slotData['time']; // e.g. "10:30 AM - 11:00 AM"
//   final Timestamp dateTimestamp = slotData['date']; // Firestore Timestamp

//   if (bookedCount >= maxCapacity) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("This slot is full. Please choose another one.")),
//     );
//     return;
//   }

//   final DateTime date = dateTimestamp.toDate();
//   final String startTimeStr = timeRange.split(' - ')[0]; // e.g. "10:30 AM"

//   // 👇 Format the full datetime string
//   String fullDateTimeStr =
//       "${DateFormat('d MMM yyyy').format(date)} $startTimeStr";

//   // 👇 Parse the full datetime using the correct format
//   final DateTime slotTime =
//       DateFormat("d MMM yyyy hh:mm a").parse(fullDateTimeStr);

//   final userId = "user_123"; // use real ID later

//   // Check if already booked
//   final existing = await FirebaseFirestore.instance
//       .collection('bookings')
//       .where('userId', isEqualTo: userId)
//       .where('courseId', isEqualTo: courseId)
//       .get();

//   if (existing.docs.isNotEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("You have already booked this course.")),
//     );
//     return;
//   }

//   // Save booking
//   await FirebaseFirestore.instance.collection('bookings').add({
//     'userId': userId,
//     'courseId': courseId,
//     'slotId': selectedSlotId,
//     'time': Timestamp.fromDate(slotTime), // ✅ Use parsed time
//     'timestamp': FieldValue.serverTimestamp(),
//   });

//   // Update slot count
//   await slotRef.update({'bookedCount': bookedCount + 1});

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("Slot booked successfully 🎉")),
//   );
// }
