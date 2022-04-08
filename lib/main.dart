import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sample_listview/model/popular_movies.dart';
import 'package:sample_listview/net/movie_api.dart';

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

class _MainState extends State<Main> {
  late Future<List<Results>> movies;

  @override
  void initState() {
    super.initState();
    movies = MovieApi.loadPopularMovie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<Results>>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _movieList(snapshot.data!);
            } else if (snapshot.hasError) {
              return _hasError();
            }
            return _defaultView();
          },
        ),
      ),
    );
  }

  Widget _movieList(List<Results> data) {
    // return ListView.builder(
    return ListView.builder(
      itemBuilder: (context, index) {
        var movie = data[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                  width: 80,
                  height: 120,
                  child: Image.network(kBASE_IMG_PATH_W154 + movie.posterPath!)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title!),
                      Text(movie.originalTitle!, overflow: TextOverflow.ellipsis,),
                      Text(movie.releaseDate!),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: data.length,
      //ListView.builder 의 경우는 사용안함
      // separatorBuilder: (context, index) {
      //   // if (index == 0) return SizedBox.shrink();
      //   return const Divider();
      // },
    );
  }

  Widget _hasError() {
    return Text('error');
  }

  Widget _defaultView() {
    return Text('loading...');
  }
}
