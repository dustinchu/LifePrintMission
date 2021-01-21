import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/layer_status.dart';

class HomeFrontLayerTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final double supFontSize;
  final double hintFontSize;
  final bool focusStatus;
  final onChangeText;

  const HomeFrontLayerTextField(
      {@required this.textEditingController,
      @required this.hintText,
      @required this.maxLines,
      @required this.maxLength,
      @required this.supFontSize,
      @required this.hintFontSize,
      @required this.focusStatus,
      this.onChangeText,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 0, bottom: 0),
      child: TextField(
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")), //只允许输入小数
        ],
        onTap: () => Provider.of<LayerStatus>(context, listen: false)
            .layerStatusClick("textField"),
        //點擊換下一個焦點
        textInputAction:
            focusStatus ? TextInputAction.next : TextInputAction.done,
        onEditingComplete:
            focusStatus ? () => FocusScope.of(context).nextFocus() : null,
        onSubmitted: (_) =>
            focusStatus ? null : FocusScope.of(context).unfocus(),
        controller: textEditingController,
        onChanged: onChangeText,
        // contentPadding: EdgeInsets.all(10.0),
        style: TextStyle(
            color: AppColors.frontLayerTextFiedColor,
            fontSize: supFontSize,
            fontWeight: FontWeight.bold),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent, //边线颜色为黄色
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          counterText: '',
          hintText: hintText,
          hintStyle: TextStyle(
              color: AppColors.frontLayerTextFiedDfColor,
              fontSize: hintFontSize,
              fontWeight: FontWeight.bold),
        ),
        maxLength: maxLength,
        maxLines: maxLines,
        // controller: titleClickController,
      ),
    );
  }
}
