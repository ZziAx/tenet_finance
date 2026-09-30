import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:intl/intl.dart' as intl;
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/borderd_box/focused_box_border.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/Buttons/GlowButton.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/Buttons/PrimaryButton.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/containers/DisabledWidget.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/containers/OverlayWidgetV1.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/containers/WithLabelContainer.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/enums/field_input_type.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/overlay/OverlayTriggerWidget.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/shadow_store/shadow_store.dart';
import 'package:tenet_finance/3rd/flutter_tenet_essential/TextFields/PrimaryTextField.dart';
import 'package:tenet_finance/core/constants/colors/app_color.dart';
import 'package:tenet_finance/core/utils/formatter_util.dart';
import 'package:tenet_finance/features/Card/controller/card_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_categories_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_controller.dart';
import 'package:tenet_finance/features/Transaction/controllers/transactions_list_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';
import 'package:tenet_finance/features/Transaction/ui/views/category_edit_view.dart';

class TransactionEditView extends StatefulWidget {
  Transaction? transaction;
  TransactionEditView({super.key, this.transaction});

  @override
  State<TransactionEditView> createState() => _TransactionEditViewState();
}

class _TransactionEditViewState extends State<TransactionEditView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final categoryController = context.watch<TransactionCategoriesController>();

    final transaction = controller.transaction;
    final String? categoryName = categoryController.getName(
      transaction.categoryId,
    );
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: ShadowStore.shadowV2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 25,
              children: [
                WithLabelContainer(
                  label: 'عنوان',
                  lead: Image.asset("assets/icons/medal.png"),
                  child: PrimaryTextField(
                    text: transaction.title,
                    borderStyle: FocusedBorderStyle.solid,
                    height: 30,
                    margin: EdgeInsets.zero,
                    onChanged: controller.setTitle,
                    placeHolder: 'عنوان',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ),
                WithLabelContainer(
                  label: 'دسته بندی',
                  lead: Transform.scale(
                    scale: 1.1,
                    child: Image.asset("assets/icons/folder_outlined.png"),
                  ),
                  child: OverlayTriggerWidget(
                    overlay: (hide) {
                      return OverlayWidgetV1(
                        padding: 10,
                        width: 250,
                        header: HeaderConfig(
                          title: 'دسته بندی',
                          separator:true,
                          actions: [
                            DisabledWidget(
                              enabled:
                                  transaction.categoryId != null &&
                                  categoryController.exist(
                                    transaction.categoryId,
                                  ),
                              child: GestureDetector(
                                onTap: () {
                                  transaction.removeCategory();
                                  setState(() {});
                                  hide();
                                },
                                child: Image.asset(
                                  'assets/icons/erase.png',
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          children:
                              categoryController.categories.map((e) {
                                bool selected =
                                    e.dbId == transaction.categoryId;
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: InkWidget(
                                    onTap: () {
                                      transaction.setCategory(e.dbId!);
                                      setState(() {});
                                      hide();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      color:
                                          selected
                                              ? HexColor('f0f0f0')
                                              : Colors.white,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        e.name,
                                        style: TextStyle(
                                          fontFamily: 'yekan',
                                          fontSize: 12,
                                          color:
                                              selected
                                                  ? Colors.black
                                                  : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    },
                    child: FocusedBoxBorder(
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            Text(
                              categoryName ?? 'انتخاب دسته بندی',
                              style: TextStyle(
                                fontFamily: 'yekan',
                                color: Colors.black54,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/arrow_down.png',
                              width: 12,
                              height: 12,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                WithLabelContainer(
                  label: 'مبلغ',
                  lead: Image.asset("assets/icons/price.png"),
                  child: PrimaryTextField(
                    text: formatPrice(transaction.amount).toPersianDigit(),
                    formatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final digits = newValue.text
                            .toEnglishDigit()
                            .replaceAll(',', '')
                            .replaceAll(RegExp(r'[^0-9]'), '');

                        if (digits.isEmpty) {
                          return newValue.copyWith(text: '');
                        }

                        final formatted = intl.NumberFormat(
                          '#,###',
                        ).format(int.parse(digits));

                        return newValue.copyWith(
                          text: formatted.toPersianDigit(),
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      }),
                    ],
                    borderStyle: FocusedBorderStyle.solid,
                    height: 30,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    inputType: FieldInputType.custom,
                    margin: EdgeInsets.zero,
                    onChanged: controller.setAmount,
                    placeHolder: 'مبلغ',
                  ),
                ),
              ],
            ),

            GlowButton(
              height: 35,
              onClicked: () async {
                context.read<TransactionsListController>().write(
                  controller.transaction,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
