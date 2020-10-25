import 'package:FStall/models/food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFoodModal extends StatefulWidget {
  @override
  _AddFoodModalState createState() => _AddFoodModalState();
}

class _AddFoodModalState extends State<AddFoodModal> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _addedFood =
      FoodItem(description: null, imageUrl: '', price: 0, title: null);

  CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('food');

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return null;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    await foodCollection.add({
      'title': _addedFood.title,
      'price': _addedFood.price,
      'imageUrl': _addedFood.imageUrl,
      'description': _addedFood.description,
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _form,
                child: Container(
                  height: 300,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _addedFood.title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          setState(() {
                            _addedFood = FoodItem(
                              description: _addedFood.description,
                              imageUrl: _addedFood.imageUrl,
                              price: _addedFood.price,
                              title: value,
                            );
                          });
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Please provide a title' : null,
                      ),
                      TextFormField(
                        initialValue: _addedFood.price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          setState(() {
                            _addedFood = FoodItem(
                              description: _addedFood.description,
                              imageUrl: _addedFood.imageUrl,
                              price: double.parse(value),
                              title: _addedFood.title,
                            );
                          });
                        },
                        validator: (value) => (double.parse(value) < 0)
                            ? 'Please provide a positive number.'
                            : null,
                      ),
                      TextFormField(
                        initialValue: _addedFood.description,
                        decoration: InputDecoration(
                          labelText: 'ImageURL',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.url,
                        onSaved: (value) {
                          setState(() {
                            _addedFood = FoodItem(
                              description: _addedFood.description,
                              imageUrl: value,
                              price: _addedFood.price,
                              title: _addedFood.title,
                            );
                          });
                        },
                        validator: (value) => !value.contains('/')
                            ? 'Please check the url.'
                            : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          setState(() {
                            _addedFood = FoodItem(
                              description: value,
                              imageUrl: _addedFood.imageUrl,
                              price: _addedFood.price,
                              title: _addedFood.title,
                            );
                          });
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Please add a description.' : null,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: _saveForm,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Confirm',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
