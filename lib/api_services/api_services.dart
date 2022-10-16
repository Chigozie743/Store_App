import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:store_app/constants/api_const.dart';
import 'package:store_app/models/categories_model.dart';
import 'package:store_app/models/products_model.dart';
import 'package:store_app/models/users_model.dart';

class APIServices {

  static Future<List<dynamic>> getData({
    required String target,
    String? limit,
  }) async{
    try{
      var uri = Uri.https(
          BASE_URL,
          "api/v1/$target",
          target == "products"
              ? {
              "offset": "0",
              "limit": limit,
              }
              : {}
      );

      var response = await http.get(uri);

      //print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      List tempList = [];
      if(response.statusCode !=200){
        throw data["message"];
      }
      for (var v in data){
        tempList.add(v);
      }
      return tempList;
    }catch(error){
      log("An error occured $error");
      throw error.toString();
    }
  }

  static Future<List<ProductsModel>> getALlProducts({required String? limit}) async{
    List temp = await getData(target: "products", limit: limit);
    return ProductsModel.productsFromSnapshot(temp);
  }

  static Future<List<CategoriesModel>> getALlCategories() async{
    List temp = await getData(target: "categories");
    return CategoriesModel.categoriesFromSnapshot(temp);
  }

  static Future<List<UsersModel>> getALlUsers() async{
    List temp = await getData(target: "users");
    return UsersModel.usersFromSnapshot(temp);
  }

  static Future<ProductsModel> getProductsById({required String id}) async{
    try{
      var uri = Uri.https(BASE_URL, "api/v1/products/$id");
      var response = await http.get(uri);

      //print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);

      if(response.statusCode !=200){
        throw data["message"];
      }

      return ProductsModel.fromJson(data);
    }catch(error) {
      log("error occured while getting product info $error");
      throw error.toString();
    }
  }
}