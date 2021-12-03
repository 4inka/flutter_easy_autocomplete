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

import 'package:easy_autocomplete/widgets/filterable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyAutocomplete extends StatefulWidget {
  /// 
  final List<String> suggestions;
  /// 
  final TextEditingController? controller;
  /// 
  final InputDecoration? decoration;
  /// 
  final Function(String)? onChanged;
  /// 
  final List<TextInputFormatter>? inputFormatter;
  /// 
  final String? initialValue;
  /// 
  final String? Function(String?)? validator;
  /// 
  final AutovalidateMode autovalidateMode;

  /// Creates a autocomplete widget to help you manage your suggestions
  EasyAutocomplete({
    required this.suggestions,
    this.controller,
    this.decoration,
    this.onChanged,
    this.inputFormatter,
    this.initialValue,
    this.validator,
    this.autovalidateMode = AutovalidateMode.always
  }) : assert(onChanged != null || controller != null, 'onChanged and controller parameters cannot be both null at the same time'),
    assert(!(controller != null && initialValue != null), 'controller and initialValue cannot be used at the same time');

  @override
  State<EasyAutocomplete> createState() => _EasyAutocompleteState();
}

class _EasyAutocompleteState extends State<EasyAutocomplete> {
  late TextFormField _textFormField;
  bool _hasOpenedOverlay = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<String> _suggestions = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _textFormField = TextFormField(
      decoration: widget.decoration ?? InputDecoration(),
      controller: widget.controller ?? TextEditingController(),
      inputFormatters: widget.inputFormatter ?? [],
      onChanged: (value) {
        openOverlay();
        widget.onChanged!(value);
      },
      onFieldSubmitted: (value) {
        closeOverlay();
        widget.onChanged!(value);
      },
      onEditingComplete: () => closeOverlay(),
      autovalidateMode: widget.autovalidateMode,
      validator: (value) {
        String? validate = widget.validator!(value);
        if (validate != null && validate.isNotEmpty) {
          return '';
        }

        return null;
      }
    );
    _textFormField.controller!.text = widget.initialValue ?? '';
    _textFormField.controller!.addListener(() {
      updateSuggestions(_textFormField.controller!.text);

      String? validate = widget.validator!(_textFormField.controller!.text);
      if (validate != null && validate.isNotEmpty) {
        setState(() => errorMessage = validate);
      }
      else {
        setState(() => errorMessage = '');
      }
    });
  }

  void openOverlay() {
    if (_overlayEntry == null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry ??= OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5.0,
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: FilterableList(
              items: _suggestions,
              onItemTapped: (value) {
                _textFormField.controller!
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
    if (!_hasOpenedOverlay) {
      Overlay.of(context)!.insert(_overlayEntry!);
      setState(() => _hasOpenedOverlay = true );
    }
  }

  void closeOverlay() {
    if (_hasOpenedOverlay) {
      _overlayEntry!.remove();
      setState(() => _hasOpenedOverlay = false );
    }
  }

  void updateSuggestions(String input) {
    _suggestions = widget.suggestions.where((element) {
      return element.toLowerCase().contains(input.toLowerCase());
    }).toList();
    if(_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textFormField,
            Visibility(
              visible: errorMessage.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 12
                  )
                ),
              )
            )
          ]
        ),
        onFocusChange: (hasFocus) {
          if(hasFocus) openOverlay();
          else closeOverlay();
        }
      )
    );
  }

  @override
  void dispose() {
    if (_overlayEntry != null) _overlayEntry!.dispose();
    if (widget.controller != null) widget.controller!.dispose();
    super.dispose();
  }
}