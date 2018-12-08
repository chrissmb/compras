class Compra {
  int id;
  String descricao;
  bool status;

  Compra(this.id, this.descricao, this.status)
      : assert(descricao != null),
        assert(descricao != ''),
        assert(id != null),
        assert(id > 0),
        assert(status != null);

  Compra.novo(this.descricao)
      : status = false,
        assert(descricao != null),
        assert(descricao != '');

  Compra.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    descricao = map['descricao'];
    status = map['status'] == 1 ? true : false;
  }

  toMap() {
    var map = <String, dynamic>{
      'descricao': descricao,
      'status': status,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
