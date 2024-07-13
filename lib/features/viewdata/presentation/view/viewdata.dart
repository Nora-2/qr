import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/features/viewdata/cubit/cubit/data_cubit.dart';

class ViewDataScreen extends StatelessWidget {
  const ViewDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataCubit(),
      child: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataDeletedSuccessfully || state is AllDataDeletedSuccessfully) {
            context.read<DataCubit>().rearrangeAndSetCurrentId();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('View QR Codes'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => DataCubit.get(context).deleteAllData(context),
                ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('qrcodes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                var docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('QR Code: ${data['qrCode']}'),
                        subtitle: Text('ID: ${index + 1}\n ${data['datetime']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => DataCubit.get(context).deleteData(docs[index].id,context),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
