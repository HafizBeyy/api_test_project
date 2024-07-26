import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyWidget());
}

Future<Map<String, dynamic>>
    datayiDondurenMetod() async {
      //* mapler json gibi bir format için biçilmez kaftandırlar.
      //todo çünkü içerlerinde herhangi bir değeri tutabilirler.
      final Map<String,String> stringMap = {"key":"value"};
      //? örnek olarak bu map key olarak bir liste tutuyor
      final Map<List<String>,int> listIntMap = {["annass","babans"]: 5,["aferti","faferti","shitierti"]: 10};
      //! test için
    print(listIntMap[""]); //* köşeli tırnak içindeki yer keydir. karşılığı olan int değerini verir

  const String apiKey = "cur_live_GJfJpAXhBIuhIVBDgOkGUndA6ohUD7h9gHd32ohz";

  final postUrl = Uri.parse("https://api.currencyapi.com/v3/latest");

  final buDataDegilSadeceIstekatiyor =
      await http.get(postUrl, headers: {"apikey": apiKey});

  final String buGercekData = buDataDegilSadeceIstekatiyor.body;

  if (buDataDegilSadeceIstekatiyor.statusCode == 200) {

    return jsonDecode(buGercekData) as Map<String, dynamic>;

  } else {

    throw Exception("bu daag iui");
  }
}

class MyWidget extends StatelessWidget {

  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.blueGrey,
          //* Bu arkadaş async olarak gelen dataları göstermeye yarar
          //? kendisi tek başına bir şey yapmaz bunun için builder methodunda gerçek bir widget döndürmek iyidir
          //! Eğer bi object sınıfımız olsaydı Map<String,dynamic> yerine kullanılabilirdi 
          /// bakın https://docs.flutter.dev/cookbook/networking/fetch-data#3-convert-the-response-into-a-custom-dart-object
          child: FutureBuilder<Map<String, dynamic>>(
            future:
                datayiDondurenMetod(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("sıkıntı var lan it : ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text("hiçbişey yok lan it"),
                );
              } else {
                //* aslında gereksiz silinebilir
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data["data"].length,
                  itemBuilder: (context, index) {
                    final cur = data["data"].values.elementAt(index);
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.amberAccent,
                      margin: const EdgeInsets.all(4),
                      child: Text("${cur["code"]} : ${cur["value"]}"),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
