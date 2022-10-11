class PostCompo{
  final String title;
  final int pType;

  PostCompo({
    required this.title,
    required this.pType,
  });

  factory PostCompo.fromJson(Map<String,dynamic> json){

    return PostCompo(
        title: json['title'] as String,
        pType: json['pType'] as int
    );
  }
}