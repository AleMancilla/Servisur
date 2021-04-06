import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxis_app/Core/ApiFirebase.dart';
import 'package:taxis_app/Core/User_Preferens.dart';
import 'package:taxis_app/Pages/HomePage.dart';

class RegisterPage extends StatelessWidget {

  final ApiFirebase apiFirebase = ApiFirebase();
  final UserPreferences pref = UserPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'src/images/iconTaxi.png',
              width: 100,
              height: 100,
            ),
            _buttonLoginGoogle(context)
            // Container(
            //   padding: EdgeInsets.all(20),
            //   child: SimpleInputWidget()
            // )
          ],
        ),
      ),
    );
  }

  Padding _buttonLoginGoogle(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(30.0),
            child: CupertinoButton(
              onPressed: ()async{
                Flushbar(
                  title:  "Cargando",
                  message:  "Espere un momento mientras procesamos el pedido",
                  duration:  Duration(seconds: 3),
                  backgroundColor: Colors.green,
                )..show(context);
                var user =  await apiFirebase.signInWithGoogle();
                if(user  != null){
                  pref.userEmail = user.email;
                  pref.userName = user.displayName;
                  pref.userPhotoUrl = user.photoURL;
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (BuildContext context) => HomePage())
                  );
                }else{
                  Flushbar(
                    title:  "Error",
                    message:  "Ocurrio un error al procesar tu solicitud",
                    duration:  Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  )..show(context);
                }
              }, 
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset('src/icons/google-symbol.png', width: 30,height: 30,),
                  ),
                  Text('Iniciar con Google'),
                ],
              )
            ),
          );
  }
}