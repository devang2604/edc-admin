import 'package:flutter/material.dart';
import 'package:vp_admin/constants.dart';

class ChoiceButton extends StatefulWidget {
  // final String? selected;
  final List<String> options;
  final String? defaultValue;
  final void Function(String) onChanged;
  final String? value;
  const ChoiceButton(
      {Key? key,
      required this.options,
      required this.onChanged,
      this.defaultValue,
      this.value})
      : super(key: key);
  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  int defaultChoiceIndex = 1000;

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      defaultChoiceIndex = widget.options.indexOf(widget.defaultValue!);
    }

    if (widget.value != null) {
      defaultChoiceIndex = widget.options.indexOf(widget.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      defaultChoiceIndex = widget.options.indexOf(widget.value!);
    }
    return Wrap(
      spacing: 10,
      children: List.generate(widget.options.length, (index) {
        return ChoiceChip(
          // labelPadding: const EdgeInsets.all(0),
          label: Text(
            widget.options[index],
            style: TextStyle(
                color: defaultChoiceIndex == index ? Colors.white : kTextColor,
                fontSize: 14),
          ),
          selected: defaultChoiceIndex == index,
          selectedColor: kViolet,
          onSelected: (value) {
            setState(() {
              defaultChoiceIndex = value ? index : defaultChoiceIndex;
            });
            widget.onChanged(widget.options[index]);
          },
          backgroundColor: Colors.white,
          elevation: 3,
          selectedShadowColor: Colors.black,
        );
      }),
    );
  }
}

//Multiple Choice Button
class MultipleChoiceButton extends StatefulWidget {
  const MultipleChoiceButton({
    super.key,
    required this.options,
    this.defaultValues,
    required this.onSelected,
    required this.onDeselected,
  });
  final List<String> options;
  final List<String>? defaultValues;
  final void Function(String) onSelected;
  final void Function(String) onDeselected;

  @override
  State<MultipleChoiceButton> createState() => _MultipleChoiceButtonState();
}

class _MultipleChoiceButtonState extends State<MultipleChoiceButton> {
  List<String> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    if (widget.defaultValues != null) {
      setState(() {
        selectedChoices = widget.defaultValues!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: List.generate(widget.options.length, (index) {
        return ChoiceChip(
          // labelPadding: const EdgeInsets.all(0),
          label: Text(
            widget.options[index],
            style: TextStyle(
                color: selectedChoices.contains(widget.options[index])
                    ? Colors.white
                    : kTextColor,
                fontSize: 14),
          ),
          selected: selectedChoices.contains(widget.options[index]),
          selectedColor: kViolet,
          onSelected: (value) {
            setState(() {
              if (value) {
                selectedChoices.add(widget.options[index]);
              } else {
                selectedChoices.remove(widget.options[index]);
              }
            });
            if (value) {
              widget.onSelected(widget.options[index]);
            } else {
              widget.onDeselected(widget.options[index]);
            }
          },
          backgroundColor: Colors.white,
          elevation: 1,
        );
      }),
    );
  }
}
