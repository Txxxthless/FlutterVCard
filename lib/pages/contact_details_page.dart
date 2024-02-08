import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_v_card/models/contact_model.dart';
import 'package:flutter_v_card/providers/contact_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactDetailsPage extends StatefulWidget {
  final int id;
  static const String routeName = 'details';
  const ContactDetailsPage({super.key, required this.id});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late int id;

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getContactById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Image.file(
                    File(contact.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(contact.mobile),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        onPressed: () {
                          callContact(contact.mobile);
                        },
                        icon: const Icon(Icons.call),
                      ),
                      IconButton(
                        onPressed: () {
                          smsContact(contact.mobile);
                        },
                        icon: const Icon(Icons.sms),
                      ),
                    ]),
                  ),
                  ListTile(
                    title: Text(contact.address),
                    trailing: IconButton(
                      onPressed: () {
                        openMap(contact.address);
                      },
                      icon: const Icon(Icons.map),
                    ),
                  ),
                  ListTile(
                    title: Text(contact.email),
                    trailing: IconButton(
                      onPressed: () {
                        mailContact(contact.email);
                      },
                      icon: const Icon(Icons.mail),
                    ),
                  ),
                  ListTile(
                    title: Text(contact.website),
                    trailing: IconButton(
                      onPressed: () {
                        openWebsite(contact.website);
                      },
                      icon: const Icon(Icons.open_in_browser),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            return const Center(
              child: Text('Loading...'),
            );
          },
        ),
      ),
    );
  }

  void callContact(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void mailContact(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void openMap(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'https://maps/apple.com/?q=$address';
    }

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void openWebsite(String website) async {
    final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }
}
