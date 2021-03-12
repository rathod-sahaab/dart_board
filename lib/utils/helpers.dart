class Helpers {
  static const KILO = 1024;
  static const KB = KILO;
  static const MB = KILO * KB;
  static const GB = KILO * MB;

  /// Returns human redable form of size
  /// 1536 -> 1.50 KB
  static String bytesToHumanReadable(int bytes) {
    if (bytes >= GB) {
      final gbs = bytes / GB;
      return '${gbs.toStringAsFixed(2)} GB';
    }
    if (bytes >= MB) {
      final mbs = bytes / MB;
      return '${mbs.toStringAsFixed(2)} MB';
    }
    if (bytes >= KB) {
      final kbs = bytes / KB;
      return '${kbs.toStringAsFixed(2)} KB';
    }
    return '${bytes} B';
  }
}
