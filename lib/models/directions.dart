class Directions
{
  String? humanReadableAddress;
  String? locationName;
  String? locationId;
  double? locationLatitude;
  double? locationLongitude;

  Directions({
    this.humanReadableAddress,
    this.locationName,
    this.locationId,
    this.locationLatitude,
    this.locationLongitude,
  });

  Directions.fromJson(Map<String, dynamic> json)
  {
    locationName = json["location_name"];
    locationId = json["location_id"];
    locationLatitude = json["location_latitude"];
    locationLongitude = json["location_longitude"];
  }

  Map<String, dynamic> toJson()
  {
    return {
      "location_name": locationName,
      "location_id": locationId,
      "location_latitude": locationLatitude,
      "location_longitude": locationLongitude,
    };
  }
}