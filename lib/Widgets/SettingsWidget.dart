import 'package:flutter/material.dart';
import 'package:learning/Widgets/LoginWidget.dart';
import 'package:learning/main.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green[500],
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.green, spreadRadius: 20, blurRadius: 100)
                  ]),
              child:  Text(
    accData.getString('userName')!.toUpperCase().substring(0, 1),
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80, left: 30),
            child: const Text(
              'Your Name',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff1E2126),
                  border: Border.all(color: Colors.grey)),
              margin: const EdgeInsets.only(top: 15),
              alignment: FractionalOffset.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                accData.getString('firstName')![0].toUpperCase() +
                    accData.getString('firstName')!.substring(1).toLowerCase(),
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff1E2126),
                  border: Border.all(color: Colors.grey)),
              margin: const EdgeInsets.only(top: 40),
              alignment: FractionalOffset.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  accData.getString('lastName')![0].toUpperCase() +
                      accData.getString('lastName')!.substring(1).toLowerCase(),
                  style: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 50, left: 30),
            child: const Text(
              'Account Info',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 150,
              child: Card(
                elevation: 15,
                color: const Color(0xff1E2126),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username:',
                            style: TextStyle(color: Color(0xff727272))),
                        SizedBox(height: 10),
                        Text('E-Mail:',
                            style: TextStyle(color: Color(0xff727272))),
                        SizedBox(height: 10),
                        Text('Password:',
                            style: TextStyle(color: Color(0xff727272))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(accData.getString('userName')!,
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        SizedBox(
                            width: 245,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  accData.getString('email')!,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))),
                        SizedBox(height: 10),
                        Text('12345678', style: TextStyle(color: Colors.white, )),
                      ],
                    ),
                  )
                ]),
              )),
          Center(
            child: Container(
              width: 180,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 50),
              child: ElevatedButton(
                onPressed: () {
                  Login.LogOut();

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainApp()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff7E7EBE)),
                  overlayColor:
                      MaterialStateProperty.all(const Color(0xff61619D)),
                  splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                  elevation: MaterialStateProperty.all(15),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
