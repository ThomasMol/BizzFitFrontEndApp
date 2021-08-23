class FitbitActivityLog {
  List<FitbitActivities> activities;
  FitbitPagination pagination;

  FitbitActivityLog({this.activities, this.pagination});

  FitbitActivityLog.fromJson(Map<String, dynamic> json) {
    if (json['activities'] != null) {
      List<FitbitActivities> activities = [];
      json['activities'].forEach((v) {
        activities.add(new FitbitActivities.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new FitbitPagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activities != null) {
      data['activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class FitbitActivities {
  int activeDuration;
  List<FitbitActivityLevel> activityLevel;
  String activityName;
  int activityTypeId;
  int averageHeartRate;
  int calories;
  String caloriesLink;
  double distance;
  String distanceUnit;
  int duration;
  String heartRateLink;
  List<FitbitHeartRateZones> heartRateZones;
  String lastModified;
  int logId;
  String logType;
  FitbitManualValuesSpecified manualValuesSpecified;
  FitbitSource source;
  double speed;
  String startTime;
  int steps;
  String tcxLink;
  double pace;

  FitbitActivities(
      {this.activeDuration,
      this.activityLevel,
      this.activityName,
      this.activityTypeId,
      this.averageHeartRate,
      this.calories,
      this.caloriesLink,
      this.distance,
      this.distanceUnit,
      this.duration,
      this.heartRateLink,
      this.heartRateZones,
      this.lastModified,
      this.logId,
      this.logType,
      this.manualValuesSpecified,
      this.source,
      this.speed,
      this.startTime,
      this.steps,
      this.tcxLink,
      this.pace});

  FitbitActivities.fromJson(Map<String, dynamic> json) {
    activeDuration = json['activeDuration'];
    if (json['activityLevel'] != null) {
      List<FitbitActivityLevel> activityLevel = [];
      json['activityLevel'].forEach((v) {
        activityLevel.add(new FitbitActivityLevel.fromJson(v));
      });
    }
    activityName = json['activityName'];
    activityTypeId = json['activityTypeId'];
    averageHeartRate = json['averageHeartRate'];
    calories = json['calories'];
    caloriesLink = json['caloriesLink'];
    distance = json['distance'];
    distanceUnit = json['distanceUnit'];
    duration = json['duration'];
    heartRateLink = json['heartRateLink'];
    if (json['heartRateZones'] != null) {
      List<FitbitHeartRateZones> heartRateZones = [];
      json['heartRateZones'].forEach((v) {
        heartRateZones.add(new FitbitHeartRateZones.fromJson(v));
      });
    }
    lastModified = json['lastModified'];
    logId = json['logId'];
    logType = json['logType'];
    manualValuesSpecified = json['manualValuesSpecified'] != null
        ? new FitbitManualValuesSpecified.fromJson(json['manualValuesSpecified'])
        : null;
    source =
        json['source'] != null ? new FitbitSource.fromJson(json['source']) : null;
    speed = json['speed'];
    startTime = json['startTime'];
    steps = json['steps'];
    tcxLink = json['tcxLink'];
    pace = json['pace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activeDuration'] = this.activeDuration;
    if (this.activityLevel != null) {
      data['activityLevel'] =
          this.activityLevel.map((v) => v.toJson()).toList();
    }
    data['activityName'] = this.activityName;
    data['activityTypeId'] = this.activityTypeId;
    data['averageHeartRate'] = this.averageHeartRate;
    data['calories'] = this.calories;
    data['caloriesLink'] = this.caloriesLink;
    data['distance'] = this.distance;
    data['distanceUnit'] = this.distanceUnit;
    data['duration'] = this.duration;
    data['heartRateLink'] = this.heartRateLink;
    if (this.heartRateZones != null) {
      data['heartRateZones'] =
          this.heartRateZones.map((v) => v.toJson()).toList();
    }
    data['lastModified'] = this.lastModified;
    data['logId'] = this.logId;
    data['logType'] = this.logType;
    if (this.manualValuesSpecified != null) {
      data['manualValuesSpecified'] = this.manualValuesSpecified.toJson();
    }
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    data['speed'] = this.speed;
    data['startTime'] = this.startTime;
    data['steps'] = this.steps;
    data['tcxLink'] = this.tcxLink;
    data['pace'] = this.pace;
    return data;
  }
}

class FitbitActivityLevel {
  int minutes;
  String name;

  FitbitActivityLevel({this.minutes, this.name});

  FitbitActivityLevel.fromJson(Map<String, dynamic> json) {
    minutes = json['minutes'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minutes'] = this.minutes;
    data['name'] = this.name;
    return data;
  }
}

class FitbitHeartRateZones {
  int max;
  int min;
  int minutes;
  String name;

  FitbitHeartRateZones({this.max, this.min, this.minutes, this.name});

  FitbitHeartRateZones.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    min = json['min'];
    minutes = json['minutes'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max'] = this.max;
    data['min'] = this.min;
    data['minutes'] = this.minutes;
    data['name'] = this.name;
    return data;
  }
}

class FitbitManualValuesSpecified {
  bool calories;
  bool distance;
  bool steps;

  FitbitManualValuesSpecified({this.calories, this.distance, this.steps});

  FitbitManualValuesSpecified.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    distance = json['distance'];
    steps = json['steps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['distance'] = this.distance;
    data['steps'] = this.steps;
    return data;
  }
}

class FitbitSource {
  String id;
  String name;
  String type;
  String url;

  FitbitSource({this.id, this.name, this.type, this.url});

  FitbitSource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}

class FitbitPagination {
  String beforeDate;
  int limit;
  String next;
  String sort;

  FitbitPagination({this.beforeDate, this.limit, this.next, this.sort});

  FitbitPagination.fromJson(Map<String, dynamic> json) {
    beforeDate = json['beforeDate'];
    limit = json['limit'];
    next = json['next'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beforeDate'] = this.beforeDate;
    data['limit'] = this.limit;
    data['next'] = this.next;
    data['sort'] = this.sort;
    return data;
  }
}