import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex_flutter_riverpod/services/http_service.dart';

import '../controllers/home_page_controller.dart';
import '../models/page_data.dart';
import '../models/pokemon.dart';
import '../services/database_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, String url) async {
    HttpService httpService = GetIt.I.get<HttpService>();
    Response? response = await httpService.get(url);
    if (response != null &&
        response.data != null &&
        response.statusCode == 200) {
      return Pokemon.fromJson(response.data);
    }
    return null;
  },
);

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>(
  (ref) => HomePageController(HomePageData.initial()),
);

final favoritesProvider =
    StateNotifierProvider<FavoritesProvider, List<String>>(
  (ref) => FavoritesProvider([]),
);

class FavoritesProvider extends StateNotifier<List<String>> {

  static const String FAVORITES_KEY = "favorites";
  final DatabaseService _databaseService = GetIt.I.get<DatabaseService>();

  FavoritesProvider(
    super.state,
  ) {
    _setup();
  }

  Future<void> _setup() async {
    state = await _databaseService.getList(FAVORITES_KEY) ?? [];
  }

  void add(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITES_KEY, state);
  }

  void remove(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(FAVORITES_KEY, state);
  }
}
