import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:used_market/component/page_viewer.dart';
import 'custom_scroll_behavior.dart';

class GoodsInfoImageViewer extends StatefulWidget {
  const GoodsInfoImageViewer({Key? key, required this.pageList, required this.imageDescription, required this.currentPage}) : super(key: key);
  final List pageList;
  final List imageDescription;
  final int currentPage;

  @override
  GoodsInfoImageViewerState createState() => GoodsInfoImageViewerState();
}

class GoodsInfoImageViewerState extends State<GoodsInfoImageViewer> {
  //파라미터로 받은 currentPage 변수는 PageController의 initialPage로 사용이 불가능하므로, 새로운 currentPage변수를 선언해서 값을 넣어줌
  late int currentPage;

  @override
  void initState() {
    currentPage = widget.currentPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: currentPage);
    return InteractiveViewer(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: PageView.builder(
              controller: controller,
              scrollBehavior: CustomScrollBehavior(),
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: widget.pageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                      showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (BuildContext context) => Dialog.fullscreen(
                              backgroundColor: Colors.black,
                              child: PageViewer(pageList: widget.pageList, imageDescription: widget.imageDescription, currentPage: index,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.pageList[index])),
                    ),
                  ),
                );

                //   Image.network(
                //   widget.pageList[index],
                // );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageViewDotIndicator(
              currentItem: currentPage,
              count: widget.pageList.length,
              unselectedColor: Colors.grey,
              selectedColor: Colors.white,
              size: const Size(12, 12),
              unselectedSize: const Size(8, 8),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}