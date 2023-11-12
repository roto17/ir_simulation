class Attribute{
  String name;
  double value;
  bool isPercentage;
  bool isLockedEditing;
  Attribute({
    required this.name,
    required this.value,
    this.isPercentage = false,
    this.isLockedEditing = false
  });
}