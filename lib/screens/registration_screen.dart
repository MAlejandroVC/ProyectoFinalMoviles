import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Nombre de Usuario',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ingresa tu nombre de usuario',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Dirección de Correo Electrónico',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ingresa tu correo electrónico',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Contraseña',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Ingresa tu contraseña',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Placeholder: Implementar función para registrar usuario
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
