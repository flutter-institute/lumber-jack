import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import 'components/dimension_selector.dart';
import 'components/fit_summary.dart';
import 'model/cuts.dart';
import 'model/dimensions.dart';
import 'model/fittings.dart';
import 'util/make_fit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumber Jack',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _sawWidthController;
  TextEditingController _lumberLenController;

  CutGroup cutGroup;

  @override
  void initState() {
    cutGroup = CutGroup();
    cutGroup.cuts.add(CutDesc());

    _lumberLenController =
        TextEditingController(text: cutGroup.maxLen.toString());
    _sawWidthController =
        TextEditingController(text: cutGroup.sawWidth.toString());

    super.initState();
  }

  _onDimensionsChanged(DimensionItem dims) {
    setState(() {
      cutGroup.dimensions = dims;
    });
  }

  _onLengthChanged(String lenStr) {
    final d = Decimal.tryParse(lenStr);
    if (d != null) {
      setState(() {
        cutGroup.maxLen = d;
      });
    }
  }

  _onSawWidthChange(String lenStr) {
    final d = Decimal.tryParse(lenStr);
    if (d != null) {
      setState(() {
        cutGroup.sawWidth = d;
      });
    }
  }

  _onCutLengthChange(int cutNum, String newLen) {
    final d = Decimal.tryParse(newLen);
    if (d != null) {
      setState(() {
        cutGroup.cuts[cutNum].len = d;
      });
    }
  }

  _onCutQuantityChanged(int cutNum, String qty) {
    final q = int.tryParse(qty);
    if (q != null) {
      setState(() {
        cutGroup.cuts[cutNum].count = q;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lumber Selector"),
        // TODO drop down menu with "Reset"
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DimensionSelector(
                value: cutGroup.dimensions,
                onChanged: _onDimensionsChanged,
              ),
              TextFormField(
                controller: _lumberLenController,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Desired Length of Lumber",
                  suffixText: "inches",
                ),
                onSaved: _onLengthChanged,
                onChanged: _onLengthChanged,
                // TODO validation that it is the correct format
              ),
              TextFormField(
                controller: _sawWidthController,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Width of Saw Blade",
                  suffixText: "inches",
                ),
                onSaved: _onSawWidthChange,
                onChanged: _onSawWidthChange,
              ),
              ...cutGroup.cuts.asMap().entries.map((desc) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Number of Cuts",
                          suffixText: "qty",
                        ),
                        onSaved: (val) {
                          _onCutQuantityChanged(desc.key, val);
                        },
                        onChanged: (val) {
                          _onCutQuantityChanged(desc.key, val);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("@"),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: "Length of Cuts",
                          suffixText: "inches",
                        ),
                        onSaved: (val) {
                          _onCutLengthChange(desc.key, val);
                        },
                        onChanged: (val) {
                          _onCutLengthChange(desc.key, val);
                        },
                      ),
                    ),
                  ],
                );
              }),
              FlatButton(
                onPressed: () {
                  setState(() {
                    cutGroup.cuts.add(CutDesc());
                  });
                },
                child: Row(
                  children: [Icon(Icons.add), Text("Add Cut")],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return CutSummary(
                      cutGroup: cutGroup,
                    );
                  }));
                },
                child: Text("Calculate Required Number of Boards"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CutSummary extends StatefulWidget {
  final CutGroup cutGroup;

  const CutSummary({Key key, this.cutGroup}) : super(key: key);

  @override
  _CutSummaryState createState() => _CutSummaryState();
}

class _CutSummaryState extends State<CutSummary> {
  bool _loading;
  List<Fit> _fits;

  @override
  void initState() {
    _loading = true;
    _fits = [];

    _calculateFits();

    super.initState();
  }

  Future _calculateFits() async {
    final fits = makeFit(widget.cutGroup);

    setState(() {
      _fits = fits;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lumber Calculator"),
      ),
      body: _loading
          ? (Center(
              child: CircularProgressIndicator(),
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Supplies Needed:",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "${_fits.length}x ${widget.cutGroup.maxLen}\" ${widget.cutGroup.dimensions.inches}",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 30),
                  // TODO make this scrollable
                  ..._fits.map((f) => FitSummary(fit: f)),
                ],
              )),
            ),
    );
  }
}
