import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'celestial_gallery_screen.dart';


class LoginScreen extends StatelessWidget {
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
                  onPressed: () {
                    // TODO: Implement function to log in
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CelestialGalleryScreen()),
                    );
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
