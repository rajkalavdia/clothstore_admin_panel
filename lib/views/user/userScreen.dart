import 'package:clothstore_admin_pannel/backend/controller/userController.dart';
import 'package:clothstore_admin_pannel/backend/provider/userProvider.dart';
import 'package:clothstore_admin_pannel/model/user/userModel.dart';
import 'package:clothstore_admin_pannel/views/user/userDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  static const String routeName = "/UserScreen";

  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserProvider userProvider = UserProvider();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userProvider = context.read<UserProvider>();
      userProvider.usersList.clear();
      await UserController().getUserFromFirebase(userProvider: userProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: Center(
          child: CircularProgressIndicator(),
        ),
        child: Scaffold(
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader(),
            getUserWidget(),
          ],
        )),
      ),
    );
  }

  Widget getHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        'Users',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget getUserWidget() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.usersList.isEmpty && userProvider.isLoading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Expanded(
          child: userProvider.usersList.isEmpty ? _buildEmptyState() : _buildUserList(userProvider),
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
            Icons.people_outline,
            size: 64,
            color: Colors.grey[700],
          ),
          SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(UserProvider userProvider) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: userProvider.usersList.length,
      itemBuilder: (context, int index) {
        final user = userProvider.usersList[index];
        return _buildUserCard(context, user, userProvider, index);
      },
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user, UserProvider userProvider, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          await UserController().getFavouritesProducts(userProvider: userProvider, index: index);
          await UserController().getOrdersList(userProvider: userProvider, index: index);
          Navigator.pushNamed(context, UserDetailsScreen.routeName, arguments: <String, UserModel>{"userModel": user});
          setState(() {
            isLoading = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUserAvatar(user),
              SizedBox(width: 16),
              Expanded(
                child: _buildUserInfo(user),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(UserModel user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          user.imageUrl,
          height: 64,
          width: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 64,
              width: 64,
              color: Colors.grey[800],
              child: Icon(
                Icons.person,
                size: 32,
                color: Colors.grey[600],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 64,
              width: 64,
              color: Colors.grey[800],
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4),
        _buildInfoRow(Icons.phone, user.phoneNumber),
        SizedBox(height: 4),
        _buildInfoRow(Icons.email, user.email),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[500],
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
