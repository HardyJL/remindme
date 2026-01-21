import 'package:flutter_test/flutter_test.dart';
import 'package:remindme/task.dart';

void main() {
  group('Task Model', () {
    test('should create a task with default values', () {
      final task = Task(createdDate: DateTime.now());

      expect(task.notifactionEnabled, false);
      expect(task.completed, false);
      expect(task.priority, Priority.medium);
    });

    test('should create a task with provided values', () {
      final date = DateTime.now();
      final task = Task(
        id: '1',
        name: 'Test Task',
        description: 'Test Description',
        notifactionEnabled: true,
        completed: true,
        priority: Priority.high,
        createdDate: date,
      );

      expect(task.id, '1');
      expect(task.name, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.notifactionEnabled, true);
      expect(task.completed, true);
      expect(task.priority, Priority.high);
      expect(task.createdDate, date);
    });
  });
}
