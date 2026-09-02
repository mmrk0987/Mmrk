import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CarHisabApp());
}

class CarHisabApp extends StatelessWidget {
  const CarHisabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Hisab',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// ===============================
// TRIP MODEL
// ===============================

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

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'].toString(),
      date: DateTime.parse(json['date'].toString()),
      place: json['place'].toString(),
      rent: (json['rent'] as num).toDouble(),
      utility: (json['utility'] as num).toDouble(),
      maintenance: (json['maintenance'] as num).toDouble(),
      payment: (json['payment'] as num).toDouble(),
      note: json['note']?.toString() ?? '',
    );
  }
}

// ===============================
// HOME PAGE
// ===============================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Trip> trips = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  // ===============================
  // LOAD DATA
  // ===============================

  Future<void> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('trips');

    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);

      setState(() {
        trips = decoded
            .map((item) => Trip.fromJson(item))
            .toList()
            .cast<Trip>();

        trips.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  // ===============================
  // SAVE DATA
  // ===============================

  Future<void> saveTrips() async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(
      trips.map((trip) => trip.toJson()).toList(),
    );

    await prefs.setString('trips', data);
  }

  // ===============================
  // ADD TRIP
  // ===============================

  Future<void> addTrip(Trip trip) async {
    setState(() {
      trips.insert(0, trip);
    });

    await saveTrips();
  }

  // ===============================
  // DELETE TRIP
  // ===============================

  Future<void> deleteTrip(int index) async {
    final trip = trips[index];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Trip?'),
          content: Text(
            'Are you sure you want to delete the trip to ${trip.place}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        trips.removeAt(index);
      });

      await saveTrips();
    }
  }

  // ===============================
  // TOTALS
  // ===============================

  double get totalRent =>
      trips.fold(0, (sum, trip) => sum + trip.rent);

  double get totalUtility =>
      trips.fold(0, (sum, trip) => sum + trip.utility);

  double get totalMaintenance =>
      trips.fold(0, (sum, trip) => sum + trip.maintenance);

  double get totalPayment =>
      trips.fold(0, (sum, trip) => sum + trip.payment);

  double get totalExpense =>
      totalRent + totalUtility + totalMaintenance;

  double get balance =>
      totalPayment - totalExpense;

  // ===============================
  // UI
  // ===============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Car Hisab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // ===============================
          // SUMMARY
          // ===============================

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Trips',
                        value: trips.length.toString(),
                        icon: Icons.directions_car,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SummaryCard(
                        title: 'Payment',
                        value: totalPayment.toStringAsFixed(0),
                        icon: Icons.payments,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Expense',
                        value: totalExpense.toStringAsFixed(0),
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SummaryCard(
                        title: 'Balance',
                        value: balance.toStringAsFixed(0),
                        icon: Icons.calculate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // ===============================
          // TRIP LIST
          // ===============================

          Expanded(
            child: trips.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 70,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No trips added yet',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];

                      final expense =
                          trip.rent +
                          trip.utility +
                          trip.maintenance;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            trip.place,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            formatDate(trip.date),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            onPressed: () => deleteTrip(index),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                16,
                              ),
                              child: Column(
                                children: [
                                  InfoRow(
                                    title: 'Rent',
                                    value: trip.rent,
                                  ),
                                  InfoRow(
                                    title: 'Utility',
                                    value: trip.utility,
                                  ),
                                  InfoRow(
                                    title: 'Maintenance',
                                    value: trip.maintenance,
                                  ),
                                  InfoRow(
                                    title: 'Total Expense',
                                    value: expense,
                                    bold: true,
                                  ),
                                  InfoRow(
                                    title: 'Payment',
                                    value: trip.payment,
                                    bold: true,
                                  ),
                                  if (trip.note.isNotEmpty)
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(
                                        Icons.note,
                                      ),
                                      title: const Text('Note'),
                                      subtitle: Text(trip.note),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ===============================
      // ADD BUTTON
      // ===============================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final trip = await Navigator.push<Trip>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTripPage(),
            ),
          );

          if (trip != null) {
            await addTrip(trip);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Trip'),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ===============================
// SUMMARY CARD
// ===============================

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// INFO ROW
// ===============================

class InfoRow extends StatelessWidget {
  final String title;
  final double value;
  final bool bold;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// ADD TRIP PAGE
// ===============================

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final formKey = GlobalKey<FormState>();

  final placeController = TextEditingController();
  final rentController = TextEditingController();
  final utilityController = TextEditingController();
  final maintenanceController = TextEditingController();
  final paymentController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    placeController.dispose();
    rentController.dispose();
    utilityController.dispose();
    maintenanceController.dispose();
    paymentController.dispose();
    noteController.dispose();

    super.dispose();
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  double number(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  void saveTrip() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final trip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: selectedDate,
      place: placeController.text.trim(),
      rent: number(rentController),
      utility: number(utilityController),
      maintenance: number(maintenanceController),
      payment: number(paymentController),
      note: noteController.text.trim(),
    );

    Navigator.pop(context, trip);
  }

  // ===============================
  // UI
  // ===============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // DATE

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Date'),
                subtitle: Text(
                  '${selectedDate.day.toString().padLeft(2, '0')}/'
                  '${selectedDate.month.toString().padLeft(2, '0')}/'
                  '${selectedDate.year}',
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: selectDate,
              ),
            ),

            const SizedBox(height: 12),

            // PLACE

            TextFormField(
              controller: placeController,
              decoration: const InputDecoration(
                labelText: 'Place',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter place';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // RENT

            AmountField(
              controller: rentController,
              label: 'Rent',
              icon: Icons.money,
            ),

            const SizedBox(height: 12),

            // UTILITY

            AmountField(
              controller: utilityController,
              label: 'Utility',
              icon: Icons.electrical_services,
            ),

            const SizedBox(height: 12),

            // MAINTENANCE

            AmountField(
              controller: maintenanceController,
              label: 'Maintenance',
              icon: Icons.build,
            ),

            const SizedBox(height: 12),

            // PAYMENT

            AmountField(
              controller: paymentController,
              label: 'Payment',
              icon: Icons.payments,
            ),

            const SizedBox(height: 12),

            // NOTE

            TextFormField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Note',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // SAVE

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: saveTrip,
                icon: const Icon(Icons.save),
                label: const Text(
                  'SAVE TRIP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// AMOUNT FIELD
// ===============================

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (double.tryParse(value) == null) {
            return 'Enter a valid number';
          }
        }
        return null;
      },
    );
  }
}
