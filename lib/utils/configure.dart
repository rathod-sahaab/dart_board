import 'dart:io';

class Configure {
  static final dirName = 'files-to-serve'; // don't append '/'
  static final dir = Directory(dirName);

  static String getFilesDirName() {
    return dirName;
  }

  /// Get the directory where files are stored
  static Directory getFilesDir() {
    return dir;
  }
}
