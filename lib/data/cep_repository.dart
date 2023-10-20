import 'package:cep_app/models/cep_model.dart';
import 'package:dio/dio.dart';

class CepRepository {
  static final dio = Dio();
  static String? resultado;
  static bool deuCerto = false;
  static var cepModel;

  static getCep(cep) async {
    try {
      var response = await dio.get('https://viacep.com.br/ws/$cep/json/');

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['erro'] == true) {
          resultado = 'Erro. O cep informado não existe.';
          deuCerto = false;
        } else {
          // O JSON não contém erro, prossiga com o processamento normal.
          cepModel = CepModel.fromJson(responseData);
          resultado =
              "${cepModel.localidade} - ${cepModel.uf}\n${cepModel.logradouro} - ${cepModel.cep}\n${cepModel.bairro}.";
          deuCerto = true;
        }
      }
    } catch (e) {
      resultado = "Cep não encontrado!";
      deuCerto = false;
    }
  }
}
