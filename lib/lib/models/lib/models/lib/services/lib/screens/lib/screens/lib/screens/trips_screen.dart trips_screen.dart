import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../widgets/trip_form_sheet.dart';

class TripsScreen extends StatefulWidget {
  final List<Trip> trips;
  final Function(Trip) onAddTrip;
  final Function(Trip) onUpdateTrip;
  final Function(String) onDeleteTrip;
  final bool isOwner;

  const TripsScreen({
    super.key,
    required this.trips,
    required this.onAddTrip,
    required this.onUpdateTrip,
    required this.onDeleteTrip,
    required this.isOwner,
  });

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  Future<void> _showAddTripForm() async {
    final result = await showModalBottomSheet<Trip>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const TripFormSheet(),
    );
    if (result != null) {
      widget.onAddTrip(result);
    }
  }

  Future<void> _showEditTripForm(Trip trip) async {
    final result = await showModalBottomSheet<Trip>(
      context: context,
      isScrollControlled: true,
      builder: (context) => TripFormSheet(existingTrip: trip),
    );
    if (result != null) {
      widget.onUpdateTrip(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.trips.isEmpty
          ? const Center(child: Text('কোনো ট্রিপ নেই'))
          : ListView.builder(
              itemCount: widget.trips.length,
              itemBuilder: (context, index) {
                final trip = widget.trips[index];
                return ListTile(
                  title: Text(trip.place),
                  subtitle: Text(
                      '${trip.date.toString().split(' ')[0]}  |  ভাড়া: ৳${trip.rent}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditTripForm(trip),
                      ),
                      if (widget.isOwner)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => widget.onDeleteTrip(trip.id),
                        ),
                    ],
                  ),
                  onTap: () => _showEditTripForm(trip),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTripForm,
        child: const Icon(Icons.add),
        tooltip: 'নতুন ট্রিপ',
      ),
    );
  }
}
