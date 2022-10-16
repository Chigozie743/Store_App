import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:store_app/api_services/api_services.dart';
import 'package:store_app/constants/color_constant.dart';
import 'package:store_app/models/products_model.dart';
import 'package:store_app/views/categories_screen.dart';
import 'package:store_app/views/feeds_screen.dart';
import 'package:store_app/views/users_screen.dart';
import 'package:store_app/widget/appbar_icons.dart';
import 'package:store_app/widget/feeds_grid.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:store_app/widget/feeds_widget.dart';
import 'package:store_app/widget/sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _textEditingController;

  //List<ProductsModel> productList = [];

  @override
  void initState() {
    // TODO: implement initState
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
        child: Scaffold(
          appBar: AppBar(
            //elevation: 4,
            title: const Text(
              "Home",
            ),
            leading: AppBarIcons(
              function: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const CategoriesScreen(),
                  ),
                );
              },
              icon: IconlyBold.category,
            ),
            actions: [
              AppBarIcons(
                function: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const UsersScreen(),
                    ),
                  );
                },
                icon: IconlyBold.user3,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox( height: 18.0,),

                TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Search",
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).cardColor
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        width: 1.1,
                        color: Theme.of(context).colorScheme.secondary
                      ),
                    ),
                    suffixIcon: Icon(
                      IconlyLight.search,
                      color: lightIconsColor,
                    ),
                  ),
                ),

                const SizedBox(height: 18.0,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.25,
                          child: Swiper(
                            itemCount: 3,
                            itemBuilder: (ctx, index){
                              return const SaleWidget();
                            },
                            autoplay: true,
                            pagination: SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: DotSwiperPaginationBuilder(
                                color: Colors.white,
                                activeColor: Colors.redAccent[700],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                "Latest Products",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0
                                ),
                              ),

                              const Spacer(),
                              AppBarIcons(
                                  function: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const FeedsScreen(),
                                      ),
                                    );
                                  },
                                  icon: IconlyBold.arrowRight2,
                              ),
                            ],
                          ),
                        ),

                        // productList.isEmpty
                        //     ? Container()
                        //     : FeedsGridWidget(productsList: productList,),

                        FutureBuilder<List<ProductsModel>>(
                          future: APIServices.getALlProducts(limit: "3"),
                          builder: ((context, snapshot){
                            if(snapshot.connectionState ==
                            ConnectionState.waiting){
                              return Center(
                                child: HeartbeatProgressIndicator(
                                  child:  const Icon(Icons.home, color: Colors.pink,),
                                ),
                              );
                            } else if(snapshot.hasError){
                              Center(
                                child: Text("An error occured ${snapshot.error}"),
                              );
                            } else if(snapshot.data == null){
                              const Center(
                                child: Text("No product has been added yet"),
                              );
                            }
                            return FeedsGridWidget(productsList: snapshot.data!);
                          }),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
    );
  }
}
