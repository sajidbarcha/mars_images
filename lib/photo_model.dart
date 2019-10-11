class PhotoModel {
  int id;
  String imageSource;
  String earthDate;

  PhotoModel({this.id, this.earthDate, this.imageSource});


  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as int,
      imageSource: json['img_src'] as String,
      earthDate: json['earth_date'] as String,
    );
  }
}
