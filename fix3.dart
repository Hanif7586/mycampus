import 'dart:convert';
import 'dart:io';

void main() {
  print('Running flutter analyze...');
  var result = Process.runSync('flutter.bat', ['analyze', '--write-machine']);
  
  var lines = result.stdout.toString().split('\n');
  var fixes = 0;
  
  for (var line in lines) {
    if (line.contains('invalid_constant') || line.contains('non_constant_default_value') || line.contains('const_with_non_constant_argument') || line.contains('invalid_assignment') || line.contains('const_initialized_with_non_constant_value')) {
      var parts = line.split('|');
      if (parts.length > 5) {
        var filePath = parts[3];
        var lineNum = int.tryParse(parts[4]);
        
        if (filePath.isNotEmpty && lineNum != null && lineNum > 0) {
          var file = File(filePath);
          if (file.existsSync()) {
            var fileLines = file.readAsLinesSync();
            if (lineNum - 1 < fileLines.length) {
              var text = fileLines[lineNum - 1];
              // Try to remove const on that line
              if (text.contains('const ')) {
                fileLines[lineNum - 1] = text.replaceFirst('const ', '');
                file.writeAsStringSync(fileLines.join('\n'));
                fixes++;
              } else {
                // look backwards for a few lines to find 'const '
                for (var i = lineNum - 1; i >= (lineNum - 5 > 0 ? lineNum - 5 : 0); i--) {
                  if (fileLines[i].contains('const ')) {
                    fileLines[i] = fileLines[i].replaceFirst('const ', '');
                    file.writeAsStringSync(fileLines.join('\n'));
                    fixes++;
                    break;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  print('Fixed \ const errors.');
}
