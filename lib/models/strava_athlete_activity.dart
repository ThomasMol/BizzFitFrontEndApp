class StravaAthleteActivity {
  int resourceState;
  StravaAthlete athlete;
  String name;
  double distance;
  int movingTime;
  int elapsedTime;
  double totalElevationGain;
  String type;
  int workoutType;
  int id;
  String externalId;
  int uploadId;
  String startDate;
  String startDateLocal;
  String timezone;
  double utcOffset;
  List<dynamic> startLatlng;
  List<dynamic> endLatlng;
  String locationCity;
  String locationState;
  String locationCountry;
  int achievementCount;
  int kudosCount;
  int commentCount;
  int athleteCount;
  int photoCount;
  StravaMap map;
  bool trainer;
  bool commute;
  bool manual;
  bool private;
  bool flagged;
  String gearId;
  bool fromAcceptedTag;
  double averageSpeed;
  double maxSpeed;
  double averageCadence;
  double averageWatts;
  int weightedAverageWatts;
  double kilojoules;
  bool deviceWatts;
  bool hasHeartrate;
  double averageHeartrate;
  int maxHeartrate;
  int maxWatts;
  int prCount;
  int totalPhotoCount;
  bool hasKudoed;
  int sufferScore;

  StravaAthleteActivity(
      {this.resourceState,
      this.athlete,
      this.name,
      this.distance,
      this.movingTime,
      this.elapsedTime,
      this.totalElevationGain,
      this.type,
      this.workoutType,
      this.id,
      this.externalId,
      this.uploadId,
      this.startDate,
      this.startDateLocal,
      this.timezone,
      this.utcOffset,
      this.startLatlng,
      this.endLatlng,
      this.locationCity,
      this.locationState,
      this.locationCountry,
      this.achievementCount,
      this.kudosCount,
      this.commentCount,
      this.athleteCount,
      this.photoCount,
      this.map,
      this.trainer,
      this.commute,
      this.manual,
      this.private,
      this.flagged,
      this.gearId,
      this.fromAcceptedTag,
      this.averageSpeed,
      this.maxSpeed,
      this.averageCadence,
      this.averageWatts,
      this.weightedAverageWatts,
      this.kilojoules,
      this.deviceWatts,
      this.hasHeartrate,
      this.averageHeartrate,
      this.maxHeartrate,
      this.maxWatts,
      this.prCount,
      this.totalPhotoCount,
      this.hasKudoed,
      this.sufferScore});

  StravaAthleteActivity.fromJson(Map<String, dynamic> json) {
    resourceState = json['resource_state'];
    athlete =
        json['athlete'] != null ? new StravaAthlete.fromJson(json['athlete']) : null;
    name = json['name'];
    distance = json['distance'];
    movingTime = json['moving_time'];
    elapsedTime = json['elapsed_time'];
    totalElevationGain = json['total_elevation_gain'];
    type = json['type'];
    workoutType = json['workout_type'];
    id = json['id'];
    externalId = json['external_id'];
    uploadId = json['upload_id'];
    startDate = json['start_date'];
    startDateLocal = json['start_date_local'];
    timezone = json['timezone'];
    utcOffset = json['utc_offset'];
    startLatlng = json['start_latlng'];
    endLatlng = json['end_latlng'];
    locationCity = json['location_city'];
    locationState = json['location_state'];
    locationCountry = json['location_country'];
    achievementCount = json['achievement_count'];
    kudosCount = json['kudos_count'];
    commentCount = json['comment_count'];
    athleteCount = json['athlete_count'];
    photoCount = json['photo_count'];
    map = json['map'] != null ? new StravaMap.fromJson(json['map']) : null;
    trainer = json['trainer'];
    commute = json['commute'];
    manual = json['manual'];
    private = json['private'];
    flagged = json['flagged'];
    gearId = json['gear_id'];
    fromAcceptedTag = json['from_accepted_tag'];
    averageSpeed = json['average_speed'];
    maxSpeed = json['max_speed'];
    averageCadence = json['average_cadence'];
    averageWatts = json['average_watts'];
    weightedAverageWatts = json['weighted_average_watts'];
    kilojoules = json['kilojoules'];
    deviceWatts = json['device_watts'];
    hasHeartrate = json['has_heartrate'];
    averageHeartrate = json['average_heartrate'];
    maxHeartrate = json['max_heartrate'];
    maxWatts = json['max_watts'];
    prCount = json['pr_count'];
    totalPhotoCount = json['total_photo_count'];
    hasKudoed = json['has_kudoed'];
    sufferScore = json['suffer_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource_state'] = this.resourceState;
    if (this.athlete != null) {
      data['athlete'] = this.athlete.toJson();
    }
    data['name'] = this.name;
    data['distance'] = this.distance;
    data['moving_time'] = this.movingTime;
    data['elapsed_time'] = this.elapsedTime;
    data['total_elevation_gain'] = this.totalElevationGain;
    data['type'] = this.type;
    data['workout_type'] = this.workoutType;
    data['id'] = this.id;
    data['external_id'] = this.externalId;
    data['upload_id'] = this.uploadId;
    data['start_date'] = this.startDate;
    data['start_date_local'] = this.startDateLocal;
    data['timezone'] = this.timezone;
    data['utc_offset'] = this.utcOffset;
    data['start_latlng'] = this.startLatlng;
    data['end_latlng'] = this.endLatlng;
    data['location_city'] = this.locationCity;
    data['location_state'] = this.locationState;
    data['location_country'] = this.locationCountry;
    data['achievement_count'] = this.achievementCount;
    data['kudos_count'] = this.kudosCount;
    data['comment_count'] = this.commentCount;
    data['athlete_count'] = this.athleteCount;
    data['photo_count'] = this.photoCount;
    if (this.map != null) {
      data['map'] = this.map.toJson();
    }
    data['trainer'] = this.trainer;
    data['commute'] = this.commute;
    data['manual'] = this.manual;
    data['private'] = this.private;
    data['flagged'] = this.flagged;
    data['gear_id'] = this.gearId;
    data['from_accepted_tag'] = this.fromAcceptedTag;
    data['average_speed'] = this.averageSpeed;
    data['max_speed'] = this.maxSpeed;
    data['average_cadence'] = this.averageCadence;
    data['average_watts'] = this.averageWatts;
    data['weighted_average_watts'] = this.weightedAverageWatts;
    data['kilojoules'] = this.kilojoules;
    data['device_watts'] = this.deviceWatts;
    data['has_heartrate'] = this.hasHeartrate;
    data['average_heartrate'] = this.averageHeartrate;
    data['max_heartrate'] = this.maxHeartrate;
    data['max_watts'] = this.maxWatts;
    data['pr_count'] = this.prCount;
    data['total_photo_count'] = this.totalPhotoCount;
    data['has_kudoed'] = this.hasKudoed;
    data['suffer_score'] = this.sufferScore;
    return data;
  }
}

class StravaAthlete {
  int id;
  int resourceState;

  StravaAthlete({this.id, this.resourceState});

  StravaAthlete.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceState = json['resource_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resource_state'] = this.resourceState;
    return data;
  }
}

class StravaMap {
  String id;
  String summaryPolyline;
  int resourceState;

  StravaMap({this.id, this.summaryPolyline, this.resourceState});

  StravaMap.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    summaryPolyline = json['summary_polyline'];
    resourceState = json['resource_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['summary_polyline'] = this.summaryPolyline;
    data['resource_state'] = this.resourceState;
    return data;
  }
}