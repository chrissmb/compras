import 'package:flutter/material.dart';
import '../service/compraProvider.dart';
import '../schema/compra.dart';

class FormCompra extends StatefulWidget {
  final CompraProvider provider;

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
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              onFieldSubmitted: (s) => saveCompra(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
              controller: txtDescricaoCtrl,
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(fontSize: 30.0),
              ),
              validator: (valor) {
                if (valor.trim().isEmpty) {
                  return 'Por favor, digite a descrição';
                }
              },
            ),
          ),
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
    if (_formKey.currentState.validate()) {
      widget.provider
          .save(
        Compra.novo(txtDescricaoCtrl.text.trim(), null),
      )
          .then((id) {
        Navigator.pop(context);
      });
    }
  }
}
