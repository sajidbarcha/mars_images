import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mars_rover_photos/photo_model.dart';

class API {
  Future<List<PhotoModel>> fetchPhotoModels(int appPageNumber) async {
    var client = new http.Client();
    List<PhotoModel> photoModels = new List();

    try {
      for (int i = (appPageNumber * 4) - 3; i <= (appPageNumber * 4); i++) {
        var response = await client.get(_apiString(i.toString()));
        var list = json.decode(response.body)['photos'];
        List<PhotoModel> photoModelList =
            list.map<PhotoModel>((model) => PhotoModel.fromJson(model)).toList();

        photoModels.addAll(photoModelList);       
      }
    } finally {
      client.close();
    }

    return photoModels;
  }

  String _apiString(String pageNumber) {
    return 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=' +
        pageNumber +
        '&api_key=a1dMOF3OqiX6U4PwQrqwCh3rwEisf4KMmFSdcEld';
  }
}
