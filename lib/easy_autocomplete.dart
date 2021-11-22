library easy_autocomplete;

import 'package:easy_autocomplete/widgets/filterable_list.dart';
import 'package:flutter/material.dart';

class EasyAutocomplete extends StatefulWidget {
  final List<String> suggestions;
  TextEditingController? controller;
  final InputDecoration? decoration;
  final Function(String)? onChanged;

  EasyAutocomplete({
    required this.suggestions,
    this.controller,
    this.decoration,
    this.onChanged
  });

  @override
  State<EasyAutocomplete> createState() => _EasyAutocompleteState();
}

class _EasyAutocompleteState extends State<EasyAutocomplete> {
  bool _suggestionClicked = false;
  bool _hasOpenedOverlay = false;

  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    widget.controller ??= TextEditingController();
    Future.delayed(Duration.zero,() {
      initializeOverlayEntry();
    });
    
  }

  void initializeOverlayEntry() {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5.0,
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: FilterableList(
                search: widget.controller!.text,
                items: widget.suggestions,
                onItemTapped: (value) {
                  setState(() => _suggestionClicked = true);
                  widget.controller!
                    ..value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(
                        offset: value.length
                      )
                    );
                  widget.onChanged!(value);
                  closeOverlay();
                  setState(() => _suggestionClicked = false);
                }
              )
            )
          )
        )
      );
  }

  void openOverlay() {
    if (!_hasOpenedOverlay)
      Overlay.of(context)!.insert(_overlayEntry);
    setState(() => _hasOpenedOverlay = true );
  }

  void closeOverlay() {
    if (_hasOpenedOverlay)
      _overlayEntry.remove();
    setState(() => _hasOpenedOverlay = false );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        child: TextFormField(
          decoration: widget.decoration,
          controller: widget.controller,
          onChanged: (value) {
            if (!_suggestionClicked)
              openOverlay();
            widget.onChanged!(value);
          },
          onEditingComplete: () => closeOverlay()
        ),
        onFocusChange: (hasFocus) {
          if(hasFocus) openOverlay();
          else closeOverlay();
        },
      )
    );
  }
}