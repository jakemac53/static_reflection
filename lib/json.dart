import 'package:static_reflection/reflection.dart';

class _FromJson {
  const _FromJson();
}

const fromJson = _FromJson();

T jsonDecode<T>(Map<String, dynamic> json, ClassMirror<T> classMirror) =>
    _parseJson(json, classMirror, T) as T;

Object? _parseJson(dynamic json, ClassMirror classMirror, Type type) {
  if (json == null) return null;

  var action = _actionCache[type] ??= _buildDecoder(type, classMirror);
  return action(json);
}

Object? _self(Object? o) => o;

const _selfTypes = [String, int, double, num, Null];

Object? Function(Object?) _buildDecoder(Type type, ClassMirror classMirror) {
  if (_selfTypes.contains(type)) {
    return _self;
  }
  var constructor = _constructorFor(classMirror.reflectedType, classMirror);

  if (classMirror.reflectedType == List) {
    return (json) {
      if (json is! List) return json;
      var newList = constructor.invoke(const []) as List;
      var typeParamMirror = classMirror.typeArguments.first as ClassMirror;
      for (var item in json) {
        newList.add(
            _parseJson(item, typeParamMirror, typeParamMirror.reflectedType));
      }
      return newList;
    };
  }

  var hasPositional = constructor.parameters.any((p) => !p.isNamed);
  var hasNamed = constructor.parameters.any((p) => p.isNamed);

  return (json) {
    if (json == null) return null;
    if (json is! Map<String, dynamic>) {
      throw UnsupportedError('Unsupported type ${json.runtimeType}');
    }
    var positionalArguments = hasPositional ? <Object?>[] : const <Object?>[];
    var namedArguments =
        hasNamed ? <String, Object?>{} : const <String, Object?>{};
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
  };
}

final _actionCache = <Type, Object? Function(Object?)>{};

final _constructorCache = <Type, ConstructorMirror>{};

ConstructorMirror _constructorFor(Type type, ClassMirror classMirror) =>
    _constructorCache[type] ??= classMirror.declarations.values.firstWhere(
        (declarationMirror) =>
            declarationMirror is MethodMirror &&
            declarationMirror.isConstructor &&
            declarationMirror.metadata.contains(fromJson),
        orElse: () => throw 'Type `${classMirror.name}` has no constructor '
            'annotated with `fromJson`') as ConstructorMirror;
