
import 'package:blackmovies/data/media.dart';
import 'package:blackmovies/data/source/media_data_source.dart';
import 'package:dio/dio.dart';


final httpClient=Dio(
  BaseOptions(baseUrl: 'https://blackmovies.ir/back/api/')
);
final mediaRepository=MediaRepository(MediaRemoteDataSourse(httpClient));

abstract class IMediaRepository{
  Future<List<MoviesData>> getAllMovies(int index);
  Future<List<SeriesData>> getAllSeries(int index);
  Future<List<ISeries>> getSerie(int id);
  Future<List<Search>> SearchMedia(String title);
  Future<dynamic> getMedia(int id);
  Future<List<SeriesData>> getloved(int index);


}
class MediaRepository implements IMediaRepository{
  final IMediaDataSource dataSource ;

  MediaRepository(this.dataSource);

  @override
  Future<List<MoviesData>> getAllMovies( int index) => dataSource.getAllMovies(index);

  @override
  Future<List<SeriesData>> getAllSeries(int index) => dataSource.getAllSeries(index);

  @override
  Future<List<ISeries>> getSerie(int id) => dataSource.getSerie(id);

  @override
  Future<List<Search>> SearchMedia(String title) => dataSource.SearchMedia(title);

  @override
  Future<dynamic> getMedia(int id) => dataSource.getMedia(id);

  @override
  Future<List<SeriesData>> getloved(int index) => dataSource.getloved(index);


}