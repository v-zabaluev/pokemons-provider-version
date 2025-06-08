import 'package:flutter/foundation.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../domain/entities/pokemon_entity.dart';

class PokemonListProvider with ChangeNotifier {
  final PokemonRepository repository;

  PokemonListProvider(this.repository);

  List<PokemonEntity> _pokemonList = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<PokemonEntity> get pokemonList => _pokemonList;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadPokemonList() async {
    _isLoading = true;
    notifyListeners();
    try {
      _pokemonList = await repository.getPokemonList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Ошибка загрузки списка покемонов';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
