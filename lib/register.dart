import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("EXAM BASE", style: TextStyle( fontSize: 40, fontWeight: FontWeight.w900),),
              const Text("LOGIN HERE"),
              TextFormField(
                        // maxLength: 11,
                        //controller: fname,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          filled: true,
                          //fillColor: AppColor.black.withOpacity(0.1),
                          border: InputBorder.none,
                          hintStyle: const TextStyle(fontSize: 12),
                          hintText: 'Email or  Matric No',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        validator: (value) {
                          return null;
                        
                          // if (value!.trim().isEmpty) {
                          //   return 'meter number cant be empty';
                          // } else if (value.trim().length != 11) {
                          //   return 'Phone Number must be 11 characters';
                          // } else {
                          //   return null;
                          // }
                        },
                      ),
                      SizedBox(height: 20,),

                       TextFormField(
                        // maxLength: 11,
                        //controller: fname,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          filled: true,
                          //fillColor: AppColor.black.withOpacity(0.1),
                          border: InputBorder.none,
                          hintStyle:  TextStyle(fontSize: 12),
                          hintText: 'Password',
                          labelStyle:  TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        validator: (value) {
                          return null;
                        
                          // if (value!.trim().isEmpty) {
                          //   return 'meter number cant be empty';
                          // } else if (value.trim().length != 11) {
                          //   return 'Phone Number must be 11 characters';
                          // } else {
                          //   return null;
                          // }
                        },
                      ),

                      SizedBox( height: 20,),

                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black
                        ),
                        child: Center(child: Text("Login", style: TextStyle( color: Colors.white, fontSize: 20),)),
                      ),
                    
            ],
          ),
        ),
      ),
    );
  }
}