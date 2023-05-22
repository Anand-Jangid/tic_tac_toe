import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ScoreCard extends StatefulWidget {
  const ScoreCard(
      {Key? key,
      required this.user1Name,
      required this.user2Name,
      required this.user1Won,
      required this.user2Won,
      required this.draw})
      : super(key: key);

  final String user1Name;
  final String user2Name;
  final int user1Won;
  final int user2Won;
  final int draw;
  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  List<PieData> pieData = [];

  late ChartType chart;
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = [
      ChartData(widget.user1Name, widget.user1Won.toDouble()),
      ChartData(widget.user2Name, widget.user2Won.toDouble()),
      ChartData('Draw', widget.draw.toDouble()),
    ];
    _tooltip = TooltipBehavior(enable: true);
    pieData
        .add(PieData(widget.user1Name, widget.user1Won, '${widget.user1Won}'));
    pieData
        .add(PieData(widget.user2Name, widget.user2Won, '${widget.user2Won}'));
    pieData.add(PieData("draw", widget.draw, '${widget.draw}'));
    chart = ChartType.PIECHART;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Score Card"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),

              child: Text(
                'Choose Your Graph',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white)
              ),
            ),
            //PieChart
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text('Pie Chart'),
              onTap: () {
                setState(() {
                  chart = ChartType.PIECHART;
                });
                // Perform the desired action when the item is tapped
                Navigator.pop(context); // Close the drawer
              },
            ),
            //BarChart
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Bar Chart'),
              onTap: () {
                setState(() {
                  chart = ChartType.BARCHART;
                });
                // Perform the desired action when the item is tapped
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Column(children: [
        (chart == ChartType.PIECHART)
          ? Center(
            child: SfCircularChart(
              palette: [
                Colors.deepPurple.shade400,
                Colors.deepPurple.shade900,
                Colors.deepPurple.shade50
              ],
                legend: Legend(isVisible: true),
                series: <PieSeries<PieData, String>>[
              PieSeries<PieData, String>(
                  explode: true,
                  explodeIndex: 0,
                  dataSource: pieData,
                  xValueMapper: (PieData data, _) => data.xData,
                  yValueMapper: (PieData data, _) => data.yData,
                  dataLabelMapper: (PieData data, _) => data.text,
                  dataLabelSettings: DataLabelSettings(isVisible: true)),
            ]))
          : Center(
          child:  SfCartesianChart(
              palette: [
                Colors.deepPurple.shade400,
                Colors.green,
                Colors.pinkAccent
              ],
              plotAreaBorderWidth: 2,
              plotAreaBorderColor: Colors.deepPurple,
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 5, interval: 10),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: 'Gold',
                    color: Color.fromRGBO(8, 142, 255, 1))
              ])),
      ]),
    );
  }
}

// class _SalesData {
//   _SalesData(this.year, this.sales);
//
//   final String year;
//   final double sales;
// }

class PieData {
  PieData(this.xData, this.yData, [this.text = ""]);
  final String xData;
  final num yData;
  final String text;
}

enum ChartType{
  PIECHART,
  BARCHART,
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}