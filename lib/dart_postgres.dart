import 'dart:io';

import 'package:postgres/postgres.dart';

Future<void> run() async {
   final conn = await Connection.open(Endpoint(
    host: Platform.environment['DB_HOST'] ?? '127.0.0.1',
    database: Platform.environment['DB_NAME'] ?? 'test',
    username: Platform.environment['DB_USER'] ?? 'postgres',
    password: Platform.environment['DB_PASSWORD'] ?? 'postgres',
  ));

  final result = await conn.execute(
    'SELECT * FROM recipient'
    // Sql.named('SELECT * FROM recipient WHERE id=@id'),
    // parameters: {'id': '1'},
  );

  print(result.schema);

  result.forEach((row) =>print(row.toColumnMap()));
  // print(result.first.toColumnMap());
  conn.close();
}