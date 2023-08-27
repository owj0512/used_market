import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:used_market/component/image_uploader.dart';
import 'package:used_market/component/loading.dart';
import 'package:used_market/component/on_back_pressed.dart';
import 'package:used_market/controller/used_market/used_market_controller.dart';
import 'package:used_market/model/market/goods_category.dart';

class AddGoods extends StatefulWidget {
  const AddGoods({Key? key}) : super(key: key);

  @override
  State<AddGoods> createState() => AddGoodsState();
}

class AddGoodsState extends State<AddGoods> {
  final _formKey = GlobalKey<FormState>();
  String? category;
  TextEditingController goodsName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController tradePlace = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await OnBackPressed().onBackPressed(context, '나가시겠습니까?\n입력하신 정보는 저장되지 않습니다');
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  OnBackPressed().onBackPressed(context, '나가시겠습니까?\n입력하신 정보는 저장되지 않습니다');
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87)),
            title: const Text('물품 등록', style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.bold)),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Color(0xffEAEAEA)),
                      )),
                      padding: const EdgeInsets.all(4),
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('카테고리', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 40),
                              SizedBox(
                                width: 150,
                                child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                                    hint: const Text('카테고리 선택'),
                                    alignment: Alignment.center,
                                    isExpanded: true,
                                    value: category,
                                    items: GoodsCategory().goodsCategory.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        category = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (category == null) {
                                        return '카테고리를 선택해주세요';
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Color(0xffEAEAEA)),
                      )),
                      padding: const EdgeInsets.all(4),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('물품명', style: const TextStyle(fontSize: 16)),
                          TextFormField(
                            controller: goodsName,
                            maxLines: 1,
                            maxLength: 100,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                                //hintText: '입력',
                                alignLabelWithHint: true,
                                isDense: true,
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                )),
                              validator: (value) {
                                if (goodsName.text.isEmpty) {
                                  return '물품명을 입력해주세요';
                                }
                                return null;
                              }
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Color(0xffEAEAEA)),
                      )),
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('판매금액', style: TextStyle(fontSize: 16)),
                          TextFormField(
                            controller: price,
                            maxLines: 1,
                            maxLength: 20,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'ko',
                                decimalDigits: 0,
                                symbol: '￦',
                              )
                            ],
                            decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                counterText: '',
                                isDense: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                )),
                              validator: (value) {
                                if (price.text.isEmpty) {
                                  return '판매금액을 입력해주세요';
                                }
                                return null;
                              }
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Color(0xffEAEAEA)),
                      )),
                      padding: const EdgeInsets.all(4),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('거래 희망 지역', style: TextStyle(fontSize: 16)),
                          TextField(
                            controller: tradePlace,
                            maxLines: 1,
                            maxLength: 100,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                                //hintText: '입력',
                                alignLabelWithHint: true,
                                isDense: true,
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ),

                    //사진 등록 부분
                    const ImageUploader()
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (buildContext) =>
                        AlertDialog(
                          title: const Text('등록하시겠습니까?', style: TextStyle(fontSize: 16)),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('네'),
                              onPressed: () async {
                                //팝업창을 닫고 로딩 팝업창을 띄움
                                Navigator.pop(context);
                                Loading().loading(context, '등록중입니다');
                                await UsedMarketController().addGoods(
                                  category!,
                                  goodsName.text,
                                  price.text,
                                  tradePlace.text,
                                  ImageUploaderState.images,
                                  ImageUploaderState.imageDescriptionText,
                                );
                                if (!mounted) return;
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('아니요'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )
                );
              } else {null;}

            },
            child: Container(
                margin: const EdgeInsets.all(6),
                width: 600,
                height: 50,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                child: const Center(child: Text('등록', style: TextStyle(fontSize: 20, color: Colors.white)))),
          ),
        ),
      ),
    );
  }
}
