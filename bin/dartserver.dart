import 'dart:convert';
import 'dart:io';

main() async {
  var server = await HttpServer.bind('188.246.233.189'.toString(), 80);
  print("Serving at ${server.address}:${server.port}");

  await for (var request in server) {
    switch (request.method.toUpperCase()) {
      case 'GET':
        handleGetRequest(request);
        break;
      case 'POST':
        handlePostRequest(request);
        break;
    }
  }
}

Future handlePostRequest(HttpRequest request) async {
  var path = request.uri.pathSegments.first;
  print(request.uri);
  if (path == 'login') {
    try {
      String content = await utf8.decoder.bind(request).join();
      var data = jsonDecode(content) as Map;
      print(data);
      var login = data['login'];
      var password = data['password'];
      if (login == "1" && password == "1") {
        var responseText = await readFileAsync();
        request.response
          ..statusCode = 200
          ..headers.contentType =
              new ContentType("application", "json", charset: "utf-8")
          ..write(responseText)
          ..close();
      } else {
        request.response
          ..statusCode = 200
          ..headers.contentType =
              new ContentType("application", "json", charset: "utf-8")
          ..write('{"errorCode": "4", "errorDesc": "Incorrect params"}')
          ..close();
      }
    } catch (e) {
      request.response
        ..statusCode = 200
        ..headers.contentType =
            new ContentType("application", "json", charset: "utf-8")
        ..write('{"errorCode": "500", "errorDesc": "Something went wrong"}')
        ..close();
    }
  } else {
    request.response
      ..statusCode = 200
      ..headers.contentType =
          new ContentType("application", "json", charset: "utf-8")
      ..write('{"errorCode": "404", "errorDesc": "Incorrect request"}')
      ..close();
  }
}

Future<String> readFileAsync() async {
  return new File('./assets/success_login.json').readAsString();
}

void handleGetRequest(HttpRequest request) {
  request.response
    ..statusCode = 200
    ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
    ..write('Hello, world')
    ..close();
}
