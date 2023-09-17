import 'package:flutter/material.dart';

class IngredientInput extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController amountController;

  IngredientInput({
    required this.nameController,
    required this.amountController,
  });

  @override
  _IngredientInputState createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: widget.nameController,
            decoration: InputDecoration(
              hintText: "Ingredient Name",
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: widget.amountController,
            decoration: InputDecoration(
              hintText: "Amount",
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        // IconButton(
        //   icon: Icon(Icons.delete),
        //   onPressed: () {
        //     // Remove this IngredientInput widget from the parent list
        //     setState(() {
        //       ingredients.remove(this);
        //     });
        //   },
        // ),
      ],
    );
  }
}
