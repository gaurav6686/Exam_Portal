import 'dart:convert';
import 'package:adminpanel/signinup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'UserDetailsPage.dart';
import 'package:get/get.dart';
import 'config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCount {
  final int count;

  UserCount(this.count);
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

class HomePage extends StatefulWidget {
  final token;
  const HomePage({
    Key? key, this.token,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'http://192.168.156.2233:5000/user/list';
  late Future<List<UserData>> data;
  late String searchText;

  SharedPreferences? prefs;
  late String userId;
  String? username;
  String? email;

  late Future<UserCount> userCount;
  late Future<UserCount> completeUserCount;
  late Future<UserCount> incompleteUserCount;
  late Future<UserCount> pendingUserCount;
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
    selectedOption = 'CLASS';
    selecteddivi = 'DIVISION';
    userCount = fetchUserCount();
    completeUserCount = fetchUserCompleteCount();
    incompleteUserCount = fetchUserInCompleteCount();
    pendingUserCount = fetchpendingCount();
    searchText = '';
    initializeSharedPreferences();

    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['id'];
    print('Token received: ${widget.token}');
    fetchProfileData(userId);
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void filterBooks(String query) {
    setState(() {
      searchText = query;
    });
  }

  Future<void> fetchProfileData(userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.156.223:3000/profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['username'];
        });
        print(username);
      } else {
        print('Failed to fetch profile data. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }

  Future<List<UserData>> fetchData() async {
    const String url = 'http://192.168.156.223:5000/user/list';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic>? dataList = jsonData['items'];
        if (dataList != null && dataList.isNotEmpty) {
          final userList =
              dataList.map((json) => UserData.fromJson(json)).toList();

          // Filter the user list based on the selected class option
          List<UserData> filteredList;
          if (selectedOption == 'CLASS') {
            filteredList = userList;
          } else {
            filteredList = userList
                .where((user) =>
                    user.classValue.toLowerCase() ==
                    selectedOption.toLowerCase())
                .toList();
          }

          // Filter the user list based on the selected division option
          List<UserData> filteredListWithDivision;
          if (selecteddivi == 'DIVISION') {
            filteredListWithDivision = filteredList;
          } else {
            filteredListWithDivision = filteredList
                .where((user) =>
                    user.division.toLowerCase() == selecteddivi.toLowerCase())
                .toList();
          }

          return filteredListWithDivision;
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load data. Error: $error');
    }
  }

  Future<UserCount> fetchUserCount() async {
    final response =
        await http.get(Uri.parse('http://192.168.156.223:5000/user/count'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserCount(data['count']);
    } else {
      throw Exception('Failed to fetch user count');
    }
  }

  Future<UserCount> fetchUserCompleteCount() async {
    final response = await http
        .get(Uri.parse('http://192.168.156.223:5000/user/count/complete'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserCount(data['count']);
    } else {
      throw Exception('Failed to fetch user count');
    }
  }

  Future<UserCount> fetchUserInCompleteCount() async {
    final response = await http
        .get(Uri.parse('http://192.168.156.223:5000/user/count/incomplete'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserCount(data['count']);
    } else {
      throw Exception('Failed to fetch user count');
    }
  }

  Future<UserCount> fetchpendingCount() async {
    final response = await http
        .get(Uri.parse('http://192.168.156.223:5000/user/count/incomplete'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserCount(data['count']);
    } else {
      throw Exception('Failed to fetch user count');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          username ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 2.fw),
          child: IconButton(
            icon:
                const Icon(Icons.account_circle, color: Colors.white, size: 40),
            onPressed: () {
              // Handle the action when the person icon is pressed
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 9.fw, top: 18.fh),
            child: Text(
              'Admin DashBoard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.012,
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      ),
      body: Builder(builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(top: 10.fh, left: 3.fw, bottom: 10.fh),
          child: Row(
            children: [
              Container(
                width: 86.fw,
                height: 800.fh,
                color: const Color.fromARGB(255, 69, 69, 69),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20.fh,
                      left: 4.fw,
                      child: Container(
                        width: 78.fw,
                        height: 80.fh,
                        color: Colors.white,
                        child: Center(
                          child: FutureBuilder<UserCount>(
                            future: userCount,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'Total User: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0196,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${snapshot.data?.count}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 66, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error: ${snapshot.error}",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0196,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }

                              return const CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120.fh,
                      left: 4.fw,
                      child: Container(
                        width: 78.fw,
                        height: 80.fh,
                        color: Colors.white,
                        child: Center(
                          child: FutureBuilder<UserCount>(
                            future: completeUserCount,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'Total User: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0196,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${snapshot.data?.count}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 66, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error: ${snapshot.error}",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0196,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }

                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 220.fh,
                      left: 4.fw,
                      child: Container(
                        width: 78.fw,
                        height: 80.fh,
                        color: Colors.white,
                        child: Center(
                          child: FutureBuilder<UserCount>(
                            future: incompleteUserCount,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'Total User: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0196,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${snapshot.data?.count}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 66, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error: ${snapshot.error}",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0196,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }

                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 320.fh,
                      left: 4.fw,
                      child: Container(
                        width: 78.fw,
                        height: 80.fh,
                        color: Colors.white,
                        child: Center(
                          child: FutureBuilder<UserCount>(
                            future: pendingUserCount,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'Total User: ',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0196,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${snapshot.data?.count}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 66, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error: ${snapshot.error}",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0196,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }

                              return CircularProgressIndicator();
                            },
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
                          Padding(
                            padding: EdgeInsets.only(left: 6.fw),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 50),
                              width: 40.fw,
                              height: 50.fh,
                              color: Colors.grey,
                              // color: const Color.fromARGB(255, 255, 66, 0),
                              child: DropdownButton<String>(
                                value: selectedOption,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue!;
                                    data = fetchData();
                                  });
                                },
                                items: dropdownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.011,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 20.fw,
                          // ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.fw),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 50),
                              width: 40.fw,
                              height: 50.fh,
                              color: Colors.grey,
                              // color: const Color.fromARGB(255, 255, 66, 0),
                              child: DropdownButton<String>(
                                value: selecteddivi,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selecteddivi = newValue!;
                                    data = fetchData();
                                  });
                                },
                                items: dropdowndivi.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.011,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width:300,
                          // ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.fw),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 50,
                              ),
                              width: 40.fw,
                              height: 50.fh,
                              color: const Color.fromARGB(255, 255, 66, 0),
                              child: Center(
                                child: Text(
                                  "Export",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.011,
                                      color: Colors.white),
                                ),
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
                            width: 276.fw,
                            child: TextField(
                              onChanged: (value) {
                                filterBooks(value);
                              },
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
                    Padding(
                      padding: EdgeInsets.only(left: 5.fw, right: 5.fw),
                      child: Container(
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
                              final userList = snapshot.data!;
                              final filteredList = searchText.isEmpty
                                  ? userList
                                  : userList.where((user) {
                                      final name = user.name.toLowerCase();
                                      final lowerCaseQuery =
                                          searchText.toLowerCase();

                                      return name.startsWith(lowerCaseQuery);
                                    }).toList();

                              if (filteredList.isEmpty) {
                                return const Center(
                                  child: Text('No Student found.'),
                                );
                              }

                              if (userList.isEmpty) {
                                return const Center(
                                  child: Text('No Student found.'),
                                );
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 28,
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.012,
                                                color: const Color.fromARGB(
                                                    255, 255, 66, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Class',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.012,
                                                color: const Color.fromARGB(
                                                    255, 255, 66, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Division',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.012,
                                                color: const Color.fromARGB(
                                                    255, 255, 66, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final userData = filteredList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserDetailsPage(
                                                      user: userData,
                                                      studentId: userData.id,
                                                      token: widget.token,
                                                      userId: userId,
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: Offset(4, 4),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.fw,
                                                  vertical: 8.fh),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      userData.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 40),
                                                  Expanded(
                                                    child: Text(
                                                      userData.classValue,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 36),
                                                  Expanded(
                                                    child: Text(
                                                      userData.division,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text('No data available.'),
                              );
                            }
                          },
                        ),
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
