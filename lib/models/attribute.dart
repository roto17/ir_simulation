class Attribute{
  String name;
  String nameEN;
  double value;
  bool isPercentage;
  bool isLockedEditing;
  Attribute({
    required this.name,
    required this.nameEN,
    required this.value,
    this.isPercentage = false,
    this.isLockedEditing = false
  });
}