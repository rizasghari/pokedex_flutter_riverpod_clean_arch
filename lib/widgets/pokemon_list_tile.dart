import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';
import '../providers/providers.dart';

class PokemonListTile extends ConsumerStatefulWidget {
  final String url;

  const PokemonListTile({super.key, required this.url});

  @override
  ConsumerState<PokemonListTile> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends ConsumerState<PokemonListTile> {
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
      child: ListTile(
        leading: pokemon != null &&
                pokemon.sprites != null &&
                pokemon.sprites?.frontDefault != null
            ? CircleAvatar(
                backgroundImage:
                    NetworkImage(pokemon.sprites?.frontDefault ?? ""))
            : CircleAvatar(),
        title: Text(pokemon?.name!.toUpperCase() ?? "Loading..."),
        subtitle: Text("Has ${pokemon?.moves?.length ?? 0} moves"),
        trailing: IconButton(
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
    );
  }
}
