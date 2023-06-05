import 'package:flutter/src/widgets/framework.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather/pages/searchPage.dart';
import 'package:weather/pages/weather.dart';

List temps = [];
String tempMax = '';
String tempMin = '';
String local = '';
List href = [];
List diasSemana = [];
List prevDias = [];
List dias = [];
List prev = [];

class WeatherPage extends StatefulWidget {
  WeatherPage(
      {Key? key,
      required this.requests,
      required this.cidade,
      required this.estado})
      : super(key: key);
  late String requests;
  late String cidade;
  late String estado;
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String tempNow = '';
  var brasao;
  bool img = false;
  var tempo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tempNow,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 90,
                  fontWeight: FontWeight.w400),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('°C', style: TextStyle(color: Colors.white, fontSize: 30)),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.blue[100],
                      size: 12,
                    ),
                    Text(
                      '${tempMax.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.blue[100],
                      size: 12,
                    ),
                    Text(
                      '${tempMin.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        Text('${local.replaceAll('/', ', ')}',
            style: TextStyle(color: Colors.white, fontSize: 30)),
        Icon(
          Icons.cloud_outlined,
          size: 100,
          color: Color.fromRGBO(206, 234, 238, 1),
        ),
        Text(
          'O tempo está: \n$tempo',
          style: TextStyle(color: Colors.white, fontSize: 30),
          textAlign: TextAlign.center,
        ),
        // Image.network(
        //   '$brasao',
        //   height: 200,
        // ),
      ],
    );
  }

  getData() async {
    var url = widget.requests;
    //print(url);
    var response = await http.get(Uri.parse(url));
    dom.Document html = dom.Document.html(response.body);

    final cidade = html
        .querySelectorAll('body > div > div > div > div > h2')
        .map((e) => e.innerHtml.trim())
        .toList();
    for (final c in cidade) {
      //debugPrint(c);
      setState(() {
        local = c;
      });
      print(widget.cidade.replaceAll(' ', '-'));
      var uri =
          'https://climaonline.com.br/${widget.cidade.replaceAll(' ', '-')}-${widget.estado}';
      var responseUri = await http.get(Uri.parse(uri));
      dom.Document getHtml = dom.Document.html(responseUri.body);
      print(getHtml);
      var tempNow = getHtml
          .querySelectorAll(
              'body > div > div > div > div > div > div > div > div > div')
          .map((e) => e.innerHtml.trim())
          .toString();
      setState(() {
        tempNow = tempNow[1] + tempNow[2];
        // tempNow = tempNow.replaceAll('(', '');
        // tempNow = tempNow.replaceAll(')', '');
        // tempNow = tempNow.replaceAll('º', '');
        this.tempNow = tempNow;
        var brasao = getHtml.documentElement!
            .getElementsByClassName('brasao')
            .map((e) => e.attributes['src'])
            .toString();
        brasao =
            brasao.substring(brasao.indexOf('https:'), brasao.indexOf(")"));
        this.brasao = brasao;
        var prevtempo = getHtml
            .querySelectorAll(
                'body > div > div > div > div > div > div > div > p > strong')
            .map((e) => e.innerHtml.trim())
            .toString();
        var len = prevtempo.length - 1;
        var len2 = prevtempo.indexOf(', ') + 2;
        this.tempo = prevtempo.substring(len2, len);
        print(this.tempo);
      });
    }

    final temperatura = html
        .querySelectorAll(
            'body > div > div > div > div > div > div > div > span')
        .map((e) => e.innerHtml.trim())
        .toList();
    print('Contar temperaturas ${temperatura.length}');
    for (final t in temperatura) {
      setState(() {
        var i = t.replaceAll(
            '&nbsp;<i class="fa fa-thermometer-empty" aria-hidden="true"></i>',
            '');
        i = i.replaceAll(
            '&nbsp;<i class="fa fa-thermometer-full" aria-hidden="true"></i>',
            '');
        //print(i);
        temps.add(i);
      });
    }
    setState(() {
      tempMax = temps[1];
      tempMin = temps[0];
    });
    final dias = html
        .querySelectorAll('body > div > div > div > div > div > div > h5')
        .map((e) => e.innerHtml.trim())
        .toList();

    dias.forEach((element) {
      setState(() {
        var e = element.replaceAll('<br>', ' - ');
        diasSemana.add(e);
        //print(e);
      });
    });

    final tempsd = html
        .querySelectorAll(
            'body > div > div > div > div > div > div > div > div > span')
        .map((e) => e.innerHtml.trim())
        .toList();
    tempsd.forEach((element) {
      var i = element.replaceAll(
          '<i class="fa fa-thermometer-empty" aria-hidden="true"></i>&nbsp;',
          '');
      i = i.replaceAll(
          '&nbsp;<i class="fa fa-thermometer-full" aria-hidden="true"></i>',
          '');
      //print(i);
      setState(() {
        prevDias.add(i);
        prev = List.from(prevDias);
      });
    });
    print('dias: ${diasSemana.length}');
    print('Temperaturas: ${prevDias.length}');
    temps.clear();
    // diasSemana.clear();
    prevDias.clear();
    widget.requests = '';
  }
}
