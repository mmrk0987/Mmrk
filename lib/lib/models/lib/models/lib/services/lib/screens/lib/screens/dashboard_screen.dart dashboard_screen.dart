import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/settings.dart';
import '../utils/calculations.dart';

class DashboardScreen extends StatelessWidget {
  final List<Trip> trips;
  final Settings settings;
  final String role;

  const DashboardScreen({
    super.key,
    required this.trips,
    required this.settings,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final summary = calculateSummary(trips, settings);
    final isOwner = role == 'owner';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.money),
            title: const Text('মোট ভাড়া'),
            trailing: Text('৳${summary.totalRent.toStringAsFixed(2)}'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('নিট আয়'),
            trailing: Text('৳${summary.netIncome.toStringAsFixed(2)}'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.build),
            title: const Text('মেইনটেন্যান্স'),
            trailing: Text('৳${summary.totalMaintenance.toStringAsFixed(2)}'),
          ),
        ),
        if (isOwner) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('মালিকের শেয়ার'),
              trailing: Text('৳${summary.ownerShare.toStringAsFixed(2)}'),
            ),
          ),
        ],
        Card(
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('ড্রাইভারের শেয়ার'),
            trailing: Text('৳${summary.driverShare.toStringAsFixed(2)}'),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'সাম্প্রতিক ট্রিপ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (trips.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('কোনো ট্রিপ নেই'),
          )
        else
          ...trips.take(5).map((trip) => ListTile(
                title: Text(trip.place),
                subtitle: Text(trip.date.toString().split(' ')[0]),
                trailing: Text('৳${trip.rent.toStringAsFixed(2)}'),
              )),
      ],
    );
  }
}
