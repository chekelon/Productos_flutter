import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation_app/src/bloc/provider.dart';
import 'package:formvalidation_app/src/models/producto_model.dart';
//import 'package:formvalidation_app/src/providers/producto_provider.dart';
import 'package:formvalidation_app/src/utils/utlis.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  File? foto;

  ProductosBloc? productosBloc;
  ProductoModel producto = new ProductoModel();
  //final productoProvider = new ProductosProvider();

  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final prodData = ModalRoute.of(context)?.settings.arguments;
    if (prodData != null) {
      producto = prodData as ProductoModel;
      print(producto.fotoUrl);
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text('Producto'),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del Producto.';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.deepPurple;
        }),
      ),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      autofocus: true,
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc!.subirFoto(foto!);
    }

    if (producto.id == null) {
      productosBloc!.agregarProducto(producto);
    } else {
      productosBloc!.editarProducto(producto);
    }
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('Registro guardado');
    Navigator.pushNamed(context, 'home').then((value) => setState(() => {}));
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        activeColor: Colors.deepPurple,
        title: Text('Disponible'),
        onChanged: (value) {
          setState(() {
            producto.disponible = value;
          });
        });
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(producto.fotoUrl!),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.cover);
    } else {
      if (foto != null) {
        producto.fotoUrl = null;
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    procesarImagen(ImageSource.gallery);
  }

  void _tomarFoto() async {
    procesarImagen(ImageSource.camera);
  }

  procesarImagen(ImageSource tipo) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: tipo,
    );
    try {
      foto = File(pickedFile!.path);
    } catch (e) {
      print('$e');
    }

    if (foto != null) {
      producto.fotoUrl = null;
    }
    setState(() {});
  }
}
