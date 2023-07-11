import 'dart:convert';
import 'package:examportal/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainpage.dart';
import 'package:http/http.dart' as http;

import 'new.dart';

class SignIN extends StatefulWidget {
  const SignIN({Key? key}) : super(key: key);

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late SharedPreferences prefs;

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> signUp() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final apiUrl = 'http://192.168.122.223:3000/user/signup';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        print('token: $token');
        await _saveToken(token);
        _clearFields();
      } else {
        final error = json.decode(response.body)['msg'];
        print('Error: $error');
      }
    } catch (e) {
      print('Exception occurred while signing up: $e');
    }
  }

  Future<void> signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final apiUrl = 'http://192.168.122.223:3000/user/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        prefs.setString('token', token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(token: token)),
        );
      } else {
        final error = json.decode(response.body)['message'];
        print('Error: $error');
      }
    } catch (e) {
      print('Exception occurred while logging in: $e');
    }

    return null;
  }

  // Future<void> signIn() async {
  //   final email = _emailController.text;
  //   final password = _passwordController.text;
  //   final apiUrl = 'http://192.168.122.223:3000/user/login';

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'email': email,
  //         'password': password,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final token = json.decode(response.body)['token'];
  //       print('token: $token');
  //       await _saveToken(token);
  //       _clearFields();
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => news(token: token)),
  //       );
  //     } else {
  //       final error = json.decode(response.body)['msg'];
  //       print('Error: $error');
  //     }
  //   } catch (e) {
  //     print('Exception occurred while signing in: $e');
  //   }
  // }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _clearFields() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _getToken().then((token) {
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(token: token)),
        );
      }
    });
    initializeSharedPreferences();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      currentTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
                    height: ScreenUtil().setHeight(540),
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
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            'Register or Login Yourself',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: 330,
                          height: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: const Color.fromARGB(255, 255, 66, 0),
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  tabs: const [
                                    Tab(text: 'Sign In'),
                                    Tab(text: 'Sign Up'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 240,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 255, 66, 0),
                                                ),
                                              ),
                                              labelText: 'Email Id',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 255, 66, 0),
                                                ),
                                              ),
                                              labelText: 'Password',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            controller: _usernameController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 255, 66, 0),
                                                ),
                                              ),
                                              labelText: 'Name',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            controller: _emailController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 255, 66, 0),
                                                ),
                                              ),
                                              labelText: 'Email Id',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            controller: _passwordController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 255, 66, 0),
                                                ),
                                              ),
                                              labelText: 'Password',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 60,
                          color: const Color.fromARGB(255, 255, 66, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: currentTabIndex == 0 ? signIn : signUp,
                                child: Text(
                                  currentTabIndex == 0 ? 'signIn' : 'Register',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
            ),
          ),
        );
      },
    );
  }
}
