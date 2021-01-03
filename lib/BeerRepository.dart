import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BeerRepository {
  static const int _perPage = 10;
  const BeerRepository._();
  static final BeerRepository _instance = BeerRepository._();
  factory BeerRepository() {
    return _instance;
  }

  Future<dynamic> getBeers({@required int page}) async {
    try {
      final url =
          "https://api.punkapi.com/v2/beers?page=$page&per_page=$_perPage";
      log("htting url " + url);
      final headers = Map<String, String>();
      headers[HttpHeaders.contentTypeHeader] = ContentType.json.mimeType;
      return await http.get(url, headers: headers);
    } catch (e) {
      return e.toString();
    }
  }
}
