import 'package:exambase/homepage.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool _startloading = false;
   TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Form(
        key: formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("EXAM BASE", style: TextStyle( fontSize: 40, fontWeight: FontWeight.w900),),
                const Text("LOGIN HERE"),
                const SizedBox(height: 20,),
                TextFormField(
                          // maxLength: 11,
                          controller: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            filled: true,
                            //fillColor: AppColor.black.withOpacity(0.1),
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 12),
                            hintText: 'Email or  Matric No',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          validator: (value) {
                            //return null;
                          
                            RegExp nameRegExp = RegExp(
                                          r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]',
                                        );
                                        if (value!.trim().isEmpty) {
                                          return 'Name cannot be Empty';
                                        } else if (value.trim().length < 3) {
                                          return 'Full name is required';
                                        } else if (nameRegExp
                                            .hasMatch(value.trim())) {
                                          return 'invalid input';
                                        } else {
                                          return null;
                                        }
                          },
                        ),
                        const SizedBox(height: 20,),
        
                         TextFormField(
                          // maxLength: 11,
                          controller: pass,
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
                            //return null;
                          
                           if (value!.trim().isEmpty) {
                                    return 'Password cant be empty';
                                  } else if (value.trim().length < 6) {
                                    return 'cant be less than 6';
                                  } else {
                                    return null;
                                  }
                          },
                        ),
        
                        const SizedBox( height: 20,),
        
                        _startloading
                                ? const CircularProgressIndicator(
                                    color:Colors.black,
                                  )
                                :GestureDetector(
                                  
                          onTap: (){
                            startLoading();
                             if (formkey.currentState!.validate()) {
                                         Navigator.push(context, MaterialPageRoute(
                                builder: (_) => const MyHomePage(),
                              ),);
                                        }
                            
                              stopLoading();
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black
                            ),
                            child: const Center(child: Text("Login", style: TextStyle( color: Colors.white, fontSize: 20),)),
                          ),
                        ),
                      
              ],
            ),
          ),
        ),
      ),
    );

    
  }


    void startLoading() {
    setState(() => _startloading = true);
  }

  void stopLoading() {
    setState(() => _startloading = false);
  }
}