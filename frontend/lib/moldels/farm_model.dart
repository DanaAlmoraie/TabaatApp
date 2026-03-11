class Farm {
  final int id;
  final String name;
  final String location;
  final List<String> fruits;
  final bool isOpen;
  final double? latitude;
  final double? longitude;

  Farm({
    required this.id,
    required this.name,
    required this.location,
    required this.fruits,
    required this.isOpen,
    this.latitude,
    this.longitude,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      fruits: List<String>.from(json['fruits'] ?? []),
      isOpen: json['is_open'] ?? true,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
