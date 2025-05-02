import 'package:clothstore_admin_pannel/backend/controller/productsController.dart';
import 'package:clothstore_admin_pannel/backend/provider/productProvider.dart';
import 'package:clothstore_admin_pannel/model/productModel.dart';
import 'package:clothstore_admin_pannel/views/product/addEditProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = "/ProductsScreen";

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductProvider productProvider = ProductProvider();
  final _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      productProvider = Provider.of<ProductProvider>(context, listen: false);
      // Call this to load the initial data
      await ProductController().getProductFromFirebase(productProvider);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !productProvider.isLoading && productProvider.hashMore) {
        ProductController().getProductFromFirebase(productProvider);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("productPRovider list length in product Screen : ${productProvider.productModelList.length}");
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: productProvider.isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              getHeader(),
              getProducts(),
            ],
          ),
          floatingActionButton: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AddEditProduct.routeName);
            },
            icon: Icon(Icons.add),
            label: Text(
              "Add Product",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget getHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Products',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: -0.5,
              color: Colors.black87, // Dark text for light background
            ),
          ),
        ],
      ),
    );
  }

  Widget getProducts() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        if (productProvider.productModelList.isEmpty && productProvider.isLoading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue[600],
              ),
            ),
          );
        }

        if (productProvider.productModelList.isEmpty) {
          return Expanded(
            child: _buildEmptyState(),
          );
        }

        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: productProvider.productModelList.length + (productProvider.hashMore ? 1 : 0),
            controller: _scrollController,
            itemBuilder: (context, int index) {
              if (index < productProvider.productModelList.length) {
                return _buildProductCard(context, productProvider.productModelList[index], productProvider);
              } else if (productProvider.hashMore) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      color: Colors.blue[600],
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[500],
          ),
          SizedBox(height: 16),
          Text(
            'No products available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product, ProductProvider productProvider) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white,
      // Light background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                _buildProductImage(product),
                SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand & Edit Button
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.brandName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Dark text
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildEditButton(context, product, productProvider),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Category
                      Text(
                        product.productCategory,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700], // Darker gray for light background
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 12),

                      // Sizes
                      _buildSizeRow(product),

                      SizedBox(height: 12),

                      // Colors
                      _buildColorRow(product),

                      SizedBox(height: 12),

                      // Price
                      Text(
                        "₹${product.productPrice}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700], // Darker green for light background
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Status toggle
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildStatusToggle(product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1), // Lighter border
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: (product.productImages.isNotEmpty)
            ? Image.network(
                product.productImages[0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  );
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200], // Light gray background
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey[600], // Darker icon for contrast
          size: 40,
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, ProductModel product, ProductProvider productProvider) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").doc(product.productId).get();
        ProductModel model = ProductModel.fromMap(query.data() as Map<String, dynamic>);
        productProvider.startEdit();
        Navigator.pushNamed(context, AddEditProduct.routeName, arguments: <String, ProductModel>{"productModel": model});
        setState(() {
          isLoading = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        minimumSize: Size(0, 36),
        elevation: 1,
      ),
      child: Text(
        "Edit",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSizeRow(ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Size: ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800], // Darker text for light background
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: product.productSize.map((size) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light gray background
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800], // Dark text
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildColorRow(ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Color: ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800], // Darker text for light background
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.productColor.length,
              itemBuilder: (context, index) {
                final colorCode = product.productColor[index];
                return Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Color(int.parse(colorCode)),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[400]!, // Lighter border
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusToggle(ProductModel product) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Very light gray background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: product.productEnabled ? Colors.green[400]! : Colors.red[400]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                product.productEnabled ? Icons.check_circle : Icons.cancel,
                color: product.productEnabled ? Colors.green[600] : Colors.red[600], // Darker for contrast
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                product.productEnabled ? "Product Enabled" : "Product Disabled",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: product.productEnabled ? Colors.green[600] : Colors.red[600], // Darker for contrast
                ),
              ),
            ],
          ),
          // Custom Switch
          GestureDetector(
            onTap: () async {
              setState(() {
                product.productEnabled = !product.productEnabled;
              });
              await FirebaseFirestore.instance.collection('products').doc(product.productId).update(
                {'productEnabled': product.productEnabled},
              );
            },
            child: Container(
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: product.productEnabled ? Colors.green[400] : Colors.red[400],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: product.productEnabled ? 24 : 0,
                    top: 2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          product.productEnabled ? Icons.check : Icons.close,
                          size: 14,
                          color: product.productEnabled ? Colors.green[600] : Colors.red[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
