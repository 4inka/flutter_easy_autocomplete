import 'package:flutter/material.dart';

class FilterableList extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTapped;

  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0);

  FilterableList({
    required this.items,
    required this.onItemTapped
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 100
      ),
      child: Visibility(
        visible: items.isNotEmpty,
        child: Scrollbar(
          //isAlwaysShown: true,
          controller: _scrollController,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                title: Text(items[index]),
                onTap: () => onItemTapped(items[index])
              );
            }
          )
        )
      )
    );
  }
}