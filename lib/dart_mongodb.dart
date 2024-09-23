import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;

void run() async {
  String host = Platform.environment['MONGO_DART_DRIVER_HOST'] ?? '127.0.0.1';
  String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ?? '27017';
  var db = Db('mongodb://$host:$port/test');

  await db.open();
  DbCollection collection = db.collection('weather_archive');
  var indexes = await collection.getIndexes();
  indexes.forEach((index) => print(index));

  var documents = await collection.count();
  print('There are $documents in ${collection.collectionName}');

  await collection
      .find(where.sortBy('date', descending: true).limit(10))
      .map((document) => Temperature.fromJson(document))
      .forEach((temperature) => print(temperature));

  db.close();
}

class Temperature {
  ObjectId _id;
  DateTime date;
  num morningTemperature;
  num afternoonTemperature;
  num eveningTemperature;
  num nightTemperature;

  Temperature(
      this._id,
      this.date,
      this.morningTemperature,
      this.afternoonTemperature,
      this.eveningTemperature,
      this.nightTemperature);

  static Temperature fromJson(Map<String, dynamic> json) {
    return Temperature(
      json['_id'],
      json['date'],
      json['morningTemperature'],
      json['afternoonTemperature'],
      json['eveningTemperature'],
      json['nightTemperature'],
    );
  }

  @override
  String toString() {
    return 'Temperature:\n{date=${DateFormat('dd-MM-yyyy').format(date)}, morning=$morningTemperature,  afternoon=$afternoonTemperature,  evening=$eveningTemperature,  night=$nightTemperature}';
  }
}
