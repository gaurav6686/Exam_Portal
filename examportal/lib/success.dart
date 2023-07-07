import 'package:flutter/material.dart';

class succes extends StatefulWidget {
  const succes({super.key});

  @override
  State<succes> createState() => _succesState();
}

class _succesState extends State<succes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 66, 0),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 350,
            width: 350,
            decoration: BoxDecoration(
              color: const Color.fromARGB(125, 255, 68, 0),
              borderRadius: BorderRadius.circular(200),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 50,),
                Text(
                  "SUCCESS",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.verified_rounded,
                  color: Colors.green,
                  size: 40,
                ),
                Text(
                  'Your Form was Successfully',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                Text(
                  'Submited',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                Text(
                  'Wait till verification keep watching profile',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.share,
                size: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Share the Form',
                style: TextStyle(
                    fontSize: 20, decoration: TextDecoration.underline),
              )
            ],
          ),
        ],
      ),
    );
  }
}
