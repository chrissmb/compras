import 'package:compras/schema/grupo.dart';
import 'package:flutter/material.dart';
import '../service/compraProvider.dart';
import '../schema/compra.dart';

class FormCompra extends StatefulWidget {
  final CompraProvider provider;

  FormCompra(this.provider);

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
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextFormField(
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
                  if (valor?.trim().isEmpty ?? true) {
                    return 'Por favor, digite a descrição';
                  }
                },
              ),
              Autocomplete<Grupo>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return Iterable<Grupo>.empty();
                  }
                  return Iterable<Grupo>.empty();
                },
              )
            ]
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
    if (_formKey.currentState?.validate() ?? false) {
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
