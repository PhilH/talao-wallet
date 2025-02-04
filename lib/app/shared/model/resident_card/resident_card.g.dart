// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentCard _$ResidentCardFromJson(Map<String, dynamic> json) => ResidentCard(
      json['id'] as String,
      json['gender'] as String? ?? '',
      json['maritalStatus'] as String? ?? '',
      json['type'] as String,
      json['birthPlace'] as String? ?? '',
      json['nationality'] as String? ?? '',
      json['address'] as String? ?? '',
      json['identifier'] as String? ?? '',
      json['familyName'] as String? ?? '',
      json['image'] as String? ?? '',
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
      json['birthDate'] as String? ?? '',
      json['givenName'] as String? ?? '',
    );

Map<String, dynamic> _$ResidentCardToJson(ResidentCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gender': instance.gender,
      'maritalStatus': instance.maritalStatus,
      'type': instance.type,
      'birthPlace': instance.birthPlace,
      'nationality': instance.nationality,
      'address': instance.address,
      'identifier': instance.identifier,
      'familyName': instance.familyName,
      'image': instance.image,
      'issuedBy': instance.issuedBy.toJson(),
      'birthDate': instance.birthDate,
      'givenName': instance.givenName,
    };
