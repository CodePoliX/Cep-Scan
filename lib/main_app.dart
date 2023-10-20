import 'package:cep_app/lista_cep.dart';
import 'package:cep_app/procurador_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainAppPage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryTextTheme: GoogleFonts.josefinSansTextTheme(),
      ),
    );
  }
}

class MainAppPage extends StatefulWidget {
  const MainAppPage({Key? key}) : super(key: key);

  @override
  MainAppPageState createState() => MainAppPageState();
}

class MainAppPageState extends State<MainAppPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CepScan'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: const <Widget>[
          ProcuradorPage(),
          ListaCep(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        unselectedItemColor:
            Colors.white, // Cor dos ícones não selecionados (branco)
        selectedItemColor: const Color.fromARGB(255, 43, 42, 42),
        currentIndex: _currentPage,
        onTap: (int page) {
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'lista',
          ),
        ],
      ),
    );
  }
}
