import 'dart:convert';

import 'package:blackmovies/common/exeptions.dart';
import 'package:blackmovies/data/media.dart';
import 'package:dio/dio.dart';

abstract class IMediaDataSource {
  Future<List<MoviesData>> getAllMovies(int index);

  Future<List<SeriesData>> getAllSeries(int index);

  Future<List<ISeries>> getSerie(int id);

  Future<List<Search>> SearchMedia(String title);
  Future<List<SeriesData>> getloved(int index);
  Future<dynamic> getMedia(int id);
}

class MediaRemoteDataSourse implements IMediaDataSource {
  final Dio httpClient;

  MediaRemoteDataSourse(this.httpClient);

  @override
  Future<List<MoviesData>> getAllMovies(int index) async {
    final response = await httpClient.get('movies.php?index=$index');
    validateResponse(response);
    try {
      final Map<String, dynamic> dataMap = jsonDecode(response.data);
      // Check the type of 'data' field
      if (dataMap.containsKey('status') && dataMap['status'] == 'ok') {
        final dynamic data = dataMap['data'];
        // If 'data' is a String, decode it into a List<dynamic>
        final List<dynamic> jsonList = data is String ? jsonDecode(data) : data;
        List<MoviesData> movies =
            jsonList.map((json) => MoviesData.fromJson(json)).toList();

        return movies;
      } else {
        print('خطا در دریافت فیلم‌ها: ${dataMap["status"]}');
        return [];
      }
    } catch (e) {
      print('خطا در دریافت فیلم‌ها: $e');
      return [];
    }
  }

  @override
  Future<List<SeriesData>> getAllSeries(int index) async {
    final response = await httpClient.get('series.php?index=$index');
    validateResponse(response);
    try {
      final Map<String, dynamic> dataMap = jsonDecode(response.data);
      // Check the type of 'data' field
      if (dataMap.containsKey('status') && dataMap['status'] == 'ok') {
        final dynamic data = dataMap['data'];
        // If 'data' is a String, decode it into a List<dynamic>
        final List<dynamic> jsonList = data is String ? jsonDecode(data) : data;
        List<SeriesData> series =
            jsonList.map((json) => SeriesData.fromJson(json)).toList();

        return series;
      } else {
        print('خطا در دریافت سریالها: ${dataMap["status"]}');
        return [];
      }
    } catch (e) {
      print('خطا در دریافت سریالها: $e');
      return [];
    }
  }

  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }

  @override
  Future<List<ISeries>> getSerie(int id) async {
    final response = await httpClient.get('serie.php?id_serie=$id');
    validateResponse(response);
    try {
      final Map<String, dynamic> dataMap = jsonDecode(response.data);
      // Check the type of 'data' field
      if (dataMap.containsKey('status') && dataMap['status'] == 'ok') {
        final dynamic data = dataMap['data'];
        // If 'data' is a String, decode it into a List<dynamic>
        final List<dynamic> jsonList = data is String ? jsonDecode(data) : data;
        List<ISeries> serie =
            jsonList.map((json) => ISeries.fromJson(json)).toList();

        return serie;
      } else {
        print('خطا در دریافت سریال: ${dataMap["status"]}');
        return [];
      }
    } catch (e) {
      print('خطا در دریافت سریال: $e');
      return [];
    }
  }

  @override
  Future<List<Search>> SearchMedia(String title) async {
    final response = await httpClient.get('search_title.php?title=$title');
    validateResponse(response);
    try {
      final Map<String, dynamic> dataMap = jsonDecode(response.data);
      if (dataMap != null &&
          dataMap.containsKey('status') &&
          dataMap['status'] == 'ok') {
        final dynamic data = dataMap['data'];
        final List<dynamic> dataList = jsonDecode(data);
        List<Search> search =
            dataList.map((json) => Search.fromJson(json)).toList();

        return search;
      } else {
        print('خطا در دریافت سریالها: ${dataMap["status"]}');
        return [];
      }
    } catch (e) {
      print('خطا در دریافت سریالها: $e');
      return [];
    }
  }

  @override
  Future<dynamic> getMedia(int id) async {
    final response = await httpClient.get('search_id.php?id=$id');
    validateResponse(response);
    try {
      final Map<String, dynamic> dataMap = jsonDecode(response.data);

      if (dataMap.containsKey('status') && dataMap['status'] == 'ok') {
        dynamic dataType = dataMap['data'];
        if (dataType is String) {
          dataType = jsonDecode(dataType);
        }
        if (dataType is Map<String, dynamic>) {
          if (dataType['type'] == "movie") {
            final dynamic data = dataMap['data'];
            Map<String, dynamic> jsonMap = json.decode(data);
            MoviesData moviesData = MoviesData.fromJson(jsonMap);
            return moviesData;
          } else {
            final dynamic data = dataMap['data'];
            Map<String, dynamic> jsonMap = json.decode(data);
            SeriesData serie = SeriesData.fromJson(jsonMap) ;
            return serie;
          }
        } else {
          return [];
        }
      } else {
        print('خطا در دریافت سریالها: ${dataMap["status"]}');
        return [];
      }
    } catch (e) {
      print('خطا در دریافت سریالها: $e');
      return [];
    }
  }



  @override
  Future<List<SeriesData>> getloved(int index) async {
    final response = await httpClient.get('special.php?index=$index');
    validateResponse(response);
    try {
      final Map<String, dynamic> dataMap = jsonDecode(response.data);
      // Check the type of 'data' field
      if (dataMap.containsKey('status') && dataMap['status'] == 'ok') {
        final dynamic data = dataMap['data'];
        // If 'data' is a String, decode it into a List<dynamic>
        final List<dynamic> jsonList = data is String ? jsonDecode(data) : data;
        List<SeriesData> series =
        jsonList.map((json) => SeriesData.fromJson(json)).toList();
        print(series);
        return series;
      } else {
        print('خطا در اطلاعات: ${dataMap["status"]}');
        return [];
      }
    } catch (e) {
      print('خطا در دریافت اطلاعات: $e');
      return [];
    }
  }

}
