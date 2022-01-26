import 'defaultBean.dart';

class Grupo implements DefaultBean {
  int id;
  String descricao;

  Grupo(this.id, this.descricao)
      : assert(id != null),
        assert(id > 0),
        assert(descricao != null),
        assert(descricao != '');


  Grupo.novo(this.descricao)
      : assert(descricao != null),
        assert(descricao != '');

  Grupo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    descricao = map['descricao'];
  }

  toMap() {
    return <String, dynamic> {
      'id': id,
      'descricao': descricao
    };
  }
}
