import 'package:flutter/material.dart';

import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import 'custom_scroll_behavior.dart';

class PageViewer extends StatefulWidget {
  const PageViewer({Key? key, required this.pageList, required this.currentPage, this.imageDescription}) : super(key: key);
  final List pageList;
  final int currentPage;
  final imageDescription;

  @override
  PageViewerState createState() => PageViewerState();
}

class PageViewerState extends State<PageViewer> {
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
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          Expanded(
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
                return Column(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Image.network(
                        widget.pageList[index],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.imageDescription[index],
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                        maxLines: 20,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          PageViewDotIndicator(
            currentItem: currentPage,
            count: widget.pageList.length,
            unselectedColor: Colors.grey,
            selectedColor: Colors.white,
            size: const Size(12, 12),
            unselectedSize: const Size(8, 8),
            alignment: Alignment.center,
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}