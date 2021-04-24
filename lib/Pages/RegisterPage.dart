import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxis_app/Core/ApiFirebase.dart';
import 'package:taxis_app/Core/User_Preferens.dart';
import 'package:taxis_app/Pages/HomePage.dart';
import 'package:taxis_app/Widgets/SimpleInputWidget.dart';

class RegisterPage extends StatelessWidget {
  final ApiFirebase apiFirebase = ApiFirebase();
  final UserPreferences pref = UserPreferences();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'src/icons/iconoApp.jpeg',
                width: 200,
                height: 200,
              ),
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: SimpleInputWidget(
                  label: "Codigo de movilidad",
                  textEditingController: controller,
                )),
            _buttonLoginGoogle(context)
          ],
        ),
      ),
    );
  }

  CollectionReference taxis = FirebaseFirestore.instance.collection('taxis');
  Padding _buttonLoginGoogle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: CupertinoButton(
          onPressed: () async {
            print(
                "== ${controller.text} == ${controller.text != ''} == ${controller.text != null}");
            if (controller.text != null && controller.text != '') {
              Flushbar(
                title: "Cargando",
                message: "Espere un momento mientras procesamos la solicitud",
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              )..show(context);
              var user = await apiFirebase.signInWithGoogle();
              if (user != null) {
                pref.userEmail = user.email;
                pref.userName = user.displayName;
                pref.userPhotoUrl = user.photoURL;
                pref.userFirebaseId = user.uid;
                pref.userMatricula = controller.text;
                taxis.doc("${pref.userMatricula}").set({
                  'matricula': pref.userMatricula,
                  'idFirebase': pref.userFirebaseId,
                  'userEmail': pref.userEmail,
                  'userPhoto': pref.userPhotoUrl,
                  'userName': pref.userName,
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
              } else {
                Flushbar(
                  title: "Error",
                  message: "Ocurrio un error al procesar tu solicitud",
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                )..show(context);
              }
            } else {
              Flushbar(
                title: "Error",
                message: "Matricula requerida",
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
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
                child: Image.asset(
                  'src/icons/google-symbol.png',
                  width: 30,
                  height: 30,
                ),
              ),
              Text('Iniciar con Google'),
            ],
          )),
    );
  }
}
