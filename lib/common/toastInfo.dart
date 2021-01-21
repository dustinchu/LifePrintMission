import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_print_3d/common/extra/color.dart';

toastInfo(String info) {
  Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG,
   backgroundColor: AppColors.selectBackroundColor,
  );
}
    // Fluttertoast.showToast(
    //     msg: "This is Center Short Toast",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );