import 'package:flutter/material.dart';

class SubmitScreen extends StatefulWidget {
  final String time, course;
  const SubmitScreen({super.key, required this.time, required this.course});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.done, size: 50,),
               Text("You Have Successfully Book ${widget.time} for your ${widget.course} Exam", textAlign: TextAlign.center, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.w800),),
              const SizedBox(height: 30,),
                GestureDetector(
                          // onTap: (){
                          //   Navigator.push(context, MaterialPageRoute(
                          //       builder: (_) => const MyHomePage(),
                          //     ),);
                          // },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black
                            ),
                            child: const Center(child: Text("Print", style: TextStyle( color: Colors.white, fontSize: 20),)),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}


