# Easy Autocomplete

<a href="https://www.buymeacoffee.com/4inka" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-violet.png" alt="Buy Me A Pizza" style="height: 60px !important; width: 217px !important;" ></a>


A Flutter plugin to handle input autocomplete suggestions

## Preview
![Preview](https://raw.githubusercontent.com/4inka/flutter_easy_autocomplete/main/preview/preview.gif)

## ToDo
* Add validation functionality
* Adding asynchronous suggestions fetch
* Add possibility to show empty message when no suggestion is found

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

``` yaml
dependencies:
  ...
  easy_autocomplete: ^1.0.0
```

You can create a simple autocomplete input widget with the following example:

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

## API
| Attribute | Type | Required | Description | Default value |
|:---|:---|:---:|:---|:---|
| suggestions | `List<String>` | :heavy_check_mark: | The list of suggestions to be displayed |  |
| controller | `TextEditingController` | :x: | Text editing controller |  |
| decoration | `InputDecoration` | :x: | Can be used to decorate the input | InputDecoration() |
| onChanged | `Function(String)` | :x: | Function that handles the changes to the input |  |
| inputFormatter | `List<TextInputFormatter>` | :x: | Can be used to set custom inputFormatters to field |  |
| initialValue | `String` | :x: | Can be used to set the textfield initial value |  |
| textCapitalization | `TextCapitalization` | :x: | Can be used to set the text capitalization type | TextCapitalization.sentences |
| autofocus | `bool` | :x: | Determines if should gain focus on screen open | false |

## Issues & Suggestions
If you encounter any issue you or want to leave a suggestion you can do it by filling an [issue](https://github.com/4inka/flutter_easy_autocomplete/issues).

### Thank you for the support!