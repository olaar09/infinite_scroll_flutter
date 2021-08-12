class DataPODO {
  int id;
  String avatarPath;
  String title;
  String description;
  String createdAt;

  DataPODO({
    this.id = 0,
    this.avatarPath = '',
    this.title = '',
    this.description = '',
    this.createdAt = '',
  });

  DataPODO.setData({
    required this.id,
    required this.avatarPath,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory DataPODO.fromJson(Map<dynamic, dynamic> map) {
    return DataPODO.setData(
      id: map['id'] ?? 0,
      avatarPath: '${map['avatarPath']}',
      title: '${map['title']}',
      description: '${map['description']}',
      createdAt: '${map['created_at']}',
    );
  }

  List<DataPODO> fromJsonArr(List list) {
    return List<DataPODO>.from(list.map((x) => DataPODO.fromJson(x)));
  }
}
