import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../providers/pokemon_list_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_page.dart';


class PokemonListPageProvider extends StatefulWidget {
  final PokemonRepository repository;
  final DateTime startTime;

  const PokemonListPageProvider({
    super.key,
    required this.repository,
    required this.startTime,
  });

  @override
  State<PokemonListPageProvider> createState() => _PokemonListPageProviderState();
}

class _PokemonListPageProviderState extends State<PokemonListPageProvider> {
  late final PokemonListProvider _provider;
  bool _measured = false;

  @override
  void initState() {
    super.initState();
    _provider = PokemonListProvider(repository: widget.repository);
    _provider.addListener(_checkLoaded);
    _provider.fetchPokemonList();
  }

  void _checkLoaded() {
    if (!_measured && !_provider.isLoading && _provider.error.isEmpty && _provider.pokemons.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final loadDuration = DateTime.now().difference(widget.startTime);
        print('Полная загрузка UI заняла: ${loadDuration.inMilliseconds} мс');
        _measured = true;
      });
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_checkLoaded);
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(title: const Text('Список покемонов')),
        body: Consumer<PokemonListProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error.isNotEmpty) {
              return Center(child: Text(provider.error));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Поиск покемона',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: provider.search,
                  ),
                ),
                Expanded(
                  child: provider.pokemons.isEmpty
                      ? const Center(child: Text('Ничего не найдено'))
                      : ListView.builder(
                    itemCount: provider.pokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = provider.pokemons[index];
                      return PokemonCard(
                        pokemon: pokemon,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PokemonDetailPage(
                                url: pokemon.detailUrl,
                                repository: widget.repository,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


