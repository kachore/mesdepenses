import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/depense_provider.dart';
import '../utils/constants.dart';
import '../widgets/stat_card.dart';

class StatisticsScreen extends StatelessWidget {
const StatisticsScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Statistiques')),
body: Consumer<DepenseProvider>(
builder: (context, provider, child) {
final totalToday = provider.getTotalToday();
final totalWeek = provider.getTotalThisWeek();
final totalMonth = provider.getTotalThisMonth();
final totalYear = provider.getTotalThisYear();
final categories = provider.getCategoriesTotal();
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Vue d\'ensemble',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          StatCard(
            title: 'Aujourd\'hui',
            amount: totalToday,
            icon: Icons.today,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Cette Semaine',
            amount: totalWeek,
            icon: Icons.calendar_view_week,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Ce Mois',
            amount: totalMonth,
            icon: Icons.calendar_month,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          StatCard(
            title: 'Cette Année',
            amount: totalYear,
            icon: Icons.calendar_today,
            color: Colors.purple,
          ),
          const SizedBox(height: 32),
          Text(
            'Par Catégorie',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (categories.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Aucune donnée disponible'),
              ),
            )
          else
            ...categories.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    AppConstants.categoryIcons[entry.key] ?? Icons.category,
                    color: AppConstants.categoryColors[entry.key] ?? Colors.grey,
                  ),
                  title: Text(entry.key),
                  trailing: Text(
                    '${entry.value.toStringAsFixed(2)} FCFA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              );
            }).toList(),
        ],
      );
    },
  ),
);
}
}
