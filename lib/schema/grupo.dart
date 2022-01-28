import 'defaultBean.dart';

class Grupo implements DefaultBean {
  int? id;
  String descricao;

  Grupo(this.id, this.descricao)
      : assert((id ?? 0) > 0),
        assert(descricao.trim().isNotEmpty);

  Grupo.novo(this.descricao) : assert(descricao.trim().isNotEmpty);

  Grupo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        descricao = map['descricao'];

  toMap() {
    return <String, dynamic>{'id': id, 'descricao': descricao};
  }
}
