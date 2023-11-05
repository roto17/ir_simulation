class Indemnite{
  String name;
  double value;
  bool isTaxed;
  Indemnite({
    required this.name,
    required this.value,
    this.isTaxed = false
  });
}