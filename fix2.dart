import 'dart:io';

void main() {
  var dir = Directory('lib');
  var files = dir.listSync(recursive: true).where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    if (file is File) {
      var content = file.readAsStringSync();
      // Remove 'const' when used before AppColors
      content = content.replaceAll(RegExp(r'const\s+AppColors'), 'AppColors');
      // Also remove const from widget instantiations if they contain AppColors inside them.
      // E.g. const Text(color: AppColors.bg) -> Text(...)
      // Since regex can't parse AST, we just remove 'const' on any line that has 'AppColors.'
      
      var lines = content.split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('AppColors.') && lines[i].contains('const ')) {
          lines[i] = lines[i].replaceAll('const ', '');
        }
      }
      file.writeAsStringSync(lines.join('\n'));
    }
  }
}
