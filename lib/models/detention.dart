class Detention{
   String name;
   double value;
   bool isPercentage;
   bool isTaxed;
   bool isLockedDeleting;
   Detention({
     required this.name,
     required this.value,
     required this.isPercentage,
     required this.isTaxed,
     this.isLockedDeleting = true,
   });
}