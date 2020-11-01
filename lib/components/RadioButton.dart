import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'ButtonSelectorWidget.dart';
import 'RadioStyles.dart';

typedef OnOptionTapped = void Function(int, dynamic);
typedef OptionTapped = void Function(int, dynamic);

class RadioButton extends StatefulWidget {
  const RadioButton({
    Key key,
    @required this.ontap,
    @required this.index,
    this.option,
    this.icon,
    this.heightIcon = 70,
    this.heightNoIcon = 70,
    this.orientation = SelectorOrientation.horizontal,
    this.isSelected = false,
    this.type = SelectionType.radio,
    this.titleStyle,
    this.radioStyle,
  }) : super(key: key);
  final OnOptionTapped ontap;
  final int index;
  final OptionData option;

  final String icon;
  final double heightIcon;
  final double heightNoIcon;
  final bool isSelected;

  final SelectionType type;

  final SelectorOrientation orientation;

  final TextStyle titleStyle;

  final RadioOptionStyle radioStyle;

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  var isSelected = false;
  @override
  void initState() {
    super.initState();
    this.isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    var content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          var selector = context.read<RadioButtonNotifier>();
          selector.setSelected(widget.index);
          widget.ontap(widget.index, widget.option);
        },
        child: radioType());

    if (widget.orientation == SelectorOrientation.horizontal) {
      return Expanded(child: content);
    } else {
      return content;
    }
  }

  TextStyle titleStyle = TextStyle();

  Widget radioType() {
    return Consumer<RadioButtonNotifier>(builder: (context, value, child) {
      bool isSelected = value.selectedIndex == widget.index;

      if (widget.radioStyle != null) {
        titleStyle = TextStyle(
            fontWeight: widget.titleStyle.fontWeight,
            fontFamily: widget.titleStyle.fontFamily,
            fontSize: widget.titleStyle.fontSize,
            height: widget.titleStyle.height,
            letterSpacing: widget.titleStyle.letterSpacing,
            color: isSelected
                ? widget.radioStyle.selectedLabelColor
                : widget.radioStyle.unselectedLabelColor);
      }
      if (widget.type == SelectionType.radio) {
        return Container(
          color: isSelected
              ? widget.radioStyle.selectedBackgroundColor
              : widget.radioStyle.unselectedBackgroundColor,
          alignment: Alignment.center,
          height: widget.icon == null ? widget.heightIcon : widget.heightNoIcon,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              SizedBox(
                  width: 30,
                  child: isSelected
                      ? AnimatedRadioIndicator(
                          isSelected: true,
                          tintColor: widget.radioStyle.selectedRadioColor,
                        )
                      : CustomPaint(
                          painter: CircleFillPainter(isSelected: false))),
              SizedBox(width: 10),
              AutoSizeText(widget.option.data.description(),
                  style: titleStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 10),
              if (widget.icon != null)
                SizedBox(height: 70, child: Image.asset(widget.icon)),
            ],
          ),
          //decoration: R.containerDecorationGradient(radius: 5),
        );
      }
      return Container(
        color: isSelected
            ? widget.radioStyle.selectedBackgroundColor
            : widget.radioStyle.unselectedBackgroundColor,
        alignment: Alignment.center,
        height: widget.icon == null ? widget.heightIcon : widget.heightNoIcon,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(widget.option.data.description(),
                style: titleStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 10),
            if (widget.icon != null)
              SizedBox(height: 70, child: Image.asset(widget.icon)),
          ],
        ),
        //decoration: R.containerDecorationGradient(radius: 5),
      );
    });
  }
}

class AnimatedRadioIndicator extends StatefulWidget {
  AnimatedRadioIndicator(
      {Key key, this.isSelected, this.tintColor = Colors.white})
      : super(key: key);
  final bool isSelected;
  final Color tintColor;
  @override
  _AnimatedRadioIndicatorState createState() => _AnimatedRadioIndicatorState();
}

class _AnimatedRadioIndicatorState extends State<AnimatedRadioIndicator>
    with TickerProviderStateMixin {
  var _startRadius = 0.0;
  Duration _duration = Duration(milliseconds: 200);
  AnimationController _controller;
  Animation sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: _duration,
    );
    sizeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));
    sizeAnimation.addListener(() {
      setState(() {
        // print("Value ${sizeAnimation.value}");
        _startRadius = sizeAnimation.value; //10.0;
      });
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedRadioIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _controller.duration = _duration;
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.isSelected){

    return CustomPaint(
        painter: CircleFillPainter(
            isSelected: widget.isSelected,
            radius: _startRadius,
            tintColor: widget.tintColor));
    // }
    // return CustomPaint(painter:CircleFillPainter(isSelected: widget.isSelected));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CircleFillPainter extends CustomPainter {
  final Color tintColor;
  final bool isSelected;
  final double radius;
  CircleFillPainter(
      {this.tintColor = Colors.white, this.radius, this.isSelected = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = tintColor
      ..style = PaintingStyle.fill;

    var paint2 = Paint()
      ..color = tintColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(15, 0), radius, paint1);
    canvas.drawCircle(Offset(15, 0), 14, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
