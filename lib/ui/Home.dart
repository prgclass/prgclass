import 'package:blackmovies/ui/serie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../data/media.dart';
import '../data/repo/media_repository.dart';
import 'down_series.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller = ScrollController();

  List<SeriesData> allSeries = [];
  bool isLoading = false;
  final List<dynamic> imageBannerUrl = [
    'https://th.bing.com/th/id/OIG.tTBMZK9GnKo_aT0a6wKC?w=270&h=270&c=6&r=0&o=5&dpr=1.3&pid=ImgGn',
    'https://th.bing.com/th/id/OIG.Xu14zkOrKe3LDXJ.1.dT?w=270&h=270&c=6&r=0&o=5&dpr=1.3&pid=ImgGn',
    'https://th.bing.com/th/id/OIG.IUvfERAUO2WPY531Mnl2?w=270&h=270&c=6&r=0&o=5&dpr=1.3&pid=ImgGn',
    'https://th.bing.com/th/id/OIG.CtUjuOUf0mIvitfxOMHL?w=270&h=270&c=6&r=0&o=5&dpr=1.3&pid=ImgGn'
  ];

  @override
  void initState() {
    super.initState();
    loadSeries();
  }

  Future<void> loadSeries() async {
    setState(() {
      isLoading = true;
    });
    List<SeriesData> newSeries = await mediaRepository.getloved(0);
    setState(() {
      allSeries = newSeries;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageBannerUrl.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: imageBannerUrl[index],
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                                  color: Color(0xff262A35)),
                          errorWidget: (context, url, error) => const Icon(
                              CupertinoIcons.exclamationmark_triangle),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.white10,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // تنظیم تمام فرزندان به سمت چپ
                children: [
                  Text(
                    "سریال ها با بیشترین دانلود",
                    style: TextStyle(color: Colors.orange.shade400),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        "بیشتر",
                        style: TextStyle(color: Colors.orange.shade400),
                      ),

                      IconButton(
                        color: Colors.orange.shade500,
                        icon: Icon(CupertinoIcons.arrow_left_circle,
                            size: MediaQuery.of(context).size.width * 0.08),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MostSeries();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 14,
              ),
              if (isLoading)
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CircularProgressIndicator(
                    color: Colors.orange.shade500,
                    backgroundColor: Colors.yellowAccent.shade700,
                    strokeWidth: 5,
                    // دیگر پارامترها
                  ),
                ),
              if (!isLoading)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 8,
                      scrollDirection: Axis.horizontal,
                      // padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final data = allSeries[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _serie(
                            data: data,
                          ),
                        );
                      }),
                ),
            ]),
          )
        ],
      ),
    );
  }
}

class _serie extends StatefulWidget {
  final SeriesData data;

  const _serie({required this.data});

  @override
  State<_serie> createState() => _serieState();
}

class _serieState extends State<_serie> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        List<ISeries> episodes = await mediaRepository.getSerie(widget.data.id);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SerieDetailsPage(
                  seriesData: widget.data, episodes: episodes);
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
          Text(
            widget.data.title,
            maxLines: 1,

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
        ],
      ),
    );
  }
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
    _imageStream =
        Image.network(widget.imageUrl).image.resolve(ImageConfiguration.empty);

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
        color: Colors.deepOrange,
        size: 35,
      );
    } else {
      return Image.network(
        widget.imageUrl,
        fit: BoxFit.fill,
      );
    }
  }
}
