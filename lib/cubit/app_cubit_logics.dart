import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ir_simulation/cubit/app_cubit_states.dart';
import 'package:ir_simulation/cubit/app_cubits.dart';
import 'package:ir_simulation/pages/login_page.dart';
import 'package:ir_simulation/pages/main_page.dart';
import 'package:ir_simulation/pages/welcome_page.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({super.key});

  @override
  State<AppCubitLogics> createState() => _AppCubitLogicsState();
}

class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits,CubitStates>(
        builder: (context,state){
          if( state is WelcomeState ){
            return const WelcomePage();
          }
          if( state is LoadingState ){
            return const Center(child: CircularProgressIndicator(),);
          }
          if( state is LoginState ){
            return const LoginPage();
          }
          if( state is MainState ){
            return const MainPage();
          }
          else{
            return Container();
          }
        },
      ),
    );
  }
}
