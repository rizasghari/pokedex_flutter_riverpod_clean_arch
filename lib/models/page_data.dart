import 'pokemon.dart';
import 'package:flutter/material.dart';

@immutable
class HomePageData {
  final PokemonListData? data;

  const HomePageData({
    required this.data,
  });

  const HomePageData.initial() : data = null;

  HomePageData copyWith({PokemonListData? data}) {
    return HomePageData(
      data: data ?? this.data,
    );
  }
}
