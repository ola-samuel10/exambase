// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';
// //import 'dart:html' as html;

// class AdminSlotPanel extends StatefulWidget {
//   const AdminSlotPanel({super.key});

//   @override
//   State<AdminSlotPanel> createState() => _AdminSlotPanelState();
// }

// class _AdminSlotPanelState extends State<AdminSlotPanel> {
//   String? selectedCourseId;
//   String? selectedDate;
//   List<DocumentSnapshot> allSlots = [];
//   List<DocumentSnapshot> filteredSlots = [];
//   List<DocumentSnapshot> courses = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     final courseSnap = await FirebaseFirestore.instance.collection('course').get();
//     final slotSnap = await FirebaseFirestore.instance.collection('slot').get();

//     setState(() {
//       courses = courseSnap.docs;
//       allSlots = slotSnap.docs;
//       filteredSlots = List.from(allSlots);
//     });
//   }

//   void _filterSlots() {
//     setState(() {
//       filteredSlots = allSlots.where((slot) {
//         final data = slot.data() as Map<String, dynamic>;
//         final courseMatch = selectedCourseId == null || data['courseId'] == selectedCourseId;
//         final dateMatch = selectedDate == null ||
//             DateFormat("yyyy-MM-dd").format((data['date'] as Timestamp).toDate()) == selectedDate;
//         return courseMatch && dateMatch;
//       }).toList();
//     });
//   }

//   // void _exportToCSV() {
//   //   List<List<String>> rows = [
//   //     ["Course ID", "Date", "Time", "Max Capacity", "Booked"]
//   //   ];
//   //   for (var slot in filteredSlots) {
//   //     final data = slot.data() as Map<String, dynamic>;
//   //     rows.add([
//   //       data['courseId'],
//   //       DateFormat("yyyy-MM-dd").format((data['date'] as Timestamp).toDate()),
//   //       data['time'],
//   //       data['maxCapacity'].toString(),
//   //       data['bookedCount'].toString(),
//   //     ]);
//   //   }
//   //   String csv = const ListToCsvConverter().convert(rows);
//   //   final bytes = utf8.encode(csv);
//   //   final blob = html.Blob([bytes]);
//   //   final url = html.Url.createObjectUrlFromBlob(blob);
//   //   final anchor = html.AnchorElement(href: url)
//   //     ..setAttribute("download", "slots.csv")
//   //     ..click();
//   //   html.Url.revokeObjectUrl(url);
//   // }

//   void _editSlot(DocumentSnapshot slotDoc) async {
//     final data = slotDoc.data() as Map<String, dynamic>;
//     final TextEditingController timeCtrl = TextEditingController(text: data['time']);
//     final TextEditingController capacityCtrl = TextEditingController(text: data['maxCapacity'].toString());
//     Timestamp selectedDate = data['date'];

//     String? selectedEditCourse = data['courseId'];

//     await showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Edit Slot"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButtonFormField(
//               value: selectedEditCourse,
//               items: courses.map((course) {
//                 return DropdownMenuItem(
//                   value: course.id,
//                   child: Text(course['name']),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 selectedEditCourse = value;
//               },
//               decoration: InputDecoration(
//                 labelText: "Course",
//                 prefixIcon: Icon(Icons.book),
//               ),
//             ),
//             SizedBox(height: 8),
//             TextFormField(
//               controller: timeCtrl,
//               decoration: InputDecoration(
//                 labelText: "Time (e.g. 10:00 AM - 11:00 AM)",
//                 prefixIcon: Icon(Icons.access_time),
//               ),
//             ),
//             SizedBox(height: 8),
//             TextFormField(
//               controller: capacityCtrl,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Max Capacity",
//                 prefixIcon: Icon(Icons.people),
//               ),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 20),
//                 SizedBox(width: 8),
//                 TextButton(
//                   onPressed: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: selectedDate.toDate(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100),
//                     );
//                     if (picked != null) {
//                       selectedDate = Timestamp.fromDate(picked);
//                     }
//                   },
//                   child: Text(DateFormat("d MMM yyyy").format(selectedDate.toDate())),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//           ElevatedButton(
//             onPressed: () async {
//               await FirebaseFirestore.instance.collection("slot").doc(slotDoc.id).update({
//                 'courseId': selectedEditCourse,
//                 'time': timeCtrl.text.trim(),
//                 'maxCapacity': int.parse(capacityCtrl.text.trim()),
//                 'date': selectedDate,
//               });
//               Navigator.pop(context);
//               _loadData();
//             },
//             child: Text("Save"),
//           )
//         ],
//       ),
//     );
//   }

//   void _deleteSlot(String slotId) async {
//     await FirebaseFirestore.instance.collection("slot").doc(slotId).delete();
//     _loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Slot Management")),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField(
//                     value: selectedCourseId,
//                     items: [
//                       DropdownMenuItem(value: null, child: Text("All Courses")),
//                       ...courses.map((course) => DropdownMenuItem(
//                             value: course.id,
//                             child: Text(course['name']),
//                           ))
//                     ],
//                     onChanged: (value) {
//                       selectedCourseId = value;
//                       _filterSlots();
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Filter by Course",
//                       prefixIcon: Icon(Icons.book),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: TextFormField(
//                     readOnly: true,
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2023),
//                         lastDate: DateTime(2100),
//                       );
//                       if (picked != null) {
//                         setState(() {
//                           selectedDate = DateFormat("yyyy-MM-dd").format(picked);
//                           _filterSlots();
//                         });
//                       }
//                     },
//                     decoration: InputDecoration(
//                       labelText: "Filter by Date",
//                       prefixIcon: Icon(Icons.date_range),
//                     ),
//                     controller: TextEditingController(text: selectedDate),
//                   ),
//                 ),
//                 // IconButton(
//                 //   icon: Icon(Icons.download),
//                 //   tooltip: "Export CSV",
//                 //   onPressed: _exportToCSV,
//                 // )
//               ],
//             ),
//             Divider(height: 24),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filteredSlots.length,
//                 itemBuilder: (context, index) {
//                   final slot = filteredSlots[index];
//                   final data = slot.data() as Map<String, dynamic>;
//                   final dateStr = DateFormat("d MMM yyyy").format((data['date'] as Timestamp).toDate());

//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     child: ListTile(
//                       title: Text("${data['time']}"),
//                       subtitle: Text("$dateStr  •  Course ID: ${data['courseId']}"),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () => _editSlot(slot),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteSlot(slot.id),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:exambase/edit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminSlotListPage extends StatefulWidget {
  @override
  _AdminSlotListPageState createState() => _AdminSlotListPageState();
}

class _AdminSlotListPageState extends State<AdminSlotListPage> {
  String? selectedCourseId;

  Stream<QuerySnapshot> getSlotsStream() {
    final collection = FirebaseFirestore.instance.collection('slot');
    if (selectedCourseId != null && selectedCourseId!.isNotEmpty) {
      return collection.where('courseId', isEqualTo: selectedCourseId).snapshots();
    }
    return collection.snapshots();
  }

  void deleteSlot(String slotId) async {
    await FirebaseFirestore.instance.collection('slot').doc(slotId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slot deleted.')));
  }

  void editSlot(String slotId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditSlotPage(slotId: slotId, slotData: {},),
      ),
    );
  }

  void exportToCSV(List<QueryDocumentSnapshot> slots) {
    // Placeholder: real export logic would go here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported ${slots.length} slots to CSV (simulated).')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - Slot Management")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Filter by Course ID",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() => selectedCourseId = val);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getSlotsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final slots = snapshot.data!.docs;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total Slots: ${slots.length}"),
                    ),
                    ElevatedButton(
                      onPressed: () => exportToCSV(slots),
                      child: Text("Export to CSV"),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: slots.length,
                        itemBuilder: (context, index) {
                          final slot = slots[index];
                          final data = slot.data() as Map<String, dynamic>;

                          final date = (data['date'] as Timestamp).toDate();
                          final time = data['time'] ?? '';
                          final courseId = data['courseId'] ?? '';
                          final bookedCount = data['bookedCount'] ?? 0;
                          final maxCapacity = data['maxCapacity'] ?? 0;

                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text("$courseId - ${DateFormat('d MMM yyyy').format(date)} | $time"),
                              subtitle: Text("🧍‍♂️ $bookedCount / $maxCapacity booked"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => editSlot(slot.id),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteSlot(slot.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class EditSlotPage extends StatelessWidget {
//   final String slotId;

//   const EditSlotPage({required this.slotId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Edit Slot - Coming Soon")),
//       body: Center(child: Text("Edit functionality coming soon...")),
//     );
//   }
// }



