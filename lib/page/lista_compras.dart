import 'package:compras/core/injetor.dart';
import 'package:flutter/material.dart';
import '../schema/compra.dart';
import '../service/compra_provider.dart';
import '../page/form_compra.dart';
import '../component/item_compra.dart';
import '../component/error_window.dart';

enum menu { deleteChecked, deleteAll }

typedef void FuncaoMenu();

class ListaCompras extends StatefulWidget {
  @override
  ListaComprasState createState() => ListaComprasState();
}

class ListaComprasState extends State<ListaCompras> {
  List<Compra> _compras = [];
  CompraProvider _provider = Injetor.instance<CompraProvider>();
  List<ItemCompra> _listItem = [];

  @override
  void initState() {
    super.initState();
    _getCompras();
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
        children: _listItem,
      ),
      floatingActionButton: _isKeyboardActive()
          ? Text('')
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FormCompra(null)));
                _getCompras();
              },
            ),
    );
  }

  void _getListTiles() {
    List<ItemCompra> listItem = [];

    for (var compra in _compras) {
      listItem.add(ItemCompra(
        compra: compra,
        switchStatus: _switchStatus,
        refreshCompras: _getCompras,
        excluiCompra: _confirmaExclusaoLongPress,
      ));
    }
    setState(() {
      _listItem = listItem;
    });
  }

  void renomeia(Compra compra) {
    _provider.save(compra).then((_) => _getCompras);
  }

  void _confirmaExclusaoLongPress(int idCompra) {
    _dialogMenu('Deseja realmente exluir este item?', () {
      _provider.delete(idCompra);
      _getCompras();
    }, cancel: () {
      _getCompras();
    });
  }

  void _switchStatus(Compra compra) {
    compra.status = !compra.status;
    _provider.save(compra);
    setState(() {
      _getCompras();
    });
  }

  void _getCompras() {
    _provider.getAll().then((l) {
      setState(() {
        _compras = l;
        _getListTiles();
      });
    }, onError: (e) => ErrorWindow.showError(e, context));
  }

  void selectItemMenu(dynamic choice) {
    switch (choice) {
      case menu.deleteChecked:
        _dialogMenu(
            'Deseja realmente deletar '
            'as compras selecionadas?',
            _deleteChecked);
        break;
      case menu.deleteAll:
        _dialogMenu(
            'Deseja realmente deletar '
            'todas as compras?',
            _deleteAllCompras);
        break;
    }
  }

  void _deleteChecked() {
    _deleteCheckedAsync().then((value) => _getCompras(),
        onError: (e) => ErrorWindow.showError(e, context));
  }

  Future<void> _deleteCheckedAsync() async {
    for (var compra in _compras) {
      if (compra.status) {
        await _provider.delete(compra.id!);
      }
    }
  }

  void _deleteAllCompras() {
    _provider.deleteAll().then((_) => _getCompras(),
        onError: (e) => ErrorWindow.showError(e, context));
  }

  Future<void> _dialogMenu(String msg, FuncaoMenu func,
      {FuncaoMenu? cancel}) async {
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
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                if (cancel != null) cancel();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
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

  bool _isKeyboardActive() {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }
}
