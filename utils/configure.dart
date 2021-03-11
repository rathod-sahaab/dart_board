import 'dart:io';

class Configure {
  static final dir = Directory('files-to-serve');

  // Get the directory where files are stored
  static Directory getFilesDir() {
    return dir;
  }
}
