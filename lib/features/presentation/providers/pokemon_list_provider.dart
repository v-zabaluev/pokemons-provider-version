import 'package:flutter/foundation.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../domain/entities/pokemon_entity.dart';

class PokemonListProvider extends ChangeNotifier {
  final PokemonRepository repository;
  List<PokemonEntity> _allPokemon = [];
  List<PokemonEntity> _filteredPokemon = [];
  bool _isLoading = false;
  String _error = '';

  List<PokemonEntity> get pokemons => _filteredPokemon;

  bool get isLoading => _isLoading;

  String get error => _error;

  PokemonListProvider({required this.repository});

  Future<void> fetchPokemonList() async {
    final stopwatch = Stopwatch()..start();
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      _allPokemon = await repository.getPokemonList();
      _filteredPokemon = _allPokemon;
    } catch (e) {
      _error = 'Ошибка загрузки списка покемонов';
    }
    _isLoading = false;
    stopwatch.stop();
    print('Время загрузки (Provider): ${stopwatch.elapsedMilliseconds} мс');
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredPokemon = _allPokemon;
    } else {
      final q = query.toLowerCase();
      _filteredPokemon =
          _allPokemon
              .where((pokemon) => pokemon.name.toLowerCase().contains(q))
              .toList();
    }
    notifyListeners();
  }
}
