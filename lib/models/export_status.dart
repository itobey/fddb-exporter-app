import 'package:json_annotation/json_annotation.dart';

part 'export_status.g.dart';

@JsonSerializable()
class ExportStatus {
  List<String> successfulDays;
  List<String> unsuccessfulDays;

  ExportStatus({
    required this.successfulDays,
    required this.unsuccessfulDays,
  });

  factory ExportStatus.fromJson(Map<String, dynamic> json) => _$ExportStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ExportStatusToJson(this);
}