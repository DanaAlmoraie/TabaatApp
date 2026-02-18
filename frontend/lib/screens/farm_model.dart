// farm_model.dart

class Farm {
  String id;
  String name;
  String location;
  List<String> fruits;
  bool isArchived;

  Farm({
    required this.id,
    required this.name,
    required this.location,
    required this.fruits,
    this.isArchived = false,
  });
}
