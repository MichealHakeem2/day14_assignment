import 'package:http/http.dart' as http;
import 'package:shopping_app/features/home/data/models/product_model.dart';

class HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<ProductModel>> getProducts() async {
    try {
      return [
        ProductModel(
          id: 1,
          title: 'Black Casual T-Shirt',
          price: 150.0,
          image: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500',
          description: 'Premium cotton regular fit black t-shirt',
        ),
        ProductModel(
          id: 2,
          title: 'Orange Summer T-Shirt',
          price: 160.0,
          image: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
          description: 'Vibrant orange summer collection cotton tee',
        ),
        ProductModel(
          id: 3,
          title: 'White Classic T-Shirt',
          price: 180.0,
          image: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=500',
          description: 'Essential clean white minimalist t-shirt',
        ),
        ProductModel(
          id: 4,
          title: 'Mauve Lavender T-Shirt',
          price: 190.0,
          image: 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=500',
          description: 'Soft lavender comfortable crewneck tee',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load products from server');
    }
  }
}
