import 'package:flutter/material.dart';
import 'lista_compras.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Compras'),
        ),
        // TODO: Configurar body
        body: ListaCompras(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () => print('teste'),
        ),
      ),
    );
  }

}