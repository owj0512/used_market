import 'package:flutter/material.dart';
import 'package:used_market/view/market/add_goods.dart';

class GoodsList extends StatefulWidget {
  const GoodsList({Key? key}) : super(key: key);

  @override
  State<GoodsList> createState() => GoodsListState();
}

class GoodsListState extends State<GoodsList> {
  TextEditingController keyword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffEAEAEA),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: keyword,
                          maxLines: 1,
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: '검색'),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            keyword.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.highlight_remove,
                          color: Colors.grey,
                          size: 18,
                        ),
                        splashRadius: 24,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 34),
                  padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          body: SizedBox(),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoods()));
              },
              extendedIconLabelSpacing: 0,
              extendedPadding: const EdgeInsets.all(8),
              icon: const Icon(Icons.add),
              label: const Text('물품등록'))),
    );
  }
}
