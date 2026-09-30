import 'package:flutter/material.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:provider/provider.dart';
import 'package:tenet_finance/features/Transaction/controllers/transaction_categories_controller.dart';
import 'package:tenet_finance/features/Transaction/domain/entities/transaction_category.dart';

class CategoryEditView extends StatefulWidget {
  TransactionCategory? category;
  CategoryEditView({super.key, this.category});

  @override
  State<CategoryEditView> createState() => _CategoryEditViewState();
}

class _CategoryEditViewState extends State<CategoryEditView> {
  late final TransactionCategory category;
  String get name => category.name;
  String get description => category.description ?? '';

  @override
  void initState() {
    super.initState();
    category = widget.category?.copy() ?? TransactionCategory(name: '');
  }

  @override
  Widget build(BuildContext context) {
    // final
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WithLabelContainer(
          label: "نام دسته بندی",
          child: PrimaryTextField(
            margin: EdgeInsets.zero,
            height: 30,
            borderStyle: FocusedBorderStyle.solid,
            text: name,
            onChanged: category.setName,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),

        WithLabelContainer(
          label: "توضیحات",
          child: PrimaryTextField(
            margin: EdgeInsets.zero,
            height: 30,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            borderStyle: FocusedBorderStyle.solid,
            text: description,
            onChanged: category.setDescription,
          ),
        ),
        GlowButton(
          onClicked: () {
            context.read<TransactionCategoriesController>().write(category);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
