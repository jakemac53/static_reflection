import 'dart:convert' as convert;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:jsontool/jsontool.dart' as json_tool_raw;
import 'package:static_reflection/json.dart' as json;
import 'package:static_reflection/jsontool.dart' as json_tool;
import 'package:static_reflection/reflection_data.dart';
import 'package:static_reflection/user.dart';

var data = '''
{
  "user": {
    "name": "Joe",
    "age": 1,
    "extra": "Foo"
  },
  "password": "@dm1n",
  "data": [1]
}
''';

main() {
  StaticReflectionJsonReader().report();
  StaticReflectionJsonDecode().report();
  ManualJsonDecode().report();
  ManualJsonReader().report();
}

class StaticReflectionJsonDecode extends BenchmarkBase {
  const StaticReflectionJsonDecode() : super('StaticReflectionJsonDecode');

  @override
  void run() {
    json.jsonDecode<Login<int, String>>(
        convert.jsonDecode(data) as Map<String, dynamic>, loginMirror);
  }
}

class StaticReflectionJsonReader extends BenchmarkBase {
  const StaticReflectionJsonReader() : super('StaticReflectionJsonReader');

  @override
  void run() {
    json_tool.jsonDecode<Login<int, String>>(data, loginMirror);
  }
}

class ManualJsonDecode extends BenchmarkBase {
  const ManualJsonDecode() : super('ManualJsonDecode');

  @override
  void run() {
    createLoginManual<int, String>(
      convert.jsonDecode(data) as Map<String, dynamic>,
      convertInt,
      convertString,
    );
  }
}

class ManualJsonReader extends BenchmarkBase {
  const ManualJsonReader() : super('ManualJsonReader');

  @override
  void run() {
    jsonLogin<int, String>(json_tool_raw.jsonInt, json_tool_raw.jsonString)(
        json_tool_raw.JsonReader.fromString(data));
  }
}

Login<T, S> createLoginManual<T, S>(Map<String, dynamic> json,
        T Function(Object?) convertT, S Function(Object?) convertS) =>
    Login(
        createUserManual<S>(json['user'] as Map<String, dynamic>, convertS),
        json['password'] as String,
        (json['data'] as List).map((i) => convertT(i)).toList());

User<T> createUserManual<T>(
        Map<String, dynamic> json, T Function(Object?) convertT) =>
    User<T>(json['name'] as String,
        age: json['age'] as int, extra: convertT(json['extra']));

int convertInt(Object? o) => o as int;
String convertString(Object? o) => o as String;

json_tool_raw.JsonBuilder<Login<T, S>> jsonLogin<T, S>(
    json_tool_raw.JsonBuilder<T> builderT,
    json_tool_raw.JsonBuilder<S> builderS) {
  return (json_tool_raw.JsonReader reader) {
    reader.expectObject();
    String? key;
    late User<S> user;
    late String password;
    late List<T> data;
    while ((key = reader.nextKey() as String?) != null) {
      switch (key) {
        case 'user':
          user = jsonUser<S>(builderS)(reader);
          break;
        case 'password':
          password = json_tool_raw.jsonString(reader);
          break;
        case 'data':
          data = json_tool_raw.jsonArray<T>(builderT)(reader);
          break;
        default:
          reader.skipAnyValue();
      }
    }
    return Login(user, password, data);
  };
}

json_tool_raw.JsonBuilder<User<T>> jsonUser<T>(
    json_tool_raw.JsonBuilder<T> builderT) {
  return (json_tool_raw.JsonReader reader) {
    reader.expectObject();
    late String name;
    int? age;
    late T extra;
    String? key;
    while ((key = reader.nextKey() as String?) != null) {
      switch (key) {
        case 'name':
          name = json_tool_raw.jsonString(reader);
          break;
        case 'age':
          age = json_tool_raw.jsonInt(reader);
          break;
        case 'extra':
          extra = builderT(reader);
          break;
      }
    }
    return User(name, age: age, extra: extra);
  };
}
