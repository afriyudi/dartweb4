// contoh program static handler
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path/path.dart' as path;
import 'dart:io' as io;


void main() async {
  var pathToBuild = path.join(path.dirname(io.Platform.script.toFilePath()));
  var x=pathToBuild.split("\\");
  var p=x.length-1;
  var hasil='${x.sublist(0,p).join("\\")}\\www\\html';

  print(pathToBuild);
  final staticHandler0 = shelf_static.createStaticHandler('$hasil\\program',
      defaultDocument: 'menuutama.html');

    final staticHandler1 = Pipeline().addHandler(
        shelf_static.createStaticHandler('$hasil\\program', defaultDocument: 'about.html'));

    final staticHandler2 = Pipeline().addHandler(
        shelf_static.createStaticHandler('$hasil\\program', defaultDocument: 'dashboard.html'));

    final staticHandler3 = Pipeline().addHandler(
        shelf_static.createStaticHandler('$hasil\\program', defaultDocument: 'daftarbuku.html'));


   var router = Router()
       ..mount("/about",staticHandler1)
       ..mount("/dashboard",staticHandler2)
       ..mount("/db",staticHandler3)
       ..mount('/images_file/',shelf_static.createStaticHandler('$hasil\\images'))
       ..mount("/",staticHandler0);

   final handler = Cascade().add(router).handler;

   final pipeline=const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(handler);

  final io.HttpServer server = await shelf_io.serve(pipeline, io.InternetAddress.anyIPv4, 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
