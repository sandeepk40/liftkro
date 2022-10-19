import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:haggle/forms/forms_screen.dart';
import 'package:haggle/forms/seller_Tshirt_form.dart';
import 'package:haggle/forms/seller_jeans_form.dart';
import 'package:haggle/forms/seller_shirt_form.dart';
import 'package:haggle/forms/seller_tracsho_form.dart';
import 'package:haggle/forms/seller_trousers_form.dart';
import 'package:haggle/forms/user_review_screen.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/provider/product_provider.dart';
import 'package:haggle/screens/account_form.dart';
import 'package:haggle/screens/account_screen.dart';
import 'package:haggle/screens/authentication/email_auth_screen.dart';
import 'package:haggle/screens/authentication/email_verification_screen.dart';
import 'package:haggle/screens/authentication/phoneauth_screen.dart';
import 'package:haggle/screens/authentication/reset_password_screen.dart';
import 'package:haggle/screens/categories/category_list.dart';
import 'package:haggle/screens/categories/subCat_screen.dart';
import 'package:haggle/screens/chat/chat_screen.dart';
import 'package:haggle/screens/editproduct.dart';
import 'package:haggle/screens/bookmarks.dart';
import 'package:haggle/screens/home_screen.dart';
import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/login_screen.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/screens/main_screen_retailer.dart';
import 'package:haggle/screens/product_details_screen.dart';
import 'package:haggle/screens/sellItems/product_by_category_screen.dart';
import 'package:haggle/screens/sellItems/product_by_sub_category_screen.dart';
import 'package:haggle/screens/sellItems/seller_category_list.dart';
import 'package:haggle/screens/sellItems/seller_sub_cat.dart';
import 'package:haggle/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => CategoryProvider(),
        ),
        Provider(
          create: (_) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(238, 242, 246, 170),
        //FontFamily
      ),
      initialRoute: SplashScreen.id,
      routes: {
        //screens for navigation
        LoginScreen.id: (context) => const LoginScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        PhoneAuthScreen.id: (context) => const PhoneAuthScreen(),
        LocationScreen.id: (context) => const LocationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        EmailAuthScreen.id: (context) => const EmailAuthScreen(),
        EmailVerificationScreen.id: (context) =>
            const EmailVerificationScreen(),
        PasswordResetScreen.id: (context) => const PasswordResetScreen(),
        CategoryListScreen.id: (context) => const CategoryListScreen(),
        SubCatList.id: (context) => const SubCatList(),
        MainScreen.id: (context) => const MainScreen(),
        SellerCategory.id: (context) => const SellerCategory(),
        SellerSubCatList.id: (context) => const SellerSubCatList(),
        SellerJeansForm.id: (context) => const SellerJeansForm(),
        UserReviewScreen.id: (context) => const UserReviewScreen(),
        FormsScreen.id: (context) => const FormsScreen(),
        SellerShirtForm.id: (context) => const SellerShirtForm(),
        SellerTshirtForm.id: (context) => const SellerTshirtForm(),
        SellerTrousersForm.id: (context) => const SellerTrousersForm(),
        SellerTrackshoForm.id: (context) => const SellerTrackshoForm(),
        ProductDetailsScreen.id: (context) =>  ProductDetailsScreen(),
        ProductByCategory.id: (context) => const ProductByCategory(),
        ProductBySubCategory.id: (context) => const ProductBySubCategory(),
        EditProductDetails.id: (context) =>  EditProductDetails(),
        MainScreenRetailer.id: (context) => const MainScreenRetailer(),
        Chatscreen.id: (context) => const Chatscreen(),
        BookMarks.id: (context) => const BookMarks(),
        AccountForm.id: (context) => const AccountForm(),
        AccountScreen.id: (context) => const AccountScreen(),
      },
    );
  }
}
