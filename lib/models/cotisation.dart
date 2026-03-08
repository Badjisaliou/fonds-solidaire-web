class Cotisation {
  final int id;
  final String montant;
  final String description;
  final String date;

  Cotisation({
    required this.id,
    required this.montant,
    required this.description,
    required this.date,
  });

  factory Cotisation.fromJson(Map<String, dynamic> json) {
    return Cotisation(
      id: json['id'],
      montant: json['montant'],
      description: json['description'] ?? '',
      date: json['date'],
    );
  }
}
