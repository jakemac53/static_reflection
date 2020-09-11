import 'package:static_reflection/json.dart';
import 'package:static_reflection/reflection.dart';

import 'user.dart';

// Below here would all be code generated based on something like:
//
// external ClassMirror<Login<int, String>> loginMirror;
// external ClassMirror<Foo> fooMirror;
Login<T, S> createLogin<T, S>(List<Object?> positionalArgs, [_]) => Login(
    positionalArgs[0] as User<S>,
    positionalArgs[1] as String,
    positionalArgs[2] as List<T>);

User<T> createUser<T>(List<Object?> positionalArgs,
        [Map<String, Object?>? namedArgs]) =>
    User<T>(positionalArgs[0] as String,
        age: namedArgs!['age'] as int, extra: namedArgs['extra'] as T);

Foo createFoo(List<Object?> positionalArgs, [_]) =>
    Foo(positionalArgs[0] as int);

List<T> createList<T>(_, [__]) => <T>[];

const _intMirror = ClassMirror<int>(
  name: 'int',
  reflectedType: int,
  declarations: {},
);
const _stringMirror = ClassMirror<String>(
  name: 'String',
  reflectedType: String,
  declarations: {},
);
const _listIntMirror = ClassMirror<List<int>>(
  name: 'List<int>',
  reflectedType: List/*<int>*/,
  typeArguments: [_intMirror],
  declarations: {
    '': ConstructorMirror<List<int>>(
      name: '',
      invoke: createList,
      parameters: const [],
      metadata: [fromJson],
    )
  },
);
const userMirror = ClassMirror<User<String>>(
  name: 'User',
  reflectedType: User /*String>*/,
  typeArguments: [_stringMirror],
  declarations: {
    '': ConstructorMirror<User<String>>(
      name: '',
      invoke: createUser,
      parameters: [
        ParameterMirror(
          name: 'name',
          type: _stringMirror,
          isNamed: false,
          isOptional: false,
        ),
        ParameterMirror(
          name: 'age',
          type: _intMirror,
          isNamed: true,
          isOptional: true,
        ),
        ParameterMirror(
          name: 'extra',
          type: _stringMirror,
          isNamed: true,
          isOptional: true,
        ),
      ],
      metadata: [fromJson],
    ),
  },
);

const loginMirror = ClassMirror<Login<int, String>>(
    name: 'Login<int, String>',
    reflectedType: Login/*<int, String>*/,
    typeArguments: [
      _intMirror,
      _stringMirror
    ],
    declarations: {
      '': ConstructorMirror<Login<int, String>>(
        name: '',
        invoke: createLogin,
        parameters: [
          ParameterMirror(
            name: 'user',
            type: userMirror,
            isNamed: false,
            isOptional: false,
          ),
          ParameterMirror(
            name: 'password',
            type: _stringMirror,
            isNamed: false,
            isOptional: false,
          ),
          ParameterMirror(
            name: 'data',
            type: _listIntMirror,
            isNamed: false,
            isOptional: false,
          ),
        ],
        metadata: [fromJson],
      ),
    });

const fooMirror = ClassMirror<Foo>(
  name: 'Foo',
  reflectedType: Foo,
  declarations: {
    '': ConstructorMirror<Foo>(
      name: '',
      invoke: createFoo,
      parameters: [
        ParameterMirror(
          name: 'zap',
          type: _intMirror,
          isNamed: false,
          isOptional: false,
        ),
      ],
      metadata: [fromJson],
    ),
  },
);
