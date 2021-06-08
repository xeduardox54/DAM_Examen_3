import 'package:flutter/material.dart';
import 'package:proyectounderway/src/models/producto_model.dart';
import 'package:proyectounderway/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Color(0xff003FFF),
      onPressed: () => Navigator.pushNamed(context, 'producto')
          .then((value) => setState(() {})),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
        future: productosProvider.cargarProductos(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) => _crearItem(context, productos[i]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, ProductModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          productosProvider.borrarProducto(producto.id);
        },
        child: Card(
            child: Column(
          children: [
            (producto.carga == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(producto.carga),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover),
            ListTile(
              title: Text('${producto.nombrecarga} - ${producto.precio}'),
              subtitle: Text(
                  '${producto.ubicacionInicio} - ${producto.ubicacionDestino}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: producto)
                      .then((value) => setState(() {})),
            ),
          ],
        )));
  }
}
