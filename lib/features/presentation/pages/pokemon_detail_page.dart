import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../providers/pokemon_detail_provider.dart';

class PokemonDetailPage extends StatelessWidget {
  final String url;
  final PokemonRepository repository;

  const PokemonDetailPage({
    required this.url,
    required this.repository,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonDetailProvider(repository)..loadPokemonDetail(url),
      child: Scaffold(
        appBar: AppBar(title: const Text('Информация о покемоне')),
        body: Consumer<PokemonDetailProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            } else if (provider.pokemonDetail != null) {
              final p = provider.pokemonDetail!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(p.imageUrl, height: 200),
                      const SizedBox(height: 20),
                      Text(p.name.toUpperCase(), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('ID: ${p.id}'),
                      Text('Рост: ${p.height}'),
                      Text('Вес: ${p.weight}'),
                      Text('По умолчанию: ${p.isDefault ? "Да" : "Нет"}'),
                      const SizedBox(height: 20),
                      const Text('Способности', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...p.abilities.map((ability) => Text(ability, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
