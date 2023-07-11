import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'homepage.dart';

class UserDetailsPage extends StatefulWidget {
  final UserData user;
  final String studentId;
  final token;
  final userId;

  UserDetailsPage(
      {required this.user,
      required this.studentId,
      @required this.token,
      @required this.userId});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String status = '';
  late String userId;


  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['id'];
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Future<void> updateStatus(String newStatus) async {
    String url;
    if (newStatus == 'reject') {
      url = 'http://192.168.156.223:5000/user/${widget.studentId}/reject';
    } else if (newStatus == 'accept') {
      url = 'http://192.168.156.223:5000/user/${widget.studentId}/accept';
    } else {
      return;
    }
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          status = newStatus;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: const Color.fromARGB(255, 255, 66, 0),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 22),
          width: 600,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: SizedBox(
            height: 800,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 500,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Name: ${widget.user.name}',
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 255, 66, 0),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Mobile No: ${widget.user.mobileNo}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Class: ${widget.user.classValue}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Division: ${widget.user.division}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Branch: ${widget.user.branch}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Check Exam-Form PDF',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 66, 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            height: 600, // Adjust the height as needed
                            child: SfPdfViewer.network(
                              widget.user.pdf,
                              key: _pdfViewerKey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Check Exam-Form Fee ScreenShot',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 66, 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 200,
                          child: InkWell(
                            child: Ink.image(
                              image: NetworkImage(widget.user.photo),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Query Box',
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (status != 'reject') {
                                    updateStatus('reject');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Text(
                                  status == 'reject' ? 'Rejected' : 'Reject',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 120,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (status != 'accept') {
                                    updateStatus('accept');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                                child: Text(
                                  status == 'accept' ? 'Accepted' : 'Accept',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
