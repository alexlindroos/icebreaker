import 'package:meta/meta.dart';

class UserMatch {
  UserMatch({
    @required this.id,
    @required this.name,
    @required this.avatarUrl,
  });

  final String id;
  final String name;
  final String avatarUrl;
}
