class SocialMedia {
  int? id;
  String network;
  String account;
  int influencerId;

  SocialMedia(
      {this.id,
      required this.network,
      required this.account,
      required this.influencerId});

  SocialMedia.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        network = res["network"] ?? '',
        account = res["account"] ?? '',
        influencerId = res["influencerId"] ?? 0;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'network': network,
      'account': account,
      'influencerId': influencerId
    };
  }
}
