import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import '../../di.dart';
import '../accounts/module.dart';
import '../balances/widgets/context_ext.dart';
import 'data/repository.dart';
import 'services/tx_created_watcher.dart';
import 'services/tx_sent_watcher.dart';
import 'widgets/link_listener.dart';

class ODPModule extends SingleChildStatelessWidget {
  const ODPModule({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => MultiProvider(
        providers: [
          Provider<TxCreatedWatcher>(
            lazy: false,
            create: (context) => sl<TxCreatedWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
          Provider<TxSentWatcher>(
            lazy: false,
            create: (context) => sl<TxSentWatcher>()
              ..call(onBalanceAffected: () => context.notifyBalanceAffected()),
            dispose: (_, value) => value.dispose(),
          ),
        ],
        child: LogoutListener(
          onLogout: (_) => sl<ODPRepository>().clear(),
          child: ODPLinkListener(child: child ?? const SizedBox.shrink()),
        ),
      );
}
