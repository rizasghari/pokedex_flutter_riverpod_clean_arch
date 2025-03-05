import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_flutter_riverpod/models/page_data.dart';

import '../controllers/home_page_controller.dart';
import '../widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>(
  (ref) => HomePageController(HomePageData.initial()),
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_scrollListener);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollCtrl.offset == _scrollCtrl.position.maxScrollExtent * 1 &&
        !_scrollCtrl.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);

    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _allPokemonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
              controller: _scrollCtrl,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                return PokemonListTile(
                  url: _homePageData.data!.results![index].url!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
