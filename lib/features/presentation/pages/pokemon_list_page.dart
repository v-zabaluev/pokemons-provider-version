import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_list_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_page.dart';


class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список покемонов')),
      body: Consumer<PokemonListProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          } else {
            return ListView.builder(
              itemCount: provider.pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = provider.pokemonList[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonDetailPage(
                          url: pokemon.detailUrl,
                          repository: context.read<PokemonListProvider>().repository,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
