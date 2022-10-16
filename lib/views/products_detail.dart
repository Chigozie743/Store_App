import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:store_app/api_services/api_services.dart';
import 'package:store_app/constants/color_constant.dart';
import 'package:store_app/models/products_model.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  final titleStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  ProductsModel? productsModel;
  bool isError = false;
  String errorStr = "";

  Future<void> getProductInfo() async{
    //productsModel = await APIServices.getProductsById(id: widget.id);
    try {
      productsModel = await APIServices.getProductsById(id: widget.id);
    } catch (error) {
      isError = true;
      errorStr = error.toString();
      log("error $error");
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getProductInfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: isError
              ? Center(
                child: Text(
                "An error occured $errorStr",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
            )
            : productsModel == null
            ? Center(child: GlowingProgressIndicator(
          child: const Icon(Icons.shopping_bag, color: Colors.pink, size: 50.0,),
        ),)
            :SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 18.0,),
              const BackButton(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productsModel!.category!.name.toString(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 18.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            productsModel!.title.toString(),
                            style: titleStyle,
                          ),
                        ),

                        Flexible(
                          flex: 1,
                          child: RichText(
                            text: TextSpan(
                              text: '\$',
                              style: const TextStyle(
                                fontSize: 25.0,
                                color: Color.fromRGBO(33, 150, 243, 1),
                              ),
                              children: <TextSpan>[
                                TextSpan( text: productsModel!.price.toString(),
                                  style: TextStyle(
                                    color: lightTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0,),
                  ],
                ),
              ),

              SizedBox(
                height: size.height * 0.4,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return FancyShimmerImage(
                      width: double.infinity,
                      imageUrl: productsModel!.images![index].toString(),
                      boxFit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemCount: 3,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.green,
                      activeColor: Colors.redAccent[700],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18.0,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Descripton",
                      style: titleStyle,
                    ),

                    const SizedBox(height: 18.0,),

                    Text( productsModel!.description.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 25.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
