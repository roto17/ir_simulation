class Attribute{
  String name;
  double value;
  bool isPercentage;

  Attribute({
    required this.name,
    required this.value,
    this.isPercentage = false
  });
}