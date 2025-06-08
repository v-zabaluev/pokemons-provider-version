import 'package:flutter/foundation.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../domain/entities/pokemon_details_entity.dart';

class PokemonDetailProvider with ChangeNotifier {
  final PokemonRepository repository;

  PokemonDetailProvider(this.repository);

  PokemonDetailEntity? _pokemonDetail;
  String? _errorMessage;
  bool _isLoading = false;

  PokemonDetailEntity? get pokemonDetail => _pokemonDetail;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadPokemonDetail(String url) async {
    _isLoading = true;
    notifyListeners();
    try {
      _pokemonDetail = await repository.getPokemonDetail(url);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Ошибка загрузки подробной информации о покемоне';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
