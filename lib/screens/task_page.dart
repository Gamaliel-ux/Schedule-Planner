import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../tasks/add_task_page.dart';
import '../tasks/task_card.dart';
import '../services/notification_service.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() =>
      _TaskPageState();
}

class _TaskPageState
    extends State<TaskPage> {
  List<Map<String, dynamic>> tasks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadTasks();
  }

  // =========================================================
  // LOAD
  // =========================================================

  Future<void> loadTasks() async {
    final data =
        await DatabaseHelper.instance
            .getTasks();

    if (!mounted) return;

    setState(() {
      tasks = data;
      isLoading = false;
    });
  }

  // =========================================================
  // ADD
  // =========================================================

  Future<void> addTask() async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddTaskPage();
        },
      ),
    );

    if (result == true) {
      await loadTasks();
    }
  }

  // =========================================================
  // EDIT
  // =========================================================

  Future<void> editTask(
    Map<String, dynamic> task,
  ) async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddTaskPage(
            task: task,
          );
        },
      ),
    );

    if (result == true) {
      await loadTasks();
    }
  }

  // =========================================================
  // COMPLETE
  // =========================================================

  Future<void> toggleTask(
    Map<String, dynamic> task,
  ) async {
    final completed =
        task['completed'] == 1;

    await DatabaseHelper.instance
        .updateTask(
      task['id'],
      {
        'completed':
            completed ? 0 : 1,
      },
    );

    await loadTasks();
  }

  // =========================================================
  // DELETE
  // =========================================================

  Future<void> deleteTask(
    Map<String, dynamic> task,
  ) async {
    await NotificationService.instance
        .cancelNotification(
      task['id'],
    );

    await DatabaseHelper.instance
        .deleteTask(
      task['id'],
    );

    await loadTasks();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Tasks'),

        actions: [
          IconButton(
            onPressed:
                addTask,

            icon:
                const Icon(
              Icons.add,
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : tasks.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada task.',
                    style:
                        TextStyle(
                      fontSize: 16,
                      color:
                          Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  itemCount:
                      tasks.length,

                  itemBuilder:
                      (context, index) {
                    final task =
                        tasks[index];

                    return Card(
                      margin:
                          const EdgeInsets
                              .only(
                        bottom: 12,
                      ),

                      elevation: 0,

                      child:
                          Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleTask(
                                task,
                              );
                            },

                            child:
                                TaskCard(
                              title:
                                  task['title'],

                              time:
                                  task['due_time'],

                              priority:
                                  task['priority'],

                              completed:
                                  task['completed'] ==
                                      1,
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets
                                    .only(
                              left: 16,
                              right: 16,
                              bottom: 10,
                            ),

                            child:
                                Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .end,

                              children: [
                                TextButton
                                    .icon(
                                  onPressed:
                                      () {
                                    editTask(
                                      task,
                                    );
                                  },

                                  icon:
                                      const Icon(
                                    Icons.edit,
                                    size: 18,
                                  ),

                                  label:
                                      const Text(
                                    'Edit',
                                  ),
                                ),

                                TextButton
                                    .icon(
                                  onPressed:
                                      () {
                                    deleteTask(
                                      task,
                                    );
                                  },

                                  icon:
                                      const Icon(
                                    Icons.delete,
                                    size: 18,
                                  ),

                                  label:
                                      const Text(
                                    'Delete',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

      floatingActionButton:
          FloatingActionButton(
        onPressed:
            addTask,

        child:
            const Icon(
          Icons.add,
        ),
      ),
    );
  }
}