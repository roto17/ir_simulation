import 'package:bloc/bloc.dart';
import 'package:ir_simulation/cubit/app_cubit_states.dart';

class AppCubits extends Cubit<CubitStates>{
  AppCubits():super(InitialState()){

  emit(WelcomeState());

  }

  void goToLogin(){

    emit(LoadingState());

    emit(LoginState());

  }

  void goToMain(){

    emit(LoadingState());

    emit(MainState());

  }

}