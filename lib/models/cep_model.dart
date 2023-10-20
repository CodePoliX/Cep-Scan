class CepModel {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;

  CepModel.fromJson(Map<String, dynamic> json) {
    cep = json['cep'] as String? ?? '';
    logradouro = json['logradouro'] as String? ?? '';
    complemento = json['complemento'] as String? ?? '';
    bairro = json['bairro'] as String? ?? '';
    localidade = json['localidade'] as String? ?? '';
    uf = json['uf'] as String? ?? '';
    ibge = json['ibge'] as String? ?? '';
    gia = json['gia'] as String? ?? '';
    ddd = json['ddd'] as String? ?? '';
    siafi = json['siafi'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }
}
