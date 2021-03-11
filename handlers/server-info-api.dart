import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import '../utils/configure.dart';

final serverInfoHandler =
    shelf.Cascade().add(countFiles).add(spaceUsed).handler;

Future<shelf.Response> countFiles(shelf.Request request) async {
  if (request.url.path == 'api/count') {
    final filesDir = Configure.getFilesDir();

    final entities = filesDir.list(recursive: true);

    var fileCount = 0;
    var directoriesCount = 0;
    await for (final file in entities) {
      if (file is File) {
        fileCount++;
      } else if (file is Directory) {
        directoriesCount++;
      }
    }

    final response =
        jsonEncode({'files': fileCount, 'directories': directoriesCount});

    return shelf.Response.ok(response,
        headers: {'content-type': 'application/json'});
  }
  // Cascade handler will handle it and execute next
  return shelf.Response.notFound('Bad Route');
}

const KILO = 1024;
const KB = KILO;
const MB = KILO * KB;
const GB = KILO * MB;

Future<shelf.Response> spaceUsed(shelf.Request request) async {
  if (request.url.path == 'api/space-used') {
    final filesDir = Configure.getFilesDir();

    final entities = filesDir.list(recursive: true);

    var bytesUsed = 0;
    await for (final file in entities) {
      if (file is File) {
        bytesUsed += await file.length();
      }
    }

    var humanReadable;

    if (bytesUsed >= GB) {
      final gbs = bytesUsed / GB;
      humanReadable = '${gbs.toStringAsFixed(2)} GB';
    } else if (bytesUsed >= MB) {
      final mbs = bytesUsed / MB;
      humanReadable = '${mbs.toStringAsFixed(2)} MB';
    } else if (bytesUsed >= KB) {
      final kbs = bytesUsed / KB;
      humanReadable = '${kbs.toStringAsFixed(2)} KB';
    } else {
      humanReadable = '${bytesUsed} B';
    }

    final response = jsonEncode(
      {'bytesUsed': bytesUsed, 'humanReadable': humanReadable},
    );

    return shelf.Response.ok(response,
        headers: {'content-type': 'application/json'});
  }
  // Cascade handler will handle it and execute next
  return shelf.Response.notFound('Bad Route');
}
