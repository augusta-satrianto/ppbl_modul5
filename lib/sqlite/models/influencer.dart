import 'social_media.dart';

class Influencer implements Comparable {
  int? id;
  String nickName;
  String? realName;
  List<SocialMedia> socialMedia = [];

  Influencer({this.id, required this.nickName, this.realName});

  Influencer.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        nickName = res["nickName"],
        realName = res["realName"];

  Map<String, Object?> toMap() {
    return {'id': id, 'nickName': nickName, 'realName': realName};
  }

  @override
  bool operator ==(Object other) {
    return other is Influencer && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return -(other.id - id ?? 0) as int;
  }
}
