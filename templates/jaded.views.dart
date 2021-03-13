library jade_templates;

import 'package:jaded/runtime.dart' as jade;

Map<String, Function> JADE_TEMPLATES = {
  'lib/templates/views/404.jade': ([locals]) {
    ///jade-begin
    if (locals == null) locals = {};

    var buf = [];
    var self = locals;
    if (self == null) self = {};
    buf.add(
        "<!DOCTYPE html><html><head><title>Not found</title></head><body><h1>404, Not found</h1></body></html>");
    ;
    return buf.join('');
  },

  ///jade-end
  'lib/templates/views/index.jade': ([locals]) {
    ///jade-begin
    if (locals == null) locals = {};

    var buf = [];
    var self = locals;
    if (self == null) self = {};
    buf.add(
        "<html><head><title>Dart Board - The file server</title></head><body><h1>Welcome to dartboard!</h1></body></html>");
    ;
    return buf.join('');
  },

  ///jade-end
};
//ignore_for_file: prefer_interpolation_to_compose_strings,unused_local_variable
