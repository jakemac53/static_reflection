import 'package:static_reflection/json.dart';

class User {
  String name;
  int? age;

  @fromJson
  User(this.name, {this.age});

  toString() => '''
name: $name
age: $age''';
}

class Login {
  User user;
  String password;

  @fromJson
  Login(this.user, this.password);

  toString() => '''
user:
${user.toString().split('\n').map((s) => '  $s').join('\n')}
password: $password''';
}

class Foo {
  int zap;

  @fromJson
  Foo(this.zap);
  toString() => '''
zap: $zap''';
}
