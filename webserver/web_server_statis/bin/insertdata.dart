import 'dart:async';

import 'package:mysql1/mysql1.dart';

Future main() async {
  // Open a connection (testdb should already exist)
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3308,
      user: 'root',
      db: 'programmer',
      password: '12345'));


  // Insert some data
  var result = await conn.query(
      'insert into Books (BookName, AuthorName, Summary,Price) values (?, ?, ?, ?)',
      ['Dart Apprentice: Fundamentals#','by Jonathan Sande','Dart Apprentice: Fundamentals is the first of a two-book series that will teach you all the basic concepts you need to master this powerful and versatile language.',150000]);
  print('Inserted row id=${result.insertId}');
  result = await conn.query(
      'insert into Books (BookName, AuthorName, Summary,Price) values (?, ?, ?, ?)',
      ['Dart Apprentice: Beyond the Basics#','by Jonathan Sande','Dart Apprentice: Beyond the Basics is the second of a two-book series that will teach you all the important concepts you need to master this powerful and versatile language.',175000]);
  print('Inserted row id=${result.insertId}');
  result = await conn.query(
      'insert into Books (BookName, AuthorName, Summary,Price) values (?, ?, ?, ?)',
      ['Data Structures & Algorithms in Dart#','by Jonathan Sande, Vincent Ngo, and Kelvin Lau','Take your programming skills to the next level. Learn to build stacks, queues, trees, graphs, and efficient sorting and searching algorithms from scratch.',225000]);
  print('Inserted row id=${result.insertId}');
  result = await conn.query(
      'insert into Books (BookName, AuthorName, Summary,Price) values (?, ?, ?, ?)',
      ['Essential Dart','noname','It\'s part of Essential Programming Books.It\'s written to provide clear and concise explanation of topics for both beginner and advanced programmers. Most examples are linked to online playground that allows you to change the code and re-run it. ',125000]);
  print('Inserted row id=${result.insertId}');
  result = await conn.query(
      'insert into Books (BookName, AuthorName, Summary,Price) values (?, ?, ?, ?)',
      ['Pengantar Pemrograman Dart dan Flutter','Jubilee Enterprise','membuat aplikasi Android selain memanfaatkan Java. Buku ini memberi pengantar ringkas bagaimana memahami framework Flutter dan bahasa pemrograman Dart dari sudut pandang programmer pemula.',125000]);
  print('Inserted row id=${result.insertId}');

  // Query the database using a parameterized query
  var results = await conn.query(
      'select BookName, AuthorName, Summary,Price from Books ');
  for (var row in results) {
    print('books title : ${row[0]}, Author: ${row[1]} summary: ${row[2]}  price: ${row[3]}');
  }


  // Finally, close the connection
  await conn.close();
}

