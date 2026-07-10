import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Online/Offline toggle
          Switch(
            value: _isOnline,
            onChanged: (value) {
              setState(() => _isOnline = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? 'You are now online' : 'You are now offline'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            activeThumbColor: Colors.green,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Center(
              child: Text('Online'),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh dashboard data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isOnline ? Colors.green : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.check_circle : Icons.circle,
                    color: _isOnline ? Colors.green : Colors.grey,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOnline ? 'You are Online' : 'You are Offline',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        _isOnline
                            ? 'Ready to accept new jobs'
                            : 'Toggle online to receive jobs',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.work,
                    label: 'Available Jobs',
                    value: '12',
                    color: Colors.blue,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.attach_money,
                    label: "Today's Earnings",
                    value: 'SAR 240',
                    color: Colors.green,
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_outline,
                    label: 'Completed',
                    value: '8',
                    color: Colors.teal,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending,
                    label: 'Pending',
                    value: '3',
                    color: Colors.orange,
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent jobs header
            Text(
              'Recent Jobs',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Placeholder job items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.cleaning_services,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text('Job #${1000 + index}'),
                    subtitle: Text('Service location ${index + 1}'),
                    trailing: Chip(
                      label: Text(
                        ['Pending', 'In Progress', 'Completed'][index],
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: [
                        Colors.orange.shade100,
                        Colors.blue.shade100,
                        Colors.green.shade100,
                      ][index],
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
