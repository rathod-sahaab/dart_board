import 'dart:io';
// import 'dart:convert';

import 'package:dart_board/utils/configure.dart';
import 'package:shelf/shelf.dart' as shelf;

final pagesHandler = shelf.Cascade().add(directoryPageHandler).handler;

/// ADDRESS/dir/path/to/directory
/// to view contents of the directory
/// renders an html page from template
Future<shelf.Response> directoryPageHandler(shelf.Request request) async {
  final ps = request.url.pathSegments;
  if (ps[0] == 'dir') {
    final filesDir = Configure.getFilesDirName();
    final pathToDir = [filesDir, ...ps.sublist(1)];

    final dir = Directory(Uri(pathSegments: pathToDir).toFilePath());

    if (!await dir.exists()) {
      print("directory doesn't exists");
      return shelf.Response.notFound("Directory doesn't exists");
    }

    var dirContents = '';

    await for (final entity in dir.list()) {
      final eps = entity.uri.pathSegments;
      var entityName = eps[eps.lastIndexWhere((seg) => seg != '')];

      if (entity is Directory) {
        entityName += '/'; // non functional '\' TODO
      }
      dirContents += '<li>$entityName</li>';
    }

    final html = '''
				<html>
				<body>
				<h1> ${dir.path} </h1>
				<ul>
				$dirContents
				</ul>
				</body>
				</html>
				''';
    return shelf.Response.ok(html, headers: {'content-type': 'text/html'});
  }
  return shelf.Response.notFound('Something went wrong');
}
