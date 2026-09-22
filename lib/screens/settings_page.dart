import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Card(
            elevation: 0,

            child: ListTile(
              leading: const Icon(
                Icons.notifications_outlined,
              ),

              title: const Text(
                'Notifications',
              ),

              subtitle: const Text(
                'Manage schedule reminders',
              ),

              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),

          Card(
            elevation: 0,

            child: ListTile(
              leading: const Icon(
                Icons.dark_mode_outlined,
              ),

              title: const Text(
                'Dark Mode',
              ),

              subtitle: const Text(
                'Change application theme',
              ),

              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ),

          Card(
            elevation: 0,

            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),

              title: const Text(
                'About',
              ),

              subtitle: const Text(
                'Schedule Planner',
              ),

              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName:
                      'Schedule Planner',
                  applicationVersion:
                      '1.0.0',
                  applicationLegalese:
                      'Flutter Application',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}