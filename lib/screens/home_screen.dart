import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/pastel_background.dart';
import 'add_event_screen.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final events = state.events;
    final classes = state.classes;

    return PastelBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Dashboard"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEventScreen()),
          ),
          child: const Icon(Icons.add),
        ),
        body: state.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Upcoming Events",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...events.map(
                  (e) => Card(
                child: ListTile(
                  title: Text(e.title),
                  subtitle: Text(e.dateTime.toString()),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailsScreen(event: e),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Class Sessions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...classes.map(
                  (c) => Card(
                child: ListTile(
                  title: Text(c.title),
                  subtitle: Text(
                    "${c.instructor} • ${c.startTime} - ${c.endTime}",
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
