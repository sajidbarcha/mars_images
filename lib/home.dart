import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mars_rover_photos/API.dart';
import 'package:mars_rover_photos/photo_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 1;
  bool isLastPage = false;
  final _service = API();
  Set<String> favoriteImages = new Set<String>();
  Map<int, List<PhotoModel>> pages = new Map<int, List<PhotoModel>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mars Photos'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(
              child: Text('Previous'),
              onPressed: () {
                if(currentPage==1){
                  return null;
                }
                setState(() {
                  currentPage > 1 ? currentPage-- : currentPage;
                });
              },
            ),
            Text('Page $currentPage'),
            FlatButton(
              child: Text('Next'),
              onPressed: () {
                if(isLastPage) {
                  return null;
                }
                setState(() {
                  currentPage++;
                });
              },
            )
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    bool isInMemory = pages.keys.contains(currentPage);
    return FutureBuilder(
      future: isInMemory ? imageUrlsFromMemory() : _service.fetchPhotoModels(currentPage),
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default: 
            int count = snap.data.length;            
            pages[currentPage] = snap.data;
            isLastPage = count < 100;            
            return ListView.builder(
              itemCount: count,              
              itemBuilder: (BuildContext context, int index) {
                PhotoModel photoModel = snap.data[index];
                return _imageTile(photoModel);
              },
            );
        }
      },
    );
  }

  Future<List<PhotoModel>> imageUrlsFromMemory() {    
    return Future<List<PhotoModel>>.value(pages[currentPage]);
  }

  Widget _imageTile(PhotoModel photoModel) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: new CachedNetworkImageProvider(photoModel.imageSource))),
        ),
        Positioned(
          left: 20,
          bottom: 20,
          child: FavoriteWidget(
            faves: favoriteImages,
            url: photoModel.imageSource,
          ),
        ),
        Positioned(
          right: 25,
          bottom: 20,
          child: Text(
            photoModel.earthDate,
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  final Set<String> faves;
  final String url;

  const FavoriteWidget({Key key, this.faves, this.url}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        (widget.faves.contains(widget.url)
            ? Icons.favorite
            : Icons.favorite_border),
        color: Colors.red,
      ),
      onPressed: () {
        if (widget.faves.contains(widget.url)) {
          widget.faves.remove(widget.url);
        } else {
          widget.faves.add(widget.url);
        }
        setState(() {}); //trigger a rebuild

        //TODO
        /**
               * Implement Favorite/Unfavorite functionality that persists. Current implementation 
               * only temporarily stores favorites
               */
      },
    );
  }
}
