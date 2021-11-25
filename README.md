# Easy Autocomplete (To Do)

<a href="https://www.buymeacoffee.com/4inka" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-violet.png" alt="Buy Me A Pizza" style="height: 60px !important; width: 217px !important;" ></a>


A Flutter plugin to handle input autocomplete suggestions

## Preview
![Preview](https://raw.githubusercontent.com/4inka/flutter_quantity_input/main/preview/preview.gif)

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

``` yaml
dependencies:
  ...
  easy_autocomplete: ^0.0.1
```

You can create a simple autocomplete input widget with the following example:

``` dart
import 'package:flutter/material.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int simpleIntInput = 0;

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
              suggestions: ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brasil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'],
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
| value | `int`/`double` | :heavy_check_mark: | Has to be an int or double depending on QuantityInputType variable |  |
| onChanged | `Function(String)` | :heavy_check_mark: | Detects changes to the input and sends value through param |  |
| step | `int`/`double` | :x: | The value that is incremented or decremented each time the user presses a button | 1 |
| decimalDigits | `int` | :x: | The number of decimal places that can be displayed for double input | 1 |
| minValue | `int`/`double` | :x: | Set min value to be displayed in input | 1 |
| maxValue | `int`/`double` | :x: | Set max value to be displayed in input | 100 |
| inputWidth | `double` | :x: | The width of the textfield input | 80 |
| buttonColor | `Color` | :x: | Sets color for increment and decrement buttons | Primary app color |
| iconColor | `Color` | :x: | Sets color for icons inside increment and decrement buttons | Colors.white |
| label | `String` | :x: | Sets label for input |  |
| readOnly | `bool` | :x: | Determines if the input will be readOnly | false |
| acceptsZero | `bool` | :x: | If set to true, the input can accept the value 0 | false |
| acceptsNegatives | `bool` | :x: | If set to true, the input can accept negative values | false |
| type | `QuantityInputType` | :x: | Determines if the input will manage values as int or double | QuantityInputType.int |
| decoration | `InputDecoration` | :x: | Sets custom InputDecoration to the widget TextFormField |  |
| elevation | `double` | :x: | Sets elevation to increment and decrement buttons | 5 |

## Issues & Suggestions
If you encounter any issue you or want to leave a suggestion you can do it by filling an [issue](https://github.com/4inka/flutter_easy_autocomplete/issues).

### Thank you for the support!