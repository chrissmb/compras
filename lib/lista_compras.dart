import 'package:flutter/material.dart';
import 'compra.dart';
import 'comprasProvider.dart';
import 'form_compra.dart';

class ListaCompras extends StatefulWidget {
  @override
  ListaComprasState createState() => ListaComprasState();
}

class ListaComprasState extends State<ListaCompras> {
  List<Compra> _compras;
  ComprasProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ComprasProvider();
    _provider.open().then((d) {
      _getCompras();
    });
  }

  @override
  void dispose() {
    _provider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _getCompras(),
          ),
        ],
      ),
      body: ListView(
        children: getListTiles(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormCompra(_provider)));
        },
      ),
    );
  }

  List<ListTile> getListTiles() {
    if (_compras == null) return List<ListTile>();
    return _compras.map<ListTile>((compra) {
      return formatListTile(compra);
    }).toList();
  }

  ListTile formatListTile(Compra compra) {
    if (compra.status) {
      return ListTile(
        leading: CircleAvatar(
          child: Text(compra.descricao[0]),
          backgroundColor: Colors.grey,
        ),
        title: Text(compra.descricao),
        onTap: () => _switchStatus(compra),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          child: Text(compra.descricao[0]),
          backgroundColor: Colors.blue,
        ),
        title: Text(
          compra.descricao,
          style: TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        onTap: () => _switchStatus(compra),
      );
    }
  }

  void _switchStatus(Compra compra) {
    setState(() {
      compra.status = !compra.status;
    });
  }

  void _getCompras() {
    _provider.getALl().then((l) {
      setState(() {
        _compras = l;
      });
    });
  }
}
