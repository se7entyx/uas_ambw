import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  Note(
      {required this.judul,
      required this.isi,
      required this.created,
      required this.edited});

  @HiveField(0)
  String judul;

  @HiveField(1)
  String isi;

  @HiveField(2)
  DateTime created;

  @HiveField(3)
  DateTime edited;
}
