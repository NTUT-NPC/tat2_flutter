import 'dart:io';

void main() async {

  final result = await Process.run('git', ['rev-list', '--count', 'HEAD']);
  if (result.exitCode != 0) {
    print('Error: Failed to get git commit count.');
    exit(1);
  }
  final commitCount = result.stdout.toString().trim();

  final pubspecFile = File('pubspec.yaml');
  String content = await pubspecFile.readAsString();


  String baseVersion = '1.0.0';
  RegExp versionRegex = RegExp(r'^version: .*$', multiLine: true);
  String newVersionLine = 'version: $baseVersion+$commitCount';

  if (versionRegex.hasMatch(content)) {
    content = content.replaceFirst(versionRegex, newVersionLine);
  } else {
    print('Error: Could not find a "version:" line in pubspec.yaml');
    exit(1);
  }

  await pubspecFile.writeAsString(content);

  print(
      'Successfully updated pubspec.yaml version to $baseVersion+$commitCount');
}