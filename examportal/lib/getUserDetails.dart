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
  bool isLoading = true;

  late String userId;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['id'];
    fetchSubmittedData(userId);
    print(userId);
  }

  Future<void> fetchSubmittedData(userId) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.122.223:3000/api/studentData'),
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
          isLoading = false;
        });
      } else {
        print(
            'Error fetching submitted data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }

  // PDFViewController? pdfController;
  // int? totalPages;
  // int? currentPage;

  // void openPDF() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PDFView(
  //         filePath: pdf,
  //         onRender: (pages) {
  //           setState(() {
  //             totalPages = pages;
  //           });
  //         },
  //         onViewCreated: (controller) {
  //           setState(() {
  //             pdfController = controller;
  //           });
  //         },
  //         onPageChanged: (index, _) {
  //           setState(() {
  //             currentPage = index! + 1;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Data'),
      ),
      body: Stack(
        children: [
          Padding(
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
                  // Image.network("https://res.cloudinary.com/ds197oik9/image/upload/v1688744739/f6jlubsv1iya1q1a1zsh.pdf"),
                  // ElevatedButton(
                  //   onPressed: openPDF,
                  //   child: Text('Open PDF'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPdfViewer(pdfPath: pdf),
                        ),
                      );
                    },
                    child: Text('View PDF'),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) // Show CircularProgressIndicator if loading
            Container(
              color: Colors.black.withOpacity(0.5), // Add a semi-transparent background color
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class MyPdfViewer extends StatefulWidget {
  final String pdfPath;
  MyPdfViewer({required this.pdfPath});
  @override
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  late PDFViewController pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My PDF Document"),
      ),
      body: PDFView(
        filePath: widget.pdfPath,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        onError: (error) {
          print(error);
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController vc) {
          pdfViewController = vc;
        },
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
