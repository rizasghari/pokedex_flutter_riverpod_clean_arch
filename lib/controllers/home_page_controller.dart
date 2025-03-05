import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_flutter_riverpod/services/http_service.dart';
import 'package:flutter/material.dart';

import '../models/page_data.dart';
import '../models/pokemon.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt sl = GetIt.I;
  late HttpService _httpService;

  HomePageController(
    super.state,
  ) {
    _httpService = sl.get<HttpService>();
    _setUp();
  }

  Future<void> _setUp() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      var url = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0";
      Response? res = await _httpService.get(url);
      if (res != null && res.data != null && res.statusCode == 200) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(data: data);
      }
    } else {
      if (state.data?.next == null) return;

      var url = state.data!.next!;
      debugPrint(url);
      Response? res = await _httpService.get(url);
      if (res != null && res.data != null && res.statusCode == 200) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(
          data: data.copyWith(
            results: [
              ...?state.data?.results,
              ...?data.results,
            ],
          ),
        );
      }
    }
  }
}
