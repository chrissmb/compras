import 'package:flutter/material.dart';
import 'page/lista_compras.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      home: ListaCompras(),
    );
  }
}
