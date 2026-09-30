import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/dialog/show_custom_dialog.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_categories_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/ui/views/transaction_edit_view.dart';

Future showEditTransactionDialog(
  BuildContext context, {
  Transaction? transaction,
  TransactionType ?type
}) async {
  return await showCustomDialog(
context,
    child: Container(
        alignment: Alignment.center,

        child: Container(
          width: 300,
          height:320,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
            create: (_) => TransactionController(transaction,type:type),),
            ChangeNotifierProvider.value(value: context.read<TransactionsListController>()),
            ChangeNotifierProvider.value(value: context.read<TransactionCategoriesController>()),

            ],
            child: TransactionEditView(),
          ),
        ),
      )
  );
}
