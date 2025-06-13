import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/data/datasources/pokemon_remote_data_source.dart';
import 'features/data/repositories/pokemon_repository.dart';
import 'package:dio/dio.dart';
import 'features/presentation/pages/pokemon_list_page.dart';
import 'features/presentation/providers/pokemon_list_provider.dart';

class PokemonApp extends StatelessWidget {
  final DateTime startTime;

  const PokemonApp({super.key, required this.startTime});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'));
    final remoteDataSource = PokemonRemoteDataSource(dio);
    final repository = PokemonRepository(remoteDataSource);

    return MaterialApp(
      home: PokemonListPageProvider(
        repository: repository,
        startTime: startTime,
      ),
    );
  }
}


