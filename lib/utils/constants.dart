import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> categories = [
    'Alimentation',
    'Transport',
    'Logement',
    'Santé',
    'Loisirs',
    'Shopping',
    'Éducation',
    'Autres',
  ];

  static const Map<String, IconData> categoryIcons = {
    'Alimentation': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Logement': Icons.home,
    'Santé': Icons.local_hospital,
    'Loisirs': Icons.sports_esports,
    'Shopping': Icons.shopping_bag,
    'Éducation': Icons.school,
    'Autres': Icons.more_horiz,
  };

  static const Map<String, Color> categoryColors = {
    'Alimentation': Colors.orange,
    'Transport': Colors.blue,
    'Logement': Colors.green,
    'Santé': Colors.red,
    'Loisirs': Colors.purple,
    'Shopping': Colors.pink,
    'Éducation': Colors.teal,
    'Autres': Colors.grey,
  };
}