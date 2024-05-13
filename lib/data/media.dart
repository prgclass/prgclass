class Genre {
  final int id;
  final String title;

  Genre({required this.id, required this.title});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] ?? 0, title: json['title'] ?? '');
  }
}

class Source {
  final int id;
  final String quality;
  final String type;
  final String url;

  Source({required this.id, required this.quality, required this.type, required this.url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? 0,
      quality: json['quality'] ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Country {
  final int id;
  final String title;

  Country({required this.id, required this.title});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(id: json['id'] ?? 0, title: json['title'] ?? '');
  }
}

class MoviesData {
  final int id;
  final String type;
  final String title;
  final String description;
  final double year;
  final double imdb;
  final bool comment;
  final double rating;
  final String duration;
  final String downloadas;
  final String playas;
  final String classification;
  final String image;
  final String cover;
  final List<Genre> genres;
  final List<Source> sources;
  final List<Country> country;

  MoviesData({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.year,
    required this.imdb,
    required this.comment,
    required this.rating,
    required this.duration,
    required this.downloadas,
    required this.playas,
    required this.classification,
    required this.image,
    required this.cover,
    required this.genres,
    required this.sources,
    required this.country,
  });

  factory MoviesData.fromJson(Map<String, dynamic> json) {
    return MoviesData(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: (json['year'] as num?)?.toDouble() ?? 0,
      imdb: (json['imdb'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] ?? '',
      downloadas: json['downloadas'] ?? '',
      playas: json['playas'] ?? '',
      classification: json['classification'] ?? '',
      image: json['image'] ?? '',
      cover: json['cover'] ?? '',
      genres: List<Genre>.from(
          json['genres'].map((genre) => Genre.fromJson(genre))),
      sources: List<Source>.from(
          json['sources'].map((source) => Source.fromJson(source))),
      country: List<Country>.from(
          json['country'].map((country) => Country.fromJson(country))),
    );
  }
}


class   SeriesData {
  final int id;
  final String type;
  final String title;
  final String description;
  final double year;
  final double imdb;
  final bool comment;
  final double rating;
  final String duration;
  final String downloadas;
  final String playas;
  final String classification;
  final String image;
  final String cover;
  final List<Genre> genres;
  final List<Country> country;

  SeriesData({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.year,
    required this.imdb,
    required this.comment,
    required this.rating,
    required this.duration,
    required this.downloadas,
    required this.playas,
    required this.classification,
    required this.image,
    required this.cover,
    required this.genres,
    required this.country,
  });

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: (json['year'] as num?)?.toDouble() ?? 0,
      imdb: (json['imdb'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] ?? '',
      downloadas: json['downloadas'] ?? '',
      playas: json['playas'] ?? '',
      classification: json['classification'] ?? '',
      image: json['image'] ?? '',
      cover: json['cover'] ?? '',
      genres: List<Genre>.from(
          json['genres'].map((genre) => Genre.fromJson(genre))),
      country: List<Country>.from(
          json['country'].map((country) => Country.fromJson(country))),
    );
  }
}




class SearchID {
  final int id;
  final String type;
  final String title;
  final String description;
  final double year;
  final double imdb;
  final bool comment;
  final double rating;
  final String duration;
  final String downloadas;
  final String playas;
  final String classification;
  final String image;
  final String cover;
  final List<Genre> genres;
  final List<Source> sources;
  final List<Country> country;

  SearchID({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.year,
    required this.imdb,
    required this.comment,
    required this.rating,
    required this.duration,
    required this.downloadas,
    required this.playas,
    required this.classification,
    required this.image,
    required this.cover,
    required this.genres,
    required this.sources,
    required this.country,
  });

  factory SearchID.fromJson(Map<String, dynamic> json) {
    return SearchID(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: (json['year'] as num?)?.toDouble() ?? 0,
      imdb: (json['imdb'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] ?? '',
      downloadas: json['downloadas'] ?? '',
      playas: json['playas'] ?? '',
      classification: json['classification'] ?? '',
      image: json['image'] ?? '',
      cover: json['cover'] ?? '',
      genres: List<Genre>.from(
          json['genres'].map((genre) => Genre.fromJson(genre))),
      sources: List<Source>.from(
          json['sources'].map((source) => Source.fromJson(source))),
      country: List<Country>.from(
          json['country'].map((country) => Country.fromJson(country))),
    );
  }
}




class Episode {
  final int id;
  final String title;
  final String? description;
  final String? duration;
  final String downloadas;
  final String playas;
  final List<Source> sources;

  Episode({
    required this.id,
    required this.title,
    this.description,
    this.duration,
    required this.downloadas,
    required this.playas,
    required this.sources,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      duration: json['duration'],
      downloadas: json['downloadas'] ?? '',
      playas: json['playas'] ?? '',
      sources: List<Source>.from(
        json['sources'].map((source) => Source.fromJson(source)),
      ),
    );
  }
}



class ISeries {
  final int id;
  final String title;
  final List<Episode> episodes;

  ISeries({
    required this.id,
    required this.title,
    required this.episodes,
  });

  factory ISeries.fromJson(Map<String, dynamic> json) {
    return ISeries(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      episodes: List<Episode>.from(
        json['episodes'].map((episode) => Episode.fromJson(episode)),
      ),
    );
  }
}



class Search {
  final String id;
  final String title;
  final String year;
  final String type;
  final String imdb;
  final String postedId;
  final String image;

  Search({
    required this.id,
    required this.title,
    required this.year,
    required this.type,
    required this.imdb,
    required this.postedId,
    required this.image,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      year: json['year'] ?? "",
      type: json['type'] ?? "",
      imdb: json['imdb'] ?? "",
      postedId: json['posted_id'] ?? "",
      image: json['image'] ?? "",
    );
  }
}
