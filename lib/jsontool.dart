// Roughly the same as `json.dart`, but uses the `jsontool` package and its
// JsonReader interface instead of the built in jsonDecode.
//
// @dart=2.8

import 'package:static_reflection/json.dart' show fromJson;
import 'package:static_reflection/reflection.dart';
import 'package:jsontool/jsontool.dart';

T jsonDecode<T>(String json, ClassMirror<T> classMirror) =>
    _parseJson(JsonReader.fromString(json), classMirror, T) as T;

Object _parseJson(JsonReader reader, ClassMirror classMirror, Type type) {
  var action = _actionCache[type] ??= _buildDecoder(type, classMirror);
  return action(reader);
}

Object Function(JsonReader) _buildDecoder(Type type, ClassMirror classMirror) {
  switch (type) {
    case String:
      return jsonString;
    case int:
      return jsonInt;
    case double:
      return jsonDouble;
    case num:
      return jsonNum;
  }

  var constructor = _constructorFor(classMirror.reflectedType, classMirror);

  if (classMirror.reflectedType == List) {
    return (JsonReader reader) {
      reader.expectArray();
      var newList = constructor.invoke(const []) as List;
      var typeParamMirror = classMirror.typeArguments.first as ClassMirror;
      while (reader.hasNext()) {
        newList.add(
            _parseJson(reader, typeParamMirror, typeParamMirror.reflectedType));
      }
      return newList;
    };
  }

  final numPositional = constructor.parameters.where((p) => !p.isNamed).length;
  final hasNamed = constructor.parameters.any((p) => p.isNamed);
  final paramsByName = {
    for (var param in constructor.parameters) param.name: param,
  };

  return (JsonReader reader) {
    reader.expectObject();
    var positionalArguments =
        numPositional > 0 ? List(numPositional) : const <Object>[];
    var namedArguments =
        hasNamed ? <String, Object>{} : const <String, Object>{};
    String name;
    int idx = 0;
    while ((name = reader.nextKey()) != null) {
      var parameter = paramsByName[name];
      if (parameter == null) {
        reader.skipAnyValue();
        continue;
      }
      var value = _parseJson(
          reader, parameter.type as ClassMirror, parameter.type.reflectedType);
      if (parameter.isNamed) {
        namedArguments[name] = value;
      } else {
        positionalArguments[idx++] = value;
      }
    }
    return constructor.invoke(positionalArguments, namedArguments) as Object;
  };
}

final _actionCache = <Type, Object Function(JsonReader)>{};

final _constructorCache = <Type, ConstructorMirror>{};

ConstructorMirror _constructorFor(Type type, ClassMirror classMirror) =>
    _constructorCache[type] ??= classMirror.declarations.values.firstWhere(
        (declarationMirror) =>
            declarationMirror is MethodMirror &&
            declarationMirror.isConstructor &&
            declarationMirror.metadata.contains(fromJson),
        orElse: () => throw 'Type `${classMirror.name}` has no constructor '
            'annotated with `fromJson`') as ConstructorMirror;
