import 'package:flutter/material.dart';
import 'package:talao/app/shared/enum/verification_status.dart';

extension VerifyExtension on VerificationState {
  String get message {
    switch (this) {
      case VerificationState.Unverified:
        return 'Pending';
      case VerificationState.Verified:
        return 'Verified';
      case VerificationState.VerifiedWithWarning:
        return 'Verified (with warnings)';
      case VerificationState.VerifiedWithError:
        return 'Failed verification';
    }
  }

  IconData get icon {
    switch (this) {
      case VerificationState.Unverified:
        return Icons.update;
      case VerificationState.Verified:
        return Icons.check_circle_outline;
      case VerificationState.VerifiedWithWarning:
        return Icons.warning_amber_outlined;
      case VerificationState.VerifiedWithError:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case VerificationState.Unverified:
        return Colors.orange;
      case VerificationState.Verified:
        return Colors.green;
      case VerificationState.VerifiedWithWarning:
        return Colors.orange;
      case VerificationState.VerifiedWithError:
        return Colors.red;
    }
  }
}
