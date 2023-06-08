import 'dart:io';
import 'package:examportal/signin.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool uploaded = false;
  bool isuploaded = false;
  late String pdf;
  late String photo;

  final fullNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final branchController = TextEditingController();
  final classController = TextEditingController();
  final divisionController = TextEditingController();

  Future<void> sendData() async {
    String fullName = fullNameController.text;
    String mobileNo = mobileNoController.text;
    String branch = branchController.text;
    String classValue = classController.text;
    String division = divisionController.text;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.12:3000/api/action'),
    );

    request.fields['name'] = fullName;
    request.fields['mobileNo'] = mobileNo;
    request.fields['branch'] = branch;
    request.fields['classValue'] = classValue;
    request.fields['division'] = division;
    request.fields['status'] = 'Pending';

    request.files.add(await http.MultipartFile.fromPath('pdf', pdf));
    request.files.add(await http.MultipartFile.fromPath('photo', photo));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Data saved');
      } else {
        print('Error saving data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 66, 0),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Add your menu icon onPressed action here
          },
        ),
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.person,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                // Add your profile icon onPressed action here
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 255, 66, 0)),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                    'JSPMs Bhivrabai Sawant Institute of Technology & Research, Wagholi, Pune',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 900,
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
                        height: 180,
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
                                    color:
                                        const Color.fromARGB(255, 255, 66, 0),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upload Exam_Form Pdf',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 150,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 255, 66, 0),
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf'],
                                      );

                                      if (result != null) {
                                        PlatformFile file = result.files.first;

                                        setState(() {
                                          uploaded = true;
                                          pdf = file.path!;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors
                                          .transparent, 
                                      shadowColor: Colors
                                          .transparent, 
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.upload),
                                        const SizedBox(width: 8),
                                        Text(
                                          uploaded ? 'Uploaded' : 'Upload',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 66, 0),
                              ),
                            ),
                            labelText: 'Full Name',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: mobileNoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 66, 0),
                              ),
                            ),
                            labelText: 'Mobile No',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: branchController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 66, 0),
                              ),
                            ),
                            labelText: 'Branch',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: classController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 66, 0),
                                  ),
                                ),
                                labelText: 'Class',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: divisionController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 66, 0),
                                  ),
                                ),
                                labelText: 'Division',
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 350,
                        height: 180,
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
                                    color:
                                        const Color.fromARGB(255, 255, 66, 0),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upload Fee ScreenShot',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 150,
                              height: 60,
                              // color: const Color.fromARGB(255, 255, 66, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.image,
                                      );

                                      if (result != null) {
                                        PlatformFile file = result.files.first;

                                        setState(() {
                                          isuploaded = true;
                                          photo = file.path!;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors
                                          .transparent, 
                                      shadowColor: Colors
                                          .transparent, 
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Container(
                                      width: 200,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 255, 66, 0),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.upload),
                                          const SizedBox(width: 8),
                                          Text(
                                            isuploaded ? 'Uploaded' : 'Upload',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 150,
                        height: 50,
                        color: const Color.fromARGB(255, 255, 66, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            sendData();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 255, 66, 0),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
