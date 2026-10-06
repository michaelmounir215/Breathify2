class SupportChatModel {
  final String id;
  final String userId;
  final String message;
  final bool isFromUser;

  SupportChatModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.isFromUser,
  });

  factory SupportChatModel.fromJson(Map<String, dynamic> json) {
    return SupportChatModel(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      isFromUser: json['is_from_user'],
    );
  }
}