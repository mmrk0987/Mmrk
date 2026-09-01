import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final String currentRole;
  final Function(String) onRoleChange;

  const InfoScreen({
    super.key,
    required this.currentRole,
    required this.onRoleChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          leading: Icon(Icons.info),
          title: Text('Car Hisab'),
          subtitle: Text('গাড়ির ট্রিপ, আয়-ব্যয় ও মালিক/ড্রাইভার শেয়ার হিসাব'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('বর্তমান ভূমিকা'),
          trailing: DropdownButton<String>(
            value: currentRole,
            items: const [
              DropdownMenuItem(value: 'owner', child: Text('মালিক')),
              DropdownMenuItem(value: 'driver', child: Text('ড্রাইভার')),
            ],
            onChanged: (value) {
              if (value != null) {
                onRoleChange(value);
              }
            },
          ),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.business),
          title: Text('ব্র্যান্ড/প্রতিষ্ঠাতা'),
          subtitle: Text('আপনার নাম/কোম্পানি'),
        ),
        const ListTile(
          leading: Icon(Icons.phone),
          title: Text('যোগাযোগ'),
          subtitle: Text('ফোন: +৮৮০ ১XXX-XXXXXX'),
        ),
      ],
    );
  }
}
