import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/pastel_background.dart';
import 'event_details_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final events = state.events;

    return PastelBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Schedule"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: events
              .map(
                (e) => Card(
              child: ListTile(
                title: Text(e.title),
                subtitle: Text(e.dateTime.toString()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsScreen(event: e),
                  ),
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
