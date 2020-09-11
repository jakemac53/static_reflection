import 'package:static_reflection/json.dart';

class User<T> {
  String name;
  int? age;
  T extra;

  @fromJson
  User(this.name, {this.age, required this.extra});

  toString() => '''
name: $name
age: $age
extra<$T>: $extra''';
}

class Login<T, S> {
  User<S> user;
  String password;
  List<T> data;

  @fromJson
  Login(this.user, this.password, this.data);

  toString() => '''
user<$S>:
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
