import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/screen/search_screen/search_list.dart';
import 'package:text_print_3d/state/search_status.dart';

class SearchScreen extends StatefulWidget {
  AnimationController animationController;
  SearchScreen({@required this.animationController, Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController;

  @override
  void initState() {
    searchTextEditingController = TextEditingController();
    super.initState();
  }

  textEditChange(value) {
    Provider.of<SearchStatus>(context, listen: false)
        .setBeforeListDataInit(true);
    if (value == "") {
      Provider.of<SearchStatus>(context, listen: false).setBeforeListDataNull();
      Provider.of<SearchStatus>(context, listen: false)
          .setBeforeListDataInit(false);
    } else {
      Provider.of<SearchStatus>(context, listen: false).getAllListData(value);
    }
  }

  ontap() {
    // Provider.of<SearchStatus>(context, listen: false)
    //     .setBeforeListDataInit(true);
  }

  @override
  Widget build(BuildContext context) {
    var searchStatus = Provider.of<SearchStatus>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 34, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                iconSize: 30,
                color: AppColors.selectBackroundColor,
                icon: Icon(Icons.chevron_left),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Text("Search",
                    style: TextStyle(
                        color: AppColors.searchColor,
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  onTap: ontap(),
                  controller: searchTextEditingController,
                  style: TextStyle(
                    color: AppColors.selectBackroundColor,
                  ),
                  onChanged: (value) {
                    textEditChange(value);
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppColors.selectBackroundColor,
                    ),
                    focusedBorder: _borderStyle(),
                    enabledBorder: _borderStyle(),
                    counterText: '',
                    border: const OutlineInputBorder(),
                    hintText: "Type any keyword here",
                    hintStyle:
                        TextStyle(color: AppColors.searchTextFiedHintColor),
                  ),
                  maxLength: 20,
                  maxLines: 1,
                  // controller: titleClickController,
                ),
              ),
              searchStatus.getInit
                  ? searchStatus.getbeforListData != null ||
                          searchStatus.getafterListData != null
                      ? SearchList(
                          animationController: widget.animationController)
                      : _serachNull()
                  : Container(),
            ],
          ),
        ));
  }

  Widget _serachNull() {
    return Expanded(
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text("No matching search results",
                style: TextStyle(
                    color: AppColors.searchNoColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold)),
          ),
          Image.asset(
            'assets/icon/Search_icon.png',
          )
        ],
      ),
    );
  }

  InputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: AppColors.selectBackroundColor, //边线颜色为黄色
        width: 3, //边线宽度为2
      ),
    );
  }
}
