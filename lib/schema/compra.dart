import 'grupo.dart';
import 'default_bean.dart';

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
        status = map['status'] == 1 ? true : false ,
        grupo = map['grupo_id'] != null ? Grupo(map['grupo_id'], map['grupo_descricao']) : null;

  @override
  toMap() {
    return <String, dynamic>{
      'descricao': descricao,
      'status': status,
      'id': id,
      'grupo_id': grupo?.id
    };
  }
}
