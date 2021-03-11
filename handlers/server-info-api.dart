import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;

final serverInfoHandler =
    shelf.Cascade().add(countFiles).add(spaceUsed).handler;

Future<shelf.Response> countFiles(shelf.Request request) async {
  if (request.url.path == 'api/count') {
    final filesToServeDir = Directory('files-to-serve');

    final fileCount = await filesToServeDir.list().length;

    final response = jsonEncode({'fileCount': fileCount});

    return shelf.Response.ok(response,
        headers: {'content-type': 'application/json'});
  }
  // Cascade handler will handle it and execute next
  return shelf.Response.notFound('Bad Route');
}

const KILO = 1024;
const KB = 1024;
const MB = KILO * KB;
const GB = KILO * MB;

Future<shelf.Response> spaceUsed(shelf.Request request) async {
  if (request.url.path == 'api/space-used') {
    final filesToServeDir = Directory('files-to-serve');

    final files = filesToServeDir.list();

    var bytesOccupied = 0;
    await for (final file in files) {
      if (file is File) {
        bytesOccupied += await file.length();
      }
    }

    var humanReadable;

    if (bytesOccupied > GB) {
      humanReadable = '${bytesOccupied / GB} GB';
    } else if (bytesOccupied > MB) {
      humanReadable = '${bytesOccupied / MB} MB';
    } else if (bytesOccupied > KB) {
      humanReadable = '${bytesOccupied / KB} KB';
    } else {
      humanReadable = '${bytesOccupied} B';
    }

    final response = jsonEncode(
      {'bytes': bytesOccupied, 'humanReadable': humanReadable},
    );

    return shelf.Response.ok(response,
        headers: {'content-type': 'application/json'});
  }
  // Cascade handler will handle it and execute next
  return shelf.Response.notFound('Bad Route');
}
