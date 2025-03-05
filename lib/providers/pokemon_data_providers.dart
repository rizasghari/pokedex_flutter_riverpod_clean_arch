import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_flutter_riverpod/services/http_service.dart';

import '../models/pokemon.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, String url) async {
    HttpService httpService = GetIt.I.get<HttpService>();
    Response? response = await httpService.get(url);
    if (response != null && response.data != null && response.statusCode == 200) {
      return Pokemon.fromJson(response.data);
    }
    return null;
  },
);