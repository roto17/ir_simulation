import 'package:equatable/equatable.dart';
import 'package:ir_simulation/models/attribute.dart';
abstract class CubitStates extends Equatable{}

class InitialState extends CubitStates{
  @override
  // TODO: implement props
  List<Object> get props => [];

}


class WelcomeState extends CubitStates{
  @override
  // TODO: implement props
  List<Object> get props => [];

}


class LoadingState extends CubitStates{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class LoginState extends CubitStates{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class MainState extends CubitStates{
  MainState(this.attributeList);
  final Map<String,Attribute> attributeList;
  @override
  // TODO: implement props
  List<Object> get props => [attributeList];

}