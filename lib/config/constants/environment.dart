import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{
  //inicializacion del .env
 static intiEnvironment() async {
    await dotenv.load(fileName: ".env");
  }


  //tengo que poner el .env en los assets
  static String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
}