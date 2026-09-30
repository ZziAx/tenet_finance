import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/theme/TenetEssentialTheme.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/theme/TenetEssentialThemeData.dart';
import 'package:tenet_finance/features/Card/controller/card_controller.dart';
import 'package:tenet_finance/features/Card/controller/card_list_controller.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Card/domain/repo/card_repo.dart';
import 'package:tenet_finance/features/Card/ui/views/card_edit_view.dart';
import 'package:tenet_finance/features/Navigation/controllers/navigation_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_categories_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';

class AppInitView extends StatefulWidget {
  Widget child;
  AppInitView({super.key, required this.child});

  @override
  State<AppInitView> createState() => _AppInitViewState();
}

class _AppInitViewState extends State<AppInitView> {
  late final CardListController cardListController;
  void _loadCards() async {
    // final list = await CardRepo.getAll();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     cards = list;
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    cardListController = CardListController();
    cardListController.load();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cardListController,
    
      child: Consumer<CardListController>(
        builder: (_, controller, _) {
          final cards = controller.cards;
          if (cards == null) {
            return Container(color: Colors.red);
          }
    
          if (cards.isEmpty) {
            return CardEditView(
              onSumbitted: (card) {
                cards.add(card);
                setState(() {});
              },
            );
          }
    
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => TransactionCategoriesController(),
              ),
            ],
            child: PageView(
              children: [
                ...cards.map((e) {
                  return _buildProviderView(e);
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProviderView(CardObject card) {
    final cardController = CardController(card);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider.value(value: cardController),
        ChangeNotifierProvider.value(
          value: cardController.transactionsListController,
        ),
      ],
      child: widget.child,
    );
  }
}
