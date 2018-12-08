import 'package:flutter/material.dart';
import 'compra.dart';
import 'comprasProvider.dart';

class ListaCompras extends StatefulWidget {
  @override
  ListaComprasState createState() => ListaComprasState();
}

class ListaComprasState extends State<ListaCompras> {
  List<Compra> _compras;
  ComprasProvider _provider = ComprasProvider();

  @override
  void initState() {
    super.initState();
    _provider.open('compras.sqlite').then((d) {
      getCompras();
    });
  }

  @override
  void dispose() {
    _provider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <ListTile>[],
    );
  }

  List<ListTile> getListTiles() {
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
        onTap: () => switchStatus(compra),
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
        onTap: () => switchStatus(compra),
      );
    }
  }

  void switchStatus(Compra compra) {
    setState(() {
      compra.status = !compra.status;
    });
  }

  void getCompras() {
    _provider.getALl().then((l) {
      setState(() {
        _compras = l;
      });
    });
  }
}
