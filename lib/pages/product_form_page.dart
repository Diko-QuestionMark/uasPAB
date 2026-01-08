import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  ProductFormPage({this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name;
  late TextEditingController _desc;
  late TextEditingController _price;
  late TextEditingController _image;
  late TextEditingController _longDesc;

  String _imagePreview = '';

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?.name ?? '');
    _desc = TextEditingController(text: widget.product?.description ?? '');
    _longDesc = TextEditingController(
      text: widget.product?.longDescription ?? '',
    );

    _price = TextEditingController(
      text: widget.product == null
          ? ''
          : widget.product!.price % 1 == 0
          ? widget.product!.price.toInt().toString()
          : widget.product!.price.toString(),
    );
    _image = TextEditingController(text: widget.product?.image ?? '');
    _imagePreview = widget.product?.image ?? '';
    _image.addListener(() {
      setState(() {
        _imagePreview = _image.text;
      });
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    if (widget.product == null) {
      await ApiService.addProduct(
        name: _name.text,
        description: _desc.text,
        longDescription: _longDesc.text,
        price: double.parse(_price.text),
        image: _image.text,
      );
    } else {
      await ApiService.updateProduct(
        id: widget.product!.id,
        name: _name.text,
        description: _desc.text,
        longDescription: _longDesc.text,
        price: double.parse(_price.text),
        image: _image.text,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah Menu' : 'Edit Menu'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field(_name, 'Nama Menu'),
              _field(_desc, 'Deskripsi'),
              _field(_longDesc, 'Deskripsi Panjang', TextInputType.multiline),
              _field(
                _price,
                'Harga',
                TextInputType.numberWithOptions(decimal: false),
              ),

              _field(_image, 'URL Gambar'),

              SizedBox(height: 12),

              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePreview.isEmpty
                    ? Center(child: Text('Preview gambar'))
                    : Image.network(
                        _imagePreview,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Center(child: Text('Gambar tidak valid')),
                      ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, [
    TextInputType type = TextInputType.text,
  ]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
