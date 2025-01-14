class AreaHierarchy {
  String areaCode;
  String areaDesc;
  List<String> districtNames;

  AreaHierarchy({
    required this.areaCode,
    required this.areaDesc,
    required this.districtNames,
  });


factory AreaHierarchy.fromJson(Map<String, dynamic> json) {
    return AreaHierarchy(
      areaCode: json['areaCode'],
      areaDesc: json['areaDesc'],
      districtNames: List<String>.from(json['districtNames']),
    );
  }
}


