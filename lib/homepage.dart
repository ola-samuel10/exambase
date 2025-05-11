import 'package:exambase/submit.dart';
import 'package:flutter/material.dart';

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

  var timeLIst = [
    '2:00 am ',
    '4:34 pm',
    ' 1:00 pm',
    '7: 30 am',
    'Agric',
    '9:am',
    'Seven',
    'Eight',
    'Nine',
    'Ten'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "EXAM BASE",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
              ),
              const Text(
                "welcome Back Sam!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: const Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Text(
                        "Daily Quotes:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "every single codes ,matters and go a long way to many otherevery single codes ,matters a every single codes ,matters a",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // DropdownButtonFormField(items: dropdownList.map((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              // onChanged: ( value){
              //   dropdownList = value as List<String>;
              // }),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(6),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Select data plan',
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                hint: const Text('Choose SUject'),
                //value: dropdownvalue1,
                onChanged: (value) {
                  setState(() {
                    //dropdownvalue1 = value;
                  });
                },
                items: dropdownList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(6),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //hintText: 'Select data plan',
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                hint: const Text('Select TIme Available'),
                //value: dropdownvalue1,
                onChanged: (value) {
                  setState(() {
                    //dropdownvalue1 = value;
                  });
                },
                items: timeLIst.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubmitScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: const Center(
                      child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
