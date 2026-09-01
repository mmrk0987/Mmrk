import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripFormSheet extends StatefulWidget {
  final Trip? existingTrip; // null for new trip

  const TripFormSheet({super.key, this.existingTrip});

  @override
  State<TripFormSheet> createState() => _TripFormSheetState();
}

class _TripFormSheetState extends State<TripFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _placeController;
  late TextEditingController _rentController;
  late TextEditingController _utilityController;
  late TextEditingController _maintenanceController;
  late TextEditingController _paymentController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.existingTrip?.date ?? DateTime.now();
    _dateController = TextEditingController(
        text: _selectedDate.toString().split(' ')[0]);
    _placeController =
        TextEditingController(text: widget.existingTrip?.place ?? '');
    _rentController = TextEditingController(
        text: widget.existingTrip?.rent.toString() ?? '');
    _utilityController = TextEditingController(
        text: widget.existingTrip?.utility.toString() ?? '');
    _maintenanceController = TextEditingController(
        text: widget.existingTrip?.maintenance.toString() ?? '');
    _paymentController = TextEditingController(
        text: widget.existingTrip?.payment.toString() ?? '');
    _noteController =
        TextEditingController(text: widget.existingTrip?.note ?? '');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _placeController.dispose();
    _rentController.dispose();
    _utilityController.dispose();
    _maintenanceController.dispose();
    _paymentController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final trip = Trip(
        id: widget.existingTrip?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDate,
        place: _placeController.text.trim(),
        rent: double.parse(_rentController.text),
        utility: double.parse(_utilityController.text),
        maintenance: double.parse(_maintenanceController.text),
        payment: double.parse(_paymentController.text),
        note: _noteController.text.trim(),
      );
      Navigator.pop(context, trip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.existingTrip == null ? 'নতুন ট্রিপ যোগ করুন' : 'ট্রিপ সম্পাদনা',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'তারিখ',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'তারিখ দিন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'স্থান',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'স্থান লিখুন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ভাড়া (টাকা)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v!.isEmpty) return 'ভাড়া দিন';
                  if (double.tryParse(v) == null) return 'সঠিক সংখ্যা দিন';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _utilityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ইউটিলিটি/তেল খরচ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v!.isEmpty) return 'খরচ দিন';
                  if (double.tryParse(v) == null) return 'সঠিক সংখ্যা দিন';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _maintenanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'মেইনটেন্যান্স',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v!.isEmpty) return 'খরচ দিন';
                  if (double.tryParse(v) == null) return 'সঠিক সংখ্যা দিন';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _paymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'পেমেন্ট (ড্রাইভার থেকে মালিককে)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v!.isEmpty) return 'পেমেন্ট দিন';
                  if (double.tryParse(v) == null) return 'সঠিক সংখ্যা দিন';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'নোট (ঐচ্ছিক)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('সংরক্ষণ'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('বাতিল'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
