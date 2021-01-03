part of 'beer_bloc.dart';

@immutable
abstract class BeerEvent {
  const BeerEvent();
}

class BeerFetchEvent extends BeerEvent {
  const BeerFetchEvent();
}
