import 'package:compras/page/form_compra.dart';
import 'package:flutter/material.dart';
import '../schema/compra.dart';

// typedef SimpleAction = void Function();
// typedef ActionDynamic = void Function(dynamic x);
// typedef ActionCompra = void Function(Compra compra);
// typedef ActionInt = void Function(int id);

class ItemCompra extends StatefulWidget {
  final Compra compra;
  void Function(Compra compra) switchStatus;
  void Function() refreshCompras;
  void Function(int id) excluiCompra;

  ItemCompra({
    required this.compra,
    required this.switchStatus,
    required this.refreshCompras,
    required this.excluiCompra,
  });

  @override
  State<ItemCompra> createState() => _ItemCompraState();
}

class _ItemCompraState extends State<ItemCompra> {
  bool _edicao = false;
  var _txtController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Compra compra = widget.compra;
    return Dismissible(
      key: ObjectKey(compra),
      onDismissed: (d) => widget.excluiCompra(compra.id!),
      child: ListTile(
        onTap: () => widget.switchStatus(compra),
        onLongPress: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormCompra(compra)));
          widget.refreshCompras();
        }, //_alternaEdicao,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        leading: _getAvatar(),
        title: _getItemLabel(),
      ),
    );
  }

  Widget _getAvatar() {
    Compra compra = widget.compra;
    return CircleAvatar(
      radius: 25.0,
      child: Text(
        compra.descricao[0],
        style: TextStyle(fontSize: 25.0),
      ),
      backgroundColor: compra.status ? Colors.grey : Colors.blue,
    );
  }

  Widget _getItemLabel() {
    Compra compra = widget.compra;
    return Text(
      '${compra.descricao} - ${compra.grupo?.descricao ?? ''}',
      style: TextStyle(
        fontSize: 20.0,
        color: compra.status ? Colors.grey : Colors.black,
        decoration:
            compra.status ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }
}
