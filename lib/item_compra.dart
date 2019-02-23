import 'package:flutter/material.dart';
import 'compra.dart';


typedef SimpleAction = void Function();
typedef ActionDynamic = void Function(dynamic x);
typedef ActionCompra = void Function(Compra compra);
typedef ActionInt = void Function(int id);

class ItemCompra extends StatefulWidget {

  Compra compra;
  int index;
  ActionCompra switchStatus;
  ActionInt excluiCompra;
  ActionDynamic onHorizontalDrangEnd;

  ItemCompra({
    @required this.compra,
    @required this.index,
    @required this.switchStatus,
    @required this.excluiCompra,
    @required this.onHorizontalDrangEnd,
  });

  @override
  State<ItemCompra> createState() => _ItemCompraState();

}

class _ItemCompraState extends State<ItemCompra> {
  @override
  Widget build(BuildContext context) {
    Compra compra = widget.compra;
    return  GestureDetector(
          onHorizontalDragEnd: widget.onHorizontalDrangEnd,
          onTap: () => widget.switchStatus(compra),
          onLongPress: () => widget.excluiCompra(compra.id),
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
          ),
        );
  }

}