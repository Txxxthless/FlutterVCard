import 'package:flutter/material.dart';
import 'package:flutter_v_card/pages/contact_details_page.dart';
import 'package:flutter_v_card/pages/scan_page.dart';
import 'package:flutter_v_card/providers/contact_provider.dart';
import 'package:flutter_v_card/utils/helper_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact List',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            _fetchData();
          },
          backgroundColor: Colors.blue[100],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                alignment: FractionalOffset.centerRight,
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: _showConfirmDialog,
              onDismissed: (_) async {
                await provider.deleteContact(contact.id);
                showMsg(context, 'Deleted');
              },
              child: ListTile(
                  title: Text(contact.name),
                  trailing: IconButton(
                    onPressed: () {
                      provider.updateFavorite(contact);
                    },
                    icon: Icon(contact.favorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                  ),
                  onTap: () {
                    context.goNamed(
                      ContactDetailsPage.routeName,
                      extra: contact.id,
                    );
                  }),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(DismissDirection direction) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          OutlinedButton(
            onPressed: () {
              context.pop(false);
            },
            child: const Text('NO'),
          ),
          OutlinedButton(
            onPressed: () {
              context.pop(true);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }

  void _fetchData() {
    if (selectedIndex == 0) {
      Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    } else if (selectedIndex == 1) {
      Provider.of<ContactProvider>(context, listen: false)
          .getAllFavoriteContacts();
    }
  }
}
