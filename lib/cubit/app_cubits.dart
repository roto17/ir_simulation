import 'package:bloc/bloc.dart';
import 'package:ir_simulation/cubit/app_cubit_states.dart';
import 'package:ir_simulation/pages/globals.dart' as globals;
import 'package:ir_simulation/models/simulation_ir.dart';

class AppCubits extends Cubit<CubitStates>{

  AppCubits():super(InitialState()){

    final attributeList = SimulationIr.attributeList;
    if( globals.sharedPreferences!.getString( 'email' ) != '' && globals.sharedPreferences!.getString( 'email' ) != null && globals.sharedPreferences!.getString( 'email' ) != 'null' ){
      emit( MainState(attributeList) );
    }else if( globals.sharedPreferences!.getBool('visitedWelcomePage') == true ){
       emit( LoginState() );
     }else{
       emit (WelcomeState() );
     }

  }

  void goToLogin(){

    emit(LoadingState());
    final attributeList = SimulationIr.attributeList;
    if(globals.sharedPreferences!.getString( 'email' ) != '' && globals.sharedPreferences!.getString( 'email' ) != null && globals.sharedPreferences!.getString( 'email' ) != 'null' ){
      emit( MainState(attributeList) );
    }else{
      emit(LoginState());
    }

  }

  void goToMain(){

    final attributeList = SimulationIr.attributeList;
    emit(LoadingState());
    emit(MainState(attributeList));

  }

}