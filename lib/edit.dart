// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class EditSlotPage extends StatefulWidget {
//   final String slotId;
//   final Map<String, dynamic> slotData;

//   const EditSlotPage({super.key, required this.slotId, required this.slotData});

//   @override
//   State<EditSlotPage> createState() => _EditSlotPageState();
// }

// class _EditSlotPageState extends State<EditSlotPage> {
//   late TextEditingController _timeController;
//   late TextEditingController _capacityController;
//   Timestamp? _selectedDate;
//   String? _selectedCourseId;
//   List<String> _courseIds = [];

//   @override
//   void initState() {
//     super.initState();
//     _timeController = TextEditingController(text: widget.slotData['time']);
//     _capacityController = TextEditingController(text: widget.slotData['maxCapacity'].toString());
//     _selectedDate = widget.slotData['date'];
//     _selectedCourseId = widget.slotData['courseId'];
//     _loadCourses();
//   }

//   Future<void> _loadCourses() async {
//     final courses = await FirebaseFirestore.instance.collection('course').get();
//     setState(() {
//       _courseIds = courses.docs.map((doc) => doc.id).toList();
//     });
//   }

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate?.toDate() ?? DateTime.now(),
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = Timestamp.fromDate(picked);
//       });
//     }
//   }

//   Future<void> _saveChanges() async {
//     if (_selectedDate == null || _selectedCourseId == null) return;

//     await FirebaseFirestore.instance.collection('slot').doc(widget.slotId).update({
//       'courseId': _selectedCourseId,
//       'date': _selectedDate,
//       'time': _timeController.text.trim(),
//       'maxCapacity': int.tryParse(_capacityController.text.trim()) ?? 0,
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slot updated')));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Edit Slot")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField(
//               value: _selectedCourseId,
//               items: _courseIds.map((id) => DropdownMenuItem(
//                 value: id,
//                 child: Text(id),
//               )).toList(),
//               onChanged: (value) {
//                 setState(() => _selectedCourseId = value);
//               },
//               decoration: InputDecoration(labelText: "Course ID", border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               readOnly: true,
//               onTap: _selectDate,
//               controller: TextEditingController(
//                 text: _selectedDate != null ? DateFormat("d MMM yyyy").format(_selectedDate!.toDate()) : '',
//               ),
//               decoration: InputDecoration(
//                 labelText: "Date",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.calendar_today),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _timeController,
//               decoration: InputDecoration(
//                 labelText: "Time Range (e.g. 10:00 AM - 11:00 AM)",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.access_time),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _capacityController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Max Capacity",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.people),
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _saveChanges,
//               icon: Icon(Icons.save),
//               label: Text("Save Changes"),
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

class EditSlotPage extends StatefulWidget {
  final String slotId;
  final Map<String, dynamic> slotData;

  const EditSlotPage({super.key, required this.slotId, required this.slotData});

  @override
  State<EditSlotPage> createState() => _EditSlotPageState();
}

class _EditSlotPageState extends State<EditSlotPage> {
  late TextEditingController _timeController;
  late TextEditingController _maxController;
  DateTime? _selectedDate;
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(text: widget.slotData['time']);
    _maxController = TextEditingController(text: widget.slotData['maxCapacity'].toString());
    _selectedDate = (widget.slotData['date'] as Timestamp).toDate();
    _selectedCourseId = widget.slotData['courseId'];
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateSlot() async {
    try {
      await FirebaseFirestore.instance.collection('slot').doc(widget.slotId).update({
        'time': _timeController.text.trim(),
        'maxCapacity': int.tryParse(_maxController.text.trim()) ?? 0,
        'date': Timestamp.fromDate(_selectedDate!),
        'courseId': _selectedCourseId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Slot updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update slot: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Slot")),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('course').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: _selectedCourseId,
                  decoration: InputDecoration(
                    labelText: "Select Course",
                    border: OutlineInputBorder(),
                  ),
                  items: courses.map((course) {
                    final data = course.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: course.id,
                      child: Text("${data['code']} - ${data['name']}"),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCourseId = value),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: "Time Range (e.g. 10:00 AM - 11:00 AM)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _maxController,
                  decoration: InputDecoration(
                    labelText: "Max Capacity",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Select Date",
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedDate != null
                          ? DateFormat("d MMM yyyy").format(_selectedDate!)
                          : 'Choose date',
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _updateSlot,
                  icon: Icon(Icons.save),
                  label: Text("Save Changes"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
