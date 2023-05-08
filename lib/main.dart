import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keranamu/entity/tamago_listing_cubit.dart';
import 'package:keranamu/home_screen.dart';
import 'package:keranamu/repository/card_repository.dart';

void main() {
  runApp(const Keranamu());
}

class Keranamu extends StatelessWidget {
  const Keranamu({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => TamagoListingCubit(TamagoRepository()),
      )
    ], child: const MaterialApp(home: MyHomePage()));
  }
}