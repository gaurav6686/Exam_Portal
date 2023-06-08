import 'package:flutter/material.dart';

import 'mainpage.dart';

class signIN extends StatefulWidget {
  const signIN({super.key});

  @override
  State<signIN> createState() => _signINState();
}

class _signINState extends State<signIN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 66, 0),
          ),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 150),
                height: 610,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width: 348,
                                  height: 70,
                                  color: Color.fromARGB(255, 255, 66, 0),
                                  child:
                                      Row(children: [Container(), Container()]),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            width: 320,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 66, 0),),
                                ),
                                labelText: 'Email Id',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            width: 320,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 66, 0),),
                                ),
                                labelText: 'password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            width: 320,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 66, 0),),
                                ),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 200,
                      height: 60,
                      color: Color.fromARGB(255, 255, 66, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()),
                              );
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
