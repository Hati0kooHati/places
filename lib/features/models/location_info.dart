class LocationInfo {
  final double latitude;
  final double longitude;
  final String address;

  const LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory LocationInfo.fromMap(Map map) {
    return LocationInfo(
      latitude: map["latitude"],
      longitude: map["longitude"],
      address: map["address"],
    );
  }
}
