import '../screens/farm_model.dart';

/// قاعدة بيانات وهمية مشتركة بين الفارمر والشوبر
class MockFarmsDB {
  static List<Farm> farms = [
    Farm(
      id: '1',
      name: 'Al Noor Farm',
      location: 'Jeddah - Asfan Road',
      fruits: ['Apple', 'Orange', 'Banana'],
      isArchived: false,
    ),
    Farm(
      id: '2',
      name: 'Green Valley',
      location: 'Taif - Al Hada',
      fruits: ['Strawberry', 'Grapes', 'Lemon'],
      isArchived: false,
    ),
    Farm(
      id: '3',
      name: 'Palm Oasis',
      location: 'Madinah - Quba',
      fruits: ['Majdool Dates', 'Sukary Dates', 'Asil Dates'],
      isArchived: false,
    ),
    Farm(
      id: '4',
      name: 'Sunrise Orchard',
      location: 'Abha - Al Soudah',
      fruits: ['Kiwi', 'Apple', 'Orange'],
      isArchived: true, // هذه ما تظهر للشوبر
    ),
  ];

  static void addFarm(Farm farm) {
    farms.add(farm);
  }

  static List<Farm> getActiveFarms() {
    return farms.where((f) => !f.isArchived).toList();
  }
}
