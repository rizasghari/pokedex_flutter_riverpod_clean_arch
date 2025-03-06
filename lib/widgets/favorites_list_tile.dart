import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';
import '../providers/providers.dart';

class FavoritesListTile extends ConsumerStatefulWidget {
  final String url;

  const FavoritesListTile({super.key, required this.url});

  @override
  ConsumerState<FavoritesListTile> createState() => _FavoritesListTileState();
}

class _FavoritesListTileState extends ConsumerState<FavoritesListTile> {
  late AsyncValue<Pokemon?> _pokemonData;
  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pokemonData = ref.watch(pokemonDataProvider(widget.url));
    _favoritePokemons = ref.watch(favoritesProvider);
    return _buildTile(context);
  }

  Widget _buildTile(BuildContext context) {
    return _pokemonData.when(
      data: (pokemon) {
        return _tile(context, false, pokemon);
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return _tile(context, true, null);
      },
    );
  }

  Widget _tile(BuildContext context, bool isLeading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLeading,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pokemon?.name!.toUpperCase() ?? "Loading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "#${pokemon?.id.toString() ?? '#'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            pokemon != null &&
                    pokemon.sprites != null &&
                    pokemon.sprites?.frontDefault != null
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(pokemon.sprites?.frontDefault ?? ""))
                : CircleAvatar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${pokemon?.moves?.length ?? 0} moves",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                  child: IconButton(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onPressed: () {
                      if (_favoritePokemons.contains(widget.url)) {
                        ref.read(favoritesProvider.notifier).remove(widget.url);
                      } else {
                        ref.read(favoritesProvider.notifier).add(widget.url);
                      }
                    },
                    icon: Icon(
                      _favoritePokemons.contains(widget.url)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
