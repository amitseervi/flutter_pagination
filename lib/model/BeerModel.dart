import 'package:json_annotation/json_annotation.dart';
part 'BeerModel.g.dart';

@JsonSerializable()
class BeerModel {
  int id;
  String name;
  String tagline;
  String description;
  @JsonKey(name: "image_url")
  String imageUrl;

  BeerModel();

  factory BeerModel.fromJson(Map<String, dynamic> json) =>
      _$BeerModelFromJson(json);
}
