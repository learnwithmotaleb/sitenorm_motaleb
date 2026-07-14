import 'package:intl/intl.dart';

class ResultSummaryModel {
  final bool? success;
  final Data? data;

  ResultSummaryModel({this.success, this.data});

  factory ResultSummaryModel.fromJson(Map<String, dynamic> json) =>
      ResultSummaryModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  final String? simpleLabel;
  final String? determination;
  final int? totalScore;
  final int? maxScore;
  final String? period;
  final Station? station;
  final List<Station>? stations;
  final String? stationMethod;
  final Station? rainfallStation;
  final Location? location;
  final String? county;
  final String? state;
  final String? countyFips;
  final List<RainfallRecord>? rainfallRecord;
  final List<MonthDetail>? monthDetails;
  final AdditionalInfo? additionalInfo;
  final String? climateReferencePeriod;
  final List<StationLog>? stationLog;
  final DateTime? observationDate;

  Data({
    this.simpleLabel,
    this.determination,
    this.totalScore,
    this.maxScore,
    this.period,
    this.station,
    this.stations,
    this.stationMethod,
    this.rainfallStation,
    this.location,
    this.county,
    this.state,
    this.countyFips,
    this.rainfallRecord,
    this.monthDetails,
    this.additionalInfo,
    this.climateReferencePeriod,
    this.stationLog,
    this.observationDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    simpleLabel: json["simpleLabel"],
    determination: json["determination"],
    totalScore: json["totalScore"],
    maxScore: json["maxScore"],
    period: json["period"],
    station: json["station"] == null ? null : Station.fromJson(json["station"]),
    stations: json["stations"] == null
        ? []
        : List<Station>.from(json["stations"]!.map((x) => Station.fromJson(x))),
    stationMethod: json["stationMethod"],
    rainfallStation: json["rainfallStation"] == null
        ? null
        : Station.fromJson(json["rainfallStation"]),
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    county: json["county"],
    state: json["state"],
    countyFips: json["countyFips"],
    rainfallRecord: json["rainfallRecord"] == null
        ? []
        : List<RainfallRecord>.from(
            json["rainfallRecord"]!.map((x) => RainfallRecord.fromJson(x)),
          ),
    monthDetails: json["monthDetails"] == null
        ? []
        : List<MonthDetail>.from(
            json["monthDetails"]!.map((x) => MonthDetail.fromJson(x)),
          ),
    additionalInfo: json["additionalInfo"] == null
        ? null
        : AdditionalInfo.fromJson(json["additionalInfo"]),
    climateReferencePeriod: json["climateReferencePeriod"],
    stationLog: json["stationLog"] == null
        ? []
        : List<StationLog>.from(
            json["stationLog"]!.map((x) => StationLog.fromJson(x)),
          ),
    observationDate: _parseDate(json["observationDate"]),
  );

  static DateTime? _parseDate(dynamic dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      try {
        return DateFormat("MMM dd, yyyy").parse(dateString);
      } catch (_) {
        return null;
      }
    }
  }

  Map<String, dynamic> toJson() => {
    "simpleLabel": simpleLabel,
    "determination": determination,
    "totalScore": totalScore,
    "maxScore": maxScore,
    "period": period,
    "station": station?.toJson(),
    "stations": stations == null
        ? []
        : List<dynamic>.from(stations!.map((x) => x.toJson())),
    "stationMethod": stationMethod,
    "rainfallStation": rainfallStation?.toJson(),
    "location": location?.toJson(),
    "county": county,
    "state": state,
    "countyFips": countyFips,
    "rainfallRecord": rainfallRecord == null
        ? []
        : List<dynamic>.from(rainfallRecord!.map((x) => x.toJson())),
    "monthDetails": monthDetails == null
        ? []
        : List<dynamic>.from(monthDetails!.map((x) => x.toJson())),
    "additionalInfo": additionalInfo?.toJson(),
    "climateReferencePeriod": climateReferencePeriod,
    "stationLog": stationLog == null
        ? []
        : List<dynamic>.from(stationLog!.map((x) => x.toJson())),
    "observationDate": observationDate == null
        ? null
        : "${observationDate!.year.toString().padLeft(4, '0')}-${observationDate!.month.toString().padLeft(2, '0')}-${observationDate!.day.toString().padLeft(2, '0')}",
  };
}

class AdditionalInfo {
  final String? wetsStation;
  final String? location;
  final String? soilMapUnit;
  final String? growingSeason;
  final String? growingSeasonThreshold;

  AdditionalInfo({
    this.wetsStation,
    this.location,
    this.soilMapUnit,
    this.growingSeason,
    this.growingSeasonThreshold,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    wetsStation: json["wetsStation"],
    location: json["location"],
    soilMapUnit: json["soilMapUnit"],
    growingSeason: json["growingSeason"],
    growingSeasonThreshold: json["growingSeasonThreshold"],
  );

  Map<String, dynamic> toJson() => {
    "wetsStation": wetsStation,
    "location": location,
    "soilMapUnit": soilMapUnit,
    "growingSeason": growingSeason,
    "growingSeasonThreshold": growingSeasonThreshold,
  };
}

class Location {
  final double? lat;
  final double? lon;

  Location({this.lat, this.lon});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(lat: json["lat"]?.toDouble(), lon: json["lon"]?.toDouble());

  Map<String, dynamic> toJson() => {"lat": lat, "lon": lon};
}

class RainfallRecord {
  final String? month;
  final double? less30;
  final double? avg;
  final double? more30;
  final double? rainfall;
  final String? condition;

  RainfallRecord({
    this.month,
    this.less30,
    this.avg,
    this.more30,
    this.rainfall,
    this.condition,
  });

  factory RainfallRecord.fromJson(Map<String, dynamic> json) => RainfallRecord(
    month: json["month"],
    less30: _parseDouble(json["less30"]),
    avg: _parseDouble(json["avg"]),
    more30: _parseDouble(json["more30"]),
    rainfall: _parseDouble(json["rainfall"]),
    condition: json["condition"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "less30": less30,
    "avg": avg,
    "more30": more30,
    "rainfall": rainfall,
    "condition": condition,
  };
}

class MonthDetail {
  final int? position;
  final String? month;
  final int? year;
  final int? monthNum;
  final double? less30;
  final double? avg;
  final double? more30;
  final double? rainfall;
  final String? condition;
  final int? conditionValue;
  final int? weight;
  final int? score;

  MonthDetail({
    this.position,
    this.month,
    this.year,
    this.monthNum,
    this.less30,
    this.avg,
    this.more30,
    this.rainfall,
    this.condition,
    this.conditionValue,
    this.weight,
    this.score,
  });

  factory MonthDetail.fromJson(Map<String, dynamic> json) => MonthDetail(
    position: _parseInt(json["position"]),
    month: json["month"],
    year: _parseInt(json["year"]),
    monthNum: _parseInt(json["monthNum"]),
    less30: _parseDouble(json["less30"]),
    avg: _parseDouble(json["avg"]),
    more30: _parseDouble(json["more30"]),
    rainfall: _parseDouble(json["rainfall"]),
    condition: json["condition"],
    conditionValue: _parseInt(json["conditionValue"]),
    weight: _parseInt(json["weight"]),
    score: _parseInt(json["score"]),
  );

  Map<String, dynamic> toJson() => {
    "position": position,
    "month": month,
    "year": year,
    "monthNum": monthNum,
    "less30": less30,
    "avg": avg,
    "more30": more30,
    "rainfall": rainfall,
    "condition": condition,
    "conditionValue": conditionValue,
    "weight": weight,
    "score": score,
  };
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

class Station {
  final String? name;
  final String? sid;
  final double? lat;
  final double? lon;
  final dynamic distance;

  Station({this.name, this.sid, this.lat, this.lon, this.distance});

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    name: json["name"],
    sid: json["sid"],
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sid": sid,
    "lat": lat,
    "lon": lon,
    "distance": distance,
  };
}

class StationLog {
  final String? stationName;
  final String? sid;
  final dynamic distance;
  final String? status;
  final String? reason;

  StationLog({
    this.stationName,
    this.sid,
    this.distance,
    this.status,
    this.reason,
  });

  factory StationLog.fromJson(Map<String, dynamic> json) => StationLog(
    stationName: json["stationName"],
    sid: json["sid"],
    distance: json["distance"],
    status: json["status"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "stationName": stationName,
    "sid": sid,
    "distance": distance,
    "status": status,
    "reason": reason,
  };
}
