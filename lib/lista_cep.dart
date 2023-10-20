import 'package:cep_app/data/cep_back4app.dart';
import 'package:cep_app/models/cep_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ListaCep extends StatefulWidget {
  const ListaCep({Key? key}) : super(key: key);

  @override
  ListaCepState createState() => ListaCepState();
}

class ListaCepState extends State<ListaCep> {
  Dio dio = Dio();
  CepBack4App server = CepBack4App();
  List<CepModel> ceps = [];

  @override
  void initState() {
    super.initState();
    carregarCeps();
  }

  Future<void> carregarCeps() async {
    try {
      var listaCeps = await server.obterCepsDaAPI();
      setState(() {
        ceps = listaCeps;
      });
    } catch (e) {
      print("Erro ao carregar CEPs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 254, 254),
      body: FutureBuilder<int>(
        future: server.quantidadeCep(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar a lista: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: ceps.length,
              itemBuilder: (context, index) {
                final cep = ceps[index];
                return ListTile(
                  title: Text("${cep.localidade!} - ${cep.bairro}"),
                  subtitle: Text(cep.cep!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (index < ceps.length) {
                        // Verifique se o índice é válido
                        server
                            .deletarCep(ceps[index].cep.toString())
                            .then((success) {
                          if (success) {
                            setState(() {
                              ceps.removeAt(index);
                            });
                          } else {
                            // Trate o erro de exclusão, se necessário
                            print("Erro ao excluir o CEP do servidor");
                          }
                        });
                      }
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Sem dados disponíveis.'));
        },
      ),
    );
  }
}
