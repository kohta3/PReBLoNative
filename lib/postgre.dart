import 'package:postgres/postgres.dart';

//↓データベース接続
void main(List<String> argument) async {
  var connection = PostgreSQLConnection(
      "ec2-35-174-56-18.compute-1.amazonaws.com",
      5432,
      "d7b3j5jpksdl1f",
      username: "nidpustzmfzulk",
      password: "69a6cbf80ab0316a8db78e428f87f70ebe8ffc5728375ed30f990db4db0caf63");
  await connection.open();
  print("connection");
  List<List<dynamic>> results = await connection.query("SELECT all FROM information");
  print(results);
  await connection.close();
}