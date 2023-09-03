import 'package:flutter/material.dart';
import 'package:used_market/component/goods_info_image_viewer.dart';
import 'package:used_market/controller/used_market/used_market_controller.dart';

class GoodsView extends StatefulWidget {
  const GoodsView({super.key, required this.docId});
  final String docId;

  @override
  State<GoodsView> createState() => GoodsViewState();
}

class GoodsViewState extends State<GoodsView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: UsedMarketController().getGoodsInfo(widget.docId),
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Column(children: [
                    GoodsInfoImageViewer(
                        pageList: snapshot.data['imageUrlList'], imageDescription: snapshot.data['imageDescription'], currentPage: 0)
                  ]);
            }));
  }
}
