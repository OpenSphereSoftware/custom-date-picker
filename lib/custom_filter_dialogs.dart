// @dart=2.12

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'custom_calendar.dart' as calendar;

import 'package:flutter/material.dart';

const Size _calendarPortraitDialogSize = Size(300.0, 398.0);
const Size _calendarLandscapeDialogSize = Size(344.0, 346.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);

/// Shows a dialog containing a Material Design date picker.
///
/// The returned [Future] resolves to the date selected by the user when the
/// user confirms the dialog. If the user cancels the dialog, null is returned.
///
/// When the date picker is first displayed, it will show the month of
/// [initialDate], with [initialDate] selected.
///
/// The [firstDate] is the earliest allowable date. The [lastDate] is the latest
/// allowable date. [initialDate] must either fall between these dates,
/// or be equal to one of them. For each of these [DateTime] parameters, only
/// their dates are considered. Their time fields are ignored. They must all
/// be non-null.
///
/// The [currentDate] represents the current day (i.e. today). This
/// date will be highlighted in the day grid. If null, the date of
/// `DateTime.now()` will be used.
///
///
/// An optional [selectableDayPredicate] function can be passed in to only allow
/// certain days for selection. If provided, only the days that
/// [selectableDayPredicate] returns true for will be selectable. For example,
/// this can be used to only allow weekdays for selection. If provided, it must
/// return true for [initialDate].
///
/// The following optional string parameters allow you to override the default
/// text used for various parts of the dialog:
///
///   * [helpText], label displayed at the top of the dialog.
///   * [cancelText], label on the cancel button.
///   * [confirmText], label on the ok button.
///   * [errorFormatText], message used when the input text isn't in a proper date format.
///   * [errorInvalidText], message used when the input text isn't a selectable date.
///   * [fieldHintText], text used to prompt the user when no text has been entered in the field.
///   * [fieldLabelText], label for the date text input field.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// ([TextDirection.ltr] or [TextDirection.rtl]) for the date picker. It
/// defaults to the ambient text direction provided by [Directionality]. If both
/// [locale] and [textDirection] are non-null, [textDirection] overrides the
/// direction chosen for the [locale].
///
/// The [context], [useRootNavigator] and [routeSettings] arguments are passed to
/// [showDialog], the documentation for which discusses how it is used. [context]
/// and [useRootNavigator] must be non-null.
///
/// The [builder] parameter can be used to wrap the dialog widget
/// to add inherited widgets like [Theme].
///
/// An optional [initialDatePickerMode] argument can be used to have the
/// calendar date picker initially appear in the [DatePickerMode.year] or
/// [DatePickerMode.day] mode. It defaults to [DatePickerMode.day], and
/// must be non-null.
///

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  // custom styling
  Widget dropDownIcon = const Icon(Icons.arrow_drop_down),
  Color controlColor = Colors.black,
  Widget monthControlIconLeft = const Icon(Icons.chevron_left),
  Widget monthControlIconRight = const Icon(Icons.chevron_right),
  Color enabledDayColor = Colors.blue,
  Color disabledDayColor = Colors.grey,
  Color selectedDayColor = Colors.white,
  Color selectedDayBackground = Colors.blue,
  Color todayColor = Colors.grey,
  Color weekdayAxisColor = Colors.grey,
  Color enabledYearColor = Colors.grey,
  Color disabledYearColor = Colors.grey,
  Color selectedYearColor = Colors.white,
  Color selectedYearBackground = Colors.blue,
  Color currentYearColor = Colors.green,
}) async {
  initialDate = DateUtils.dateOnly(initialDate);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);

  Widget dialog = CustomDatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
    //custom style
    dropDownIcon: dropDownIcon,
    controlColor: controlColor,
    monthControlIconLeft: monthControlIconLeft,
    monthControlIconRight: monthControlIconRight,
    selectedDayBackground: selectedDayBackground,
    todayColor: todayColor,
    enabledDayColor: enabledDayColor,
    disabledDayColor: disabledDayColor,
    selectedDayColor: selectedDayColor,
    weekdayAxisColor: weekdayAxisColor,
    currentYearColor: currentYearColor,
    enabledYearColor: enabledYearColor,
    disabledYearColor: disabledYearColor,
    selectedYearBackground: selectedYearBackground,
    selectedYearColor: selectedYearColor,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

/// The concrete CustomToolDialog
///
/// A Material-style date picker dialog.
///
class CustomDatePickerDialog extends StatefulWidget {
  CustomDatePickerDialog({
    Key? key,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    this.selectableDayPredicate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.initialCalendarMode = DatePickerMode.day,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    // custom styling
    this.dropDownIcon = const Icon(Icons.arrow_drop_down),
    this.controlColor = Colors.black,
    this.monthControlIconLeft = const Icon(Icons.chevron_left),
    this.monthControlIconRight = const Icon(Icons.chevron_right),
    this.enabledDayColor = Colors.blue,
    this.disabledDayColor = Colors.grey,
    this.selectedDayColor = Colors.white,
    this.selectedDayBackground = Colors.blue,
    this.todayColor = Colors.grey,
    this.weekdayAxisColor = Colors.grey,
    this.enabledYearColor = Colors.grey,
    this.disabledYearColor = Colors.grey,
    this.selectedYearColor = Colors.white,
    this.selectedYearBackground = Colors.blue,
    this.currentYearColor = Colors.green,
  })  : initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        super(key: key);

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The text that is displayed on the cancel button.
  final String? cancelText;

  /// The text that is displayed on the confirm button.
  final String? confirmText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String? errorInvalidText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format string. For example,
  /// 'mm/dd/yyyy' for en_US.
  final String? fieldHintText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String? fieldLabelText;

  /// Icon used for Year Selection
  final Widget dropDownIcon;

  // Color used for controls (year selection dropdown, month selection)
  final Color controlColor;

  /// widget / icon used for month selection
  final Widget monthControlIconLeft;

  /// widget / icon used for month selection
  final Widget monthControlIconRight;

  /// color of the Axis with day of the week  S M T W T F S
  final Color weekdayAxisColor;

  final Color enabledDayColor;
  final Color disabledDayColor;
  final Color selectedDayColor;
  final Color selectedDayBackground;
  final Color todayColor;
  final Color enabledYearColor;
  final Color disabledYearColor;
  final Color selectedYearColor;
  final Color selectedYearBackground;
  final Color currentYearColor;

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _selectedDate = widget.initialDate;

  final GlobalKey _calendarPickerKey = GlobalKey();

  // Function that closes the DatePicker and returns date with pop
  void _handleOk() {
    Navigator.pop(context, _selectedDate);
  }

  // Function to close the Datepicker
  void _handleCancel() {
    Navigator.pop(context);
  }

  // called everytime User selects new Date
  void _handleDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  // sizes the dialog depending on device orientation  (portrait / landscape)
  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return _calendarPortraitDialogSize;
      case Orientation.landscape:
        return _calendarLandscapeDialogSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constrain the textScaleFactor to the largest supported value to prevent layout issues.
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);

    // TODO use our custom buttons as actions  maybe from outside
    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        spacing: 8,
        children: <Widget>[
          TextButton(
            onPressed: _handleCancel,
            child: Text(
              widget.cancelText ?? "Abbrechen",
              style: const TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: _handleOk,
            child: Text(
              widget.confirmText ?? "Übernehmen",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    calendar.CustomCalendarDatePicker calendarDatePicker() {
      return calendar.CustomCalendarDatePicker(
        key: _calendarPickerKey,
        initialDate: _selectedDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        currentDate: widget.currentDate,
        onDateChanged: _handleDateChanged,
        selectableDayPredicate: widget.selectableDayPredicate,
        initialCalendarMode: widget.initialCalendarMode,
        // custom style
        dropDownIcon: widget.dropDownIcon,
        controlColor: widget.controlColor,
        monthControlIconLeft: widget.monthControlIconLeft,
        monthControlIconRight: widget.monthControlIconRight,
        selectedDayBackground: widget.selectedDayBackground,
        todayColor: widget.todayColor,
        enabledDayColor: widget.enabledDayColor,
        disabledDayColor: widget.disabledDayColor,
        selectedDayColor: widget.selectedDayColor,
        weekdayAxisColor: widget.weekdayAxisColor,
        currentYearColor: widget.currentYearColor,
        enabledYearColor: widget.enabledYearColor,
        disabledYearColor: widget.disabledYearColor,
        selectedYearBackground: widget.selectedYearBackground,
        selectedYearColor: widget.selectedYearColor,
      );
    }

    final Widget picker = calendarDatePicker();

    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: Builder(builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: picker),
                actions,
              ],
            );
          }),
        ),
      ),
    );
  }
}
