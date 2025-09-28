// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';

// // class AdminAddSlotPage extends StatefulWidget {
// //   const AdminAddSlotPage({super.key});

// //   @override
// //   State<AdminAddSlotPage> createState() => _AdminAddSlotPageState();
// // }

// // class _AdminAddSlotPageState extends State<AdminAddSlotPage> {
// //   String? selectedCourseId;
// //   DateTime? selectedDate;
// //   final timeController = TextEditingController();
// //   final capacityController = TextEditingController();

// //   final _formKey = GlobalKey<FormState>();

// //   Future<void> _submitSlot() async {
// //     if (!_formKey.currentState!.validate() || selectedDate == null || selectedCourseId == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text("Please fill all fields correctly."),
// //       ));
// //       return;
// //     }

// //     try {
// //       await FirebaseFirestore.instance.collection('slot').add({
// //         'courseId': selectedCourseId,
// //         'date': Timestamp.fromDate(selectedDate!),
// //         'time': timeController.text.trim(),
// //         'maxCapacity': int.parse(capacityController.text.trim()),
// //         'bookedCount': 0,
// //         'isBooked': false,
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Slot created successfully ✅")),
// //       );

// //       setState(() {
// //         selectedCourseId = null;
// //         selectedDate = null;
// //         timeController.clear();
// //         capacityController.clear();
// //       });
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Failed to add slot: $e")),
// //       );
// //     }
// //   }

// //   Future<void> _pickDate() async {
// //     final now = DateTime.now();
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: now,
// //       firstDate: now,
// //       lastDate: DateTime(now.year + 1),
// //     );

// //     if (picked != null) {
// //       setState(() => selectedDate = picked);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Create New Slot")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               // Fetch Courses for Dropdown
// //               StreamBuilder<QuerySnapshot>(
// //                 stream: FirebaseFirestore.instance.collection('course').snapshots(),
// //                 builder: (context, snapshot) {
// //                   if (!snapshot.hasData) return CircularProgressIndicator();

// //                   final courses = snapshot.data!.docs;
// //                   return DropdownButtonFormField<String>(
// //                     value: selectedCourseId,
// //                     items: courses.map((doc) {
// //                       final data = doc.data() as Map<String, dynamic>;
// //                       return DropdownMenuItem(
// //                         value: doc.id,
// //                         child: Text("${data['name']} (${data['code']})"),
// //                       );
// //                     }).toList(),
// //                     onChanged: (value) => setState(() => selectedCourseId = value),
// //                     decoration: InputDecoration(labelText: "Select Course"),
// //                     validator: (value) => value == null ? 'Please select a course' : null,
// //                   );
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 readOnly: true,
// //                 decoration: InputDecoration(
// //                   labelText: "Pick Date",
// //                   hintText: selectedDate != null
// //                       ? DateFormat('d MMM yyyy').format(selectedDate!)
// //                       : 'Tap to select',
// //                   suffixIcon: Icon(Icons.calendar_today),
// //                 ),
// //                 onTap: _pickDate,
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: timeController,
// //                 decoration: InputDecoration(labelText: "Time (e.g. 10:00 AM - 11:00 AM)"),
// //                 validator: (value) => value == null || value.trim().isEmpty ? 'Enter time range' : null,
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: capacityController,
// //                 decoration: InputDecoration(labelText: "Max Capacity"),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) => value == null || value.trim().isEmpty ? 'Enter capacity' : null,
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _submitSlot,
// //                 child: Text("Add Slot"),
// //               ),
              
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }





// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // class AdminSlotManager extends StatefulWidget {
// //   const AdminSlotManager({super.key});

// //   @override
// //   State<AdminSlotManager> createState() => _AdminSlotManagerState();
// // }

// // class _AdminSlotManagerState extends State<AdminSlotManager> {
// //   final _formKey = GlobalKey<FormState>();
// //   String? selectedCourseId;
// //   DateTime? selectedDate;
// //   final timeController = TextEditingController();
// //   final capacityController = TextEditingController();

// //   Future<void> createSlot() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     if (selectedCourseId == null || selectedDate == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Please select course and date")));
// //       return;
// //     }

// //     await FirebaseFirestore.instance.collection('slot').add({
// //       'courseId': selectedCourseId,
// //       'date': Timestamp.fromDate(selectedDate!),
// //       'time': timeController.text.trim(),
// //       'maxCapacity': int.parse(capacityController.text.trim()),
// //       'bookedCount': 0,
// //     });

// //     ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Slot created successfully ✅")));

// //     // Clear form
// //     setState(() {
// //       selectedDate = null;
// //       selectedCourseId = null;
// //       timeController.clear();
// //       capacityController.clear();
// //     });
// //   }

// //   Future<void> deleteSlot(String slotId) async {
// //     await FirebaseFirestore.instance.collection('slot').doc(slotId).delete();
// //     ScaffoldMessenger.of(context)
// //         .showSnackBar(SnackBar(content: Text("Slot deleted ❌")));
// //   }

// //   Future<void> updateSlotCapacity(String slotId, int newCapacity) async {
// //     await FirebaseFirestore.instance
// //         .collection('slot')
// //         .doc(slotId)
// //         .update({'maxCapacity': newCapacity});
// //     ScaffoldMessenger.of(context)
// //         .showSnackBar(SnackBar(content: Text("Capacity updated ✏️")));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Admin Slot Manager")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             Form(
// //               key: _formKey,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   StreamBuilder<QuerySnapshot>(
// //                     stream: FirebaseFirestore.instance.collection('course').snapshots(),
// //                     builder: (context, snapshot) {
// //                       if (!snapshot.hasData) return CircularProgressIndicator();
// //                       final courses = snapshot.data!.docs;
// //                       return DropdownButtonFormField(
// //                         value: selectedCourseId,
// //                         hint: Text("Select course"),
// //                         items: courses.map((doc) {
// //                           final data = doc.data() as Map<String, dynamic>;
// //                           return DropdownMenuItem(
// //                             value: doc.id,
// //                             child: Text("${data['name']} (${data['code']})"),
// //                           );
// //                         }).toList(),
// //                         onChanged: (value) => setState(() => selectedCourseId = value),
// //                         validator: (value) => value == null ? 'Required' : null,
// //                       );
// //                     },
// //                   ),
// //                   SizedBox(height: 10),
// //                   TextFormField(
// //                     readOnly: true,
// //                     decoration: InputDecoration(
// //                       labelText: "Select Date",
// //                       suffixIcon: Icon(Icons.calendar_today),
// //                     ),
// //                     onTap: () async {
// //                       final picked = await showDatePicker(
// //                         context: context,
// //                         initialDate: DateTime.now(),
// //                         firstDate: DateTime.now(),
// //                         lastDate: DateTime(2030),
// //                       );
// //                       if (picked != null) setState(() => selectedDate = picked);
// //                     },
// //                     controller: TextEditingController(
// //                       text: selectedDate == null ? '' : DateFormat("d MMM yyyy").format(selectedDate!),
// //                     ),
// //                   ),
// //                   SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: timeController,
// //                     decoration: InputDecoration(labelText: "Time Range (e.g. 10:00 AM - 11:00 AM)"),
// //                     validator: (val) => val!.isEmpty ? 'Required' : null,
// //                   ),
// //                   SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: capacityController,
// //                     decoration: InputDecoration(labelText: "Max Capacity"),
// //                     keyboardType: TextInputType.number,
// //                     validator: (val) => val!.isEmpty ? 'Required' : null,
// //                   ),
// //                   SizedBox(height: 10),
// //                   ElevatedButton(
// //                     onPressed: createSlot,
// //                     child: Text("Add Slot"),
// //                   ),
// //                   SizedBox(height: 20),
// //                   Divider(),
// //                   Text("Existing Slots", style: TextStyle(fontWeight: FontWeight.bold)),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               child: StreamBuilder<QuerySnapshot>(
// //                 stream: FirebaseFirestore.instance
// //                     .collection('slot')
// //                     .orderBy('date')
// //                     .snapshots(),
// //                 builder: (context, snapshot) {
// //                   if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

// //                   final slots = snapshot.data!.docs;

// //                   if (slots.isEmpty) return Center(child: Text("No slots yet"));

// //                   return ListView.builder(
// //                     itemCount: slots.length,
// //                     itemBuilder: (context, index) {
// //                       final slot = slots[index];
// //                       final data = slot.data() as Map<String, dynamic>;

// //                       return ListTile(
// //                         title: Text("${data['time']} | ${DateFormat("d MMM yyyy").format(data['date'].toDate())}"),
// //                         subtitle: Text("Max: ${data['maxCapacity']} | Booked: ${data['bookedCount']}"),
// //                         trailing: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             IconButton(
// //                               icon: Icon(Icons.delete, color: Colors.red),
// //                               onPressed: () => deleteSlot(slot.id),
// //                             ),
// //                             IconButton(
// //                               icon: Icon(Icons.edit, color: Colors.blue),
// //                               onPressed: () {
// //                                 final controller = TextEditingController(text: data['maxCapacity'].toString());
// //                                 showDialog(
// //                                   context: context,
// //                                   builder: (_) => AlertDialog(
// //                                     title: Text("Update Capacity"),
// //                                     content: TextField(
// //                                       controller: controller,
// //                                       keyboardType: TextInputType.number,
// //                                       decoration: InputDecoration(labelText: "New Capacity"),
// //                                     ),
// //                                     actions: [
// //                                       TextButton(
// //                                         onPressed: () => Navigator.pop(context),
// //                                         child: Text("Cancel"),
// //                                       ),
// //                                       TextButton(
// //                                         onPressed: () {
// //                                           updateSlotCapacity(slot.id, int.parse(controller.text));
// //                                           Navigator.pop(context);
// //                                         },
// //                                         child: Text("Update"),
// //                                       )
// //                                     ],
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AdminPage extends StatefulWidget {
//   const AdminPage({super.key});

//   @override
//   State<AdminPage> createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _courseIdController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _capacityController = TextEditingController();
//   DateTime? _selectedDate;
//   TimeOfDay? _startTime;
// TimeOfDay? _endTime;
// String? selectedCourseId;


//   Future<void> _createSlot() async {
//     if (!_formKey.currentState!.validate() || _selectedDate == null) return;
//     final timeRange = "${_startTime!.format(context)} - ${_endTime!.format(context)}";
  
//     await FirebaseFirestore.instance.collection('slot').add({
//       //'courseId': _courseIdController.text.trim(),
//       'courseId': selectedCourseId!,
//       'date': Timestamp.fromDate(_selectedDate!),
//       //'time': _timeController.text.trim(),
//        'time': timeRange,
//       'maxCapacity': int.parse(_capacityController.text.trim()),
//       'bookedCount': 0,
//     });

//     _courseIdController.clear();
//     _timeController.clear();
//     _capacityController.clear();
//     setState(() => _selectedDate = null);

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slot created successfully!')));
//   }

//   void _deleteSlot(String slotId) async {
//     await FirebaseFirestore.instance.collection('slot').doc(slotId).delete();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slot deleted')));
//   }

//   void _editSlot(DocumentSnapshot slotDoc) {
//     final data = slotDoc.data() as Map<String, dynamic>;
//     _courseIdController.text = data['courseId'];
//     _timeController.text = data['time'];
//     _capacityController.text = data['maxCapacity'].toString();
//     _selectedDate = data['date'].toDate();

//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: Text('Edit Slot'),
//           content: Form(
//             key: _formKey,
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               TextFormField(
//                 controller: _courseIdController,
//                 decoration: InputDecoration(labelText: 'Course ID'),
//                 validator: (value) => value!.isEmpty ? 'Enter Course ID' : null,
//               ),
//               TextFormField(
//                 controller: _timeController,
//                 decoration: InputDecoration(labelText: 'Time (e.g. 10:00 AM - 11:00 AM)'),
//                 validator: (value) => value!.isEmpty ? 'Enter time' : null,
//               ),
//               TextFormField(
//                 controller: _capacityController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Max Capacity'),
//                 validator: (value) => value!.isEmpty ? 'Enter capacity' : null,
//               ),
//               SizedBox(height: 10),
//               TextButton(
//                 onPressed: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: _selectedDate ?? DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) setState(() => _selectedDate = picked);
//                 },
//                 child: Text(_selectedDate == null
//                     ? 'Pick a date'
//                     : 'Date: ${DateFormat('d MMM yyyy').format(_selectedDate!)}'),
//               ),
//             ]),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
//             ElevatedButton(
//               onPressed: () async {
//                 if (!_formKey.currentState!.validate() || _selectedDate == null) return;

//                 await FirebaseFirestore.instance
//                     .collection('slot')
//                     .doc(slotDoc.id)
//                     .update({
//                   'courseId': _courseIdController.text.trim(),
//                   'time': _timeController.text.trim(),
//                   'maxCapacity': int.parse(_capacityController.text.trim()),
//                   'date': Timestamp.fromDate(_selectedDate!),
//                 });

//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slot updated')));
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Panel')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             /// CREATE SLOT FORM
//             Form(
//               key: _formKey,
//               child: Column(children: [
//                 StreamBuilder<QuerySnapshot>(
//   stream: FirebaseFirestore.instance.collection('course').snapshots(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) return CircularProgressIndicator();

//     final courseItems = snapshot.data!.docs.map((doc) {
//       return DropdownMenuItem(
//         value: doc.id, // or doc['code'] if you're using that
//         child: Text("${doc['name']} (${doc['code']})"),
//       );
//     }).toList();

//     return DropdownButtonFormField(
//       value: selectedCourseId,
//       items: courseItems,
//       onChanged: (value) {
//         setState(() {
//           print(value);
//           selectedCourseId = value;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: "Course",
//         border: OutlineInputBorder(),
//       ),
//     );
//   },
// ),
//                 // TextFormField(
//                 //   controller: _courseIdController,
//                 //   decoration: InputDecoration(labelText: 'Course ID'),
//                 //   validator: (value) => value!.isEmpty ? 'Enter course ID' : null,
//                 // ),
//                 // TextFormField(
//                 //   controller: _timeController,
//                 //   decoration: InputDecoration(labelText: 'Time'),
//                 //   validator: (value) => value!.isEmpty ? 'Enter time' : null,
//                 // ),

//              // 📍 Start Time Picker
// TextFormField(
//   readOnly: true,
//   decoration: InputDecoration(
//     labelText: 'Start Time',
//     suffixIcon: Icon(Icons.access_time),
//     border: OutlineInputBorder(),
//   ),
//   controller: TextEditingController(
//     text: _startTime == null ? '' : _startTime!.format(context),
//   ),
//   onTap: () async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _startTime = picked;
//       });
//     }
//   },
// ),
// SizedBox(height: 10),

// // 📍 End Time Picker
// TextFormField(
//   readOnly: true,
//   decoration: InputDecoration(
//     labelText: 'End Time',
//     suffixIcon: Icon(Icons.access_time_outlined),
//     border: OutlineInputBorder(),
//   ),
//   controller: TextEditingController(
//     text: _endTime == null ? '' : _endTime!.format(context),
//   ),
//   onTap: () async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: _startTime ?? TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _endTime = picked;
//       });
//     }
//   },
// ),

//                 TextFormField(
//                   controller: _capacityController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(labelText: 'Max Capacity'),
//                   validator: (value) => value!.isEmpty ? 'Enter capacity' : null,
//                 ),
//                 SizedBox( height: 10,),
//                 // TextButton(
//                 //   onPressed: () async {
//                 //     DateTime? picked = await showDatePicker(
//                 //       context: context,
//                 //       initialDate: DateTime.now(),
//                 //       firstDate: DateTime.now(),
//                 //       lastDate: DateTime(2100),
//                 //     );
//                 //     if (picked != null) setState(() => _selectedDate = picked);
//                 //   },
//                 //   child: Text(_selectedDate == null
//                 //       ? 'Pick a date'
//                 //       : 'Date: ${DateFormat('d MMM yyyy').format(_selectedDate!)}'),
//                 // ),
//         // 📍 DATE FIELD with icon
// TextFormField(
//   readOnly: true,
//   decoration: InputDecoration(
//     labelText: 'Pick Slot Date',
//     suffixIcon: Icon(Icons.calendar_today),
//     border: OutlineInputBorder(),
//   ),
//   controller: TextEditingController(
//     text: _selectedDate == null
//         ? ''
//         : DateFormat('d MMM yyyy').format(_selectedDate!),
//   ),
//   onTap: () async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   },
// ),
// SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _createSlot,
//                   child: Text('Create Slot'),
//                 ),
//                 Divider(thickness: 2),
//               ]),
//             ),

//             /// SLOT LIST VIEW
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('slot').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return CircularProgressIndicator();
//                   final slots = snapshot.data!.docs;

//                   return ListView.builder(
//                     itemCount: slots.length,
//                     itemBuilder: (context, index) {
//                       final slot = slots[index];
//                       final data = slot.data() as Map<String, dynamic>;
//                       final start = (data['date'] as Timestamp).toDate();
//                       final time = data['time'];
//                       final max = data['maxCapacity'] ?? 0;
//                       final booked = data['bookedCount'] ?? 0;

//                       return ListTile(
//                         title: Text("${data['courseId']} | ${slot['time'] ?? '⏰ Time not set'}"),
//                         subtitle: Text("📅 ${DateFormat('d MMM yyyy').format(start)} | $booked/$max booked"),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () => _editSlot(slot),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => _deleteSlot(slot.id),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminSlotPage extends StatefulWidget {
  const AdminSlotPage({super.key});

  @override
  State<AdminSlotPage> createState() => _AdminSlotPageState();
}

class _AdminSlotPageState extends State<AdminSlotPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  List<DocumentSnapshot> _courses = [];

  Future<void> _fetchCourses() async {
    final snapshot = await FirebaseFirestore.instance.collection('course').get();
    setState(() {
      _courses = snapshot.docs;
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _dateController.text = DateFormat('d MMM yyyy').format(picked);
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller.text = DateFormat('hh:mm a').format(dateTime);
    }
  }

  Future<void> _addSlot() async {
    if (_selectedCourseId == null ||
        _dateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty ||
        _capacityController.text.isEmpty) return;

    final parsedDate = DateFormat('d MMM yyyy').parse(_dateController.text);
    final combinedDateTimeStr = '${_dateController.text} ${_startTimeController.text}';
    final startTime = DateFormat('d MMM yyyy hh:mm a').parse(combinedDateTimeStr);

    await FirebaseFirestore.instance.collection('slot').add({
      'courseId': _selectedCourseId,
      'date': Timestamp.fromDate(parsedDate),
      'startTime': Timestamp.fromDate(startTime),
      'time': '${_startTimeController.text} - ${_endTimeController.text}',
      'maxCapacity': int.parse(_capacityController.text),
      'bookedCount': 0,
    });

    _dateController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    _capacityController.clear();
  }

  void _editSlot(DocumentSnapshot slotDoc) {
    final data = slotDoc.data() as Map<String, dynamic>;
    _selectedCourseId = data['courseId'];
    _dateController.text = DateFormat('d MMM yyyy').format(data['date'].toDate());
    _capacityController.text = data['maxCapacity'].toString();

    final timeParts = (data['time'] as String).split(' - ');
    _startTimeController.text = timeParts[0];
    _endTimeController.text = timeParts[1];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Slot'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _slotForm(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final parsedDate = DateFormat('d MMM yyyy').parse(_dateController.text);
              final combinedDateTimeStr = '${_dateController.text} ${_startTimeController.text}';
              final startTime = DateFormat('d MMM yyyy hh:mm a').parse(combinedDateTimeStr);

              await FirebaseFirestore.instance
                  .collection('slot')
                  .doc(slotDoc.id)
                  .update({
                'courseId': _selectedCourseId,
                'date': Timestamp.fromDate(parsedDate),
                'startTime': Timestamp.fromDate(startTime),
                'time': '${_startTimeController.text} - ${_endTimeController.text}',
                'maxCapacity': int.parse(_capacityController.text),
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  List<Widget> _slotForm() {
    return [
      DropdownButtonFormField<String>(
        value: _selectedCourseId,
        decoration: InputDecoration(labelText: 'Course'),
        items: _courses.map((course) {
          final data = course.data() as Map<String, dynamic>;
          return DropdownMenuItem(
            value: course.id,
            child: Text('${data['name']} (${data['code']})'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCourseId = value;
          });
        },
      ),
      TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Exam Date',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        onTap: _selectDate,
      ),
      TextFormField(
        controller: _startTimeController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Start Time',
          prefixIcon: Icon(Icons.access_time),
        ),
        onTap: () => _selectTime(_startTimeController),
      ),
      TextFormField(
        controller: _endTimeController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'End Time',
          prefixIcon: Icon(Icons.access_time_outlined),
        ),
        onTap: () => _selectTime(_endTimeController),
      ),
      TextFormField(
        controller: _capacityController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Max Capacity'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Slots')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._slotForm(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addSlot,
              child: Text('Add Slot'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('slot').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final slots = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final data = slot.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text("Course: ${data['courseId']}"),
                          subtitle: Text("Date: ${DateFormat('d MMM yyyy').format(data['date'].toDate())}\nTime: ${data['time']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editSlot(slot),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection('slot').doc(slot.id).delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
