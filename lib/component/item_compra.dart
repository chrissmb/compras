import 'package:flutter/material.dart';
import '../schema/compra.dart';

typedef SimpleAction = void Function();
typedef ActionDynamic = void Function(dynamic x);
typedef ActionCompra = void Function(Compra compra);
typedef ActionInt = void Function(int id);

class ItemCompra extends StatefulWidget {
  final Compra compra;
  final ActionCompra switchStatus;
  final ActionInt excluiCompra;
  final ActionCompra renameCompra;

  ItemCompra({
    required this.compra,
    required this.switchStatus,
    required this.excluiCompra,
    required this.renameCompra,
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
        onLongPress: _alternaEdicao,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        leading: _edicao ? _getConfirme() : _getAvatar(),
        title: _edicao ? _getItemInput() : _getItemLabel(),
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

  Widget _getItemInput() {
    _txtController.text = widget.compra.descricao;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _txtController,
              validator: (val) {
                if (val?.trim().isEmpty ?? true) {
                  return 'Por favor, digite a descrição';
                }
              },
              onFieldSubmitted: (_) => _renameCompra,
              onEditingComplete: _renameCompra,
            ),
          ),
        ),
        _getCancel(),
      ],
    );
  }

  Widget _getConfirme() {
    return IconButton(
      icon: Icon(
        Icons.done,
        color: Colors.green,
      ),
      onPressed: _renameCompra,
    );
  }

  Widget _getCancel() {
    return IconButton(
      icon: Icon(
        Icons.cancel,
        color: Colors.red,
      ),
      onPressed: _alternaEdicao,
    );
  }

  void _alternaEdicao() {
    setState(() {
      _edicao = !_edicao;
    });
  }

  void _renameCompra() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Compra compra = widget.compra;
    compra.descricao = _txtController.text;
    widget.renameCompra(widget.compra);
    _alternaEdicao();
  }
}
