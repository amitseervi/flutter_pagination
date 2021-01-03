import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Beers/BeerRepository.dart';
import 'package:Beers/model/BeerModel.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'beer_event.dart';
part 'beer_state.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  int _currentPage = 1;
  final BeerRepository beerRepository;
  bool isFetching = false;
  BeerBloc({this.beerRepository}) : super(BeerInitial());

  @override
  Stream<BeerState> mapEventToState(
    BeerEvent event,
  ) async* {
    log("event received");
    if (event is BeerFetchEvent) {
      yield BeerLoadingState("loading page $_currentPage");
      final response = await beerRepository.getBeers(page: _currentPage);
      if (response is http.Response) {
        if (response.statusCode == HttpStatus.ok) {
          final beers = jsonDecode(response.body) as List;
          yield BeerSuccessState(
              beers.map((e) => BeerModel.fromJson(e)).toList());
          _currentPage++;
        } else {
          yield BeerErrorState(
              "failed request with code : ${response.statusCode}");
        }
      } else {
        yield BeerErrorState("did not receive response");
      }
    }
  }
}
