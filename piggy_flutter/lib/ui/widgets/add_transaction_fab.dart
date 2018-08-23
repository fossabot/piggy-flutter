import 'package:flutter/material.dart';
import 'package:piggy_flutter/models/account.dart';
import 'package:piggy_flutter/ui/pages/transaction/transaction_form.dart';

class AddTransactionFab extends StatelessWidget {
  final Account account;
  const AddTransactionFab({Key key, this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        key: ValueKey<Color>(Theme.of(context).primaryColor),
        tooltip: 'Add new transaction',
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute<DismissDialogAction>(
                builder: (BuildContext context) => TransactionFormPage(
                      account: account,
                    ),
                fullscreenDialog: true,
              ));
        });
  }
}
