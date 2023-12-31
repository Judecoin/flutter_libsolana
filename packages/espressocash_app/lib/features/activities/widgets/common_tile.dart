import 'package:dfunc/dfunc.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/format_date.dart';
import '../../../../core/presentation/utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../transactions/services/create_transaction_link.dart';
import '../models/transaction.dart';
import 'activity_tile.dart';

class CommonTile extends StatelessWidget {
  const CommonTile({
    super.key,
    required this.txCommon,
  });

  final TxCommon txCommon;

  @override
  Widget build(BuildContext context) {
    final signature = txCommon.tx.id;

    return CpActivityTile(
      title: signature.toShortAddress(),
      status: CpActivityTileStatus.success,
      timestamp: txCommon.created?.let(context.formatDate) ?? '',
      icon: Assets.icons.txIcon.svg(),
      onTap: () {
        final link = Uri.parse(createTransactionLink(signature));
        context.openLink(link.toString());
      },
    );
  }
}
