import 'package:flutter/material.dart';

class NavItemModel {
  String title;
  String asset;
  String? selectedAsset;

  Widget body;
  NavItemModel({
    required this.title,
    required this.asset,
    required this.body,
    this.selectedAsset,
  });
}
