import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../schedule/schedule_card.dart';
import '../tasks/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> schedules = [];
  List<Map<String, dynamic>> tasks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadDashboardData();
  }

  // ==========================================================
  // LOAD DATA
  // ==========================================================

  Future<void> loadDashboardData() async {
    final scheduleData =
        await DatabaseHelper.instance.getSchedules();

    final taskData =
        await DatabaseHelper.instance.getTasks();

    if (!mounted) return;

    setState(() {
      schedules = scheduleData;
      tasks = taskData;
      isLoading = false;
    });
  }

  // ==========================================================
  // GREETING
  // ==========================================================

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning 👋';
    }

    if (hour >= 12 && hour < 18) {
      return 'Good Afternoon 👋';
    }

    return 'Good Evening 👋';
  }

  // ==========================================================
  // CHECK TODAY
  // ==========================================================

  bool isToday(String? dateString) {
    if (dateString == null) {
      return false;
    }

    final date = DateTime.tryParse(dateString);

    if (date == null) {
      return false;
    }

    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // ==========================================================
  // FORMAT DATE
  // ==========================================================

  String getTodayText() {
    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final todaySchedules = schedules
        .where(
          (schedule) => isToday(
            schedule['date'],
          ),
        )
        .toList();

    final todayTasks = tasks
        .where(
          (task) => isToday(
            task['due_date'],
          ),
        )
        .toList();

    final completedTasks = todayTasks
        .where(
          (task) => task['completed'] == 1,
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule Planner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadDashboardData,

              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // GREETING
                    // ==================================================

                    Text(
                      getGreeting(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      getTodayText(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // SUMMARY
                    // ==================================================

                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            icon:
                                Icons.calendar_month,
                            title: 'Schedule',
                            value:
                                todaySchedules.length
                                    .toString(),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.task_alt,
                            title: 'Tasks',
                            value:
                                todayTasks.length
                                    .toString(),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _SummaryCard(
                            icon:
                                Icons.check_circle,
                            title: 'Done',
                            value:
                                completedTasks
                                    .toString(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ==================================================
                    // TODAY'S SCHEDULE
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Today's Schedule",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          '${todaySchedules.length} item',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (todaySchedules.isEmpty)
                      _EmptyCard(
                        icon:
                            Icons.calendar_today,
                        message:
                            'Tidak ada schedule hari ini.',
                      )
                    else
                      ...todaySchedules.map(
                        (schedule) {
                          return ScheduleCard(
                            time:
                                '${schedule['start_time']} - ${schedule['end_time']}',
                            title:
                                schedule['title'],
                            location:
                                schedule['location'] ??
                                    '-',
                          );
                        },
                      ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // TODAY'S TASK
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Today's Tasks",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          '$completedTasks/${todayTasks.length} done',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (todayTasks.isEmpty)
                      _EmptyCard(
                        icon: Icons.task_alt,
                        message:
                            'Tidak ada task hari ini.',
                      )
                    else
                      ...todayTasks.map(
                        (task) {
                          return TaskCard(
                            title:
                                task['title'],
                            time:
                                task['due_time'],
                            priority:
                                task['priority'],
                            completed:
                                task['completed'] ==
                                    1,
                          );
                        },
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}

// ==========================================================
// SUMMARY CARD
// ==========================================================

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// EMPTY CARD
// ==========================================================

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyCard({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,

      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Center(
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.grey,
              ),

              const SizedBox(height: 10),

              Text(
                message,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}