class Module {
  final String id;
  final String title;
  final String description;

  Module({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
    );
  }
}