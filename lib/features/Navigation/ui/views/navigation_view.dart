import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:provider/provider.dart';
import 'package:tenet_finance/core/constants/colors/app_color.dart';
import 'package:tenet_finance/features/Navigation/controllers/navigation_controller.dart';
import 'package:tenet_finance/features/Navigation/domain/entities/nav_item_model.dart';
import 'package:tenet_finance/features/Home/ui/views/home_view.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/ui/views/transaction_list_view.dart';
import 'package:tenet_finance/features/Transaction/utils/show_edit_transaction_dialog.dart';

class NavView extends StatefulWidget {
  const NavView({super.key});

  @override
  State<NavView> createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;

  Widget _buildAddTransactioOption(String name, {required Function onClicked}) {
    return InkWidget(
      onTap: () {
        onClicked();
      },
      child: Container(
        height: 35,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 7),
        alignment: Alignment.centerRight,
        child: Text(
          name,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'yekan',
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    double height = 83;
    double width = 130;
    // final listController = context.watch<TransactionsListController>();
    _overlay = OverlayEntry(
      builder:
          (_) => ChangeNotifierProvider.value(
            value:context.read<TransactionsListController>() ,
            child: Consumer<TransactionsListController>(
              builder: (_, controller, _) {
                return Material(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            _hideOverlay();
                          },
                          child: Container(
                            color: Colors.white.withOpacity(0.0),
                          ),
                        ),
                      ),
                      CompositedTransformFollower(
                        link: _layerLink,
                        offset: Offset(-width + 10, -height + 10),
                        showWhenUnlinked: false,
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            boxShadow: ShadowStore.shadowV2,
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAddTransactioOption(
                                "افزودن دخل",
                                onClicked: () async {
                                  _hideOverlay();
                                  await showEditTransactionDialog(
                                    context,
                                    type: TransactionType.income,
                                  );
                                },
                              ),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: Colors.black12,
                              ),
                              _buildAddTransactioOption(
                                "افزودن خرج",
                                onClicked: () async {
                                  _hideOverlay();
                                  await showEditTransactionDialog(
                                    context,
                                    type: TransactionType.outcome,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  final navs = [
    NavItemModel(
      title: 'خانه',
      asset: "assets/icons/home.png",
      body: HomeView(),
    ),
    NavItemModel(
      title: 'خانه',
      asset: "assets/icons/list_filled.png",
      body: TransactionListView(),
    ),
  ];
  // late final NavigationController navigationController;
  // late final TransactionsListController transactionsListController;
  @override
  void initState() {
    super.initState();
    // navigationController = NavigationController();
    // transactionsListController = TransactionsListController();
  }

  @override
  Widget build(BuildContext context) {
    final navController = context.watch<NavigationController>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: navs[navController.selectedTab].body,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            height: 90,
            // color: Colors.red,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.primary,
                          AppColor.primary.withOpacity(0.4),
                        ],
                      ),
                      boxShadow: ShadowStore.shadowV2,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 50,
                    child: Row(
                      spacing: 10,
                      children: [
                        _buildNavItem(0),
                        _buildCircularButtonPlaceHolder(),
                        _buildNavItem(1),
                      ],
                    ),
                  ),
                ),

                _buildCircularButton(),
              ],
            ),
          ),

          Container(
            height: MediaQuery.of(context).viewInsets.bottom,
            width: double.infinity,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final navController = context.watch<NavigationController>();

    final bool selected = navController.selectedTab == index;

    Color color = Colors.white;
    double opacity = selected ? 1.0 : 0.6;
    return Flexible(
      fit: FlexFit.tight,

      child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 100),
        child: GestureDetector(
          onTap: () {
            navController.selectTab(index);
          },
          child: Container(
            padding: EdgeInsets.all(13),
            child:
                navController.selectedTab == index
                    ? Image.asset(
                      navs[index].selectedAsset ?? navs[index].asset,
                      color: color,
                    )
                    : Image.asset(navs[index].asset, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButtonPlaceHolder() {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(alignment: Alignment.center),
    );
  }

  Widget _buildCircularButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              _showOverlay();
            },
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: ShadowStore.shadowV1,
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: HexColor('f0f0f0'),
                            width: 2,
                          ),
                        ),
                        height: double.infinity,
                        child: Icon(Icons.add, color: AppColor.primary),
                      ),

                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: ShadowStore.shadowV3(
                              AppColor.primary,
                              offset: Offset(-40, 40),
                            ),
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
      ),
    );
  }
}
