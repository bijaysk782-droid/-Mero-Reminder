import 'package:flutter/material.dart';

void main() {
  runApp(const MeroReminderApp());
}

class MeroReminderApp extends StatelessWidget {
  const MeroReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mero Reminder',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff7f8fc),
      ),
      home: const HomePage(),
    );
  }
}

class ReminderItem {
  final String type;
  final String title;
  final DateTime expiry;
  final IconData icon;

  const ReminderItem({
    required this.type,
    required this.title,
    required this.expiry,
    required this.icon,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ReminderItem> items = [
    ReminderItem(
      type: 'Driving License',
      title: 'Driving License',
      expiry: DateTime(2026, 12, 20),
      icon: Icons.badge_outlined,
    ),
    ReminderItem(
      type: 'Vehicle Tax',
      title: 'Bluebook / Tax',
      expiry: DateTime(2026, 10, 15),
      icon: Icons.directions_car_outlined,
    ),
    ReminderItem(
      type: 'Insurance',
      title: 'Vehicle Insurance',
      expiry: DateTime(2027, 1, 8),
      icon: Icons.shield_outlined,
    ),
    ReminderItem(
      type: 'Passport',
      title: 'Passport',
      expiry: DateTime(2029, 4, 16),
      icon: Icons.travel_explore_outlined,
    ),
  ];

  int getDaysLeft(DateTime date) =>
      date.difference(DateTime.now()).inDays;

  String dateText(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Color statusColor(int days) {
    if (days < 0) return Colors.grey;
    if (days <= 7) return Colors.red;
    if (days <= 30) return Colors.orange;
    return Colors.green;
  }

  String statusText(int days) {
    if (days < 0) return 'Expired';
    if (days == 0) return 'Expires today';
    return '$days days left';
  }

  Future<void> addReminder() async {
    final result = await Navigator.push<ReminderItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddReminderPage()),
    );
    if (result != null) {
      setState(() => items.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final expiring = [...items]
      ..sort((a, b) => a.expiry.compareTo(b.expiry));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mero Reminder',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addReminder,
        icon: const Icon(Icons.add),
        label: const Text('Add Document'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          const Text('नमस्ते 👋',
              style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 4),
          const Text('तपाईंका Renewal / Expiry यहाँ सुरक्षित राख्नुहोस्',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'Total',
                  '${items.length}',
                  Icons.folder_copy_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryCard(
                  '30 days',
                  '${items.where((e) => getDaysLeft(e.expiry) >= 0 && getDaysLeft(e.expiry) <= 30).length}',
                  Icons.warning_amber_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryCard(
                  'Expired',
                  '${items.where((e) => getDaysLeft(e.expiry) < 0).length}',
                  Icons.error_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          const Text('My Documents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ...expiring.map((item) {
            final days = getDaysLeft(item.expiry);
            final color = statusColor(days);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                leading: CircleAvatar(
                  child: Icon(item.icon),
                ),
                title: Text(item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Expiry: ${dateText(item.expiry)}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(statusText(days),
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(item.type,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54)),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.security_outlined),
              title: const Text('Document Vault'),
              subtitle: const Text('पछि PDF / Photo सुरक्षित राख्न मिल्ने'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.family_restroom_outlined),
              title: const Text('Family Members'),
              subtitle: const Text('परिवारका सदस्यका document पनि राख्नुहोस्'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 7),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final title = TextEditingController();
  String type = 'Driving License';
  DateTime? expiry;

  final types = const [
    'Driving License',
    'Bluebook / Tax',
    'Insurance',
    'Passport',
    'Warranty',
    'Subscription',
    'Other',
  ];

  IconData get icon {
    switch (type) {
      case 'Driving License':
        return Icons.badge_outlined;
      case 'Bluebook / Tax':
        return Icons.directions_car_outlined;
      case 'Insurance':
        return Icons.shield_outlined;
      case 'Passport':
        return Icons.travel_explore_outlined;
      case 'Warranty':
        return Icons.build_outlined;
      case 'Subscription':
        return Icons.subscriptions_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 20),
      initialDate: now,
    );
    if (picked != null) setState(() => expiry = picked);
  }

  void save() {
    if (title.text.trim().isEmpty || expiry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title र Expiry Date भर्नुहोस्।')),
      );
      return;
    }

    Navigator.pop(
      context,
      ReminderItem(
        type: type,
        title: title.text.trim(),
        expiry: expiry!,
        icon: icon,
      ),
    );
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Document')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: type,
            decoration: const InputDecoration(
              labelText: 'Document Type',
              border: OutlineInputBorder(),
            ),
            items: types
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => type = v!),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: title,
            decoration: const InputDecoration(
              labelText: 'Document Name / Number',
              hintText: 'जस्तै: BA 01 PA 1234',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Expiry / Renewal Date',
                border: OutlineInputBorder(),
              ),
              child: Text(
                expiry == null
                    ? 'Date छान्नुहोस्'
                    : '${expiry!.day}/${expiry!.month}/${expiry!.year}',
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: (_) {},
                  title: const Text('Automatic Reminder'),
                  subtitle: const Text('30, 15, 7, 3 र 1 दिन अगाडि'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save_outlined),
            label: const Padding(
              padding: EdgeInsets.all(13),
              child: Text('Save Document'),
            ),
          ),
        ],
      ),
    );
  }
}
