class Depense {
  final int? id;
  final String titre;
  final double montant;
  final DateTime date;
  final String categorie;

  Depense({
    this.id,
    required this.titre,
    required this.montant,
    required this.date,
    required this.categorie,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'montant': montant,
      'date': date.toIso8601String(),
      'categorie': categorie,
    };
  }

  factory Depense.fromMap(Map<String, dynamic> map) {
    return Depense(
      id: map['id'],
      titre: map['titre'],
      montant: map['montant'],
      date: DateTime.parse(map['date']),
      categorie: map['categorie'],
    );
  }
}
