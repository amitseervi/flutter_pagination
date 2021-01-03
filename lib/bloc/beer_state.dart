part of 'beer_bloc.dart';

@immutable
abstract class BeerState {
  const BeerState();
}

class BeerInitial extends BeerState {
  const BeerInitial() : super();
}

class BeerLoadingState extends BeerState {
  final String message;
  const BeerLoadingState(this.message) : super();
}

class BeerSuccessState extends BeerState {
  final List<BeerModel> beers;

  const BeerSuccessState(this.beers);
}

class BeerErrorState extends BeerState {
  final String message;

  const BeerErrorState(this.message);
}
