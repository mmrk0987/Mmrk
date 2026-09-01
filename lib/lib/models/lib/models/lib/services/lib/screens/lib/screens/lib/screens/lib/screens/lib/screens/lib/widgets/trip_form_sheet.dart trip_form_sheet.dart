import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';
import 'dashboard_screen.dart';
import 'trips_screen.dart';
import 'settings_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> _trips = [];
  Settings _settings = Settings.defaultSettings();
  String _role = 'owner';
  bool _loading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final trips = await StorageService.loadTrips();
    final settings = await StorageService.loadSettings();
    final role = await StorageService.loadRole();
    setState(() {
      _trips = trips;
      _settings = settings;
      _role = role;
      _loading = false;
    });
  }

  Future<void> _saveTrips() async {
    await StorageService.saveTrips(_trips);
  }

  Future<void> _saveSettings() async {
    await StorageService.saveSettings(_settings);
  }

  Future<void> _saveRole(String role) async {
    await StorageService.saveRole(role);
  }

  void _addTrip(Trip trip) {
    setState(() {
      _trips.add(trip);
    });
    _saveTrips();
  }

  void _updateTrip(Trip updatedTrip) {
    setState(() {
      final index = _trips.indexWhere((t) => t.id == updatedTrip.id);
      if (index != -1) {
        _trips[index] = updatedTrip;
      }
    });
    _saveTrips();
  }

  void _deleteTrip(String id) {
    setState(() {
      _trips.removeWhere((t) => t.id == id);
    });
    _saveTrips();
  }

  void _updateSettings(Settings settings) {
    setState(() {
      _settings = settings;
    });
    _saveSettings();
  }

  void _changeRole(String role) {
    setState(() {
      _role = role;
    });
    _saveRole(role);
    // If role changed to driver, hide settings tab and redirect if needed
    if (_role == 'driver' && _currentIndex == 2) {
      setState(() {
        _currentIndex = 0; // Go to dashboard
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Build bottom nav items based on role
    final tabs = <Widget>[
      DashboardScreen(
        trips: _trips,
        settings: _settings,
        role: _role,
      ),
      TripsScreen(
        trips: _trips,
        onAddTrip: _addTrip,
        onUpdateTrip: _updateTrip,
        onDeleteTrip: _deleteTrip,
        isOwner: _role == 'owner',
      ),
      if (_role == 'owner')
        SettingsScreen(
          settings: _settings,
          onSave: _updateSettings,
        ),
      InfoScreen(
        currentRole: _role,
        onRoleChange: _changeRole,
      ),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'ড্যাশবোর্ড',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'ট্রিপ',
          ),
          if (_role == 'owner')
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'সেটিংস',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'তথ্য',
          ),
        ],
      ),
    );
  }
}
