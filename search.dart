import 'package:emplug/constants/colors.dart';
import 'package:emplug/membership%20Selection/advertiser%20Registration/addAdvert%20and%20View%20advert/controller/search_ads.dart';
import 'package:emplug/membership%20Selection/advertiser%20Registration/addAdvert%20and%20View%20advert/model/get_all_ads_model.dart';
import 'package:emplug/membership%20Selection/advertiser%20Registration/addAdvert%20and%20View%20advert/views/general_advert.dart';
import 'package:emplug/membership%20Selection/advertiser%20Registration/addAdvert%20and%20View%20advert/views/view_full_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends SearchDelegate {
  var data = [];
  List<Datum> results = [];
  List<Datum> search({required String searchQuery, required List<Datum> items}) {
      return items.where((item) =>
              item.message!.toLowerCase().contains(searchQuery)).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  FetchAds _fetchAds = FetchAds();
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List<GetAllAdsModel>>(
          future: _fetchAds.getAdsList(query: query),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: adsCtrl.gettingAds.value.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = adsCtrl.gettingAds.value.data[index];
                  return GestureDetector(
                    onTap: () async {
                      SharedPreferences ref =
                          await SharedPreferences.getInstance();
                      var uiDD = ref.getString('_id');
                      singleAds.gettingSingleAds(data.id);
                      print('hi id $uiDD');
                      Get.to(ViewAdsDetailScreen(
                        userId: uiDD.toString(),
                        adsId: data.user.id,
                        singleCatId:
                            singleCat.loadingCategory.value.data.toString(),
                        categoryId:
                            getCategories.allCategories.value.data[index].name,
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              offset: Offset(5, 5),
                              blurRadius: 7,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.images!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return data.images == 0 && data.images.isEmpty
                                    ? Container(
                                        child: Icon(Icons.image),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.96,
                                        decoration: BoxDecoration(),
                                        child: data.images.isEmpty &&
                                                data.images.length == 0
                                            ? Container()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data.images.first,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                              ),
                                      );
                              },
                            ),
                          ),

                          //
                          // USER
                          //
                          adsCtrl.gettingAds.value.data[index].user == null
                              ? Text('Unknown',
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)))
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 10,
                                      ),
                                      child: Text(
                                          adsCtrl.gettingAds.value.data[index]
                                              .user.fullName,
                                          style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12))),
                                    ),
                                    //
                                    // Date
                                    //

                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.only(top: 10, right: 10),
                                    //   child: Text(
                                    //     timeago.format(adsCtrl.gettingAds.value
                                    //         .data![index].createdAt!),
                                    //     style: GoogleFonts.nunito(
                                    //         textStyle: const TextStyle(
                                    //             fontSize: 12, color: Colors.black)),
                                    //   ),
                                    // ),
                                  ],
                                ),
                          //
                          // ADVERT TITLE
                          //
                          SizedBox(
                            height: 10,
                          ),

                          adsCtrl.gettingAds.value.data[index].title == null
                              ? Text('no title')
                              : Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 20),
                                  child: Text(
                                      adsCtrl
                                          .gettingAds.value.data[index].title,
                                      // maxLines: ,
                                      style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                              color: Colors.black))),
                                ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search Adverts"),
    );
  }
}


 
