import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../main.dart';
import '../model/popular_movies.dart';

const String kURL_GET_POPULAR_MOVIE = 'movie/popular';
const String kURL_GET_SEARCH_MOVIE = 'search/movie';
const String kURL_TV = 'tv/';
const String kSLASH = '/';
const String kURL_RATING = 'rating';
const String kBASE_TMDB_URL = 'https://api.themoviedb.org/3/';


const String kAPI_KEY = '?api_key=';

const String kBASE_IMG_PATH = 'https://image.tmdb.org/t/p/original';

const String kSEARCH_KEYWORD = '&query=스파이더';
const String kLANGUEGE_KO = '&language=ko-KR';
const String kPARAM_PAGE = '&page=1';


class MovieApi {
  static Future<List<Results>> loadPopularMovie() async {
    var url = Uri.parse(kBASE_TMDB_URL + kURL_GET_POPULAR_MOVIE + kAPI_KEY);
    var response = await get(url);

    List<Results> result = [];
    var respObj = PopularMovies.fromJson(jsonDecode(response.body));
    if (respObj.results != null) {
      result = respObj.results!;
    }

    return result;
  }

  static Future<List<Results>> rateTVShow(String tvid, double rate) async {
    var url = Uri.parse(kBASE_TMDB_URL + kURL_TV + tvid + kSLASH + kURL_RATING + kAPI_KEY);
    //header
    var headers = {'Content-Type': 'application/json'};
    //map data
    var data = {
      "value": 8.5
    };
    //dart:convertor 패키지의 jsonCodec 을 통해 map to json
    var body = json.encode(data);
    var response = await post(url, body: body, headers: headers);

    List<Results> result = [];
    var respObj = PopularMovies.fromJson(jsonDecode(response.body));
    if (respObj.results != null) {
      result = respObj.results!;
    }

    return result;
  }

}
