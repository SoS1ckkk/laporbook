
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/models/laporan.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;
  final bool isLaporanku;
  const ListItem(
      {super.key,
      required this.laporan,
      required this.akun,
      required this.isLaporanku});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
   final _storage = FirebaseStorage.instance;

   void deleteLaporan() async {
     try {
       await _firestore.collection('laporan').doc(widget.laporan.docId).delete();

 // menghapus gambar dari storage
       if (widget.laporan.gambar != '') {
         await _storage.refFromURL(widget.laporan.gambar!).delete();
       }
       Navigator.popAndPushNamed(context, '/dashboard');
     } catch (e) {
       print(e);
     }
   }

   @override
    Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            widget.laporan.gambar != ''
                ? Image.network(
                    widget.laporan.gambar!,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/istock-default.jpg',
                    width: 130,
                    height: 130,
                  ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(width: 2))),
              child: Text(
                widget.laporan.judul,
                style: headerStyle(level: 4),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                      widget.laporan.status,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(widget.laporan.tanggal),
                    ),
                
              ],
            )
          ],
        ),
      );
    }
}