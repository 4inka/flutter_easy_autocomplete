# Easy Autocomplete

<a href="https://www.buymeacoffee.com/4inka" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-violet.png" alt="Buy Me A Pizza" style="height: 60px !important; width: 217px !important;"/>
</a>


A Flutter plugin to handle input autocomplete suggestions

## Preview
![Preview](https://raw.githubusercontent.com/4inka/flutter_easy_autocomplete/main/preview/preview.gif)

## ToDo
* Add validation functionality
* Add possibility to show empty message when no suggestion is found
## Done
* Add asynchronous suggestions fetch

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

``` yaml
dependencies:
  ...
  easy_autocomplete: ^1.2.0
```

### Basic example

You can create a simple autocomplete input widget as shown in first preview with the following example:

``` dart
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Example')
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: EasyAutocomplete(
              suggestions: ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'],
              onChanged: (value) => print(value)
            )
          )
        )
      )
    );
  }
}
```

### Example with customized style

You can customize other aspects of the autocomplete widget such as the suggestions text style, background color and others as shown in example below:

``` dart
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Example')
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: EasyAutocomplete(
              suggestions: ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'],
              cursorColor: Colors.purple,
              suggestionBackgroundColor: Colors.purple,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.purple,
                    style: BorderStyle.solid
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.purple,
                    style: BorderStyle.solid
                  )
                )
              ),
              suggestionTextStyle: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 16
              ),
              onChanged: (value) => print(value)
            )
          )
        )
      )
    );
  }
}
```
The above example will generate something like below preview:

![Preview](https://raw.githubusercontent.com/4inka/flutter_easy_autocomplete/main/preview/preview2.gif)

### Example with asynchronous data fetch

To create a autocomplete field that fetches data asynchronously you will need to use `asyncSuggestions` instead of `suggestions`
``` dart
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(Duration(milliseconds: 750));
    List<String> _suggestions = ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'];
    List<String> _filteredSuggestions = _suggestions.where((element) {
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
    return _filteredSuggestions;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Example')
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: EasyAutocomplete(
              asyncSuggestions: (searchValue) async => _fetchSuggestions(searchValue),
              onChanged: (value) => print(value)
            )
          )
        )
      )
    );
  }
}
```

The above example will generate something like below preview:

![Preview](https://raw.githubusercontent.com/4inka/flutter_easy_autocomplete/main/preview/preview3.gif)

## API
| Attribute | Type | Required | Description | Default value |
|:---|:---|:---:|:---|:---|
| suggestions | `List<String>` | :x: | The list of suggestions to be displayed |  |
| asyncSuggestions | `Future<List<String>> Function(String)` | :x: | Fetches list of suggestions from a Future |  |
| controller | `TextEditingController` | :x: | Text editing controller |  |
| decoration | `InputDecoration` | :x: | Can be used to decorate the input |  |
| onChanged | `Function(String)` | :x: | Function that handles the changes to the input |  |
| inputFormatter | `List<TextInputFormatter>` | :x: | Can be used to set custom inputFormatters to field |  |
| initialValue | `String` | :x: | Can be used to set the textfield initial value |  |
| textCapitalization | `TextCapitalization` | :x: | Can be used to set the text capitalization type | TextCapitalization.sentences |
| autofocus | `bool` | :x: | Determines if should gain focus on screen open | false |
| keyboardType | `TextInputType` | :x: | Can be used to set different keyboardTypes to your field | TextInputType.text |
| cursorColor | `Color` | :x: | Can be used to set a custom color to the input cursor | Colors.blue |
| inputTextStyle | `TextStyle` | :x: | Can be used to set custom style to the suggestions textfield |  |
| suggestionTextStyle | `TextStyle` | :x: | Can be used to set custom style to the suggestions list text |  |
| suggestionBackgroundColor | `Color` | :x: | Can be used to set custom background color to suggestions list |  |
| debounceDuration | `Duration` | :x: | Used to set the debounce time for async data fetch | Duration(milliseconds: 400) |

## Issues & Suggestions
If you encounter any issue you or want to leave a suggestion you can do it by filling an [issue](https://github.com/4inka/flutter_easy_autocomplete/issues).

### Thank you for the support!