## 1.6.0 - [23-06-2022]

### Added
* Added `validator` parameter. Now you can validate the autocomplete field inside a form
* Added `progressIndicatorBuilder` parameter. Now you can add a custom progress indicator to be used in async suggestions fetch

### Fixed
* Fixed progress indicator appearing when regaining focus on element

## 1.5.0 - [13-02-2022]

### Added
* Added `onSubmitted` parameter

### Changed
* Formatted dart files
 
## 1.4.2 - [13-01-2022]

### Added
* Added `focusNode` parameter

### Fixed
* Correcting bug in which keyboard wouldn't close when pressing enter on keyboard

## 1.4.1 - [11-01-2022]

### Fixed
* Correcting bug in which couldn't apply changes to TextField using setState

## 1.4.0 - [07-01-2022]

### Changed
* Improving default suggestions list background color to ajust to different background colors depending on light, dark theme and different scaffold colors

## 1.3.1 - [22-12-2021]

### Fixed
* Correcting default suggestions background color

## 1.3.0 - [18-12-2021]

### Added
* Added the `suggestionBuilder` parameter that can be used to customize suggestion items

## 1.2.2 - [14-12-2021]

### Fixed
* Correcting bug in which disposing controller would generate error

## 1.2.1 - [09-12-2021]

### Fixed
* Correcting bug in which could not set initial value through controller

## 1.2.0 - [09-12-2021]

### Added
* Parameters to style suggestions textfield text
* Function to fetch suggestions asynchronously

## 1.1.0 - [08-12-2021]

### Added
* Parameters to style cursor color and suggestions list
* Parameter to set custom keyboard type to the suggestions textfield

## 1.0.0 - [02-12-2021]

* Initial release
