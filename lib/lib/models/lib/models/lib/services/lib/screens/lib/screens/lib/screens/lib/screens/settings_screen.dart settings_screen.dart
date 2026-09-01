import 'package:flutter/material.dart';
import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  final Settings settings;
  final Function(Settings) onSave;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onSave,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _ownerPercentController;
  late TextEditingController _driverPercentController;
  late TextEditingController _ownerFixedController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankAccountController;
  late TextEditingController _bkashController;
  late TextEditingController _nagadController;
  late TextEditingController _contactController;
  late bool _useFixed;

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _ownerPercentController =
        TextEditingController(text: s.ownerPercent.toString());
    _driverPercentController =
        TextEditingController(text: s.driverPercent.toString());
    _ownerFixedController =
        TextEditingController(text: s.ownerFixed.toString());
    _bankNameController = TextEditingController(text: s.bankName);
    _bankAccountController = TextEditingController(text: s.bankAccount);
    _bkashController = TextEditingController(text: s.bkash);
    _nagadController = TextEditingController(text: s.nagad);
    _contactController = TextEditingController(text: s.contact);
    _useFixed = s.useFixed;
  }

  @override
  void dispose() {
    _ownerPercentController.dispose();
    _driverPercentController.dispose();
    _ownerFixedController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _bkashController.dispose();
    _nagadController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _save() {
    final ownerPercent = double.tryParse(_ownerPercentController.text) ?? 0;
    final driverPercent = double.tryParse(_driverPercentController.text) ?? 0;
    final ownerFixed = double.tryParse(_ownerFixedController.text) ?? 0;

    // Validate: if percentage mode, sum should be 100
    if (!_useFixed && ownerPercent + driverPercent != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('শতাংশের যোগফল ১০০ হতে হবে')),
      );
      return;
    }

    final settings = Settings(
      ownerPercent: ownerPercent,
      driverPercent: driverPercent,
      ownerFixed: ownerFixed,
      useFixed: _useFixed,
      bankName: _bankNameController.text,
      bankAccount: _bankAccountController.text,
      bkash: _bkashController.text,
      nagad: _nagadController.text,
      contact: _contactController.text,
    );
    widget.onSave(settings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('ফিক্সড শেয়ার ব্যবহার করুন'),
              subtitle: const Text('চালু করলে শতাংশের বদলে মালিকের ফিক্সড টাকা কাটা হবে'),
              value: _useFixed,
              onChanged: (val) => setState(() => _useFixed = val),
            ),
            const SizedBox(height: 16),
            if (!_useFixed) ...[
              TextField(
                controller: _ownerPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'মালিকের শতাংশ (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _driverPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ড্রাইভারের শতাংশ (%)',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              TextField(
                controller: _ownerFixedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'মালিকের ফিক্সড টাকা',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text('ব্যাংক তথ্য', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                labelText: 'ব্যাংকের নাম',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bankAccountController,
              decoration: const InputDecoration(
                labelText: 'হিসাব নম্বর',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bkashController,
              decoration: const InputDecoration(
                labelText: 'বিকাশ নম্বর',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nagadController,
              decoration: const InputDecoration(
                labelText: 'নগদ নম্বর',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('যোগাযোগ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'ফোন নম্বর বা ঠিকানা',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
