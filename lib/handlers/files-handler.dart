import 'dart:io';
// import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;

import '../utils/configure.dart';

final filesHandler = shelf.Cascade().add(downloadFile).handler;

/// download a file
/// request: GET ADDRESS/files/$pathInFilesDir
Future<shelf.Response> downloadFile(shelf.Request request) async {
  print(request.url.path);
  var ps = request.url.pathSegments;
  if (ps[0] == 'files') {
    final filesDir = Configure.getFilesDirName();

    // remove files/ (url part) and adds folder_path (where files are stored) instead
    var path = [filesDir, ...ps.sublist(1)];
    final fileURI = Uri(pathSegments: path).toFilePath();

    print('Looking for file in: $fileURI');

    final file = File(fileURI);

    if (await file.exists()) {
      return shelf.Response.ok(await file.readAsString(), headers: {
        // 'content-type': 'text/plain',
        'content-disposition': 'attachment; filename="${ps.last}"',
      });
    } else {
      return shelf.Response.ok('missing');
    }
  }

  return shelf.Response.notFound('Bad route');
}
