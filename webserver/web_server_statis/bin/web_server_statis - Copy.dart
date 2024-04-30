// contoh program static handler
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path/path.dart' as path;
import 'dart:io' as io;
import 'package:mysql1/mysql1.dart';
import 'package:os_detect/os_detect.dart' as os_detect;

Future<String> readData() async {
final conn=await MySqlConnection.connect(ConnectionSettings(
    host:'192.168.137.1',
    port:3306,
    user:'root',
    db:'programmer',
    password:'12345',
));

var hasil=StringBuffer('');
var results=await conn.query(
           'select BookName, AuthorName, Summary, Price from Books');
for(var row in results) {
  hasil.writeln('''
        <tr class="table-info">
        <td>${row[0]}</td>
        <td>${row[1]}</td>
        <td>${row[3]}</td>
         </tr>
''');
 }
 await conn.close();
 return hasil.toString();
}

String getSign()
{
var sign1='';
if(os_detect.isLinux) {
  print('  OS type : Linux');
  sign1='/';
} else if(os_detect.isMacOS) {
  print('  OS type : MacOS');
  sign1='/';
} else if(os_detect.isWindows) {
  print('  OS type : Windows');
  sign1='\\';
}
return sign1;
}

void main() async {
  var sign1=getSign();
  var pathToBuild = path.join(path.dirname(io.Platform.script.toFilePath()));
  var x=pathToBuild.split(sign1);
  var p=x.length-1;
  var hasil='${x.sublist(0,p).join(sign1)}${sign1}www${sign1}html';

  print(pathToBuild);
  final staticHandler0 = shelf_static.createStaticHandler('$hasil${sign1}program',
      defaultDocument: 'menuutama.html');

    final staticHandler1 = Pipeline().addHandler(
        shelf_static.createStaticHandler('$hasil${sign1}program', defaultDocument: 'about.html'));

    final staticHandler2 = Pipeline().addHandler(
        shelf_static.createStaticHandler('$hasil${sign1}program', defaultDocument: 'dashboard.html'));

    final staticHandler3 = Pipeline().addHandler(
        shelf_static.createStaticHandler('$hasil${sign1}program', defaultDocument: 'daftarbuku.html'));

Response _render(String body){
    return Response.ok(body, headers:{
      'Content-type':'text/html; charset=UTF-8',
    });
}
   var router = Router()
       ..mount("/about",staticHandler1)
       ..mount("/dashboard",staticHandler2)
       ..mount("/db",staticHandler3)
       ..mount('/images_file/',shelf_static.createStaticHandler('$hasil${sign1}images'))
       ..get('/dbnew',(Request request) async {
                var filenya=io.File('$hasil${sign1}template${sign1}daftarbukutemplate.tp').readAsStringSync();
                 String data=await readData();
                 return _render(filenya.replaceAll('[[content]]',data));
         })
       ..mount("/",staticHandler0);

   final handler = Cascade().add(router).handler;

   final pipeline=const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(handler);

  final io.HttpServer server = await shelf_io.serve(pipeline, io.InternetAddress.anyIPv4, 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
