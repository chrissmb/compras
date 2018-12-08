import 'package:flutter/material.dart';
import 'comprasProvider.dart';
import 'compra.dart';

class FormCompra extends StatefulWidget {
  final ComprasProvider provider;

  FormCompra(this.provider) : assert(provider != null);

  @override
  FormCompraState createState() => FormCompraState();
}

class FormCompraState extends State<FormCompra> {
  final _formKey = GlobalKey<FormState>();
  var txtDescricaoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digite a descrição'),
      ),
      body: Form(
        key: _formKey,
        child: TextField(
          controller: txtDescricaoCtrl,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: saveCompra,
      ),
    );
  }

  void saveCompra() {
    widget.provider.save(
      Compra.novo(txtDescricaoCtrl.text),
    ).then((id) {
      Navigator.pop(context);
    });
  }
}
