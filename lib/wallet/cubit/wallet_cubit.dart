import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/interop/secure_storage/secure_storage.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:bloc/bloc.dart';
import 'package:talao/credentials/credentials.dart';
import 'package:talao/drawer/drawer.dart';

part 'wallet_state.dart';

part 'wallet_cubit.g.dart';

class WalletCubit extends Cubit<WalletState> {
  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;

  WalletCubit({
    required this.repository,
    required this.secureStorageProvider,
    required this.profileCubit,
  }) : super(WalletState()) {
    initialize();
  }

  Future initialize() async {
    final key = await secureStorageProvider.get('key');
    if (key != null) {
      if (key.isNotEmpty) {
        /// When app is initialized, set all credentials with active status to unknown status
        await repository.initializeRevocationStatus();
        await loadAllCredentialsFromRepository();
      }
    }
  }

  Future loadAllCredentialsFromRepository() async {
    await repository.findAll(/* filters */).then((values) {
      emit(state.copyWith(
        status: WalletStatus.init,
        credentials: values,
      ));
    });
  }

  Future deleteById(String id) async {
    await repository.deleteById(id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == id);
    emit(state.copyWith(
      status: WalletStatus.delete,
      credentials: credentials,
    ));
  }

  Future updateCredential(CredentialModel credential) async {
    await repository.update(credential);
    final index = state.credentials
        .indexWhere((element) => element.id == credential.id.toString());
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id)
      ..insert(index, credential);
    emit(state.copyWith(
      status: WalletStatus.update,
      credentials: credentials,
    ));
  }

  Future handleUnknownRevocationStatus(CredentialModel credential) async {
    await repository.update(credential);
    final index = state.credentials
        .indexWhere((element) => element.id == credential.id.toString());
    if (index != -1) {
      final credentials = List.of(state.credentials)
        ..removeWhere((element) => element.id == credential.id)
        ..insert(index, credential);
      emit(state.copyWith(
        status: WalletStatus.idle,
        credentials: credentials,
      ));
    }
  }

  Future insertCredential(CredentialModel credential) async {
    await repository.insert(credential);
    final credentials = List.of(state.credentials)..add(credential);
    emit(state.copyWith(
      status: WalletStatus.insert,
      credentials: credentials,
    ));
  }

  Future resetWallet() async {
    await secureStorageProvider.delete(SecureStorageKeys.key);
    await secureStorageProvider.delete(SecureStorageKeys.mnemonic);
    await secureStorageProvider.delete(SecureStorageKeys.data);
    await repository.deleteAll();
    await profileCubit.resetProfile();
    emit(state.copyWith(
      status: WalletStatus.reset,
      credentials: [],
    ));
    emit(state.copyWith(status: WalletStatus.init));
  }

  Future<void> recoverWallet(List<CredentialModel> credentials) async {
    await repository.deleteAll();
    credentials
        .forEach((credential) async => await repository.insert(credential));
    emit(state.copyWith(
      status: WalletStatus.init,
      credentials: credentials,
    ));
  }

  Future searchWallet(String search) async {
    final searchKeywords = search.split(' ');

    /// We remove empty strings from the list of keyWords
    searchKeywords.removeWhere((element) => element == '');
    if (searchKeywords.isNotEmpty) {
      await loadAllCredentialsFromRepository();
      final searchList = state.credentials.where((element) {
        var isMatch = false;
        searchKeywords.forEach(
          (keyword) {
            if (removeDiacritics(jsonEncode(element))
                .toLowerCase()
                .contains(removeDiacritics(keyword.toLowerCase()))) {
              isMatch = true;
            }
          },
        );
        return isMatch;
      }).toList();
      emit(
          state.copyWith(status: WalletStatus.search, credentials: searchList));
    }
  }
}

String removeDiacritics(String str) {
  final diacriticsMap = {};

  if (diacriticsMap.isEmpty) {
    for (var i = 0; i < ACCENTUATIONS.length; i++) {
      final letters = ACCENTUATIONS[i]['letters'] as String;
      for (var j = 0; j < letters.length; j++) {
        diacriticsMap[letters[j]] = ACCENTUATIONS[i]['key'];
      }
    }
  }

  return str.replaceAllMapped(
    RegExp('[^\u0000-\u007E]', multiLine: true),
    (a) {
      // ignore: prefer_if_null_operators
      return diacriticsMap[a.group(0)] != null
          ? diacriticsMap[a.group(0)]
          : a.group(0);
    },
  );
}

const ACCENTUATIONS = [
  {
    'key': 'a',
    'letters':
        '\u0061\u24D0\uFF41\u1E9A\u00E0\u00E1\u00E2\u1EA7\u1EA5\u1EAB\u1EA9\u00E3\u0101\u0103\u1EB1\u1EAF\u1EB5\u1EB3\u0227\u01E1\u00E4\u01DF\u1EA3\u00E5\u01FB\u01CE\u0201\u0203\u1EA1\u1EAD\u1EB7\u1E01\u0105\u2C65\u0250'
  },
  {
    'key': 'A',
    'letters':
        '\u0041\u24B6\uFF21\u00C0\u00C1\u00C2\u1EA6\u1EA4\u1EAA\u1EA8\u00C3\u0100\u0102\u1EB0\u1EAE\u1EB4\u1EB2\u0226\u01E0\u00C4\u01DE\u1EA2\u00C5\u01FA\u01CD\u0200\u0202\u1EA0\u1EAC\u1EB6\u1E00\u0104\u023A\u2C6F'
  },
  {
    'key': 'E',
    'letters':
        '\u0045\u24BA\uFF25\u00C8\u00C9\u00CA\u1EC0\u1EBE\u1EC4\u1EC2\u1EBC\u0112\u1E14\u1E16\u0114\u0116\u00CB\u1EBA\u011A\u0204\u0206\u1EB8\u1EC6\u0228\u1E1C\u0118\u1E18\u1E1A\u0190\u018E'
  },
  {
    'key': 'e',
    'letters':
        '\u0065\u24D4\uFF45\u00E8\u00E9\u00EA\u1EC1\u1EBF\u1EC5\u1EC3\u1EBD\u0113\u1E15\u1E17\u0115\u0117\u00EB\u1EBB\u011B\u0205\u0207\u1EB9\u1EC7\u0229\u1E1D\u0119\u1E19\u1E1B\u0247\u025B\u01DD'
  },
  {
    'key': 'o',
    'letters':
        '\u006F\u24DE\uFF4F\u00F2\u00F3\u00F4\u1ED3\u1ED1\u1ED7\u1ED5\u00F5\u1E4D\u022D\u1E4F\u014D\u1E51\u1E53\u014F\u022F\u0231\u00F6\u022B\u1ECF\u0151\u01D2\u020D\u020F\u01A1\u1EDD\u1EDB\u1EE1\u1EDF\u1EE3\u1ECD\u1ED9\u01EB\u01ED\u00F8\u01FF\u0254\uA74B\uA74D\u0275'
  },
  {
    'key': 'O',
    'letters':
        '\u004F\u24C4\uFF2F\u00D2\u00D3\u00D4\u1ED2\u1ED0\u1ED6\u1ED4\u00D5\u1E4C\u022C\u1E4E\u014C\u1E50\u1E52\u014E\u022E\u0230\u00D6\u022A\u1ECE\u0150\u01D1\u020C\u020E\u01A0\u1EDC\u1EDA\u1EE0\u1EDE\u1EE2\u1ECC\u1ED8\u01EA\u01EC\u00D8\u01FE\u0186\u019F\uA74A\uA74C'
  },
  {
    'key': 'C',
    'letters':
        '\u0043\u24B8\uFF23\u0106\u0108\u010A\u010C\u00C7\u1E08\u0187\u023B\uA73E'
  },
  {
    'key': 'c',
    'letters':
        '\u0063\u24D2\uFF43\u0107\u0109\u010B\u010D\u00E7\u1E09\u0188\u023C\uA73F\u2184'
  },
  {
    'key': 'D',
    'letters':
        '\u0044\u24B9\uFF24\u1E0A\u010E\u1E0C\u1E10\u1E12\u1E0E\u0110\u018B\u018A\u0189\uA779'
  },
  {
    'key': 'd',
    'letters':
        '\u0064\u24D3\uFF44\u1E0B\u010F\u1E0D\u1E11\u1E13\u1E0F\u0111\u018C\u0256\u0257\uA77A'
  },
  {
    'key': 'i',
    'letters':
        '\u0069\u24D8\uFF49\u00EC\u00ED\u00EE\u0129\u012B\u012D\u00EF\u1E2F\u1EC9\u01D0\u0209\u020B\u1ECB\u012F\u1E2D\u0268\u0131'
  },
  {
    'key': 'I',
    'letters':
        '\u0049\u24BE\uFF29\u00CC\u00CD\u00CE\u0128\u012A\u012C\u0130\u00CF\u1E2E\u1EC8\u01CF\u0208\u020A\u1ECA\u012E\u1E2C\u0197'
  },
  {
    'key': 'u',
    'letters':
        '\u0075\u24E4\uFF55\u00F9\u00FA\u00FB\u0169\u1E79\u016B\u1E7B\u016D\u00FC\u01DC\u01D8\u01D6\u01DA\u1EE7\u016F\u0171\u01D4\u0215\u0217\u01B0\u1EEB\u1EE9\u1EEF\u1EED\u1EF1\u1EE5\u1E73\u0173\u1E77\u1E75\u0289'
  },
  {
    'key': 'U',
    'letters':
        '\u0055\u24CA\uFF35\u00D9\u00DA\u00DB\u0168\u1E78\u016A\u1E7A\u016C\u00DC\u01DB\u01D7\u01D5\u01D9\u1EE6\u016E\u0170\u01D3\u0214\u0216\u01AF\u1EEA\u1EE8\u1EEE\u1EEC\u1EF0\u1EE4\u1E72\u0172\u1E76\u1E74\u0244'
  },
  {
    'key': 'n',
    'letters':
        '\u006E\u24DD\uFF4E\u01F9\u0144\u00F1\u1E45\u0148\u1E47\u0146\u1E4B\u1E49\u019E\u0272\u0149\uA791\uA7A5'
  },
  {
    'key': 'N',
    'letters':
        '\u004E\u24C3\uFF2E\u01F8\u0143\u00D1\u1E44\u0147\u1E46\u0145\u1E4A\u1E48\u0220\u019D\uA790\uA7A4'
  },
  {
    'key': 's',
    'letters':
        '\u0073\u24E2\uFF53\u00DF\u015B\u1E65\u015D\u1E61\u0161\u1E67\u1E63\u1E69\u0219\u015F\u023F\uA7A9\uA785\u1E9B'
  },
  {
    'key': 'S',
    'letters':
        '\u0053\u24C8\uFF33\u1E9E\u015A\u1E64\u015C\u1E60\u0160\u1E66\u1E62\u1E68\u0218\u015E\u2C7E\uA7A8\uA784'
  },
  {
    'key': 'y',
    'letters':
        '\u0079\u24E8\uFF59\u1EF3\u00FD\u0177\u1EF9\u0233\u1E8F\u00FF\u1EF7\u1E99\u1EF5\u01B4\u024F\u1EFF'
  },
  {
    'key': 'Y',
    'letters':
        '\u0059\u24CE\uFF39\u1EF2\u00DD\u0176\u1EF8\u0232\u1E8E\u0178\u1EF6\u1EF4\u01B3\u024E\u1EFE'
  },
  {
    'key': 'z',
    'letters':
        '\u007A\u24E9\uFF5A\u017A\u1E91\u017C\u017E\u1E93\u1E95\u01B6\u0225\u0240\u2C6C\uA763'
  },
  {
    'key': 'Z',
    'letters':
        '\u005A\u24CF\uFF3A\u0179\u1E90\u017B\u017D\u1E92\u1E94\u01B5\u0224\u2C7F\u2C6B\uA762'
  },
];
