import '../models/trip.dart';
import '../models/settings.dart';

class Summary {
  final double totalRent;
  final double totalUtility;
  final double totalMaintenance;
  final double totalPayment;
  final double netIncome;
  final double ownerShare;
  final double driverShare;

  Summary({
    required this.totalRent,
    required this.totalUtility,
    required this.totalMaintenance,
    required this.totalPayment,
    required this.netIncome,
    required this.ownerShare,
    required this.driverShare,
  });
}

Summary calculateSummary(List<Trip> trips, Settings settings) {
  double totalRent = trips.fold(0, (sum, t) => sum + t.rent);
  double totalUtility = trips.fold(0, (sum, t) => sum + t.utility);
  double totalMaintenance = trips.fold(0, (sum, t) => sum + t.maintenance);
  double totalPayment = trips.fold(0, (sum, t) => sum + t.payment);
  double netIncome = totalRent - totalUtility - totalMaintenance - totalPayment;

  double ownerShare, driverShare;
  if (settings.useFixed) {
    // Fixed amount for owner, remaining for driver
    ownerShare = settings.ownerFixed;
    driverShare = netIncome - ownerShare;
  } else {
    // Percentage based
    ownerShare = netIncome * settings.ownerPercent / 100;
    driverShare = netIncome * settings.driverPercent / 100;
  }

  // Ensure no negative shares if netIncome < 0
  if (netIncome <= 0) {
    ownerShare = 0;
    driverShare = 0;
  }

  return Summary(
    totalRent: totalRent,
    totalUtility: totalUtility,
    totalMaintenance: totalMaintenance,
    totalPayment: totalPayment,
    netIncome: netIncome,
    ownerShare: ownerShare,
    driverShare: driverShare,
  );
}
