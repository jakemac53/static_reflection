abstract class DeclarationMirror {
  String get name;

  bool get isPrivate => name.startsWith('_');

  const DeclarationMirror();
}

abstract class TypeMirror<T> extends DeclarationMirror {
  List<TypeMirror> get typeArguments;

  bool get isEnum;

  Type get reflectedType;

  const TypeMirror();
}

class ClassMirror<T> extends TypeMirror<T> {
  final Map<String, DeclarationMirror> declarations;

  final List<Object> metadata;

  final ClassMirror? mixin;

  final ClassMirror? superclass;

  final List<ClassMirror> superinterfaces;

  @override
  final String name;

  @override
  final Type reflectedType;

  @override
  final List<TypeMirror> typeArguments;

  const ClassMirror({
    required this.name,
    required this.reflectedType,
    this.declarations = const {},
    this.metadata = const [],
    this.mixin,
    this.superclass,
    this.superinterfaces = const [],
    this.typeArguments = const [],
  });

  @override
  bool get isEnum => false;
}

abstract class MethodMirror extends DeclarationMirror {
  bool get isConstructor;

  bool get isGetter;

  bool get isSetter;

  bool get isStatic;

  bool get isRegularMethod;

  bool get isTopLevel;

  List<Object> get metadata;

  List<ParameterMirror> get parameters;

  const MethodMirror();
}

class GetterMirror<T, S> extends MethodMirror {
  final S Function(T reciever) invoke;

  final TypeMirror returnType;

  @override
  final String name;

  @override
  final bool isStatic;

  @override
  final bool isTopLevel;

  @override
  final List<Object> metadata;

  @override
  bool get isConstructor => false;

  @override
  bool get isGetter => true;

  @override
  bool get isSetter => false;
  @override
  bool get isRegularMethod => false;

  @override
  List<ParameterMirror> get parameters => [];

  const GetterMirror({
    required this.name,
    required this.invoke,
    required this.isStatic,
    required this.isTopLevel,
    required this.returnType,
    this.metadata = const [],
  });
}

class SetterMirror<T, S> extends MethodMirror {
  final void Function(T reciever, S value) invoke;

  @override
  final String name;

  @override
  final bool isStatic;

  @override
  final bool isTopLevel;

  @override
  final List<Object> metadata;

  @override
  final List<ParameterMirror> parameters;

  @override
  bool get isConstructor => false;

  @override
  bool get isGetter => false;

  @override
  bool get isSetter => true;

  @override
  bool get isRegularMethod => false;

  const SetterMirror({
    required this.name,
    required this.invoke,
    required this.isStatic,
    required this.isTopLevel,
    required this.parameters,
    this.metadata = const [],
  });
}

class ConstructorMirror<T> extends MethodMirror {
  final T Function(List<Object?> positionalArgs,
      [Map<String, Object?> namedArgs]) invoke;

  @override
  final String name;

  @override
  final List<Object> metadata;

  @override
  final List<ParameterMirror> parameters;

  @override
  bool get isStatic => true;

  @override
  bool get isTopLevel => false;

  @override
  bool get isConstructor => true;

  @override
  bool get isGetter => false;

  @override
  bool get isSetter => false;

  @override
  bool get isRegularMethod => false;

  const ConstructorMirror({
    required this.name,
    required this.invoke,
    required this.parameters,
    this.metadata = const [],
  });
}

class RegularMethodMirror<T, S> extends MethodMirror {
  final S Function(T reciever, List<Object>? positionalArgs,
      Map<String, Object?> namedArgs) invoke;

  final TypeMirror returnType;

  @override
  final String name;

  @override
  final bool isStatic;

  @override
  final bool isTopLevel;

  @override
  final List<Object> metadata;

  @override
  final List<ParameterMirror> parameters;

  @override
  bool get isConstructor => false;

  @override
  bool get isGetter => false;

  @override
  bool get isSetter => false;

  @override
  bool get isRegularMethod => true;

  const RegularMethodMirror({
    required this.name,
    required this.invoke,
    required this.isStatic,
    required this.isTopLevel,
    required this.parameters,
    required this.returnType,
    this.metadata = const [],
  });
}

class ParameterMirror extends DeclarationMirror {
  @override
  final String name;

  final TypeMirror type;

  final bool isNamed;

  final bool isOptional;

  const ParameterMirror({
    required this.name,
    required this.type,
    required this.isNamed,
    required this.isOptional,
  });
}
