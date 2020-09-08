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

class Login<T> {
  User user;
  String password;
  List<T> data;

  @fromJson
  Login(this.user, this.password, this.data);

  toString() => '''
user:
${user.toString().split('\n').map((s) => '  $s').join('\n')}
password: $password
data<$T>: $data''';
}

class Foo {
  int zap;

  @fromJson
  Foo(this.zap);
  toString() => '''
zap: $zap''';
}
