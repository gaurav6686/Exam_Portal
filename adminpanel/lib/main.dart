
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'UserDetailsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class UserData {
  final String id;
  final String pdf;
  final String name;
  final String mobileNo;
  final String branch;
  final String classValue;
  final String division;
  final String photo;
  final String status;


  UserData({
    required this.id,
    required this.pdf,
    required this.name,
    required this.mobileNo,
    required this.branch,
    required this.classValue,
    required this.division,
    required this.photo,
    this.status = '',
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
  return UserData(
    id: json['_id'] ?? '',
    pdf: json['pdf'] ?? '',
    name: json['name'] ?? '',
    mobileNo: json['mobileNo'] ?? '',
    branch: json['branch'] ?? '',
    classValue: json['classValue'] ?? '',
    division: json['division'] ?? '',
    photo: json['photo'] ?? '',
    status: json['status'] ?? '',
  );
}

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = 'http://192.168.1.12:3000/user/list';
  late Future<List<UserData>> data;
  String searchText = '';

// Selecting class
  late String selectedOption;
  List<String> dropdownItems = [
    'CLASS',
    'FE',
    'SE',
    'TE',
    'BE',
  ];

  // Selecting division
  late String selecteddivi;
  List<String> dropdowndivi = [
    'DIVISION',
    'A',
    'B',
    'C',
    'D',
    'E',
  ];

  @override
  void initState() {
    super.initState();
    data = fetchData();
    selectedOption = dropdownItems[0];
    selecteddivi = dropdowndivi[0];
  }

  List<UserData> filterUserListByClass(
      List<UserData> userList, String selectedClass, String selectedDivi) {
    if (selectedClass == 'CLASS' && selectedDivi == 'DIVISION') {
      return userList;
    } else if (selectedClass == 'CLASS') {
      return userList.where((user) => user.division == selectedDivi).toList();
    } else if (selectedDivi == 'DIVISION') {
      return userList.where((user) => user.classValue == selectedClass).toList();
    } else {
      return userList
          .where((user) =>
              user.classValue == selectedClass && user.division == selectedDivi)
          .toList();
    }
  }

  Future<List<UserData>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic>? data = jsonData['items'];
        if (data != null && data.isNotEmpty) {
          final userList = data.map((json) => UserData.fromJson(json)).toList();
          return userList;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load data. Error: $error');
    }
  }


  List<UserData> filterUserList(List<UserData> userList) {
    if (searchText.isEmpty &&
        selectedOption == 'CLASS' &&
        selecteddivi == 'DIVISION') {
      return userList;
    } else {
      return userList.where((user) {
        final bool matchesSearchText =
            user.name.toLowerCase().contains(searchText.toLowerCase());
        final bool matchesClass =
            selectedOption == 'CLASS' || user.classValue == selectedOption;
        final bool matchesDivision =
            selecteddivi == 'DIVISION' || user.division == selecteddivi;

        return matchesSearchText && matchesClass && matchesDivision;
      }).toList();
    }
  }

  void filterData(String text) {
    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(
          child: IconButton(
            icon:
                const Icon(Icons.account_circle, color: Colors.white, size: 40),
            onPressed: () {},
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      ),
      body: Builder(builder: (BuildContext context) {
        var screenSize = MediaQuery.of(context).size;
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Row(
            children: [
              Container(
                width: 350,
                height: screenSize.height,
                color: const Color.fromARGB(255, 69, 69, 69),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20.0,
                      left: 15.0,
                      child: Container(
                        width: 320,
                        height: 80,
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            "Total User: 450",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120.0,
                      left: 15.0,
                      child: Container(
                        width: 320,
                        height: 80,
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            "Total User: 450",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 220.0,
                      left: 15.0,
                      child: Container(
                        width: 320,
                        height: 80,
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            "Total User: 450",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 50, left: 30),
                            width: 150,
                            height: 50,
                            color: Colors.grey,
                            // color: const Color.fromARGB(255, 255, 66, 0),
                            child: DropdownButton<String>(
                              value: selectedOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOption = newValue!;
                                });
                              },
                              items: dropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 50, left: 30),
                            width: 150,
                            height: 50,
                            color: Colors.grey,
                            // color: const Color.fromARGB(255, 255, 66, 0),
                            child: DropdownButton<String>(
                              value: selecteddivi,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selecteddivi = newValue!;
                                });
                              },
                              items: dropdowndivi.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            width: 300,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 50, left: 200),
                            width: 200,
                            height: 50,
                            color: const Color.fromARGB(255, 255, 66, 0),
                            child: const Center(
                              child: Text(
                                "Export",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            width: 1120.0,
                            child: TextField(
                              onChanged: filterData,
                              decoration: const InputDecoration(
                                labelText: 'Search',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      child: FutureBuilder<List<UserData>>(
                        future: data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            final userList = filterUserListByClass(
                                snapshot.data!, selectedOption, selecteddivi);
                            if (userList.isEmpty) {
                              return const Center(
                                child: Text('No Student found.'),
                              );
                            }
                            return Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Class',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Division',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filterUserList(userList).length,
                                  itemBuilder: (context, index) {
                                    final userData = userList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDetailsPage(
                                                    user: userData,
                                                    studentId: userData.id,
                                                  )),
                                        );
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  userData.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  userData.classValue,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  userData.division,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: Text('No data available.'),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}