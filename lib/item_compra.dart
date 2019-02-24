import 'package:flutter/material.dart';
import 'compra.dart';


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
    @required this.compra,
    @required this.switchStatus,
    @required this.excluiCompra,
    @required this.renameCompra,
  }): assert(
    compra != null
    && switchStatus != null
    && excluiCompra != null
    && renameCompra != null
  );

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
    return GestureDetector(
      onHorizontalDragEnd: (_) => widget.excluiCompra(compra.id),
      onTap: () => widget.switchStatus(compra),
      onLongPress: _alternaEdicao,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        leading: CircleAvatar(
          radius: 25.0,
          child: Text(
            compra.descricao[0],
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: compra.status ? Colors.grey : Colors.blue,
        ),
        title: _edicao? _getItemInput() : _getItemLabel(),
      ),
    );
  }

  Widget _getItemLabel() {
    Compra compra = widget.compra;
    return Text(
      compra.descricao,
      style: TextStyle(
        fontSize: 20.0,
        color: compra.status ? Colors.grey : Colors.black,
        decoration: compra.status
            ? TextDecoration.lineThrough
            : TextDecoration.none,
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
                if (val.trim().isEmpty) {
                  return 'Por favor, digite a descrição';
                }
              },
              onFieldSubmitted: (_) => _renameCompra,
              onEditingComplete: _renameCompra,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.done),
          onPressed: _renameCompra,
        ),
      ],
    );
  }

  void _alternaEdicao() {
    setState(() {
      _edicao = !_edicao;      
    });
  }

  void _renameCompra() {
    if (!_formKey.currentState.validate()) return;
    Compra  compra = widget.compra;
    compra.descricao = _txtController.text;
    widget.renameCompra(widget.compra);
    _alternaEdicao();
  }

}