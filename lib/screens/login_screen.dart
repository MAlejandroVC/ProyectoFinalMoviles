import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'registration_screen.dart';

class LoginScreen extends StatelessWidget {
  final Function(bool) updateLoginStatus;

  LoginScreen({required this.updateLoginStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///// USUARIO /////
            SizedBox(height: 20.0),
            Text(
              'Usuario',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ingresa tu usuario',
              ),
            ),
            ///// CONTRASEÑA /////
            SizedBox(height: 20.0),
            Text(
              'Contraseña',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Ingresa tu contraseña',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    // TODO: Implementar función para mostrar/ocultar contraseña
                  },
                ),
              ),
            ),
            ///// BOTONES /////
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // TODO: Implementar función para olvidar contraseña
                  },
                  child: Text('Olvidé mi contraseña'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Implement function to log in
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', true);
                    updateLoginStatus(true);
                  },
                  child: Text('Iniciar Sesión'),
                ),
              ],
            ),
            ///// REGISTRO /////
            TextButton(
              child: Text('No tienes una cuenta? Registrate'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            ),
            ///// FIN /////
          ],
        ),
      ),
    );
  }
}
