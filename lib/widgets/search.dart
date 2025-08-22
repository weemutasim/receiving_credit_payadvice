import 'package:flutter/material.dart';
import '../font/appColor.dart';
import '../font/appFonts.dart';

class Search extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;
  final String title;

  const Search({super.key, required this.searchController, required this.onChanged, required this.title});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width * .15,
      height: height * .05,
      child: TextField(
        controller: widget.searchController,
        onChanged: (value) => setState(() => widget.onChanged(value)),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: widget.title,
          suffixIcon: Icon(Icons.search_rounded, color: AppColors.darkPink),
          /* suffixIcon: widget.searchController.text.isEmpty ? null : IconButton(
            onPressed: () {
              widget.searchController.clear();
              widget.onSubmitted('');
            },
            icon: Icon(Icons.close_rounded, color: AppColors.black),
          ), */
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          labelStyle: TextStyle(fontFamily: AppFonts.pgVim, color: AppColors.black, fontSize: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 136,14,79), width: 2.0),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}


//
