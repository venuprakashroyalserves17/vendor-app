import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor_app/providers/auth_provider.dart';
import 'package:grocery_vendor_app/screens/home_screen.dart';
import 'package:provider/provider.dart';


class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cPasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _dialogTextController = TextEditingController();
  String email;
  String password;
  String shopName;
  String mobile;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);//need file path to upload, we already have inside provider

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('uploads/shopProfilePic/${_nameTextController.text}').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    //now after upload file we need to file url path to save in database
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameTextController.text}').getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message){
      return ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ):Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Shop Name';
                }
                setState(() {
                  _nameTextController.text=value;
                });
                setState(() {
                  shopName=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_business),
                labelText: 'Business Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 10, //depends on the country where u use the app
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+91',
                prefixIcon: Icon(Icons.phone_android),
                labelText: 'Mobile Number',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Email';
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'Invalid Email Format';
                }
                setState(() {
                  email=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Password';
                }
                if(value.length<6){
                  return 'Minimum 6 characters';
                }
                setState(() {
                  password=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Confirm Password';
                }
                if(value.length<6){
                  return 'Minimum 6 characters';
                }
                if(_passwordTextController.text != _cPasswordTextController.text){
                  return 'Password doesn\'t match';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'Confirm Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addressTextController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please press Navigation Button';
                }
                if(_authData.shopLatitude==null){
                  return 'Please press Navigation Button';
                }

                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                labelText: 'Business Location',
                suffixIcon: IconButton(icon: Icon(Icons.location_searching),onPressed: (){
                  _addressTextController.text='Locating...\n Please wait...';
                  _authData.getCurrentAddress().then((address){
                    if(address!=null){
                      setState(() {
                        _addressTextController.text='${_authData.placeName}\n${_authData.shopAddress}';
                      });
                    }else{
                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('Could not find location.. Try gain')));
                    }
                  });
                },),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogTextController.text=value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                labelText: 'Shop Dialog',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme
                        .of(context)
                        .primaryColor
                    )
                ),
                focusColor: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if(_authData.isPicAvail==true){ //first will validate profile picture
                      if (_formKey.currentState.validate()) {//then will validate forms
                        setState(() {
                          _isLoading=true;
                        });
                        _authData.registerVendor(email, password).then((credential){
                          if(credential.user.uid!=null){
                            //user registered
                            //now ill upload profile pic to fire storage
                            uploadFile(_authData.image.path).then((url){
                              if(url!=null){
                                //save vendor details to database.
                                _authData.saveVendorDataToDb(
                                  url: url,
                                  mobile: mobile,
                                  shopName: shopName,
                                  dialog: _dialogTextController.text,
                                );
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                                //after finish all the process will navigate to Home Screen
                              }else{
                                scaffoldMessage('Failed to upload Shop Profile Pic');
                              }

                            });
                          }else{
                            //register failed
                            scaffoldMessage(_authData.error);
                          }

                        });

                      }
                    }else{
                      scaffoldMessage('Shop profile pic need to be added');
                    }

                  },
                  child: Text(
                    'Register', style: TextStyle(color: Colors.white,),),
                ),
              ),
            ],
          )
        ],
      ),

    );
  }
}

//next video will do login with registered email and forgot password