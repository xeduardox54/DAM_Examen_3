import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:proyectounderway/src/models/producto_model.dart';

class ProductosProvider {
  final String _url = 'underway-105f6-default-rtdb.firebaseio.com';

  Future<bool> crearProducto(ProductModel producto) async {
    final url = Uri.https(_url, 'cargas.json');
    final resp = await http.post(url, body: productModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> cargarProductos() async {
    final url = Uri.https(_url, 'cargas.json');
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> productos = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = Uri.https(_url, 'cargas/$id.json');
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  Future<bool> editarProducto(ProductModel producto) async {
    final url = Uri.https(_url, 'cargas/${producto.id}.json');
    final resp = await http.put(url, body: productModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dq8w8ket3/image/upload?upload_preset=iadqvad6');
    final mimetype = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );
    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimetype[0], mimetype[1] )
    );
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body );
      return null;
    }
    final respData = json.decode(resp.body);
    print( respData);
    return respData['secure_url'];
  }
  
}
