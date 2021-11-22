import 'package:flutter/material.dart';

class FilterableList extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTapped;
  final String search;

  FilterableList({
    required this.items,
    required this.onItemTapped,
    required this.search
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: items.where((element) {
          return element.toLowerCase().contains(search.toLowerCase());
        }).toList().map<Widget>((e) {
          return ListTile(
            dense: true,
            title: Text(e),
            onTap: () => onItemTapped(e)
          );
        }).toList()
      )
    );
  }
}