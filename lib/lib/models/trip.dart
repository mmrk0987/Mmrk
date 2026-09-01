class Settings {
  final double ownerPercent;
  final double driverPercent;
  final double ownerFixed;
  final bool useFixed; // true = fixed, false = percentage
  final String bankName;
  final String bankAccount;
  final String bkash;
  final String nagad;
  final String contact;

  Settings({
    required this.ownerPercent,
    required this.driverPercent,
    required this.ownerFixed,
    required this.useFixed,
    this.bankName = '',
    this.bankAccount = '',
    this.bkash = '',
    this.nagad = '',
    this.contact = '',
  });

  Map<String, dynamic> toJson() => {
        'ownerPercent': ownerPercent,
        'driverPercent': driverPercent,
        'ownerFixed': ownerFixed,
        'useFixed': useFixed,
        'bankName': bankName,
        'bankAccount': bankAccount,
        'bkash': bkash,
        'nagad': nagad,
        'contact': contact,
      };

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        ownerPercent: json['ownerPercent'].toDouble(),
        driverPercent: json['driverPercent'].toDouble(),
        ownerFixed: json['ownerFixed'].toDouble(),
        useFixed: json['useFixed'] ?? false,
        bankName: json['bankName'] ?? '',
        bankAccount: json['bankAccount'] ?? '',
        bkash: json['bkash'] ?? '',
        nagad: json['nagad'] ?? '',
        contact: json['contact'] ?? '',
      );

  static Settings defaultSettings() => Settings(
        ownerPercent: 50,
        driverPercent: 50,
        ownerFixed: 0,
        useFixed: false,
      );
}
