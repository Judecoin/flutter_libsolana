import 'package:auto_route/auto_route.dart';
import 'package:cryptoplease/app/routes.dart';
import 'package:cryptoplease/core/dynamic_links_notifier.dart';
import 'package:cryptoplease/features/incoming_split_key_payment/bl/tx_processor.dart';
import 'package:cryptoplease/features/incoming_split_key_payments/bl/iskp_bloc.dart';
import 'package:cryptoplease/features/incoming_split_key_payments/bl/pending_iskp.dart';
import 'package:cryptoplease/features/incoming_split_key_payments/bl/pending_iskp_repository.dart';
import 'package:cryptoplease/features/incoming_split_key_payments/presentation/components/cancel_dialog.dart';
import 'package:cryptoplease/gen/assets.gen.dart';
import 'package:cryptoplease/l10n/l10n.dart';
import 'package:cryptoplease_ui/cryptoplease_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirstPartReadyScreen extends StatefulWidget {
  const FirstPartReadyScreen({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  State<FirstPartReadyScreen> createState() => _FirstPartReadyScreenState();
}

class _FirstPartReadyScreenState extends State<FirstPartReadyScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<DynamicLinksNotifier>().processLink((link) {
      final secondPart = ISKPSecondPart.tryParse(link);
      if (secondPart != null) {
        _processSecondPart(secondPart);

        return true;
      }

      return false;
    });
  }

  Future<void> _processSecondPart(ISKPSecondPart secondPart) async {
    final repository = context.read<PendingISKPRepository>();

    final firstPart = await repository.load();
    if (firstPart == null) {
      context.router.popForced();

      return;
    }

    try {
      final escrow = await walletFromParts(
        firstPart: firstPart.key,
        secondPart: secondPart.key,
      );
      if (!mounted) return;

      final id = const Uuid().v4();
      context.read<ISKPBloc>().add(ISKPEvent.create(escrow, id: id));
      await repository.clear();
      await context.router.replace(IncomingSplitKeyPaymentRoute(id: id));
    } on Object {
      context.router.popForced();
    }
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body: CpTheme.dark(
              child: Builder(
                builder: (context) => DecoratedBox(
                  decoration: const BoxDecoration(color: CpColors.primaryColor),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Assets.icons.logoBg
                            .svg(alignment: Alignment.bottomCenter),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              const SizedBox(height: 62),
                              Text(
                                context.l10n.splitKeySecondLinkTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const _ContentView(),
                              const SizedBox(height: 40),
                              Expanded(
                                child: Assets.images.secondLinkArtwork.image(),
                              ),
                              const SizedBox(height: 30),
                              CpButton(
                                onPressed: () => showCancelDialog(
                                  context,
                                  () {
                                    context.router.popForced();
                                    widget.onCancel();
                                  },
                                ),
                                text: context.l10n.cancel,
                                size: CpButtonSize.micro,
                                variant: CpButtonVariant.inverted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ContentView extends StatelessWidget {
  const _ContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 30),
          Text(
            context.l10n.splitKeySecondLinkMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
}