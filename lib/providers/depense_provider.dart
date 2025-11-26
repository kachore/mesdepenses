import 'package:flutter/material.dart';
import '../models/depense.dart';
import '../utils/database_helper.dart';

class DepenseProvider extends ChangeNotifier {
List<Depense> _depenses = [];
final DatabaseHelper _db = DatabaseHelper.instance;

List<Depense> get depenses => _depenses;

Future<void> loadDepenses() async {
_depenses = await _db.readAll();
notifyListeners();
}

Future<void> addDepense(Depense depense) async {
await _db.create(depense);
await loadDepenses();
}

Future<void> updateDepense(Depense depense) async {
await _db.update(depense);
await loadDepenses();
}

Future<void> deleteDepense(int id) async {
await _db.delete(id);
await loadDepenses();
}

/// Retourne le total des dépenses entre [start] inclus et [end] exclus.
double getTotalByPeriod(DateTime start, DateTime end) {
return _depenses
.where((d) => !d.date.isBefore(start) && d.date.isBefore(end))
.fold(0.0, (sum, d) => sum + d.montant);
}

/// Retourne le total des dépenses par catégorie
Map<String, double> getCategoriesTotal() {
Map<String, double> totals = {};
for (var d in _depenses) {
totals[d.categorie] = (totals[d.categorie] ?? 0) + d.montant;
}
return totals;
}

/// Méthodes utilitaires pour obtenir les périodes courantes
double getTotalToday() {
final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);
return getTotalByPeriod(today, today.add(const Duration(days: 1)));
}

double getTotalThisWeek() {
final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);
final weekStart = today.subtract(Duration(days: now.weekday - 1));
return getTotalByPeriod(weekStart, today.add(const Duration(days: 1)));
}

double getTotalThisMonth() {
final now = DateTime.now();
final monthStart = DateTime(now.year, now.month, 1);
final today = DateTime(now.year, now.month, now.day);
return getTotalByPeriod(monthStart, today.add(const Duration(days: 1)));
}

double getTotalThisYear() {
final now = DateTime.now();
final yearStart = DateTime(now.year, 1, 1);
final today = DateTime(now.year, now.month, now.day);
return getTotalByPeriod(yearStart, today.add(const Duration(days: 1)));
}
}
