import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:taxis_app/Core/ApiUbication.dart';
import 'package:taxis_app/Pages/HomePage.dart';
import 'package:taxis_app/Pages/RegisterPage.dart';

// ignore: must_be_immutable
class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Widget one;

  final FirebaseAuth auth = FirebaseAuth.instance;

  LocationData position;
  ApiUbication apiUbication = ApiUbication();
  getUbication() async {
    position = await apiUbication.determinePosition();
  }

  @override
  void initState() {
    super.initState();

    getUbication();
    print('== ${auth.currentUser}');
    if (auth.currentUser != null) {
      print('SI HAY USUARIO');
      one = HomePage();
    } else {
      print('NO HAY USUARIO');
      one = RegisterPage();
    }
  }

  Widget aux = Container(
    color: Color.fromRGBO(0, 102, 13, 1),
    child: Image.asset('src/images/splashImage.jpeg'),
  );
  bool bandera = false;

  @override
  Widget build(BuildContext context) {
    //   return CustomSplash(
    //     imagePath: 'src/images/splashImage.jpeg',
    //     backGroundColor: Colors.green,
    //     animationEffect: 'zoom-in',
    //     logoSize: 200,
    //     home: one,
    //     // customFunction: ()=>Future.delayed(Duration(seconds: 3))
    //     duration: 2500,
    //     type: CustomSplashType.StaticDuration,
    //   );
    // }
    return FutureBuilder(
      future: Future(() {
        Future.delayed(Duration(seconds: 3), () {
          print("object");
          if (!bandera) {
            if (auth.currentUser != null) {
              print('SI HAY USUARIO');
              // one = HomePage();
              aux = HomePage();
            } else {
              print('NO HAY USUARIO');
              // one = RegisterPage();
              aux = RegisterPage();
            }
            bandera = true;
            setState(() {});
          }
        });
      }),
      builder: (context, snapshot) {
        return aux;
      },
    );
  }
}
