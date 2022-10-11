class ListCompoDefi{
  final String nameContain;
  final String addressContain;


  ListCompoDefi({
    required this.nameContain,
    required this.addressContain,

  });


  factory ListCompoDefi.toJson(Map<String,dynamic> json,){
    return ListCompoDefi(
      nameContain: json['nameList'] as String,
      addressContain: json['addressList'] as String,
    );
  }
}