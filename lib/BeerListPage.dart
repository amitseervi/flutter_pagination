import 'dart:developer';

import 'package:Beers/BeerRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/beer_bloc.dart';
import 'model/BeerModel.dart';

class BeerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return BeerBloc(beerRepository: BeerRepository())
          ..add(BeerFetchEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Beers"),
        ),
        body: BeerListBody(),
      ),
    );
  }
}

class BeerListBody extends StatelessWidget {
  final List<BeerModel> _beers = [];
  final ScrollController _scrollControler = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: BlocConsumer<BeerBloc, BeerState>(
        listener: (context, state) {
          if (state is BeerLoadingState) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is BeerSuccessState) {
            _beers.addAll(state.beers);
            context.read<BeerBloc>().isFetching = false;
            Scaffold.of(context).hideCurrentSnackBar();
          } else if (state is BeerErrorState) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.read<BeerBloc>().isFetching = false;
          } else if (state is BeerInitial &&
              !context.read<BeerBloc>().isFetching) {
            context.read<BeerBloc>()
              ..isFetching = true
              ..add(BeerFetchEvent());
          }
        },
        builder: (context, state) {
          _scrollControler
            ..addListener(() {
              if (_scrollControler.offset ==
                      _scrollControler.position.maxScrollExtent &&
                  !context.read<BeerBloc>().isFetching) {
                context.read<BeerBloc>()
                  ..isFetching = true
                  ..add(BeerFetchEvent());
              }
            });
          if (state is BeerInitial ||
              (_beers.isEmpty && state is BeerLoadingState)) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BeerErrorState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<BeerBloc>()
                      ..isFetching = true
                      ..add(BeerFetchEvent());
                  },
                  icon: Icon(Icons.refresh),
                ),
                const SizedBox(height: 15),
                Text(state.message, textAlign: TextAlign.center),
              ],
            );
          }
          return ListView.separated(
              controller: _scrollControler,
              itemBuilder: (context, index) {
                return BeerListItem(
                  beer: _beers[index],
                  key: UniqueKey(),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: _beers.length);
        },
      ),
    );
  }
}

class BeerListItem extends StatelessWidget {
  final BeerModel beer;

  const BeerListItem({Key key, this.beer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(beer.name),
      subtitle: Container(
        child: Column(
          children: [
            Text(beer.description),
            if (beer.imageUrl != null)
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.network(
                  beer.imageUrl,
                ),
              )
          ],
        ),
      ),
    );
  }
}
