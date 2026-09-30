import 'package:flutter/material.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

import 'package:tenet_finance/core/constants/colors/app_color.dart';
import 'package:tenet_finance/core/utils/formatter_util.dart';
import 'package:tenet_finance/core/widgets/containers/header_title.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_categories_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_sort_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';
import 'package:tenet_finance/features/Transaction/ui/views/category_edit_view.dart';
import 'package:tenet_finance/features/Transaction/utils/show_edit_transaction_dialog.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key});

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<TransactionsListController>().load();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final listController = context.watch<TransactionsListController>();

    return ChangeNotifierProxyProvider<
      TransactionsListController,
      TransactionSortController
    >(
      create:
          (_) => TransactionSortController(listController.transactions ?? []),
      update: (_, listController, sortController) {
        sortController!.setTransactions(listController.transactions ?? []);
        return sortController;
      },
      child: Column(children: [_buildHeader(), _buildTransactionList()]),
    );
  }

  Widget _buildHeader() {
    return HeaderTitle(
      title: 'لیست تراکنش ها',
      right: [_buildFilterBar()],

      left: [_buildCategoryBar()],
    );
  }

  Widget _buildSortButton(
    String label,
    String asset, {
    required bool selected,
    required Function onClicked,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),

      child: InkWidget(
        onTap: () {
          onClicked();
        },
        child: Container(
          height: 30,
          width: double.infinity,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected ? AppColor.primary : Colors.transparent,
          ),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Transform.translate(
                offset: Offset(0, -2),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,

                    fontFamily: 'yekan',
                    color: selected ? Colors.white : Colors.black54,
                  ),
                ),
              ),
              Image.asset(
                asset,
                color: selected ? Colors.white : Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    //     List<Transaction> get transactions => context.read<TransactionsListController>().transactions??[];
    // List<Transaction> get sorted =>TransactionSortHelper(transactions).sort();

    final listController = context.watch<TransactionsListController>();
    return Consumer<TransactionSortController>(
      builder: (_, controller, _) {
        final transactions = controller.sort(context);
        if (transactions.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                "تراکنشی یافت نشد.",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontFamily: 'yekan', color: Colors.black54),
              ),
            ),
          );
        }
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: HexColor('fafafa'),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100, width: 2),
            ),
            child: ListView.separated(
              padding: EdgeInsets.all(20),
              itemBuilder: (context, i) {
                final transaction = transactions[i];
                final isIncome = transaction.type == TransactionType.income;
                return GestureDetector(
                  onTap: () async {
                    await showEditTransactionDialog(
                      context,
                      transaction: transaction,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: ShadowStore.shadowV2,
                      border: Border.all(color: Colors.black12),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Row(
                                spacing: 10,

                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      isIncome
                                          ? "assets/icons/arrow_up.png"
                                          : "assets/icons/arrow_down.png",
                                      color:
                                          isIncome
                                              ? const Color.fromARGB(
                                                255,
                                                90,
                                                199,
                                                0,
                                              )
                                              : Colors.red.shade300,
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      height: 20,
                                      child: Text(
                                        transaction.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontFamily: 'yekan',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                "${formatPrice(transaction.amount).toPersianDigit()} تومان",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'yekan',
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            listController.remove(transaction.dbId!);
                          },
                          child: Container(
                            width: 17,
                            height: 17,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.clear,
                              color: Colors.black26,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, i) {
                return Container(height: 10);
              },
              itemCount: transactions.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBar() {
    final controller = context.watch<TransactionCategoriesController>();
    final categories = controller.categories;
    return Consumer<TransactionSortController>(
      builder: (_, sortController, _) {
        return OverlayTriggerWidget(
          offset: Offset(30, 2),
          child: Image.asset(
            'assets/icons/folder.png',
            color: Colors.black54,
            width: 30,
            height: 30,
          ),
          overlay: (hide) {
            return ChangeNotifierProvider.value(
              value: controller,
              child: Consumer<TransactionCategoriesController>(
                builder: (_, controller, _) {
                  return OverlayWidgetV1(
                    header: HeaderConfig(
                      title: "دسته بندی",
                      separator: true,
                      actions: [
                        GestureDetector(
                          onTap: () {
                            hide();
                            showCustomDialog(
                              context,
                              child: DialogContainer(
                                width: 300,
                                height: 250,
                                title: "تنضیمات دسته بندی",
                                child: ChangeNotifierProvider.value(
                                  value:
                                      context
                                          .read<
                                            TransactionCategoriesController
                                          >(),
                                  child: CategoryEditView(),
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.black54,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    width: 250,
                    child: Container(
                      height: 200,
                      alignment: Alignment.topCenter,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, i) {
                          final category = categories[i];
                          return Container(
                            height: 30,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.remove(category.dbId!);
                                    sortController.removeCategorie(category.dbId!);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.black54,
                                      size: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      hide();
                                      showCustomDialog(
                                        context,
                                        child: DialogContainer(
                                          width: 300,
                                          height: 250,
                                          title: "تنضیمات دسته بندی",
                                          child: ChangeNotifierProvider.value(
                                            value:
                                                context
                                                    .read<
                                                      TransactionCategoriesController
                                                    >(),
                                            child: CategoryEditView(
                                              category: category,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        category.name,
                                        style: TextStyle(
                                          fontFamily: 'yekan',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, i) {
                          return Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade100,
                          );
                        },
                        itemCount: categories.length,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return Builder(
      builder: (context) {
        final sortController = context.watch<TransactionSortController>();
        final TransactionCategoriesController categoryController =
            context.watch<TransactionCategoriesController>();

        return OverlayTriggerWidget(
          offset: Offset(-190, 0),
          overlay: (hide) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: sortController),
                ChangeNotifierProvider.value(value: categoryController),
              ],
              child: OverlayWidgetV1<TransactionSortController>(
                width: 190,
                child: Consumer<TransactionSortController>(
                  builder: (_, sortController, _) {
                    return Consumer<TransactionCategoriesController>(
                      builder: (_, categoryController, _) {
                        final categories = categoryController.categories;
                        return SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 15,
                            children: [
                              Column(
                                spacing: 15,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryCheckbox(
                                    value: sortController.filter.income,

                                    onChanged: (v) {
                                      sortController.setFilter(income: v);
                                    },
                                    label: 'دخل',
                                  ),
                                  PrimaryCheckbox(
                                    value: sortController.filter.outcome,
                                    onChanged: (v) {
                                      sortController.setFilter(outcome: v);
                                    },
                                    label: 'خرج',
                                  ),
                                  _buildDivider(),
                                  _buildSortButton(
                                    "بالا به پایین",
                                    "assets/icons/descending.png",
                                    selected: !sortController.ascending,
                                    onClicked: () {
                                      sortController.toggleAscending(false);
                                    },
                                  ),
                                  _buildSortButton(
                                    "پایین به بالا",
                                    "assets/icons/ascending.png",
                                    selected: sortController.ascending,

                                    onClicked: () {
                                      sortController.toggleAscending(true);
                                    },
                                  ),
                                ],
                              ),
                              if (categories.isNotEmpty)
                                Column(
                                  spacing: 15,
                                  children: [
                                    _buildDivider(),

                                    GestureDetector(
                                      child: _buildTile(
                                        'انتخاب همه',
                                        selected:
                                            sortController.categories.isEmpty,
                                        onClicked: () {
                                          sortController.clearCategories();
                                          hide();
                                        },
                                      ),
                                    ),

                                    ...categories.map((e) {
                                      return _buildCategoryTile(
                                        e,
                                        selected: sortController
                                            .categorySelected(e.dbId!),
                                        onClicked: () {
                                          sortController.toggleCategoryState(
                                            e.dbId!,
                                          );
                                          hide();
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
          child: Image.asset("assets/icons/filter.png", color: Colors.black54),
        );
      },
    );
  }

  Widget _buildCategoryTile(
    TransactionCategory category, {
    required Function onClicked,
    bool selected = false,
  }) {
    return _buildTile(category.name, onClicked: onClicked, selected: selected);
  }

  Widget _buildTile(
    String label, {
    bool selected = false,
    required Function onClicked,
  }) {
    return GestureDetector(
      onTap: () {
        onClicked();
      },
      child: Container(
        height: 33,
        padding: EdgeInsets.all(5),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected ? HexColor('f0f0f0') : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'yekan',
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  _buildDivider() {
    return Divider(height: 1, color: Colors.black12);
  }
}
