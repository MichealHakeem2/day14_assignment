abstract class ApiConstants {
  static const String baseUrl = 'https://supermarket-dan1.onrender.com/api/v1';
  static const String fallbackBaseUrl = 'http://localhost:5000/api/v1';

  static const String signUp = '/auth/signUp';
  static const String register = '/auth/signUp';
  static const String signIn = '/auth/signIn';
  static const String login = '/auth/signIn';
  static const String resetPassCode = '/auth/resetPassCode';
  static const String activeResetPass = '/auth/activeResetPass';
  static const String resetPassword = '/auth/resetPassword';

  static const String products = '/home/products';
  static const String productsFilter = '/home/productsFilter';
  static const String productCategory = '/home/products/category';
  static const String productBrand = '/home/products/brand';
  static const String categories = '/home/categories';
  static const String categoriesNames = '/home/categories/names';
  static const String brands = '/home/brands';
  static const String brandsNames = '/home/brands/names';

  static const String getCart = '/user/getCart';
  static const String addCart = '/user/addCart';
  static const String deleteCart = '/user/deleteCart';

  static const String getFavorite = '/user/getFavorite';
  static const String addFavorite = '/user/addFavorite';
  static const String deleteFavorite = '/user/deleteFavorite';

  static const String userData = '/portfoilo/userData';
  static const String addImage = '/portfoilo/addImage';
  static const String editUserData = '/portfoilo/editUserData';
}
