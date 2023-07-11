import 'package:flutter/material.dart';
import 'package:examportal/getUserDetails.dart';
import 'package:examportal/navbar.dart';
import 'package:examportal/profile.dart';
import 'package:examportal/success.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'new.dart';

class MyHomePage extends StatefulWidget {
  final String token;
  const MyHomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool uploaded = false;
  bool isuploaded = false;
  late String pdf;
  late String photo;
  bool showProgress = false;
  String token = '';
  SharedPreferences? prefs;
  late String userId;

  final fullNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final branchController = TextEditingController();
  final classController = TextEditingController();
  final divisionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['id'];
    print('Token received: ${widget.token}');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> sendData() async {
    userId = userId;
    String fullName = fullNameController.text;
    String mobileNo = mobileNoController.text;
    String branch = branchController.text;
    String classValue = classController.text;
    String division = divisionController.text;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.122.223:3000/api/action'),
    );
    request.headers['Content-Type'] = 'application/json';

    request.fields['userId'] = userId;
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
        // var responseData = await response.stream.transform(utf8.decoder).join();
        // var jsonData = json.decode(responseData);
        // String userId = jsonData['id'];

        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('userId', userId);

        print('Data saved');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetail(
              token: widget.token,
              userId: userId,
            ),
          ),
        );
      } else {
        print('Error saving data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return Scaffold(
                  drawer: Navbar(
                    token: widget.token,
                    userId: prefs?.getString('userId') ?? '',
                  ),
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 255, 66, 0),

                    // Container(
                    //   margin: EdgeInsets.only(left: 10),
                    //   child: IconButton(
                    //     icon: const Icon(
                    //       Icons.menu,
                    //       size: 40,
                    //       color: Colors.white,
                    //     ),
                    //     onPressed: () {
                    //       // Add your menu icon onPressed action here
                    //     },
                    //   ),
                    // ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final userId = prefs.getString('userId') ?? '';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                      token: widget.token, userId: userId),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(241, 255, 68, 0)),
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
                                    width: 330,
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
                                                width: 328,
                                                height: 70,
                                                color: const Color.fromARGB(
                                                    255, 255, 66, 0),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Upload Exam_Form Pdf',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                          width: 130,
                                          height: 60,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: ['pdf'],
                                                  );

                                                  if (result != null) {
                                                    PlatformFile file =
                                                        result.files.first;

                                                    setState(() {
                                                      uploaded = true;
                                                      pdf = file.path!;
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      const BeveledRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Container(
                                                  width: 250,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 255, 66, 0),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons.upload),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        uploaded
                                                            ? 'Uploaded'
                                                            : 'Upload',
                                                        style: const TextStyle(
                                                            fontSize: 15),
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
                                  SizedBox(
                                    width: 330,
                                    child: TextField(
                                      controller: fullNameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 255, 66, 0),
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
                                    width: 330,
                                    child: TextField(
                                      controller: mobileNoController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 255, 66, 0),
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
                                    width: 330,
                                    child: TextField(
                                      controller: branchController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 255, 66, 0),
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
                                        width: 145,
                                        child: TextField(
                                          controller: classController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 66, 0),
                                              ),
                                            ),
                                            labelText: 'Class',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      SizedBox(
                                        width: 145,
                                        child: TextField(
                                          controller: divisionController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 66, 0),
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
                                    width: 330,
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
                                                width: 328,
                                                height: 70,
                                                color: const Color.fromARGB(
                                                    255, 255, 66, 0),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Upload Fee ScreenShot',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                          width: 130,
                                          height: 60,
                                          // color: const Color.fromARGB(255, 255, 66, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.image,
                                                  );

                                                  if (result != null) {
                                                    PlatformFile file =
                                                        result.files.first;

                                                    setState(() {
                                                      isuploaded = true;
                                                      photo = file.path!;
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  // backgroundColor: Colors.white,
                                                  // shadowColor: Colors
                                                  //     .white,
                                                  shape:
                                                      const BeveledRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Container(
                                                  width: 250,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 255, 66, 0),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons.upload),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        isuploaded
                                                            ? 'Uploaded'
                                                            : 'Upload',
                                                        style: const TextStyle(
                                                            fontSize: 15),
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
                                    width: 130,
                                    height: 50,
                                    color:
                                        const Color.fromARGB(255, 255, 66, 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        sendData();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const succes(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromARGB(
                                            255, 255, 66, 0),
                                        shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
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
              });
        });
  }
}
