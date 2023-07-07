import 'package:examportal/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class startingPage extends StatefulWidget {
  const startingPage({Key? key}) : super(key: key);

  @override
  State<startingPage> createState() => _startingPageState();
}

class _startingPageState extends State<startingPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIN()),
                );
              },
              child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(280)),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 66, 0),
                    ),
                  )),
            ),
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assests/download.jpeg',),
                        
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Vision',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 66, 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
    
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Satisfy the aspirations of youth force, who want to lead nation towards prosperity through techno-economic development.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(186, 255, 68, 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Mission',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 66, 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'To provide, nurture and maintain an environment of high academic excellence, research and entrepreneurship for all aspiring students, which will prepare them to face global challenges maintaining high ethical and moral standards.',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(186, 255, 68, 0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60.h,
                    margin: EdgeInsets.only(top:ScreenUtil().setWidth(135)),
                    color: Color.fromARGB(255, 255, 66, 0),
                    child: InkWell(
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              child: Text(
                                "Get Started",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignIN()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
