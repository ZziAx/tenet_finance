import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tenet_finance/core/constants/colors/card_color.dart';
import 'package:tenet_finance/core/constants/sizes/app_radius.dart';
import 'package:tenet_finance/core/utils/formatter_util.dart';
import 'package:tenet_finance/core/widgets/containers/header_title.dart';
import 'package:tenet_finance/features/Card/controller/card_controller.dart';
import 'package:tenet_finance/features/Card/controller/card_list_controller.dart';
import 'package:tenet_finance/features/Card/ui/views/card_edit_view.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';
import 'package:tenet_finance/features/Transaction/logic/financial_report.dart';
import 'package:tenet_finance/features/Transaction/ui/views/transaction_edit_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<TransactionsListController>().load();
    // });
  }

  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProxyProvider<
      TransactionsListController,
      FinancialReport
    >(
      create:
          (_) => FinancialReport(
            transactions:
                context.read<TransactionsListController>().transactions ?? [],
          ),
      update: (_, transactionController, _) {
        return FinancialReport(
          transactions: transactionController.transactions ?? [],
        );
      },
      child: Builder(
        builder: (context) {
          return Column(
            spacing: 15,
            children: [
              HeaderTitle(
                title: "خانه",
                left: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => CardEditView(
                                onSumbitted: (card) {
                                  context.read<CardListController>().add(card);
                                  Navigator.of(context).pop();
                                },
                              ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/icons/plus.png',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [_buildCard(), _buildOverViewReports(context)],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverViewReports(BuildContext context) {
    final FinancialReport report = context.watch<FinancialReport>();
    return Expanded(
      child: Container(
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
          crossAxisCount: 2,
          children: [
            _buildOverViewGridItem(
              'خرج',
              report.totalOutcome,
              color: HomeCardColor1,
            ),
            _buildOverViewGridItem(
              'دخل',
              report.totalIncome,
              color: HomeCardColor2,
            ),
            _buildOverViewGridItem(
              'نسبت دخل به خرج',
              report.ivo,
              color: HomeCardColor3,
              hasTomanSymbol: false,
              isFloat: true,
            ),
            _buildOverViewGridItem(
              'برآیند',
              report.remained,
              color: HomeCardColor4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverViewGridItem(
    String label,
    num value, {
    required CardColor color,
    bool hasTomanSymbol = true,
    bool isFloat = false,
  }) {
    final n = (value.isNaN || value.isInfinite) ? 0 : value;

    String result =
        formatPrice(isFloat ? n.toStringAsFixed(2) : n).toPersianDigit();

    final controller = context.watch<CardController>();
    final visible = controller.visible;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm3),

      child: LayoutBuilder(
        builder: (_, cst) {
          return Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: color.colors,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        label,

                        gradientDirection: GradientDirection.btt,
                        colors: [
                          color.color1,
                          Color.lerp(color.colors.first, color.color1, 0.5)!,
                        ],
                        textScaleFactor: 1.05,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: 'yekan',
                          color: color.color1,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: cst.maxWidth - 20,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: color.color1.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: ShadowStore.shadowV2,
                            ),
                            child: IntrinsicWidth(
                              child: Row(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      visible ? result : '****',
                                      textDirection: TextDirection.ltr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'yekan',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  if (hasTomanSymbol)
                                    Text(
                                      'تومان',
                                      style: TextStyle(
                                        fontFamily: 'yekan',
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Positioned.fill(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.transparent,
                //       boxShadow: ShadowStore.shadowV3(
                //         color.color1,
                //         offset: Offset(-150, 135),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    final controller = context.watch<CardController>();
    final visible = controller.visible;
    final card = controller.card;

    return AspectRatio(
      aspectRatio: 2.0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.black54],
          ),
          boxShadow: ShadowStore.shadowV2,
          borderRadius: BorderRadius.circular(AppRadius.sm3),
        ),

        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GradientText(
                card.name,
                colors: [Colors.white, Colors.white54],
                gradientDirection: GradientDirection.btt,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'yekan',
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 18,
                height: 18,
                child: GestureDetector(
                  onTap: () {
                    controller.toggleVisibility();
                  },
                  child: Image.asset(
                    visible
                        ? 'assets/icons/eye_open.png'
                        : 'assets/icons/eye_close.png',
                    color: Colors.white70,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                formatCardNumber(
                  visible
                      ? card.number
                      : generateCharacter(
                        16,
                        prefix: card.number.substring(0, 3),
                        suffix: card.number.substring(13, 16),
                      ),
                ),
                style: TextStyle(
                  letterSpacing: 1,
                  fontFamily: 'yekan',
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => CardEditView(
                            card: card,
                            onSumbitted: (card) {
                              controller.setSettings(
                                name: card.name,
                                number: card.number,
                              );
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                          ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/icons/more.png',
                  width: 16,
                  height: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
