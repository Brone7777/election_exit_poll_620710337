import 'package:election_exit_poll_620710337/models/candidate.dart';
import 'package:election_exit_poll_620710337/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<candidate>> _futureCandidate;

  @override
  void initState() {
    super.initState();
    _futureCandidate = _fetch();
  }

  Future<List<candidate>> _fetch() async {
    List list = await Api().fetch('exit_poll');
    var cd = list.map((e) => candidate.fromJson(e)).toList();
    return cd;
  }

  Widget _buildCandidateCard(BuildContext context) {
    return FutureBuilder<List<candidate>>(
      future: _futureCandidate,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var candidateList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: candidateList!.length,
            itemBuilder: (BuildContext context, int index) {
              var candidate = candidateList[index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                color: Colors.white.withOpacity(0.5),
                child: InkWell(
                  onTap: () => _handleClickCandidate(candidate),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${candidate.candidateNumber}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            '${candidate.candidateNumber}${candidate.candidateTitle}${candidate.candidateFirstName} ${candidate.candidateLastName}',
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureCandidate = _fetch();
                    });
                  },
                  child: const Text('ลองใหม่'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.fill,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/vote_hand.png",
                height: 100.0,
              ),
              Text(
                'EXIT POLL \n',
                style: GoogleFonts.kanit(fontSize: 50.0, color: Colors.white),
              ),
              Text(
                'รายชื่อผู้สมัครรับเลือกตั้ง \n',
                style: GoogleFonts.kanit(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'นายกองค์การบริหารส่วนตำบลเขาพระ',
                style: GoogleFonts.kanit(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'อำเภอเมืองนครนายก จังหวัดนครนายก',
                style: GoogleFonts.kanit(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              _buildCandidateCard(context),
              // Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: ElevatedButton(
              //       onPressed: () {
              //         setState(() {
              //           Navigator.pushNamed(context, homepage());
              //         });
              //       },
              //       child: null,
              //     )),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _election(int candidateNumber) async {
    var elector =
        (await Api().submit('exit_poll', {'candidateNumber': candidateNumber}));
    _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ ${elector.toString()}');
  }

  _handleClickCandidate(candidate candidate) {
    _election(candidate.candidateNumber);
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
