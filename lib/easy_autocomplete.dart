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

import 'dart:async';

import 'package:easy_autocomplete/widgets/filterable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyAutocomplete extends StatefulWidget {
  /// The list of suggestions to be displayed
  final List<String>? suggestions;
  /// Fetches list of suggestions from a Future
  final Future<List<String>> Function(String searchValue)? asyncSuggestions;
  /// Text editing controller
  final TextEditingController? controller;
  /// Can be used to decorate the input
  final InputDecoration decoration;
  /// Function that handles the changes to the input
  final Function(String)? onChanged;
  /// Can be used to set custom inputFormatters to field
  final List<TextInputFormatter> inputFormatter;
  /// Can be used to set the textfield initial value
  final String? initialValue;
  /// Can be used to set the text capitalization type
  final TextCapitalization textCapitalization;
  /// Determines if should gain focus on screen open
  final bool autofocus;
  /// Can be used to set different keyboardTypes to your field
  final TextInputType keyboardType;
  /// Can be used to set a custom color to the input cursor
  final Color? cursorColor;
  /// Can be used to set custom style to the suggestions list text
  final TextStyle suggestionTextStyle;
  /// Can be used to set custom background color to suggestions list
  final Color? suggestionBackgroundColor;
  /// Used to set the debounce time for async data fetch
  final Duration debounceDuration;

  /// Creates a autocomplete widget to help you manage your suggestions
  EasyAutocomplete({
    this.suggestions,
    this.asyncSuggestions,
    this.controller,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.inputFormatter = const [],
    this.initialValue,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType = TextInputType.text,
    this.cursorColor,
    this.suggestionTextStyle = const TextStyle(),
    this.suggestionBackgroundColor,
    this.debounceDuration = const Duration(milliseconds: 400)
  }) : assert(onChanged != null || controller != null, 'onChanged and controller parameters cannot be both null at the same time'),
    assert(!(controller != null && initialValue != null), 'controller and initialValue cannot be used at the same time'),
    assert(suggestions != null && asyncSuggestions == null || suggestions == null && asyncSuggestions != null, 'suggestions and asyncSuggestions cannot be both null or have values at the same time');

  @override
  State<EasyAutocomplete> createState() => _EasyAutocompleteState();
}

class _EasyAutocompleteState extends State<EasyAutocomplete> {
  final LayerLink _layerLink = LayerLink();
  late TextFormField _textFormField;
  bool _hasOpenedOverlay = false;
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  Timer? _debounce;
  String _previousAsyncSearchText = '';

  @override
  void initState() {
    super.initState();
    _textFormField = TextFormField(
      decoration: widget.decoration,
      controller: widget.controller ?? TextEditingController(),
      inputFormatters: widget.inputFormatter,
      autofocus: widget.autofocus,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      cursorColor: widget.cursorColor ?? Colors.blue,
      onChanged: (value) {
        openOverlay();
        widget.onChanged!(value);
      },
      onFieldSubmitted: (value) {
        closeOverlay();
        widget.onChanged!(value);
      },
      onEditingComplete: () => closeOverlay(),
    );
    _textFormField.controller!.text = widget.initialValue ?? '';
    _textFormField.controller!.addListener(() {
      updateSuggestions(_textFormField.controller!.text);
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
              loading: _isLoading,
              items: _suggestions,
              suggestionTextStyle: widget.suggestionTextStyle,
              suggestionBackgroundColor: widget.suggestionBackgroundColor,
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

  Future<void> updateSuggestions(String input) async {
    rebuildOverlay();
    if (widget.suggestions != null) {
      _suggestions = widget.suggestions!.where((element) {
        return element.toLowerCase().contains(input.toLowerCase());
      }).toList();
      rebuildOverlay();
    }
    else if (widget.asyncSuggestions != null) {
      setState(() => _isLoading = true);
      if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
      _debounce = Timer(widget.debounceDuration, () async {
        if (_previousAsyncSearchText != input || _previousAsyncSearchText.isEmpty || input.isEmpty) {
        _suggestions = await widget.asyncSuggestions!(input);
        setState(() {
          _isLoading = false;
          _previousAsyncSearchText = input;
        });
        rebuildOverlay();
        }
      });
    }
  }

  void rebuildOverlay() {
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
            _textFormField
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
    if (_debounce != null) _debounce?.cancel();
    super.dispose();
  }
}