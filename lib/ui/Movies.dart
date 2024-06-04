

import 'package:blackmovies/data/repo/media_repository.dart';
import 'package:flutter/material.dart';
import '../data/media.dart';
import 'movie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


//============================(CLASS-MOVIE-1)===================================
class Movies extends StatefulWidget {
  int page = 0;


  Movies({super.key}); // ایجاد لیست خالی برای نگهداری تمام فیلم‌ها
  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  ScrollController controller = ScrollController();
  bool isLoading = false;
  List<MoviesData> filteredMovies = [];


  @override
  void initState() {
    super.initState();
    loadMovies(); // فراخوانی تابع برای بارگیری اولیه فیلم‌ها
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        loadMoreMovies(); // فراخوانی تابع برای بارگیری فیلم‌های بیشتر در صورت رسیدن به انتهای صفحه
      }
    });
  }

  Future<void> loadMovies() async {
    setState(() {
      isLoading = true;
    });
    List<MoviesData> newMovies = await mediaRepository.getAllMovies(widget.page);

    // اعمال فیلتر بر روی newMovies و افزودن به filteredMovies
    filteredMovies.addAll(newMovies.where((movieData) =>
    movieData.duration != "" || movieData.sources.isNotEmpty || movieData.classification != ""));

    setState(() {
      isLoading = false; // پایان وضعیت بارگیری
    });
  }


  Future<void> loadMoreMovies() async {
    setState(() {
      isLoading = true; // نشان دادن وضعیت بارگیری بیشتر
      widget.page++;
    });
    await loadMovies(); // فراخوانی مجدد تابع بارگیری فیلم‌ها برای اضافه کردن فیلم‌های جدید
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.08),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Stack(
          children: [
            GridView.builder(
              controller: controller,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                childAspectRatio: 0.55,
              ),
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {

                return _movie(data: filteredMovies[index]);
              },
            ),

            if (isLoading) // نمایشگر چرخشی در صورت بارگیری
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(
                  color: Colors.orange.shade500,
                  backgroundColor: Colors.yellowAccent.shade700,
                  strokeWidth: 5,
                  // دیگر پارامترها
                ),
              )],
        ),
      ),
    );
  }
}

class _movieState extends State<_movie> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movieData: widget.data),
          ),
        );
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
                    child: ImageLoaderWidget(imageUrl: widget.data.image,)
                ),
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
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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



//==========================(END /SHOW-MOVIES)==================================
//=========================(END /CLASS-MOVIES-1)================================





class _movie extends StatefulWidget {
  final MoviesData data;

  const _movie({super.key, required this.data});

  @override
  State<_movie> createState() => _movieState();
}




class ImageLoaderWidget extends StatefulWidget {
  final String imageUrl;

  const ImageLoaderWidget({required this.imageUrl});

  @override
  _ImageLoaderWidgetState createState() => _ImageLoaderWidgetState();
}

class _ImageLoaderWidgetState extends State<ImageLoaderWidget> {
  late ImageStream _imageStream;
  ImageStreamListener? _imageStreamListener;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadImage();
  }

  void _loadImage() {
    _imageStream = Image.network(widget.imageUrl).image.resolve(ImageConfiguration.empty);

    _imageStreamListener = ImageStreamListener(
          (ImageInfo imageInfo, bool synchronousCall) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = false;
          });
        }
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
          retryLoadImage();
        }
      },
    );

    _imageStream.addListener(_imageStreamListener!);
  }

  @override
  void dispose() {
    if (_imageStreamListener != null) {
      _imageStream.removeListener(_imageStreamListener!);
    }
    super.dispose();
  }

  void retryLoadImage() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_isLoading && _hasError) {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
        _loadImage();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingAnimationWidget.hexagonDots(
        color: Colors.orangeAccent,
        size: 35,
      );
      // return const Align(child: CircularProgressIndicator(color: Color(0xff262A35),backgroundColor: Colors.orangeAccent,strokeWidth: 2,strokeAlign: 0.0001,));

    } else if (_hasError) {
      return LoadingAnimationWidget.hexagonDots(
        color: Colors.deepOrange
        ,
        size: 35,
      );
    } else {
      return Image.network(widget.imageUrl,fit: BoxFit.fill,);
    }
  }
}
