import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talao/app/shared/widget/base/text_field.dart';
import 'package:talao/l10n/l10n.dart';
import 'package:talao/wallet/wallet.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      searchController.addListener(() {
        context.read<WalletCubit>().searchWallet(searchController.text);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BaseTextField(
      prefixIcon: searchController.text.isNotEmpty
          ? InkWell(
              onTap: () async {
                searchController.text = '';
                focusNode.unfocus();
                await context
                    .read<WalletCubit>()
                    .loadAllCredentialsFromRepository();
              },
              child: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            )
          : SizedBox.shrink(),
      icon: Icons.search,
      label: l10n.search,
      controller: searchController,
      focusNode: focusNode,
    );
  }
}
