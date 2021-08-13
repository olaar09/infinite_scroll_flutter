class InfiniteScrollPODO {
  int id;
  String avatarPath;
  String title;
  String description;
  String createdAt;

  InfiniteScrollPODO({
    this.id = 0,
    this.avatarPath = '',
    this.title = '',
    this.description = '',
    this.createdAt = '',
  });

  InfiniteScrollPODO.setData({
    required this.id,
    required this.avatarPath,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory InfiniteScrollPODO.fromJson(Map<dynamic, dynamic> map) {
    return InfiniteScrollPODO.setData(
      id: map['id'] ?? 0,
      avatarPath: '${map['avatarPath']}',
      title: '${map['title']}',
      description: '${map['description']}',
      createdAt: '${map['created_at']}',
    );
  }

  List<InfiniteScrollPODO> fromJsonArr(List list) {
    return List<InfiniteScrollPODO>.from(
        list.map((x) => InfiniteScrollPODO.fromJson(x)));
  }
}
