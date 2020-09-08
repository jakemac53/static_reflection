import 'package:static_reflection/reflection.dart';

class _FromJson {
  const _FromJson();
}

const fromJson = _FromJson();

T jsonDecode<T>(Map<String, dynamic> json, ClassMirror<T> classMirror) =>
    _parseJson(json, classMirror, T);

T _parseJson<T>(dynamic json, ClassMirror<T> classMirror, Type type) {
  if (json == null) return null as T;
  var result = _parseBuiltInType<T>(json, classMirror);
  if (result != null) return result;

  if (json is! Map<String, dynamic>) {
    throw UnsupportedError('Unsupported type ${json.runtimeType}');
  }

  var constructor = _constructorFor<T>(classMirror.reflectedType, classMirror);

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

T? _parseBuiltInType<T>(Object? input, ClassMirror<T> classMirror) {
  if (input is String || input is num) {
    return input as T;
  }
  if (classMirror.reflectedType == List) {
    var newList = _constructorFor<T>(classMirror.reflectedType, classMirror)
        .invoke(const []) as List;
    var inputList = input as List;
    var typeParamMirror = classMirror.typeArguments.first as ClassMirror;
    for (var item in inputList) {
      newList.add(
          _parseJson(item, typeParamMirror, typeParamMirror.reflectedType));
    }
    return newList as T;
  }
  return null;
}

final _constructorCache = <Type, ConstructorMirror>{};

ConstructorMirror<T> _constructorFor<T>(
        Type type, ClassMirror<T> classMirror) =>
    (_constructorCache[type] ??= classMirror.declarations.values.firstWhere(
            (declarationMirror) =>
                declarationMirror is MethodMirror &&
                declarationMirror.isConstructor &&
                declarationMirror.metadata.contains(fromJson),
            orElse: () => throw 'Type `${classMirror.name}` has no constructor '
                'annotated with `fromJson`') as ConstructorMirror)
        as ConstructorMirror<T>;
