import 'package:json_annotation/json_annotation.dart';
part 'credential_status_field.g.dart';

@JsonSerializable()
class CredentialStatusField {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String revocationListIndex;
  @JsonKey(defaultValue: '')
  final String revocationListCredential;

  factory CredentialStatusField.fromJson(Map<String, dynamic> json) =>
      _$CredentialStatusFieldFromJson(json);
  factory CredentialStatusField.emptyCredentialStatusField() =>
      CredentialStatusField('', '', '', '');

  CredentialStatusField(this.id, this.type, this.revocationListIndex,
      this.revocationListCredential);

  Map<String, dynamic> toJson() => _$CredentialStatusFieldToJson(this);
}
