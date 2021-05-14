import 'package:flutter/material.dart';
import 'package:mymoney/providers/Transaction_Provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; //new one




Widget SpeedChart(BuildContext context, String header,double limit,double net,double earned,double spent) {

  //final transProv = Provider.of<Transaction>(context, listen: true);
  return Container
    (
    width: MediaQuery
        .of(context)
        .size
        .width / 1.2,

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).primaryColor,
    ),
    child: Column(
      children: [
        SizedBox
          (
          height: 10,
        )
        ,
        Text(
          '${header} Expenditure',
          style: TextStyle
            (fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        ),

        Row
          (
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis
                  (
                  minimum: 0,
                  maximum: limit,
                  labelOffset: 30,
                  axisLineStyle: AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03
                  ),
                  majorTickStyle: MajorTickStyle(
                      length: 7,
                      thickness: 5,
                      color: Colors.white),
                  minorTickStyle: MinorTickStyle(
                      length: 4,
                      thickness: 3,
                      color: Colors.white),
                  axisLabelStyle: GaugeTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11
                  ),
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: limit,
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.22
                        ,
                        endWidth: 0.22
                        ,
                        gradient: SweepGradient
                          (
                            colors: const <Color>[
                              Colors.green,
                              Colors.yellow,
                              Colors.red
                            ],
                            stops: const <double>[
                              0.0,
                              0.5,
                              1
                            ]))
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        value: -1 * net.toDouble(),
                        needleLength: 0.85,
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        needleStartWidth: 1.5,
                        needleEndWidth: 6,
                        needleColor: Colors.white,
                        knobStyle: KnobStyle(
                            knobRadius: 0.09, color: Colors.white))
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        verticalAlignment: GaugeAlignment.near,
                        horizontalAlignment: GaugeAlignment.center,
                        widget: Container(
                          child: Text(
                            net > 0
                                ? '$net Earned'
                                : '${(net * -100) ~/limit}% Used',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.75)
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 3.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 50,),
                Text("Spent: ${spent}",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 10,),
                Text("Earned: ${earned}",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 10,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Total:",
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      WidgetSpan(
                        child: net > 0
                            ? Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        )
                            : Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: (net > 0
                            ? net
                            .toDouble()
                            .toString()
                            : (-1 * net.toDouble())
                            .toString()),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ],
    ),
  );
}
