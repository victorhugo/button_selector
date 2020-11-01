import 'package:button_selector/components/RadioStyles.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'RadioButton.dart';

enum SelectorOrientation { horizontal, vertical }

enum SelectionType { radio, highlighted }

class ButtonSelectorWidget extends StatefulWidget {
  ButtonSelectorWidget(
      {Key key,
      @required this.tapSelected,
      @required this.options,
      this.assets = const [],
      this.orientation = SelectorOrientation.horizontal,
      this.separation = 0.0,
      this.selectionStyle = SelectionType.radio,
      this.labelStyle,
      this.optionStyle})
      : super(key: key);
  final OptionTapped tapSelected;
  final List<OptionData> options;
  final List<String> assets;
  final SelectorOrientation orientation;
  final double separation;
  final SelectionType selectionStyle;
  final TextStyle labelStyle;
  final RadioOptionStyle optionStyle;

  @override
  _ButtonSelectorWidgetState createState() => _ButtonSelectorWidgetState();
}

class _ButtonSelectorWidgetState extends State<ButtonSelectorWidget> {
  int selectedIndex = 0;
  List<Widget> buttons = [];

  @override
  Widget build(BuildContext context) {
    buttons.clear();
    for (var i = 0; i < widget.options.length; i++) {
      var dat = widget.options[i];
      if (widget.assets.length == widget.options.length) {
        var icon = widget.assets[i];
        var op = RadioButton(
          isSelected: dat.isSelected != null ? dat.isSelected : false,
          ontap: onTapButton,
          index: i,
          option: dat,
          icon: icon,
          orientation: widget.orientation,
          type: widget.selectionStyle,
          radioStyle: widget.optionStyle,
          titleStyle: widget.labelStyle,
        );
        buttons.add(op);
      } else {
        var op = RadioButton(
            isSelected: dat.isSelected != null ? dat.isSelected : false,
            ontap: onTapButton,
            index: i,
            option: dat,
            orientation: widget.orientation,
            type: widget.selectionStyle,
            radioStyle: widget.optionStyle,
            titleStyle: widget.labelStyle);
        buttons.add(op);
      }
      if (widget.orientation == SelectorOrientation.horizontal) {
        buttons.add(SizedBox(width: widget.separation));
      } else {
        buttons.add(SizedBox(height: widget.separation));
      }
    }
    Widget selectors;
    if (widget.orientation == SelectorOrientation.horizontal) {
      selectors = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      );
    } else {
      selectors = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: buttons,
      );
    }

    return ChangeNotifierProvider(
      create: (context) => RadioButtonNotifier(),
      child: selectors,
    );
  }

  RadioButtonNotifier selector;
  void onTapButton(int index, dynamic data) {
    setState(() {
      selectedIndex = index;
    });
    widget.tapSelected(index, data);
  }
}

class OptionData<T extends DescriptionableInterface> {
  final String name;
  final T data;
  final int id;
  bool isSelected = false;
  OptionData(this.name, this.data, this.id, this.isSelected);
}

abstract class DescriptionableInterface {
  String description();
}

class RadioButtonNotifier extends ChangeNotifier {
  int selectedIndex = 0;

  void setSelected(int index) {
    this.selectedIndex = index;
    notifyListeners();
  }
}
