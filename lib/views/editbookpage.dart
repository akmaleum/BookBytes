import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../shared/myserverconfig.dart';

class EditBookPage extends StatefulWidget {
  final Book book;
  final User user;

  const EditBookPage({super.key, required this.book, required this.user});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late double screenWidth, screenHeight;

  File? _image;
  String dropdownvalue = 'New';
  var types = [
    'New',
    'Used',
    'Digital',
  ];

  TextEditingController isbnCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController authCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController qtyCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isbnCtrl.text = widget.book.bookIsbn.toString();
    titleCtrl.text = widget.book.bookTitle.toString();
    descCtrl.text = widget.book.bookDesc.toString();
    authCtrl.text = widget.book.bookAuthor.toString();
    priceCtrl.text = widget.book.bookPrice.toString();
    qtyCtrl.text = widget.book.bookQty.toString();
    dropdownvalue = widget.book.bookStatus.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: GestureDetector(
                      onTap: () {
                        showSelectionDialog();
                      },
                      child: Container(
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: _image == null
                                    ? NetworkImage(
                                        "${MyServerConfig.server}/bookbytes/assets/books/${widget.book.bookId}.png")
                                    : FileImage(_image!) as ImageProvider)),
                      ),
                    ),
                  ),
                  const Text(
                    "Edit Book",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length != 17)
                          ? "ISBN must be 17"
                          : null,
                      onFieldSubmitted: (v) {},
                      controller: isbnCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'ISBN',
                          labelStyle: const TextStyle(),
                          icon: const Icon(
                            Icons.numbers,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.camera)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Book title must be longer than 3"
                          : null,
                      onFieldSubmitted: (v) {},
                      controller: titleCtrl,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Book Title',
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.book,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Book description must be longer than 10"
                          : null,
                      onFieldSubmitted: (v) {},
                      maxLines: 4,
                      controller: descCtrl,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Book Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.description,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Book author must be longer than 3"
                          : null,
                      onFieldSubmitted: (v) {},
                      controller: authCtrl,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Book Author',
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.person_2,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                  Row(
                    children: [
                      Flexible(
                          flex: 3,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Book price must contain value"
                                      : null,
                              onFieldSubmitted: (v) {},
                              controller: priceCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Book Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                      Flexible(
                          flex: 3,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || !(int.parse(val) > 0)
                                      ? "Product price must contain value"
                                      : null,
                              onFieldSubmitted: (v) {},
                              controller: qtyCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.add_box),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )))),
                      Flexible(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.new_label, color: Colors.grey),
                              Container(
                                  margin: const EdgeInsets.all(8),
                                  height: 50,
                                  width: screenWidth * 0.2,
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: DropdownButton(
                                    value: dropdownvalue,
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: types.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      dropdownvalue = newValue!;

                                      setState(() {});
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth, 40)),
                    child: const Text('Update Book'),
                    onPressed: () {
                      updateBookDialog();
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      cropImage();
    } else {}
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        //CropAspectRatioPreset.square,
        //CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Please Crop Your Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }

  void updateBookDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in form!!!"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update this book",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateBook();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  void updateBook() {
    String isbn = isbnCtrl.text;
    String title = titleCtrl.text;
    String desc = descCtrl.text;
    String author = authCtrl.text;
    String price = priceCtrl.text;
    String qty = qtyCtrl.text;
    String imagestr;

    if (_image != null) {
      imagestr = base64Encode(_image!.readAsBytesSync());
    } else {
      imagestr = "NA";
    }

    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/update_book.php"),
        body: {
          "bookid": widget.book.bookId,
          "userid": widget.user.userid.toString(),
          "isbn": isbn,
          "title": title,
          "desc": desc,
          "author": author,
          "price": price,
          "qty": qty,
          "status": dropdownvalue,
          "image": imagestr
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
