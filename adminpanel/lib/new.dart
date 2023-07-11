import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';

class news extends StatefulWidget {
  final token;
  final userId;
  const news({Key? key, @required this.token,@required this.userId, })
      : super(key: key);

  @override
  State<news> createState() => _newsState();
}

class _newsState extends State<news> {
  late String email;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    email = jwtDecodeToken['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(email),
          ],
        ),
      ),
    );
  }
}
