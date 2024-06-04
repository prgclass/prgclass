import 'package:blackmovies/ui/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/media.dart';

class SerieDetailsPage extends StatefulWidget {
  final dynamic seriesData;

  final List<ISeries> episodes;
  const SerieDetailsPage({Key? key, required this.seriesData, required this.episodes}) : super(key: key);

  @override
  _SerieDetailsPageState createState() => _SerieDetailsPageState();
}

class _SerieDetailsPageState extends State<SerieDetailsPage> {
  final fonTitle = const TextStyle(
      fontFamily: "IranSans", fontSize: 16, fontWeight: FontWeight.bold);
  final fontHashtag = const TextStyle(fontFamily: "IranSans", fontSize: 14);
  bool showFullDescription = false;
  bool showQualityList = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.08),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 350,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Image.network(
                          widget.seriesData.image,
                          fit: BoxFit.fill,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      Positioned.fill(
                        top: -70,
                        child: FractionallySizedBox(
                          widthFactor: 0.4,
                          heightFactor: 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.seriesData.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width * 0.09,
                        left: MediaQuery.of(context).size.width * 0.3,
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
                            textAlign: TextAlign.center,
                            widget.seriesData.imdb.toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: IconButton(
                          color: Colors.orange.shade500,
                          icon: Icon(CupertinoIcons.arrow_right_circle_fill,
                              size: MediaQuery.of(context).size.width * 0.08),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Positioned(
                        bottom: 65,
                        right: 0,
                        left: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            widget.seriesData.title,
                            textAlign: TextAlign.center,
                            style:
                            fonTitle.apply(color: Colors.orange.shade400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  child: SizedBox(
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget.seriesData.genres.length,
                      itemBuilder: (context, index) {
                        final genre = widget.seriesData.genres[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                genre.title,
                                style: fontHashtag.apply(color: Colors.orange),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.orange.shade400,
                        thickness: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'درباره فیلم',
                        style: TextStyle(
                          color: Colors.orange.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.orange.shade400,
                        thickness: 3,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showFullDescription
                            ? widget.seriesData.description
                            : _getShortDescription(
                            widget.seriesData.description),
                        style: fontHashtag.apply(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFullDescription = !showFullDescription;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                showFullDescription
                                    ? 'بستن   <'
                                    : ' بیشتر  ...',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.orange.shade400,
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'دانلود و تماشا',
                        style: TextStyle(
                          color: Colors.orange.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.orange.shade400,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.zero,
                  children: [
                    ExpansionPanel(
                      backgroundColor: Colors.black.withOpacity(0.08),
                      canTapOnHeader: true,
                      isExpanded: showQualityList,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              showQualityList = !showQualityList;
                            });
                          },
                          title: Row(
                            children: [
                              Text(
                                'انتخاب کیفیت',
                                style: fonTitle.apply(color: Colors.orange),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.orange.shade400,
                              ),
                            ],
                          ),
                        );
                      },
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // نمایش منابع به عنوان یک لیست
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: widget.episodes.length,
                              itemBuilder: (context, seasonIndex) {
                                final season = widget.episodes[seasonIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: ExpansionTile(
                                    collapsedBackgroundColor: Colors.white12,
                                    iconColor: Colors.orange,
                                    trailing: Icon(
                                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: isExpanded ? Colors.orange.shade400 : Colors.orange.shade400,
                                      size: 36,
                                    ),
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        isExpanded = value;
                                      });
                                      // انجام عملیات مرتبط با تغییر وضعیت باز/بسته شدن
                                    },
                                    title: Text(season.title,style: fontHashtag.apply(color: Colors.orange.shade400),),
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: season.episodes.length,
                                        itemBuilder: (context, episodeIndex) {
                                          final episode = season.episodes[episodeIndex];
                                          final sources = episode.sources;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white12,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        episode.title,
                                                        style: fontHashtag.apply(
                                                            color: Colors.orange.shade400),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => VideoApp(urlVideo: sources.first.url),
                                                          ),
                                                        );
                                                      },
                                                      child: const Icon(
                                                        CupertinoIcons.play_arrow,
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 14,),
                                                    InkWell(
                                                      onTap: () {
                                                        print(sources.first.url);
                                                      },
                                                      child: const Icon(
                                                        Icons.download_for_offline,
                                                        color: Colors.orange,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );



  }


  String _getShortDescription(String fullDescription) {
    final words = fullDescription.split(' ');
    final shortDescription = words.take(10).join(' ');
    return shortDescription;
  }

// Future<void> _startDownload(String url) async {
//   final externalDir = await getExternalStorageDirectory();
//   final taskId = await FlutterDownloader.enqueue(
//     url: url,
//     savedDir: externalDir!.path,
//     fileName: 'downloaded_file',
//     showNotification: true,
//     openFileFromNotification: true,
//   );
//   print('دانلود شروع شد. Task ID: $taskId');
// }
//
// @override
// void initState() {
//   super.initState();
//   FlutterDownloader.initialize();
// }
//
// @override
// void dispose() {
//   FlutterDownloader.close();
//   super.dispose();
// }
}
