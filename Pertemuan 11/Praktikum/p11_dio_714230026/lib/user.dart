import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
      id: user['id'],
      email: user['email'],
      firstName: user['first_name'],
      lastName: user['last_name'],
      avatar: user['avatar'],
    );
  }
}

class UserCreate {
  String? id;
  String name;
  String job;
  String? createdAt;
  UserCreate({this.id, required this.name, required this.job, this.createdAt});
  Map<String, dynamic> toMap() {
    return {'name': name, 'job': job};
  }

  factory UserCreate.fromJson(Map<String, dynamic> data) {
    tz.initializeTimeZones();
    final jakartaTimeZone = tz.getLocation('Asia/Jakarta');
    final nowInJakarta = tz.TZDateTime.now(jakartaTimeZone);
    final result = DateFormat.yMd().add_jm().format(nowInJakarta);
    return UserCreate(
      id: data['id'],
      name: data['name'],
      job: data['job'],
      createdAt: result,
    );
  }
  
  @override
String toString() {
return 'User={id=$id, name=$name, job=$job, createdAt=$createdAt}';
}

}

class UserUpdate {
  final String name;
  final String job;
  final String updatedAt;

  UserUpdate({
    required this.name,
    required this.job,
    required this.updatedAt,
  });

  factory UserUpdate.fromJson(Map<String, dynamic> json) {
    return UserUpdate(
      name: json['name'],
      job: json['job'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  String toString() {
    return 'User(name=$name, job=$job, updatedAt=$updatedAt)';
  }
}


