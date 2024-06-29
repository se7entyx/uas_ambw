import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uas_ambw/confirmPin.dart';
import 'package:uas_ambw/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String pin = '';
  Box? settingBox;
  bool isSignUpMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingBox = Hive.box('settings');
    isSignUpMode = settingBox?.get('pin') == null;
  }

  Widget buildNumberRow(List<dynamic> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return buildNumberButton(number);
      }).toList(),
    );
  }

  Widget buildNumberButton(dynamic number) {
    return GestureDetector(
      onTap: () {
        if (number is int) {
          setState(() {
            if (pin.length < 6) {
              pin += number.toString();
              print("Current pin: $pin");
            }
          });
        } else if (number == Icons.arrow_back) {
          setState(() {
            if (pin.isNotEmpty) {
              pin = pin.substring(0, pin.length - 1);
            }
          });
        } else if (number == Icons.check) {
          setState(() {
            String? storedPin = settingBox?.get('pin');
            print("Pin = $pin");
            print("Stored Pin = $storedPin");
            if (pin.length == 6) {
              if (isSignUpMode) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Confirm(pin: pin)));
              } else {
                if (pin == storedPin) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Failed",
                            style: TextStyle(color: Colors.red),
                          ),
                          content: Text("Pin anda salah!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            )
                          ],
                        );
                      });
                  pin = '';
                }
              }
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Failed",
                        style: TextStyle(color: Colors.red),
                      ),
                      content: Text("Pin anda kurang dari 6 digit!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        )
                      ],
                    );
                  });
            }
          });
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: number is int
            ? Text(
                number.toString(),
                style: TextStyle(fontSize: 24, color: Colors.white),
              )
            : Icon(
                number,
                size: 24,
                color: Colors.white,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Guest!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Icon(
              Icons.lock,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              isSignUpMode ? 'Set Your PIN' : 'Enter Your PIN',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        index < pin.length ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildNumberRow([1, 2, 3]),
                    buildNumberRow([4, 5, 6]),
                    buildNumberRow([7, 8, 9]),
                    buildNumberRow([Icons.arrow_back, 0, Icons.check]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
