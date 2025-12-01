import 'package:flutter/material.dart';
import '../providers/app_state.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  DateTime? eventDate;
  DateTime? reminderDate;

  Future<void> pickEventDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (time == null) return;

    setState(() {
      eventDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> pickReminder() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;

    setState(() {
      reminderDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Event")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),

            ListTile(
              title: Text(
                eventDate == null ? "Pick Event Date" : "Event: $eventDate",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickEventDate,
            ),

            ListTile(
              title: Text(
                reminderDate == null
                    ? "Pick Reminder (optional)"
                    : "Reminder: $reminderDate",
              ),
              trailing: const Icon(Icons.alarm),
              onTap: pickReminder,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (eventDate == null) return;

                await state.addEvent(
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  dateTime: eventDate!,
                  reminderTime: reminderDate,
                );

                Navigator.pop(context);
              },
              child: const Text("Save Event"),
            ),
          ],
        ),
      ),
    );
  }
}
