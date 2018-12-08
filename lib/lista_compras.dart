import 'package:flutter/material.dart';
import 'compra.dart';
import 'comprasProvider.dart';
import 'form_compra.dart';

enum menu { deleteChecked, deleteAll }

typedef void FuncaoMenu();

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
          PopupMenuButton<menu>(
            onSelected: selectItemMenu,
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => <PopupMenuEntry<menu>>[
              const PopupMenuItem(
                value: menu.deleteChecked,
                child: Text('Deletar compras selecionadas'),
              ),
              const PopupMenuItem(
                value: menu.deleteAll,
                child: Text('Deletar todas compras'),
              ),
            ],
          )
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

  void selectItemMenu(dynamic choice) {
    switch (choice) {
      case menu.deleteChecked:
        _dialogMenu('Deseja realmente deletar '
            'as compras selecionadas?', _deleteChecked);
        break;
      case menu.deleteAll:
        _dialogMenu('Deseja realmente deletar '
            'todas as compras?', _deleteAllCompras);
        break;
    }
    _getCompras();
  }

  void _deleteChecked() {
    _compras.forEach((compra) {
      if (compra.status) {
        _provider.delete(compra.id);
      }
    });
    _getCompras();
  }

  void _deleteAllCompras() {
    _compras.forEach((compra) {
      _provider.delete(compra.id);
    });
    _getCompras();
  }

  Future<void> _dialogMenu(String msg, FuncaoMenu func) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Atenção'),
        content: SingleChildScrollView(
          child: Text(msg),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Confirmar'),
            onPressed: () {
              func();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
