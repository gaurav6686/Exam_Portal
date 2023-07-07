import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserDetail extends StatefulWidget {
  final token;
  final userId;

  const UserDetail({Key? key, @required this.token, @required this.userId})
      : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  String name = '';
  String mobileNo = '';
  String branch = '';
  String classValue = '';
  String division = '';
  String photo = '';
  String pdf = '';

  late String userId;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['id'];
    fetchSubmittedData(userId);
  }

Future<void> fetchSubmittedData(userId) async {
  try {
    var response = await http.post(
      Uri.parse('http://192.168.156.223:3000/api/studentData'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        name = jsonData['name'];
        mobileNo = jsonData['mobileNo'];
        branch = jsonData['branch'];
        classValue = jsonData['classValue'];
        division = jsonData['division'];
        photo = jsonData['photo'];
        pdf = jsonData['pdf'];
      });
    } else {
      print('Error fetching submitted data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('HTTP request error: $error');
  }
}

  PDFViewController? pdfController;
  int? totalPages;
  int? currentPage;

  void openPDF() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(
          filePath: pdf,
          onRender: (pages) {
            setState(() {
              totalPages = pages;
            });
          },
          onViewCreated: (controller) {
            setState(() {
              pdfController = controller;
            });
          },
          onPageChanged: (index, _) {
            setState(() {
              currentPage = index! + 1;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Mobile No:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                mobileNo,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Branch:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                branch,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Class:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                classValue,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Division:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                division,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Image.network(
                photo,
                width: 200,
                height: 200,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: openPDF,
                child: Text('Open PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
