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

    // FIXME: may cause problems on windows handle '/' accordingly
    final fileURI = '$filesDir/${ps.sublist(1).join('/')}';
    // remove files/ (url part) and adds folder_path where files are stored instead

    print(fileURI);

    // FIXME: check if windows requires \ and find a way to do that if it do needs
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
