import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Viewfeedback extends StatelessWidget {
  const Viewfeedback({super.key});

  Future<List<Map<String, dynamic>>> fetchComplaints() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final lid = pref.getString('lid').toString();
    final response = await http.post(Uri.parse("$ip/UserViewfeedback/"),body: {'lid':lid});
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      // Attach full image URL to each complaints
      return List<Map<String, dynamic>>.from(jsonData['data']).map((complaints) {
        return complaints;
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View All Feedbacks")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchComplaints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Feedbacks found"));
          }

          final Complaints = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: Complaints.length,
            itemBuilder: (context, index) {
              final complaints = Complaints[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                    title: Text(
                      complaints['complaint'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        Text('Reply:'+complaints['reply']),
                        Text('Date:'+complaints['date']),

                      ],
                    )
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SendFeedback()));
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}

class SendFeedback extends StatefulWidget {
  const SendFeedback({super.key});

  @override
  State<SendFeedback> createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<SendFeedback> {
  TextEditingController complaintController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter complaint'),
            controller: complaintController,
          ),
          ElevatedButton(onPressed: () async {
            String complaint=complaintController.text.trim();

            if(complaint.isEmpty) {
              Fluttertoast.showToast(msg: 'fill the  fields');
              return;
            }

            final sh= await SharedPreferences.getInstance();
            String? url= sh.getString('url');
            String? lid= sh.getString('lid');

            final api=Uri.parse('$url/SendFeedback/');

            try {
              final request= await http.post(api,body: {
                'complaint':complaint,
                'lid':lid,
              });

              if(request.statusCode == 200) {
                var data = jsonDecode(request.body);
                if(data['status']=='ok') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Viewfeedback()));
                }
                else {
                  Fluttertoast.showToast(msg: 'Complaint not sent');
                }
              }
              else {
                Fluttertoast.showToast(msg: 'connection error');
              }

            }catch (e){
              Fluttertoast.showToast(msg: 'error:$e');
            }

          }, child: Text('send complaint'))
        ],
      ),
    );
  }
}

