class Trip {
  final String id;
  final DateTime date;
  final String place;
  final double rent;
  final double utility;
  final double maintenance;
  final double payment;
  final String note;

  Trip({
    required this.id,
    required this.date,
    required this.place,
    required this.rent,
    required this.utility,
    required this.maintenance,
    required this.payment,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'place': place,
        'rent': rent,
        'utility': utility,
        'maintenance': maintenance,
        'payment': payment,
        'note': note,
      };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'],
        date: DateTime.parse(json['date']),
        place: json['place'],
        rent: json['rent'].toDouble(),
        utility: json['utility'].toDouble(),
        maintenance: json['maintenance'].toDouble(),
        payment: json['payment'].toDouble(),
        note: json['note'] ?? '',
      );
}
