import 'dart:convert';
import 'dart:html' as html;

void main() async {
  const DELAY = Duration(milliseconds: 1500);
  html.querySelector('#info').innerHtml =
      '<del>Javascript</del>Dart Linked... loading in <b>${DELAY.inMilliseconds / 1000} seconds</b>';

  await Future.delayed(DELAY);

  final spaceResponse = await html.HttpRequest.getString('/api/space-used');
  final spaceData = jsonDecode(spaceResponse);

  final countResponse = await html.HttpRequest.getString('/api/count');
  final countData = jsonDecode(countResponse);

  html.querySelector('#info').innerHtml = '''
    <b>Space Used:</b> ${spaceData['humanReadable']}
    <br/>
    <b>Total files:</b> ${countData['files']}, <b>Total Directories:</b> ${countData['directories']}
  ''';
}
