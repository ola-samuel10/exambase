// Updated Admin Panel with working Edit Slot Page and fixed Course Filter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exambase/edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'edit_slot_page.dart'; // You need to create this page

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? selectedCourse;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: _buildCourseFilter()),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text(
                    selectedDate != null
                        ? DateFormat("d MMM yyyy").format(selectedDate!)
                        : "Filter by Date",
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('slot').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final slots = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (selectedCourse != null && data['courseId'] != selectedCourse) {
                    return false;
                  }
                  if (selectedDate != null) {
                    final Timestamp? date = data['date'];
                    if (date == null) return false;
                    final DateTime slotDate = date.toDate();
                    return DateFormat("yyyy-MM-dd").format(slotDate) ==
                        DateFormat("yyyy-MM-dd").format(selectedDate!);
                  }
                  return true;
                }).toList();

                return ListView.builder(
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    final data = slot.data() as Map<String, dynamic>;
                    final startTime = data['date']?.toDate();

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text("${data['courseId'] ?? 'No Course'} - ${data['time'] ?? ''}"),
                        subtitle: Text("Date: ${startTime != null ? DateFormat("d MMM yyyy").format(startTime) : 'No date'}\nBooked: ${data['bookedCount']} / ${data['maxCapacity']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSlotPage(slotId: slot.id,  slotData: data,),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSlot(slot.id),
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
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildCourseFilter() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('course').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final courses = snapshot.data!.docs;
        return DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: "Filter by Course",
            border: OutlineInputBorder(),
          ),
          value: selectedCourse,
          items: [
            const DropdownMenuItem(value: null, child: Text("All Courses")),
            ...courses.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return DropdownMenuItem(
                value: doc.id,
                child: Text("${data['code']} - ${data['name']}"),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              selectedCourse = value;
            });
          },
        );
      },
    );
  }

  Future<void> _deleteSlot(String slotId) async {
    await FirebaseFirestore.instance.collection('slot').doc(slotId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Slot deleted successfully")),
    );
  }
}
