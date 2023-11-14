import 'package:bloc/bloc.dart';
import 'package:ir_simulation/cubit/app_cubit_states.dart';
import 'package:ir_simulation/pages/globals.dart' as globals;

class AppCubits extends Cubit<CubitStates>{
  AppCubits():super(InitialState()){

    if( globals.sharedPreferences!.getString( 'email' ) != '' && globals.sharedPreferences!.getString( 'email' ) != null && globals.sharedPreferences!.getString( 'email' ) != 'null' ){
      emit( MainState() );
    }else if( globals.sharedPreferences!.getBool('visitedWelcomePage') == true ){
       emit( LoginState() );
     }else{
       emit (WelcomeState() );
     }

  }

  void goToLogin(){

    print('roto17');
    print(globals.sharedPreferences!.getString('email') );
    emit(LoadingState());

    if(globals.sharedPreferences!.getString('email') != ''){
      emit(MainState());
    }else{
      emit(LoginState());
    }

  }

  void goToMain(){

    emit(LoadingState());

    emit(MainState());

  }

}