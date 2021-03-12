/*
 * This file contains the ReST API handlers
 */
import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import '../utils/configure.dart';
import '../utils/helpers.dart';

final serverInfoHandler =
    shelf.Cascade().add(countFiles).add(spaceUsed).handler;

/// Count files and directories
/// endpoint: ADDRESS/api/count
/// response example:
/// {
///   'files': 6,
///   'directories': 2
/// }
///
Future<shelf.Response> countFiles(shelf.Request request) async {
  if (request.url.path == 'api/count') {
    final filesDir = Configure.getFilesDir();

    final entities = filesDir.list(recursive: true);

    // TODO: use fold
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

/// Get space used by all files
/// endpoint: ADDRESS/api/space-used
/// response example:
/// {
///   'bytesUsed': 1536,
///   'humanReadable': '1.50 KB'
/// }
Future<shelf.Response> spaceUsed(shelf.Request request) async {
  if (request.url.path == 'api/space-used') {
    final filesDir = Configure.getFilesDir();

    final entities = filesDir.list(recursive: true);

    // TODO: use fold
    var bytesUsed = 0;
    await for (final file in entities) {
      if (file is File) {
        bytesUsed += await file.length();
      }
    }

    final humanReadable = Helpers.bytesToHumanReadable(bytesUsed);

    final response = jsonEncode(
      {'bytesUsed': bytesUsed, 'humanReadable': humanReadable},
    );

    return shelf.Response.ok(response,
        headers: {'content-type': 'application/json'});
  }
  // Cascade handler will handle it and execute next
  return shelf.Response.notFound('Bad Route');
}
