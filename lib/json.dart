import 'package:static_reflection/reflection.dart';

class _FromJson {
  const _FromJson();
}

const fromJson = _FromJson();

final _constructorCache = <Type, ConstructorMirror>{};

T jsonDecode<T>(Map<String, dynamic> json, ClassMirror<T> classMirror) =>
    _parseJson(json, classMirror, T);

T _parseJson<T>(dynamic json, ClassMirror<T> classMirror, Type type) {
  var result = _parseBuiltInType<T>(json);
  if (result != null) return result;

  if (json is! Map<String, dynamic>) {
    throw UnsupportedError('Unsupported type ${json.runtimeType}');
  }

  var constructor = (_constructorCache[T] ??=
          classMirror.declarations.values
              .firstWhere(
                  (declarationMirror) =>
                      declarationMirror is MethodMirror &&
                      declarationMirror.isConstructor,
                  orElse: () =>
                      throw 'Type `${classMirror.name}` has no constructor '
                          'annotated with `fromJson`') as ConstructorMirror<T>)
      as ConstructorMirror<T>;

  var positionalArguments = <Object?>[];
  var namedArguments = <String, Object?>{};
  for (var parameter in constructor.parameters) {
    var name = parameter.name;
    if (parameter.isOptional && !json.containsKey(name)) {
      continue;
    }
    var value = _parseJson(json[name], parameter.type as ClassMirror,
        parameter.type.reflectedType);
    if (parameter.isNamed) {
      namedArguments[name] = value;
    } else {
      positionalArguments.add(value);
    }
  }
  return constructor.invoke(positionalArguments, namedArguments);
}

T? _parseBuiltInType<T>(Object? input) {
  if (input is String || input is num) {
    return input as T;
  }
  return null;
}
