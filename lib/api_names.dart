import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, String>> fetchRandomName() async {
  final response = await http.get(Uri.parse('https://randomuser.me/api/'));


  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final name = data['results'][0]['name']['first'];
    final lastName = data['results'][0]['name']['last'];
    final pictureUrl = data['results'][0]['picture']['large'];

    return {'firstName': name, 'lastName': lastName, 'pictureUrl': pictureUrl};
  }else {
    return throw Exception('Failed to load name');
  }
}

class RandomGenerator extends StatefulWidget {
  const RandomGenerator({super.key});

  @override
  State<RandomGenerator> createState() => _RandomGeneratorState();
}

class _RandomGeneratorState extends State<RandomGenerator> {

  String firstName = '';

  String lastName = '';

  String pictureUrl = '';

  bool isLoading = false;

  Future<void> _getName() async {
    setState(() {
      isLoading = true;
    });

        try {
      final name = await fetchRandomName();
      setState(() {
        pictureUrl = name['pictureUrl']!;
        firstName = name['firstName']!;
        lastName = name['lastName']!;
      });
    } catch (e) {
      print('Failed to load name: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Random Person Generator'),
        centerTitle: true,
        backgroundColor: const Color(0xff153832),
        toolbarHeight: 50,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30),
        // ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/green abstract.jpeg'),
            fit: BoxFit.cover
            ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pictureUrl.isNotEmpty
                    ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(pictureUrl),
                    )
                    : const Placeholder(fallbackHeight: 300, fallbackWidth: 300,), 
                      const SizedBox(height: 20),
                    RichText(
                      text:  TextSpan(
                        children: [
                          TextSpan(
                            text: '$firstName $lastName',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black,
                            )
                          ),
                          
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _getName,
                      child: Text('Generate'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xff637373)
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}