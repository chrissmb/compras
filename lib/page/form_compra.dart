import 'package:compras/component/error_window.dart';
import 'package:compras/core/injetor.dart';
import 'package:compras/schema/grupo.dart';
import 'package:compras/service/grupo_provider.dart';
import 'package:flutter/material.dart';
import '../service/compra_provider.dart';
import '../schema/compra.dart';

class FormCompra extends StatefulWidget {
  final Compra? compra;

  FormCompra(this.compra);

  @override
  FormCompraState createState() => FormCompraState();
}

class FormCompraState extends State<FormCompra> {
  final _formKey = GlobalKey<FormState>();
  final _txtDescricaoCtrl = TextEditingController();
  TextEditingController? _txtGrupoCtrl;
  final _compraProvider = Injetor.instance<CompraProvider>();
  final _grupoProvider = Injetor.instance<GrupoProvider>();
  var _grupos = <Grupo>[];
  Grupo? _grupoSelecionado;

  @override
  void initState() {
    super.initState();
    aplicarGrupos();
    preencherDescricao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digite a descrição'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(padding: EdgeInsets.all(20), children: [
            TextFormField(
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
              controller: _txtDescricaoCtrl,
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
                return _grupos.where((grupo) => grupo.descricao
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (grupo) => _grupoSelecionado = grupo,
              displayStringForOption: (option) => option.descricao,
              fieldViewBuilder:
                  (buildContext, txtController, focuNode, onFieldSubmit) {
                _txtGrupoCtrl = txtController;
                preencherGrupo(txtController);
                return TextFormField(
                  controller: txtController,
                  focusNode: focuNode,
                  decoration: const InputDecoration(
                    labelText: 'Grupo',
                    labelStyle: TextStyle(fontSize: 30.0),
                  ),
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                );
              },
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
        onPressed: saveCompra,
      ),
    );
  }

  void saveCompra() {
    if (!(_formKey.currentState?.validate() ?? true)) {
      return;
    }
    Compra? compra = widget.compra;
    if (compra == null) {
      compra = Compra.novo(_txtDescricaoCtrl.text.trim(), null);
    } else {
      compra.descricao = _txtDescricaoCtrl.text.trim();
    }
    compra.grupo = _grupoSelecionado;
    var txtGrupo = _txtGrupoCtrl?.text.trim() ?? '';
    var callbackNavigatorPop = (_) => Navigator.pop(context);
    if (compra.grupo != null || (txtGrupo.isEmpty)) {
      _compraProvider.save(compra).then(callbackNavigatorPop,
          onError: (e) => ErrorWindow.showError(e, context));
    } else {
      _compraProvider
          .saveWithGrupo(compra, txtGrupo)
          .then(callbackNavigatorPop);
    }
  }

  void aplicarGrupos() {
    _grupoProvider.getAll().then((value) => _grupos = value,
        onError: (e) =>
            ErrorWindow.showError('Erro ao obter grupos: $e', context));
  }

  void preencherDescricao() {
    var compra = widget.compra;
    if (compra == null) return;
    _txtDescricaoCtrl.text = compra.descricao;
  }

  void preencherGrupo(TextEditingController textEditingController) {
    var compra = widget.compra;
    if (compra == null) return;
    textEditingController.text = compra.grupo?.descricao ?? '';
  }
}
