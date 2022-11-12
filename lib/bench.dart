import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';


Future<void> startServer({
  required bool reuseNestedRouter,
}) async {
  // Generate additional routes for the nested router
  final additionalSubroutes = getRandomSubroutes(20);

  final onUser = reuseNestedRouter ? createOnUserHandlerReuse(additionalSubroutes) : createOnUserHandlerNoReuse(additionalSubroutes);

  final app = Router()..mount('/users/<user>', onUser);

  const port = 6391;

  final server = await serve(app, InternetAddress.loopbackIPv4, port);

  final rootUrl = "http://${server.address.address}:${server.port}";
  print("SERVING $rootUrl");
  print("Try benchmarking the subroute $rootUrl/users/jack/sampleNestedRoute");
}

Function createOnUserHandlerReuse(List<String> subroutes) {
  // #################    REUSE ROUTER  ############################
  print("REUSE MODE");

  final usersRouter = () {
    final router = Router();

    String getUser(RequestContext c) => c.mountedParams['user']!;

    router.get(
      '/self',
      (RequestContext context) => Response(body: "I'm ${getUser(context)}"),
    );

    // Add some additional subroutes
    for (final subroute in subroutes) {
      router.get(subroute, (context) {
        return Response(body: "Route $subroute");
      });
    }

    return router;
  }();

  return (
    RequestContext context,
    String user,
  ) {
    return usersRouter(context);
  };
}

Function createOnUserHandlerNoReuse(List<String> subroutes) {
  print("NOT REUSING ROUTER MODE");

  return (
    RequestContext context,
    String user,
  ) {
    final router = Router();

    String getUser(RequestContext c) => c.mountedParams['user']!;

    router.get(
      '/self',
      (RequestContext context) => Response(body: "I'm ${getUser(context)}"),
    );

    // Add some additional subroutes
    for (final subroute in subroutes) {
      router.get(subroute, (context) {
        return Response(body: "Route $subroute");
      });
    }

    return router(context);
  };
}

List<String> getRandomSubroutes(int length) {
  final subroutes = List<String>.generate(length, (index) => "/${getRandomStr()}");
  final randomSubroutes = subroutes.toSet().toList();

  // Add known subroute
  randomSubroutes.add("/sampleNestedRoute");
  return randomSubroutes;
}

final rand = Random();
String getRandomStr() {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  const length = 10;
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rand.nextInt(chars.length))));
}
