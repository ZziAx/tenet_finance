import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:tenet_finance/core/utils/formatter_util.dart';
import 'package:tenet_finance/features/Card/domain/card_object.dart';
import 'package:tenet_finance/features/Card/domain/repo/card_repo.dart';
import 'package:tenet_finance/features/Card/domain/repo/hive/card_hive.dart';

class CardEditView extends StatefulWidget {
  CardObject? card;
  Function(CardObject) onSumbitted;
  CardEditView({super.key, this.card, required this.onSumbitted});

  @override
  State<CardEditView> createState() => _CardEditViewState();
}

class _CardEditViewState extends State<CardEditView> {
  late final CardObject card;
  @override
  void initState() {
    super.initState();
    card = widget.card ?? CardObject(number: '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('f0f0f0'),
      alignment: Alignment.center,
      child: DialogContainer(
        width: MediaQuery.of(context).size.width - 40,

        height: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 15,
          children: [
            Column(
              spacing: 15,
              children: [
                WithLabelContainer(
                  label: 'نام حساب',
                  child: PrimaryTextField(
                    borderStyle: FocusedBorderStyle.solid,
                    height: 30,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,

                    margin: EdgeInsets.zero,
                    text: card.name,
                    onChanged: (value) {
                      card.name = value;
                    },
                  ),
                ),
                WithLabelContainer(
                  label: 'شماره حساب',
                  child: PrimaryTextField(
                    borderStyle: FocusedBorderStyle.solid,
                    height: 30,
                    margin: EdgeInsets.zero,
                    text: formatCardNumber(card.number),
                    formatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String text = newValue.text.toEnglishDigit().replaceAll(
                          '-',
                          '',
                        );
                        if (text.length > 16) {
                          text = text.substring(0, 16);
                        }
                        final formatted = text
                            .replaceAllMapped(
                              RegExp(r'.{1,4}'),
                              (match) => '${match.group(0)}-',
                            )
                            .replaceFirst(RegExp(r'-$'), '');

                        return newValue.copyWith(
                          text: formatted.toPersianDigit(),
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      card.number = value.replaceAll('-', '');
                    },
                  ),
                ),
              ],
            ),
            GlowButton(
              onClicked: () async {
                CardHive cardHive = await CardRepo.write(card);
                widget.onSumbitted(cardHive.toDomain());
              },
            ),
          ],
        ),
      ),
    );
  }
}
