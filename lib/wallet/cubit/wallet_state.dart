part of 'wallet_cubit.dart';

enum KeyStatus { init, needsKey, hasKey, resetKey }

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = KeyStatus.init,
    List<CredentialModel>? credentials,
  }) : credentials = credentials ?? [];

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final KeyStatus status;
  final List<CredentialModel> credentials;

  WalletState copyWith(
      {KeyStatus? status, List<CredentialModel>? credentials}) {
    return WalletState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [status, credentials];
}
