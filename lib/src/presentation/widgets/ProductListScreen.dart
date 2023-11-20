// ignore_for_file: must_call_super

import 'package:fakestore/src/data/datasources/ProductRemoteDataSource.dart';
import 'package:fakestore/src/data/repositories/ProductRepositoryImpl.dart';
import 'package:fakestore/src/domain/entities/product/Product.dart';
import 'package:fakestore/src/domain/repositories/ProductRepository/getAllProducts.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> products;
  late GetProductUserCase getProductUserCase;

  // ignore: must_call_super
  @override
  void initState() {
  
  // Crea una instancia de ProductRemoteDataSource
  var productRemoteDataSource = ProductRemoteDataSource();

  // Crea una instancia de ProductRepositoryImpl con productRemoteDataSource
  var productRepository = ProductRepositoryImpl(productRemoteDataSource);

  // Ahora utiliza productRepository para crear GetProductUserCase
  getProductUserCase = GetProductUserCase(productRepository);

  // Llama a getAll para obtener los productos
  products = getProductUserCase.getAll();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Container(
        
        child: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay productos disponibles'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: MaterialButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Text(snapshot.data![index].title),
                        Image.network(snapshot.data![index].image),
                        
                      ],
                    )
                  ),
                  subtitle: Text(snapshot.data![index].category),
                );
              },
            );
          },
        ),
      ),
    );
  }
}