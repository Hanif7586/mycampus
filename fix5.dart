import 'dart:io';

void main() {
  var result = Process.runSync('flutter.bat', ['analyze', '--write-machine']);
  print(result.stdout.toString().substring(0, 500));
}
