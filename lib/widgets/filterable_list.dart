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

  List<String> _getList() {
    return items.where((element) {
      return element.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 100
      ),
      child: Visibility(
        visible: _getList().isNotEmpty,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: List.generate(_getList().length, (index) {
            return ListTile(
              dense: true,
              title: Text(_getList()[index]),
              onTap: () => onItemTapped(_getList()[index])
            );
          })
        )
      )
    );
  }
}