import 'package:flutter/material.dart';
import '../models/event.dart';
import '../providers/app_state.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late TextEditingController _title;
  late TextEditingController _desc;

  DateTime? reminder;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.event.title);
    _desc = TextEditingController(text: widget.event.description);
    reminder = widget.event.reminderTime;
  }

  Future<void> pickReminder() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: reminder ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;

    setState(() {
      reminder =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await state.deleteEvent(event.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),

            ListTile(
              title: Text("Event Date: ${event.dateTime}"),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: Text(reminder == null
                  ? "No Reminder"
                  : "Reminder: $reminder"),
              trailing: const Icon(Icons.alarm),
              onTap: pickReminder,
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final updated = event.copyWith(
                  title: _title.text,
                  description: _desc.text,
                  reminderTime: reminder,
                );

                await state.updateEvent(updated);
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }
}
