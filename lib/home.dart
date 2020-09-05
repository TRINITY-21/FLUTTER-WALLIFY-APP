import 'package:Wallpaper_App/views/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:Wallpaper_App/data/data.dart';
import 'dart:convert';
import 'package:Wallpaper_App/models/categorie_model.dart';
import 'package:Wallpaper_App/models/photos_model.dart';
import 'package:Wallpaper_App/view/categorie_screen.dart';
import 'package:Wallpaper_App/view/search_view.dart';
import 'package:Wallpaper_App/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = new List();

  int noOfImageToLoad = 30;
  List<PhotosModel> photos = new List();
  bool loading = true;

  getTrendingWallpaper() async {
    await http.get(
        "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        setState(() {
          loading = false;
        });
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });

      setState(() {
        
      });
    });
  }

  TextEditingController searchController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    //getWallpaper();
    getTrendingWallpaper();
    categories = getCategories();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        getTrendingWallpaper();
        
      }
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: brandName(),
              elevation: 0.1,
            ),
            backgroundColor: Color(0xFA424242),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Container(
                      
                      decoration: BoxDecoration(
                        color: Color(0xFF8D8D8D),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              
                                hintText: "search wallpapers",
                                border: InputBorder.none),
                          )),
                          InkWell(
                              onTap: () {
                                if (searchController.text != "") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchView(
                                                search: searchController.text,
                                              )));
                                }
                              },
                              child: Container(child: Icon(Icons.search, color: Colors.white,))
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Made By ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'PlayfairDisplay'),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL(
                                "https://www.github.com/TRINITY-21/");
                          },
                          child: Container(
                              child: Text(
                            "TRINITY",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                            
                               // fontFamily: 'MaterialIcons-Regular'),
                            ),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 80,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            /// Create List Item tile
                            return CategoriesTile(
                              imgUrls: categories[index].imgUrl,
                              categorie: categories[index].categorieName,
                            );
                          }),
                    ),
                    wallPaper(photos, context),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Photos provided By ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'PlayfairDisplay'),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL("https://www.pexels.com/");
                          },
                          child: Container(
                              child: Text(
                            "Pexels",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontFamily: 'MaterialIcons-Regular'),
                          )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  CategoriesTile({@required this.imgUrls, @required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategorieScreen(
                      categorie: categorie,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: kIsWeb
            ? Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(
                              imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        categorie,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay'),
                      )),
                ],
              )
            : Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(
                              imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        categorie ?? "Yo Yo",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay'),
                      ))
                ],
              ),
      ),
    );
  }
}
