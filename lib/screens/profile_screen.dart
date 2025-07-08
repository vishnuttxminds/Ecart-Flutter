import 'package:e_cart_flutter/utils/string.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              child: Column(children: [
                Container(
                  height: 130,
                  width: 130,
                  decoration: const BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.amber, width: 1),
                    ),
                    shape: BoxShape.circle,
                    color: Colors.cyan,
                    image: DecorationImage(
                      image: AssetImage('assets/images/sunil.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Sunil Chhetri',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'sunil@gmail.com',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                const Text(
                  '+91 9876543210',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.amber,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    print('Wishlist Tapped');
                    Navigator.pushNamed(context, '/favorites', arguments: 1);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Wishlist',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.favorite_border,
                            color: Colors.redAccent, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    SnackBar snackBar = const SnackBar(
                      content: Text(AppStrings.signOutSuccess),
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          AppStrings.signOut,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.exit_to_app,
                            color: Colors.redAccent, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
