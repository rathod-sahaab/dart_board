import 'dart:io';

import 'package:dart_board/utils/configure.dart';
import 'package:jaded/jaded.dart' as jade;
import 'package:shelf/shelf.dart' as shelf;

// import 'package:dart_board/templates/jaded.views.dart' as views;

final pagesHandler =
    shelf.Cascade().add(homePage).add(directoryPageHandler).handler;

Future<shelf.Response> homePage(shelf.Request request) async {
  if (request.url.path.isEmpty) {
    // redirect to home dir
    return shelf.Response.movedPermanently('/dir');
  }
  return shelf.Response.notFound('Not found');
}

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

    // to segregate directories and files
    var dirFiles = [];
    var dirDirs = [];

    await for (final entity in dir.list()) {
      if (entity is File) {
        final filename = entity.uri.pathSegments.last;

        // files/path/to/file/in/files-to-serve
        final fileLink =
            ['files', ...entity.uri.pathSegments.sublist(1)].join('/');

        dirFiles.add({'name': filename, 'link': '/$fileLink'});
      } else {
        final dirName = entity.uri.pathSegments
            .elementAt(entity.uri.pathSegments.length - 2);
        final dirLink =
            ['dir', ...entity.uri.pathSegments.sublist(1)].join('/');

        dirDirs.add({'name': '$dirName/', 'link': '/$dirLink'});
      }
    }

    final template = await File('templates/views/index.jade').readAsString();
    // print(template);
    var renderAsync = jade.compile(template);

    var html = await renderAsync({
      'contents': [...dirDirs, ...dirFiles]
    });

    // final render = views.JADE_TEMPLATES['lib/templates/views/index.jade'];
    // final html = render();

    return shelf.Response.ok(html, headers: {'content-type': 'text/html'});
  }
  return shelf.Response.notFound('Something went wrong');
}
