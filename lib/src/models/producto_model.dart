import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    ProductModel({
        this.id,
        this.foto,
        this.carga,
        this.nombrecarga = '',
        this.ubicacionInicio = '',
        this.ubicacionDestino = '',
        this.precio = 0.0,
        this.disponible = true,
        this.descripcionPedido,
    });

    String id;
    String foto;
    String carga;
    String nombrecarga;
    String ubicacionInicio;
    String ubicacionDestino;
    double precio;
    bool disponible;
    String descripcionPedido;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        foto: json["foto"],
        carga: json["carga"],
        nombrecarga: json["nombrecarga"],
        ubicacionInicio: json["ubicacionInicio"],
        ubicacionDestino: json["ubicacionDestino"],
        precio: json["precio"],
        disponible: json["disponible"],
        descripcionPedido: json["descripcionPedido"],
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "foto": foto,
        "carga": carga,
        "nombrecarga": nombrecarga,
        "ubicacionInicio": ubicacionInicio,
        "ubicacionDestino": ubicacionDestino,
        "precio": precio,
        "disponible": disponible,
        "descripcionPedido": descripcionPedido,
    };
}
