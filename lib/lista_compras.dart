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
        onPressed: () async {
          var retorno = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormCompra(_provider)));
          if (retorno == null) {
            _getCompras();
          }
        },
      ),
    );
  }

  List<ListTile> getListTiles() {
    if (_compras == null) return List<ListTile>();
    return _compras.map<ListTile>((compra) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        leading: CircleAvatar(
          radius: 25.0,
          child: Text('${compra.id}'),
          backgroundColor: compra.status ? Colors.grey : Colors.blue,
        ),
        title: Text(
          compra.descricao,
          style: TextStyle(
            fontSize: 20.0,
            color: compra.status ? Colors.grey : Colors.black,
            decoration: compra.status
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        onTap: () => _switchStatus(compra),
      );
    }).toList();
  }

  void _switchStatus(Compra compra) {
    setState(() {
      compra.status = !compra.status;
    });
    _provider.save(compra);
  }

  void _getCompras() {
    _provider.getALl().then((l) {
      setState(() {
        _compras = l;
      });
    });
  }
}
