import 'package:drift/drift.dart';
class Task extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get status => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
}


