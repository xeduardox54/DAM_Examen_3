import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyectounderway/src/models/producto_model.dart';
import 'package:proyectounderway/src/providers/productos_provider.dart';
import 'package:proyectounderway/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final form_key = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel producto = new ProductModel();
  final productoProvider = new ProductosProvider();
  bool _guardando = false;
  File _foto;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Product Name'),
          actions: [
            IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: _tomarFoto,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                  key: form_key,
                  child: Column(
                    children: [
                      _mostrarFoto(),
                      _crearNombre(),
                      _crearDescripcion(),
                      _crearDestinoInicio(),
                      _crearDestinoFin(),
                      _crearPrecio(),
                      _crearDisponoble(),
                      _crearBoton()
                    ],
                  ))),
        ));
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.nombrecarga,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.nombrecarga = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDestinoInicio() {
    return TextFormField(
      initialValue: producto.ubicacionInicio,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Ubicación de recojo'),
      onSaved: (value) => producto.ubicacionInicio = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese la ubicacion de donde se recogerá la carga';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDestinoFin() {
    return TextFormField(
      initialValue: producto.ubicacionDestino,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Ubicación de destino'),
      onSaved: (value) => producto.ubicacionDestino = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese la ubicación a donde desea que llegue su carga';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: producto.descripcionPedido,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Descripción del producto'),
      onSaved: (value) => producto.descripcionPedido = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese una breve descripción de su producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: producto.precio.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Precio'),
        onSaved: (value) => producto.precio = double.parse(value),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Solo numero';
          }
        });
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        onPressed: (_guardando) ? null : _submit,
        icon: Icon(Icons.save),
        label: Text('Guardar'),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))));
  }

  Widget _crearDisponoble() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    if (!form_key.currentState.validate()) return;
    form_key.currentState.save();
    setState(
      () => _guardando = true,
    );
    if (_foto != null) {
      producto.carga = await productoProvider.subirImagen(_foto);
    }
    if (producto.id == null) {
      productoProvider.crearProducto(producto);
      mostrarSnackbar('Registro Creado');
      setState(
        () => _guardando = false,
      );
    } else {
      productoProvider.editarProducto(producto);
      mostrarSnackbar('Registro Actualizado');
      setState(
        () => _guardando = false,
      );
    }
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (producto.carga != null) {
      return FadeInImage(
        image: NetworkImage(producto.carga),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain
      );
    } else {
      if (_foto != null) {
        return Image.file(
          _foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  Future _seleccionarFoto() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _foto = File(pickedImage.path);
      } else {
        print('Imagen no seleccionada');
      }
    });
  }

  Future _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: origen,
      maxHeight: 720,
      maxWidth: 720,
    );

    _foto = (pickedFile != null) ? File(pickedFile.path) : _foto;
    if (_foto != null) {
      producto.carga = null;
    }
    setState(() {});
  }
}
