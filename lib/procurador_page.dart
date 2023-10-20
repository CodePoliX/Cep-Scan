import 'package:cep_app/data/cep_back4app.dart';
import 'package:cep_app/data/cep_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProcuradorPage extends StatefulWidget {
  const ProcuradorPage({super.key});

  @override
  State<ProcuradorPage> createState() => _ProcuradorPageState();
}

class _ProcuradorPageState extends State<ProcuradorPage> {
  TextEditingController cepControler = TextEditingController();
  CepBack4App server = CepBack4App();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 202, 254, 254),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    const Icon(
                      Icons.map,
                      color: Colors.green,
                      size: 150,
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: TextField(
                    controller: cepControler,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Digite seu CEP:",
                        labelStyle: TextStyle(fontWeight: FontWeight.w700),
                        prefixIcon: Icon(Icons.place_outlined)),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () async {
                      await CepRepository.getCep(cepControler.text.isEmpty
                          ? "00000000"
                          : cepControler.text);
                      if (CepRepository.deuCerto) {
                        //ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                title: const Text(
                                  "Cep encontrado!",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 205, 255, 231)),
                                ),
                                content: Text(
                                  CepRepository.resultado!,
                                  style: const TextStyle(
                                      color: Color.fromARGB(180, 0, 0, 0)),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await server
                                            .salvar(CepRepository.cepModel);
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(server.existe)),
                                        );
                                      },
                                      child: const Text(
                                        "Salvar",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 205, 255, 231),
                                            fontSize: 16),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Dispensar",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 205, 255, 231),
                                              fontSize: 16))),
                                ],
                                elevation: 24.0,
                                backgroundColor: Colors.green,
                                shape:
                                    Border.all(width: 1, color: Colors.white)));
                      }
                      setState(() {});
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green)),
                    child: const Text(
                      "Procurar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
