import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_listview/model/popular_movies.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

const String URL_GET_POPULAR = '/popular';
const String BASE_MOVIE_URL = 'https://api.themoviedb.org/3/movie';
const String API_KEY = '?api_key=ed3f2c87d51c2ee427e6e5a6c3940b6f';

class _MainState extends State<Main> {
  late Future<List<Results>> movies;

  @override
  void initState() {
    super.initState();
    movies = _loadPopularMovie();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Results>>(
      future: movies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _movieList(snapshot.data!);
        } else if (snapshot.hasError) {
          return _hasError();
        }
        return _defaultView();
      },
    );
  }

  Future<List<Results>> _loadPopularMovie() async {
    var url = Uri.parse(BASE_MOVIE_URL + URL_GET_POPULAR + API_KEY);
    var response = await http.get(url);

    List<Results> result = [];
    var respObj = PopularMovies.fromJson(jsonDecode(response.body));
    if (respObj.results != null) {
      result = respObj.results!;
    }

    return result;
  }

  Widget _movieList(List<Results> data) {
    return Text('${data.length}');
  }

  Widget _hasError() {
    return Text('error');
  }

  Widget _defaultView() {
    return Text('loading...');
  }
}
