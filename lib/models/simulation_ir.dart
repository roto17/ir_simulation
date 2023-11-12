import 'package:ir_simulation/models/attribute.dart';

class SimulationIr{

  static double nbrKids = 0;
  static double baseSalary = 0;
  static double imposables = 0;
  static double Exoneres = 0;
  static double brute = 0;
  static double sNI = 0;
  static double IRBrute = 0;
  static double IRNet = 0;
  static double netSalary = 0;

  static var attributeList = <String,Attribute>{
    'nbrKids'             :  Attribute(name: 'Nombre des enfants', value: 0,isPercentage: false),
    'baseSalary'          :  Attribute(name: 'Salaire de Base', value: 20027.9,isPercentage: false),
    'indemTransport'      :  Attribute(name: 'Indemnité de transport', value: 500,isPercentage: false),
    'indemPanier'         :  Attribute(name: 'Indemnité de panier', value: 700,isPercentage: false),
    'indemFonction'       :  Attribute(name: 'Indemnité de fonction', value: 0,isPercentage: false),
    'retenuesCNSS'        :  Attribute(name: "Retenues CNSS part salariale", value: 4.48, isPercentage: true,isLockedEditing: true),
    'retenuesAMO'         :  Attribute(name: "Retenues AMO part salariale", value: 2.26, isPercentage: true,isLockedEditing: true),
    'retenuesMutuelle'    :  Attribute(name: "Retenues mutuelle", value: 2.51, isPercentage: true),
    'fraisProfessionnels' :  Attribute(name: "Frais professionnels", value: 0, isPercentage: true,isLockedEditing: true),
    'cimr'                :  Attribute(name: "CIMR", value: 0, isPercentage: true),
  };

}