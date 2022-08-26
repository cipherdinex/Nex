import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CustCountryPicker extends StatelessWidget {
  const CustCountryPicker({
    Key? key,
    this.onChanged,
    this.onInit,
    this.showCountryOnly = false,
    this.showOnlyCountryWhenClosed = false,
    this.initialSelection,
    this.enabled = true,
  }) : super(key: key);

  final Function(CountryCode)? onChanged;
  final void Function(CountryCode?)? onInit;
  final bool showCountryOnly;
  final bool showOnlyCountryWhenClosed;
  final String? initialSelection;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      enabled: enabled,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      barrierColor: Theme.of(context).scaffoldBackgroundColor,
      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      padding: const EdgeInsets.all(0),
      onChanged: onChanged,
      initialSelection: initialSelection ?? 'BE',
      onInit: onInit,
      showCountryOnly: showCountryOnly,
      showOnlyCountryWhenClosed: showOnlyCountryWhenClosed,
    );
  }
}
