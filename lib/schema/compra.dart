import 'grupo.dart';
import 'defaultBean.dart';

class Compra implements DefaultBean {
  int? id;
  String descricao;
  bool status;
  Grupo? grupo;

  Compra(this.id, this.descricao, this.status, this.grupo)
      : assert(descricao.trim().isNotEmpty),
        assert((id ?? 0) > 0);

  Compra.novo(this.descricao, this.grupo)
      : status = false,
        assert(descricao.trim().isNotEmpty);

  Compra.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        descricao = map['descricao'],
        status = map['status'] == 1 ? true : false,
        grupo = new Grupo(map['grupo_id'], map['grupo_descricao']);

  toMap() {
    return <String, dynamic>{
      'descricao': descricao,
      'status': status,
      'id': id,
      'grupo_id': grupo?.id
    };
  }
}
