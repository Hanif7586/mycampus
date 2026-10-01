import 'dart:io';

void main() {
  var dir = Directory('lib');
  var files = dir.listSync(recursive: true).where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    if (file is File) {
      var content = file.readAsStringSync();
      // Simple regex to remove 'const ' before widgets that might use AppColors
      // This is a naive approach; it's better to just remove 'const ' globally for UI
      content = content.replaceAll(RegExp(r'\bconst\s+'), '');
      
      file.writeAsStringSync(content);
    }
  }
}
