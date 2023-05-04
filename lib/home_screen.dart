import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keranamu/repository/card_repository.dart';
import 'package:f_logs/f_logs.dart';

import 'entity/tamago_listing_cubit.dart';
import 'entity/tamago_listing_state.dart';
import 'widgets/image_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<TamagoListingCubit>();
      cubit.fetchTamagoListing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search for a card...",
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(child: BlocBuilder<TamagoListingCubit, TamagoListingState>(
              builder: (context, state) {
            if (state is InitTamagoListingState ||
                state is LoadingTamagoListingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ResponseTamagoListingState) {
              final List<Tamago> tamagos = state.tamagos;
              final List<Tamago> filteredTamagos = _searchText.isEmpty
                  ? tamagos
                  : tamagos
                      .where((i) => i.name
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()))
                      .toList();
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredTamagos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return ImageCard(
                      imageName: filteredTamagos[index].name,
                      id: filteredTamagos[index].id);
                },
              );
            }
            return Center(child: Text(state.toString()));
          })),
        ],
      ),
    );
  }
}
