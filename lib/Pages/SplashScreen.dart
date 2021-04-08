
import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taxis_app/Core/User_Preferens.dart';
import 'package:taxis_app/Pages/HomePage.dart';
import 'package:taxis_app/Pages/RegisterPage.dart';
// ignore: must_be_immutable
class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Widget one ;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() { 
    super.initState();
    print('== ${auth.currentUser}');
    if(auth.currentUser!=null){
      print('SI HAY USUARIO');
      one = HomePage();
    }else{
      print('NO HAY USUARIO');
      one = RegisterPage();
      
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplash(
        imagePath: 'src/images/iconTaxi.png',
        // backGroundColor: Colors.deepOrange,
        animationEffect: 'zoom-in',
        logoSize: 200,
        home: one,
        // customFunction: ()=>Future.delayed(Duration(seconds: 3))
        duration: 2500,
        type: CustomSplashType.StaticDuration,
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return
//   //   return SplashScreen.navigate(
//   //     name: 'assets/animations/chaskinuevo.flr',
//   //     next: (_) {
//   //       print('== ${auth.currentUser}');
//   //       if(auth.currentUser!=null){
//   //         print('SI HAY USUARIO');
//   //         return HomePage();
//   //       }else{
//   //         print('NO HAY USUARIO');
//   //         return RegistrationScreen();
          
//   //       }
//   //     },  //=> InitScreen(),
//   //     // until: () async{
//   //     //   one = await _verificaAuth();
//   //     //   return Future.delayed(Duration(seconds: 2));
//   //     // },
//   //     until: () {
//   //       return Future.delayed(Duration(seconds: 2));
//   //     },
//   //     fit: BoxFit.contain,
//   //     alignment: Alignment.center,
//   //     startAnimation: 'load',
//   //     backgroundColor: Colors.white,
//   //   );
//   // }

// }
