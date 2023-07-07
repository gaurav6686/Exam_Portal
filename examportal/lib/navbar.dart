import 'dart:convert';
import 'package:examportal/profile.dart';
import 'package:http/http.dart' as http;
import 'package:examportal/signin.dart';
import 'package:examportal/startingpage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'getUserDetails.dart';

class Navbar extends StatefulWidget {
  final String token;
  final String userId;

  const Navbar({Key? key, required this.token, required this.userId});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String? username;
  String? email;
  late String userId;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodeToken['id'];
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.156.223:3000/profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['username'];
          email = data['email'];
        });
      } else {
        print('Failed to fetch profile data. Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any network or parsing errors
      print('Error fetching profile data: $error');
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.156.223:3000/user/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('userId');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignIN()),
          (route) => false,
        );
        print("logout");
      } else {
        print('Failed to logout. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 66, 0),
            ),
            accountName: Text(username ?? ''),
            accountEmail: Text(email ?? ''),
            currentAccountPicture: GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Profile(token: widget.token, userId: widget.userId),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetail(
                    token: widget.token,
                    userId: widget.userId,
                  ),
                ),
              );
            },
            child: const ListTile(
              title: Text("Form"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignIN(),
                ),
              );
            },
            child: const ListTile(
              title: Text("Login"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const startingPage(),
                ),
              );
            },
            child: const ListTile(
              title: Text("Start"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          GestureDetector(
            onTap: () {
              logout();
            },
            child: const ListTile(
              title: Text("Log Out"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
