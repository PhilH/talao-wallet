import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/l10n/l10n.dart';

part 'self_issued.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SelfIssued extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  final String? address;
  final String? familyName;
  final String? givenName;
  final String? telephone;
  final String? email;

  factory SelfIssued.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedFromJson(json);

  SelfIssued(
      {required this.id,
      this.address,
      this.familyName,
      this.givenName,
      this.type = 'SelfIssued',
      this.telephone,
      this.email})
      : super(id, type, Author('', ''));

  @override
  Map<String, dynamic> toJson() => {
        'id':id,
        if (address != null && address!.isNotEmpty) 'address': address,
        if (familyName != null && familyName!.isNotEmpty) 'familyName': familyName,
        if (givenName != null && givenName!.isNotEmpty) 'givenName': givenName,
        'type': type,
        if (telephone != null && telephone!.isNotEmpty) 'telephone': telephone,
        if (email != null && email!.isNotEmpty) 'email': email,
      };

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display self-issued data');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        familyName?.isNotEmpty ?? false
            ? CredentialField(
                title: localizations.firstName, value: familyName!)
            : SizedBox.shrink(),
        givenName?.isNotEmpty ?? false
            ? CredentialField(title: localizations.lastName, value: givenName!)
            : SizedBox.shrink(),
        address?.isNotEmpty ?? false
            ? CredentialField(title: localizations.address, value: address!)
            : SizedBox.shrink(),
        email?.isNotEmpty ?? false
            ? CredentialField(title: localizations.personalMail, value: email!)
            : SizedBox.shrink(),
        telephone?.isNotEmpty ?? false
            ? CredentialField(
                title: localizations.personalPhone, value: telephone!)
            : SizedBox.shrink(),
      ],
    );
  }
}