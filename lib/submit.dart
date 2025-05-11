import 'package:flutter/material.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

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
              Icon(Icons.done, size: 50,),
              Text("You Have Successfully Book 2:30am for your Physics Exam", textAlign: TextAlign.center, style: TextStyle( fontSize: 20, fontWeight: FontWeight.w800),),
              SizedBox(height: 30,),
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
                            child: Center(child: Text("Print", style: TextStyle( color: Colors.white, fontSize: 20),)),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}