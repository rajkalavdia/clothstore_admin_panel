import 'dart:math';

import 'package:clothstore_admin_pannel/backend/provider/userProvider.dart';
import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:clothstore_admin_pannel/views/user/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/productModel.dart';
import '../../model/user/ordersModel.dart';

class UserDetailsScreen extends StatefulWidget {
  static const String routeName = "/UserDetailsScreen";

  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  UserProvider userProvider = UserProvider();
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              getHeader(),
              getUserDetailWidget(),
              getUserFavouritesProducts(),
              getOrdersList(),
            ],
          ),
        ),
      ),
    );
  }

  // Improved header with better spacing and accessibility
  Widget getHeader() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 22,
        ),
        tooltip: 'Back',
      ),
      title: const Text(
        'User Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

// Completely redesigned user details widget with better organization
  Widget getUserDetailWidget() {
    final userDetailsArgs = ModalRoute.of(context)!.settings.arguments as Map<String, UserModel>;
    final user = userDetailsArgs["userModel"];

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    var formatter = DateFormat("dd MMM yyyy, hh:mm a");
    final createdAtFormatted = formatter.format(user.createdAt);
    final lastLoginFormatted = formatter.format(user.lastLogin);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User ID Card
            _buildIdCard(user.uid),

            const SizedBox(height: 24),

            // Profile Section
            _buildProfileSection(user),

            const SizedBox(height: 24),

            // Account Details Section
            _buildSectionTitle("Account Details"),
            _buildInfoItem("Sign Up Method", user.signInMethod.toUpperCase()),
            _buildInfoItem("Created At", createdAtFormatted),
            _buildInfoItem("Last Login", lastLoginFormatted),

            // Additional sections can be added here
          ],
        ),
      ),
    );
  }

// Helper widget for displaying the user ID at the top
  Widget _buildIdCard(String userId) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          children: [
            const Text(
              "User ID",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              userId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper widget for displaying the user profile information
  Widget _buildProfileSection(UserModel user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Profile"),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User image with error handling
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    user.imageUrl,
                    height: 120,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // User information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem("Name", user.name),
                      const SizedBox(height: 12),
                      _buildInfoItem("Phone", user.phoneNumber),
                      const SizedBox(height: 12),
                      _buildInfoItem("Email", user.email),
                      if (user.signInMethod == "email") ...[
                        const SizedBox(height: 12),
                        _buildInfoItem("Password", user.password, isPassword: true),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

// Helper widget for individual info items
  Widget _buildInfoItem(String label, String value, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        isPassword
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      showPassword ? value : '*' * value.length,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, size: 20),
                    onPressed: () {
                      showPassword = !showPassword;
                      setState(() {});
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    splashRadius: 24,
                  ),
                ],
              )
            : SelectableText(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }

  Widget getUserFavouritesProducts() {
    // Early return if no favorites
    if (userProvider.userFavouritesProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and See All button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Favorite Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add navigation to all favorites screen
                },
                child: const Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Favorites product cards in horizontal list
        SizedBox(
          height: 320,
          child: ListView.builder(
            itemCount: min(userProvider.userFavouritesProducts.length, 3),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemBuilder: (context, index) {
              final product = userProvider.userFavouritesProducts[index];
              return ProductCard(product: product);
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Divider(height: 1, thickness: 1),
        ),
      ],
    );
  }

  Widget getOrdersList() {
    // Early return if no orders
    if (userProvider.userOrderList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and see all button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Orders",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add navigation to all orders screen
                },
                child: const Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Order cards in horizontal list
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: min(userProvider.userOrderList.length, 3),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemBuilder: (context, index) {
              final order = userProvider.userOrderList[index];
              return OrderCard(order: order);
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Divider(height: 1, thickness: 1),
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrdersModel order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetails.routeName);
      },
      child: Container(
        // width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoRow(
              label: "Order ID - ",
              value: order.orderId,
              context: context,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: "Items - ",
              value: "${order.itemsCount}",
              context: context,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: "Amount - ",
              value: "₹${order.orderAmount.toInt()}",
              context: context,
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required BuildContext context,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
            fontSize: isHighlighted ? 18 : 16,
            color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: _buildProductImage(product),
              ),
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand name
                Text(
                  product.brandName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Category
                Text(
                  product.productCategory,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Size options
                _buildSizeRow(context, product),

                const SizedBox(height: 6),

                // Color options
                _buildColorRow(context, product),

                const SizedBox(height: 8),

                // Price
                Text(
                  "₹${product.productPrice}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    if (product.productImages.isNotEmpty) {
      return Image.network(
        product.productImages[0],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          );
        },
      );
    } else {
      return _buildImagePlaceholder();
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[700],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildSizeRow(BuildContext context, ProductModel product) {
    return Row(
      children: [
        Text(
          "Size:",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            product.productSize.join(", "),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildColorRow(BuildContext context, ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Color:",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: SizedBox(
            height: 24,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: min(product.productColor.length, 5), // Limit to 5 colors to avoid overflow
              itemBuilder: (context, index) {
                final color = product.productColor[index];
                return Container(
                  height: 24,
                  width: 24,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Color(int.parse(color)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
