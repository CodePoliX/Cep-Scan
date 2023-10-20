import 'package:cep_app/models/cep_model.dart';
import 'package:dio/dio.dart';

class CepBack4App {
  Dio dio = Dio();
  String existe = "";
  bool carregando = true;

  var headers = {
    'X-Parse-Application-Id': 'KOrHnUyvGhuB1pEZXQ3aAyodClPA0JJ4OZCVHqhc',
    'X-Parse-REST-API-Key': '0TCuWkay7ZfwwI0i1AsPsFy6biSUL5ieDzuq9til',
    'Content-Type': 'application/json',
  };

  Future<void> salvar(CepModel cep) async {
    if (await verificarDuplicatas(cep)) {
      Map<String, dynamic> cepMap =
          cep.toJson(); // Converte o objeto CepModel em um mapa
      var resposta = await dio.post(
        "https://parseapi.back4app.com/parse/classes/ceps/",
        data: cepMap, // Use o mapa como dados na solicitação
        options: Options(headers: headers),
      );
      carregando = false;
      print(resposta);
      existe = "Cep salvo com Sucesso!";
    } else {
      existe = "Esse cep já está salvo!";
    }
  }

  Future<bool> verificarDuplicatas(CepModel cep) async {
    var response = await dio.get(
      "https://parseapi.back4app.com/parse/classes/ceps/",
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      List<CepModel> itensDaAPI = (response.data['results'] as List)
          .map((item) => CepModel.fromJson(item))
          .toList();

      // Verificar duplicatas
      if (itensDaAPI.any((item) => item.cep == cep.cep)) {
        return false; // O CEP já está presente na API, retorne false
      }
    }

    return true; // Nenhum CEP está presente na API, retorne true
  }

  Future<int> quantidadeCep() async {
    var response = await dio.get(
      "https://parseapi.back4app.com/parse/classes/ceps/",
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      // Verifique se a resposta contém informações sobre a quantidade de objetos
      if (response.data.containsKey('count')) {
        int totalObjetos = response.data['count'];
        return totalObjetos;
      }
    }

    return 0; // Retorne 0 se não for possível obter a contagem
  }

  Future<List<CepModel>> obterCepsDaAPI() async {
    var ceps = await dio.get(
      "https://parseapi.back4app.com/parse/classes/ceps/",
      options: Options(headers: headers),
    );

    if (ceps.statusCode == 200) {
      List<dynamic> data = ceps.data['results'] as List;
      List<CepModel> listaDeCeps =
          data.map((item) => CepModel.fromJson(item)).toList();
      return listaDeCeps;
    } else {
      throw Exception('Falha ao obter CEPs da API');
    }
  }

  Future<bool> deletarCep(String cep) async {
    Dio dio = Dio();
    String apiKey =
        'S0TCuWkay7ZfwwI0i1AsPsFy6biSUL5ieDzuq9til'; // Substitua pelo seu próprio API Key
    String className = 'ceps'; // Substitua pelo nome da classe

    // Passo 1: Consulta para obter o objectId do objeto com base no CEP
    try {
      Response response = await dio.get(
        'https://parseapi.back4app.com/classes/$className?where={"cep":"$cep"}&limit=1',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> results = response.data['results'];
        if (results.isNotEmpty) {
          String objectId = results[0]['objectId'];

          // Passo 2: Excluir o objeto com base no objectId
          Response deleteResponse = await dio.delete(
            'https://parseapi.back4app.com/classes/$className/$objectId',
            options: Options(headers: headers),
          );

          if (deleteResponse.statusCode == 200) {
            return true; // Exclusão bem-sucedida
          }
        }
      }
    } catch (e) {
      print('Erro na solicitação: $e');
    }

    return false; // Falha na exclusão
  }
}
