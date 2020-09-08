import 'package:static_reflection/json.dart';
import 'package:static_reflection/reflection.dart';

import 'user.dart';

// Only used in the "bad" example below to demonstrate the impact of a map like
// this on tree shaking.
var mirrors = {
  Login: loginMirror,
  Foo: fooMirror,
  User: userMirror,
};

main() {
  print(jsonDecode(
    {
      'user': {'name': 'Joe', 'age': 1, 'id': '1234'},
      'password': '@dm1n',
      'data': [1],
    },
    // Un-comment this (and comment out next line) to see the bad behavior.
    // mirrors[Login] as ClassMirror<Login>),
    loginMirror,
  ));
}

// Note that this will get tree shaken including the entire class. We can have
// unused references to these mirrors safely.
void makeFoo() {
  jsonDecode<Foo>({'zap': 1}, fooMirror);
}

// Below here would all be code generated based on something like:
//
// external ClassMirror<Login> loginMirror;
// external ClassMirror<Login> fooMirror;

User getUser(Login login) => login.user;
void setUser(Login login, User user) => login.user = user;
String getPassword(Login login) => login.password;
void setPassword(Login login, String password) => login.password = password;
List<T> getData<T>(Login<T> login) => login.data;
void setData<T>(Login<T> login, List<T> data) => login.data = data;
Login<T> createLogin<T>(List<Object?> positionalArgs, [_]) => Login<T>(
    positionalArgs[0] as User,
    positionalArgs[1] as String,
    positionalArgs[2] as List<T>);

String getName(User user) => user.name;
void setName(User user, String name) => user.name = name;
int? getAge(User user) => user.age;
void setAge(User user, int age) => user.age = age;
User createUser(List<Object?> positionalArgs,
        [Map<String, Object?>? namedArgs]) =>
    User(positionalArgs[0] as String, age: namedArgs!['age'] as int);

int getZap(Foo foo) => foo.zap;
void setZap(Foo foo, int zap) => foo.zap = zap;
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
  typeArguments: [_intMirror],
  reflectedType: List,
  declarations: {
    '': ConstructorMirror<List<int>>(
      name: '',
      invoke: createList,
      parameters: const [],
      metadata: [fromJson],
    )
  },
);
const userMirror = ClassMirror(
  name: 'User',
  reflectedType: User,
  declarations: {
    'name': GetterMirror(
      invoke: getName,
      name: 'name',
      isStatic: false,
      isTopLevel: false,
      returnType: _stringMirror,
    ),
    'name=': SetterMirror(
      invoke: setName,
      name: 'name=',
      isStatic: false,
      isTopLevel: false,
      parameters: [
        ParameterMirror(
          name: '',
          type: _stringMirror,
          isNamed: false,
          isOptional: false,
        ),
      ],
    ),
    'age': GetterMirror(
      invoke: getUser,
      name: 'age',
      isStatic: false,
      isTopLevel: false,
      returnType: _intMirror,
    ),
    'age=': SetterMirror(
      invoke: setUser,
      name: 'age=',
      isStatic: false,
      isTopLevel: false,
      parameters: [
        ParameterMirror(
          name: '',
          type: _intMirror,
          isNamed: false,
          isOptional: false,
        ),
      ],
    ),
    '': ConstructorMirror<User>(
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
      ],
      metadata: [fromJson],
    ),
  },
);

const loginMirror = ClassMirror<Login<int>>(
    name: 'Login<int>',
    reflectedType: Login,
    declarations: {
      'user': GetterMirror(
        invoke: getUser,
        name: 'user',
        isStatic: false,
        isTopLevel: false,
        returnType: userMirror,
      ),
      'user=': SetterMirror(
        invoke: setUser,
        name: 'user=',
        isStatic: false,
        isTopLevel: false,
        parameters: [
          ParameterMirror(
            name: '',
            type: userMirror,
            isNamed: false,
            isOptional: false,
          ),
        ],
      ),
      'password': GetterMirror(
        invoke: getUser,
        name: 'password',
        isStatic: false,
        isTopLevel: false,
        returnType: _stringMirror,
      ),
      'password=': SetterMirror(
        invoke: setUser,
        name: 'password=',
        isStatic: false,
        isTopLevel: false,
        parameters: [
          ParameterMirror(
            name: '',
            type: _stringMirror,
            isNamed: false,
            isOptional: false,
          ),
        ],
      ),
      'data': GetterMirror(
        invoke: getData,
        name: 'data',
        isStatic: false,
        isTopLevel: false,
        returnType: _listIntMirror,
      ),
      'data=': SetterMirror(
        invoke: setData,
        name: 'data=',
        isStatic: false,
        isTopLevel: false,
        parameters: [
          ParameterMirror(
            name: '',
            type: _listIntMirror,
            isNamed: false,
            isOptional: false,
          ),
        ],
      ),
      '': ConstructorMirror<Login<int>>(
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
    'zap': GetterMirror(
      invoke: getZap,
      name: 'zap',
      isStatic: false,
      isTopLevel: false,
      returnType: _intMirror,
    ),
    'zap=': SetterMirror(
      invoke: setZap,
      name: 'zap=',
      isStatic: false,
      isTopLevel: false,
      parameters: [
        ParameterMirror(
          name: '',
          type: _intMirror,
          isNamed: false,
          isOptional: false,
        ),
      ],
    ),
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
