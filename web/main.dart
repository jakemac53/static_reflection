import 'package:static_reflection/json.dart';

import 'package:static_reflection/reflection_data.dart';
import 'package:static_reflection/user.dart';

main() {
  print(jsonDecode(
    {
      'user': {
        'name': 'Joe',
        'age': 1,
        'id': '1234',
        'extra': 'Foo',
      },
      'password': '@dm1n',
      'data': <dynamic>[1],
    },
    // Un-comment this (and comment out next line) to see the bad behavior.
    // mirrors[Login] as ClassMirror<Login<int, String>>,
    loginMirror,
  ));
}

// Note that this will get tree shaken including the entire class. We can have
// unused references to these mirrors safely.
void makeFoo() {
  jsonDecode<Foo>({'zap': 1}, fooMirror);
}

// Only used in the "bad" example above to demonstrate the impact of a map like
// this on tree shaking.
var mirrors = {
  Login: loginMirror,
  Foo: fooMirror,
  User: userMirror,
};
