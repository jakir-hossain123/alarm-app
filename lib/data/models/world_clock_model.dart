class WorldClockModel {
  final int id;
  final String city;
  final String timeZone;

  WorldClockModel({
    required this.id,
    required this.city,
    required this.timeZone,
  });

  factory  WorldClockModel.fromMap (Map<String,dynamic> map){
    return WorldClockModel(
        id: map["id"],
        city: map["city"],
        timeZone: map["timeZone"]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'city': city,
      'timeZone': timeZone
    };
  }

}