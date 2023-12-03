import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ir_simulation/cubit/app_cubits.dart';
import 'package:ir_simulation/pages/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ir_simulation/pages/main_pages/credits_page.dart';
import 'package:ir_simulation/pages/main_pages/main_page_sub.dart';
import 'package:ir_simulation/pages/main_pages/instruction_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {


  List pages = [
    const MainPageSub(),
    const InstructionPage(),
    const CreditsPage()

  ];
  int currentIndex = 0;

  void onTape(int index){
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> logout() async{

    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    FirebaseAuth.instance.signOut();

  }



  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              logout();
              globals.sharedPreferences!.setString('email', '');
              BlocProvider.of<AppCubits>(context).goToLogin();
            },
          )
        ],
        title:  Text("${AppLocalizations.of(context)!.hello} ${globals.sharedPreferences!.getString('email')}",style: const TextStyle(color: Colors.white,fontSize: 15),),
        backgroundColor: Colors.blue,
      ),
      body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: onTape,
          currentIndex: currentIndex,
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(label: AppLocalizations.of(context)!.home,tooltip: AppLocalizations.of(context)!.home,icon: const Icon(FontAwesomeIcons.house)),
            BottomNavigationBarItem(label: AppLocalizations.of(context)!.instructions,tooltip: AppLocalizations.of(context)!.instructions,icon: const Icon(FontAwesomeIcons.compass)),
            BottomNavigationBarItem(label: AppLocalizations.of(context)!.credits,tooltip: AppLocalizations.of(context)!.credits,icon: const Icon(FontAwesomeIcons.copyright)),
          ],
        )

    );
  }
}

