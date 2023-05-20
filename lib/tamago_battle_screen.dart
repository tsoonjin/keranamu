import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keranamu/repository/card_repository.dart';

import 'entity/tamago_listing_cubit.dart';
import 'entity/tamago_listing_state.dart';
import 'widgets/image_card.dart';

class TamagoBattlePage extends StatefulWidget {
  const TamagoBattlePage({super.key});

  @override
  State<TamagoBattlePage> createState() => _TamagoBattlePageState();
}

class _TamagoBattlePageState extends State<TamagoBattlePage> {
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
        body: Center(
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 175,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ), //BoxDecoration
                ), //Container
                const SizedBox(
                  width: 20,
                ), //SizedBox
                Container(
                    width: 175,
                    height: 175,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ) //BoxDecoration
                    ) //Container
              ], //<Widget>[]
            ), //Row
            Container(
              width: 380,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue), //BoxDecoration
            ), //Container
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.cyan,
                  ), //BoxDecoration
                ), //Container
                const SizedBox(
                  width: 20,
                ), //SizedBox
                Container(
                    width: 180,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan,
                    ) //BoxedDecoration
                    ) //Container
              ], //<Widget>[]
            ), //Row
          ], //<widget>[]
        ), //Column
      ) //Padding
          ), //Container
    ));
  }
}
