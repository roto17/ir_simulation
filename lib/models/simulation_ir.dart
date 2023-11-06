import 'package:ir_simulation/models/indemnite.dart';
import 'package:ir_simulation/models/detention.dart';

class SimulationIr{

  static double nbrKids = 0;
  static double baseSalary = 0;
  static double Taxable = 0;
  static double grossSalary = 0;
  static double sNI = 0;
  static double IRBrute = 0;
  static double IRNet = 0;
  static double netSalary = 0;


  static var indemniteLit = [
    Indemnite(name: "Nombre des enfants", value: 0,isTaxed: false),
    Indemnite(name: "Salaire de Base", value: 20027.9,isTaxed: true),
    Indemnite(name: "Indemnité de transport", value: 500),
    Indemnite(name: "Indemnité de panier", value: 700),
    Indemnite(name: "Indemnité de fonction", value: 0,isTaxed: true),
  ];

  static var detentionList = [
    Detention(name: "Retenues CNSS part salariale", value: 4.48, isPercentage: true, isTaxed: false),
    Detention(name: "Retenues AMO part salariale", value: 2.26, isPercentage: true, isTaxed: false),
    Detention(name: "Retenues mutuelle", value: 2.51, isPercentage: true, isTaxed: false),
    //Detention(name: "Retenues mutuelle", value: 0, isPercentage: true, isTaxed: false),
    Detention(name: "CIMR", value: 6, isPercentage: true, isTaxed: false),
    Detention(name: "Frais professionnels", value: 0, isPercentage: true, isTaxed: false),
    //Detention(name: "Frais professionnels", value: 20, isPercentage: true, isTaxed: false),
  ];

}