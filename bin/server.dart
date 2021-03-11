import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

import '../handlers/files-handler.dart';
import '../handlers/server-info-api.dart';

const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  // Use PORT env var when available
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  final handlerCascade = shelf.Cascade()
      .add(filesHandler)
      .add(serverInfoHandler) // ReST API
      .add((request) => shelf.Response.notFound('Bad route'))
      .handler;

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(handlerCascade);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}
