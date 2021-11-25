// Copyright 2021 4inka

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.

// 3. Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

library easy_autocomplete;

import 'package:easy_autocomplete/filterable_list.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
    widget.controller!.addListener(() {
      _overlayEntry.markNeedsBuild();
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
          child: FilterableList(
            items: widget.suggestions.where((element) {
              return element.toLowerCase().contains(widget.controller!.value.text.toLowerCase());
            }).toList(),
            onItemTapped: (value) {
              widget.controller!
                ..value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(
                    offset: value.length
                  )
                );
              widget.onChanged!(value);
              closeOverlay();
            }
          )
        )
      )
    );
  }

  void openOverlay() {
    if (!_hasOpenedOverlay) {
      Overlay.of(context)!.insert(_overlayEntry);
      setState(() => _hasOpenedOverlay = true );
    }
  }

  void closeOverlay() {
    if (_hasOpenedOverlay) {
      _overlayEntry.remove();
      setState(() => _hasOpenedOverlay = false );
    }
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
            openOverlay();
            widget.onChanged!(value);
          },
          onFieldSubmitted: (value) {
            closeOverlay();
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