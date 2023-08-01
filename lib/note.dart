import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String id;
  @HiveField(1)
  String date;
  @HiveField(2)
  String mood;
  @HiveField(3)
  String content;

  Note(
      {required this.id,
      required this.date,
      required this.mood,
      required this.content});

  factory Note.empty() => Note(id: '', date: '', mood: '', content: '');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          mood == other.mood &&
          content == other.content;

  @override
  int get hashCode =>
      id.hashCode ^ date.hashCode ^ mood.hashCode ^ content.hashCode;

  @override
  String toString() {
    return 'Note{id: $id, date: $date, mood: $mood, content: $content}';
  }
}
