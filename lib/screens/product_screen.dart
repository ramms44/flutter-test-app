// class produk screen

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test_app/model/product.dart';

// fetch produk
Future<Produk> fetchProduk() async {
  final response = await http.get(
    Uri.parse('https://dummyjson.com/products?limit=10&skip=10'),
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Produk.fromJson(
      jsonDecode(response.body),
    );
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<Produk> futureProduk;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    futureProduk = fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 22, 27, 60),
        toolbarHeight: 70,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Halaman Produk'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        height: 1200,
        margin: const EdgeInsets.only(top: 30),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                FutureBuilder<Produk>(
                  future: futureProduk,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), //<--here
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  mainAxisExtent: 300,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: isLoad == false
                              ? 4
                              : snapshot.data!.products.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 350,
                                      height: 100,
                                      child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image.network(
                                              snapshot.data!.products[index]
                                                  .images[3],
                                              height: 150.0,
                                              width: 350.0,
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        snapshot.data!.products[index].title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5, left: 15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Harga : ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.products[index].price
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Diskon : ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              Text(
                                                (snapshot.data!.products[index]
                                                            .discountPercentage).toString() + ' %',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                           SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Harga Disk : ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                              Text(
                                                (snapshot.data!.products[index]
                                                            .price - (snapshot.data!.products[index]
                                                            .price * (snapshot.data!.products[index]
                                                            .discountPercentage))/ 100).round().toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite,
                                                    color: Colors.white,
                                                    size: 24.0,
                                                    semanticLabel: 'Heart',
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 24.0,
                                                    semanticLabel: 'Rating',
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.white,
                                                    size: 24.0,
                                                    semanticLabel: 'Diskon',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 22, 27, 60),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                Visibility(
                  visible: isLoad == false ? true : false,
                  child: Column(
                    children: [
                      Visibility(
                        visible: isLoad == false ? false : true,
                        child: CircularProgressIndicator(),
                      ),
                      Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GestureDetector(
                              child: Text(
                                'Load more',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                fetchProduk();
                                print('load more');
                                setState(() {
                                  isLoad = !isLoad;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
