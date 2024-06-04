import 'package:blackmovies/data/repo/media_repository.dart';
import 'package:blackmovies/ui/Movies.dart';
import 'package:blackmovies/ui/movie.dart';
import 'package:blackmovies/ui/serie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackmovies/main.dart';
import '../data/media.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final List<Search> _dataList = [];


  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        backgroundColor: Colors.white12,
      
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(

              style: TextStyle(color: Colors.orange.shade400),
              cursorColor: Colors.orange,
              controller: _searchController,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                  hintText: '  نام فیلم یا سریال را وارد کنید...',
                  hintStyle:
                      TextStyle(fontFamily: "IranSans", color: Colors.orange)),
              onChanged: onSearchTextChanged,
            ),
          ),
        ),
        body: FutureBuilder<List<Search>>(
          future: mediaRepository.SearchMedia(_searchController.text),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.orange,
                strokeWidth: 5,
              ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('خطا در دریافت داده',style: TextStyle(fontFamily:"IranSans",color: Colors.orange)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return  Directionality(textDirection: TextDirection.rtl,child: Center(child: Text('هیچ نتیجه‌ای یافت نشد.',style: TextStyle(fontFamily:"IranSans",color: Colors.orange.shade400),)));
            } else {
              return GridView.builder(
                controller: controller,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.55,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _Result(data: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  void onSearchTextChanged(String searchText) {
    setState(() {

      _searchController.text = searchText;


    });
  }
}

class _Result extends StatefulWidget {
  final Search data;

  const _Result({required this.data});

  @override
  State<_Result> createState() => _resultState();
}

class _resultState extends State<_Result> {

  Future<void> fetchData() async {
    if(widget.data.type == "movie") {
      List<MoviesData> dataMovie = (await mediaRepository.getMedia(int.parse(widget.data.id))).cast<MoviesData>();
      print(dataMovie);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movieData: dataMovie.first),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.data.type == "movie") {
          MoviesData dataMovie = (await mediaRepository.getMedia(int.parse(widget.data.id))) as MoviesData;
          print(dataMovie);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsPage(movieData: dataMovie),
            ),
          );
        } else {

          SeriesData dataSerie = (await mediaRepository.getMedia(int.parse(widget.data.id))) as SeriesData;
          List<ISeries> episodes = await mediaRepository.getSerie(int.parse(widget.data.id));
          print(dataSerie);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SerieDetailsPage(seriesData: dataSerie, episodes: episodes),
            ),
          );
        }
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 110,
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Color(0xff282626),
                          Color(0xff383635),
                          Color(0xff54514f),
                        ])),
              ),
              Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageLoaderWidget(
                      imageUrl: widget.data.image,
                    )),
              ),
              Positioned(
                left: 0,
                child: Container(
                  width: 32,
                  height: 16,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0),
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(0)),
                      color: Colors.orange),
                  child: Text(
                    widget.data.imdb.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Center(
            child: Text(
              widget.data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.orange.shade400,
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.orange.shade400,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
