
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gsheets/gsheets.dart';
import 'package:zone_trader/constants/countryImageNames.dart';

class GSheet {

  static final gsheets = GSheets(_credentials);

  static const _credentials = r''' 
{
  "type": "service_account",
  "project_id": "zelix-zonetrader",
  "private_key_id": "f3e51ec1b6c4e0be4cdecd562fa2c5ba62e82558",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCWJtATBBYC/Fq7\n0VcVlyMWUTWK5RnYOFC3zsMhP0DiSWaB7bICWNCVzr3RZvrDhDXIdTK3Nb5QqkBS\nDjKAjSRzpQcWXnl/VvWxTOTUxPyubI7e1epxxEqn+A+2i/6FrCa1Kw9aUU80Ey6o\ns57UE7DlDKSo/6XjK6a0IDL5IbYgoJkq/TZ/Be1oLY6rBWxrjxEvY/v6AKiGjw9s\neJZhq+mhtAKPYhu03X1pMhuAkM1r9TlXCCZkLBsKf2dvM/mFbe/7a2aISZOPkTrC\nR3KrlMWDHC95sjingTJL4X2lSnBWtKCjYYBzBTgEHasr7u3qc51+jePVxyQktqSc\nT7+VyXlBAgMBAAECggEAAvnTSQKH8ZiJ6ETRNiQceT80H8sLD2uMiKnYLmy6u13X\nt9BmbFXt2NTpPb1xbDYkJkxDc4BWvJzDNLJ1jxx152BoYf8c5x3bp2Zf2qpb6lu9\nxnxmbq0EmVOjuk6yqOo7bptU+ztFUJcf2PJUoYfYmXUaeB/h3gRNdbznaUdLxBzb\n1Irs57fDO2STdUvB2GLfPuGcy6pEbQYW2XeuisXFteC3D3d/KNTTJw5Ua5ux6W8h\nMzHOEFTZ0Ck2a5mt1aiNgBT8UDBMWHfDZBkr7l6CoYBDRyTb/9DQDN5S/T2swhnf\nDjqotuNpFKEfn8/22MiGdg6+oMgWZcneDFCjKbr26QKBgQDQ5Y12CDqRWsckvhgr\nvVxNiwCI8bdq7tk9UmoufZ2EozMQ63RD4jeJk4eEh07JsJ4k+shv3QcQ3WgenX1V\nPnl4r9rpB8O2J5sAiMRFC3ZIc1RE0jUlDaeNAIbroGikcYe+ESwUdg/W5CY/9ab+\nkqxLWE7ubr3scxyxO0LUd+Y/1wKBgQC4AjuQ0Pl3jH8JKCpB7B5tRu3qQwdk40q3\nKmtuXvq4t6+URU2MxptbQ/bm1HHZYB9UuTWcRBWuke5Zm92wijJBeTzYdVJL+g0H\nwLGkaKvY0QRsaeGhdiBGULYBTua+7myO/AmRsy2I4r2C8PxieOHhTFTl0O4jC6RR\numUZbS5MpwKBgGlaHAnXBJKiEaU6Kb6FdbO10sM+BJ7tbqo6kkp4F6T5GZwC41QJ\nFrFPshzokJevd1J3F/cypYmf4A7wpnEDXQe8yM6Vl+KZ/tY6I6IesbzATVOYIC1b\nwZCfH2xeLeghSbBVwMFg+YQK9C91mI7zMemd09D0ENzbATFxDbdR8NFpAoGAIc93\nNnLPg+Hy7bHNofNK2/Vufd73GtiQv/sxZkRZeVt3DZ12VGmh3jEsytk6WiDJYP3v\nFdmEymDSFPEI2QlrlpA6V+OmzYMSpdwISBdbjClL0Mfbx5k28PSfnLnsuCSDGfrB\nn132/fH7tHWnSki/6G/oIZo0R4g6FzJSpUtkeH0CgYA61GoPEAPjZlOb7URAB9U4\no5he66Smp55KqbGIpYwFZZVDPuHQBwSlkz4t8YhVaaaJl2juMAvjgU+rbA0QkQr1\nZf8u7Ml2PynkDlxLpK8gNI9rvvaYgDU6TeuoGSrBWbZ7DK8x6TLezkzjhv+ybmhk\n70H/njoX5avZO4570N141w==\n-----END PRIVATE KEY-----\n",
  "client_email": "zone-trader-service@zelix-zonetrader.iam.gserviceaccount.com",
  "client_id": "116224093654860651329",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/zone-trader-service%40zelix-zonetrader.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';
static const _spreadsheetID = '1WnlNxxLam9pK5taT2WmxLY-skoE8hyGLJzDn9lp5E1A';


// Future<List<String>> getColumn(int worksheetindex,String columnname) async {
//  final sheet = await gsheets.spreadsheet(_spreadsheetID);
//  final worksheet = await sheet.worksheetByIndex(worksheetindex);
//  return await worksheet!.values.map.columnByKey(columnname).then((value) => value!.values.map((e) => e).toList());
//}
//Future<List<String>> getRow(int worksheetindex,String rowname) async {
//  final sheet = await gsheets.spreadsheet(_spreadsheetID);
//  final worksheet = await sheet.worksheetByIndex(worksheetindex);
//  return await worksheet!.values.map.columnByKey(rowname).then((value) => value!.values.map((e) => e).toList());
//}

Future<List<List<dynamic>>> getAllRows(int worksheetindex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(worksheetindex);
  return await worksheet!.values.map.allRows(fromColumn: 1,fromRow: 1).then((value) => value!.map((e) => e.values.map((e) => e).toList()).toList());
}
//Satır bulma fonksiyonu
Future<int> findRowIndexByValue(String columnValue, int columnIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  final columnData = await worksheet!.values.column(columnIndex);
  return columnData.indexOf(columnValue) + 1; // indeks 0'dan başladığı için +1 ekliyoruz
}

// Belirli bir sütundaki tüm değerleri getirme fonksiyonu
Future<List<String>> getColumnValues(int worksheetindex,int columnIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(worksheetindex);
  return await worksheet!.values.column(fromRow: 2,columnIndex);
}

// Belirli bir satırdaki tüm değerleri getirme fonksiyonu
Future<List<String>> getRowValues(int worksheetindex,int rowIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(worksheetindex);
  return await worksheet!.values.row(fromColumn: 2,rowIndex);
}

// Belirli bir hücredeki değeri getirme fonksiyonu
Future<String> getCellValue(int worksheetindex,int rowIndex, int columnIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(worksheetindex);
  return await worksheet!.values.value(column: columnIndex, row: rowIndex);
}

// Belirli bir hücreyi güncelleme fonksiyonu
Future<void> updateCellValue(int worksheetindex,int rowIndex, int columnIndex, String newValue) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(worksheetindex);
  await worksheet!.values.insertValue(newValue, column: columnIndex, row: rowIndex);
}
// Belirli bir sütundaki tüm değerleri güncelleme fonksiyonu
Future<void> updateColumnValues(int worksheetindex,int columnIndex, List<dynamic> newValues) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(worksheetindex);
  await worksheet!.values.insertColumn(fromRow: 2,columnIndex, newValues);
}

// Belirli bir satırdaki tüm değerleri güncelleme fonksiyonu
Future<void> updateRowValues(int rowIndex, List<dynamic> newValues) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.values.insertRow(fromColumn: 2,rowIndex, newValues);
}

// Yeni bir çalışma sayfası oluşturma fonksiyonu
Future<void> createNewWorksheet(String sheetName) async {
  final ss = await gsheets.spreadsheet(_spreadsheetID);
  //final worksheet = await sheet.worksheetByIndex(0);
  //return await worksheet
  await ss.addWorksheet(sheetName);
}
// Tüm çalışma sayfalarının isimlerini getirme fonksiyonu
Future<List<String>> getAllWorksheetNames() async {
  final ss = await gsheets.spreadsheet(_spreadsheetID);
  return ss.sheets.map((e) => e.title).toList();
}

// Belirli bir çalışma sayfasını adına göre getirme fonksiyonu
Future<Worksheet?> getWorksheetByName(String sheetName) async {
  final ss = await gsheets.spreadsheet(_spreadsheetID);
  return ss.worksheetByTitle(sheetName);
}

// Bir çalışma sayfasındaki tüm verileri temizleme fonksiyonu
Future<void> clearWorksheet(String sheetName) async {
  final worksheet = await getWorksheetByName(sheetName);
  await worksheet!.clear();
}

// Bir çalışma sayfasını kopyalama fonksiyonu
Future<Worksheet?> copyWorksheet(String originalSheetName, String copySheetName) async {
  final original = await getWorksheetByName(originalSheetName);
  final ss = await gsheets.spreadsheet(_spreadsheetID);
  return ss.copyWorksheet(original!, copySheetName);
}

// Bir çalışma sayfasını yeniden adlandırma fonksiyonu
Future<void> renameWorksheet(String sheetName, String newSheetName) async {
  final worksheet = await getWorksheetByName(sheetName);
  worksheet!.updateTitle(newSheetName);
}
Future<void> addRow(List<dynamic> values) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.values.appendRow(values);
}

// Satır silme fonksiyonu
Future<void> deleteRow(int index) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.deleteRow(index);
}
// E-posta adresine göre satır bulma ve değiştirme fonksiyonu
Future<void> findAndUpdateByEmail(String email, List<dynamic> newValues) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(1);
  final emailColumnIndex = 2; // E-posta adreslerinin bulunduğu sütunun indeksi
  final emails = await worksheet!.values.column(emailColumnIndex);
  final index = emails.indexOf(email);
  if (index != -1) {
    await updateRowValues(index + 1, newValues);
  }
}
// INCOME RESET
Future<void> updateIncomesByPrices() async { 
  List<String> prices = await getColumnValues(0,3).then((value) => value);
  List<String> incomes = [];
  prices.forEach((element) {
    incomes.add((int.parse(element) * 0.15).floor().toString());
  });
  await updateColumnValues(0,4, incomes);
}
// COUNTRY OWNER UPDATE
Future<void> countryOwnerUpdate(String countryname,String username) async {
  List<String> countries = await getColumnValues(0,1).then((value) => value);
  
  countries.forEach((element)async { 
    if (element == countryname) {
     print('countries.indexOf(element) + 1: '+(countries.indexOf(element) + 1).toString());
     String ownervalue = await getCellValue(0,countries.indexOf(element) + 2,5).then((value) => value);
      
     List<String> oldusers = ownervalue.split(',');
     oldusers.add(username);
     String newownersstr = oldusers.join(',').toString(); 
     updateCellValue(0,countries.indexOf(element) + 2, 
                     5, 
                     ownervalue == 'No owner' || ownervalue == 'Noone' || ownervalue == 'Yok' || ownervalue == 'No hay' || ownervalue == '無し' 
                     ? 
                     username 
                     : 
                     newownersstr);
    }
  });
}
Future<List<String>> getBoughtValues() async {
  //List<String> usernames = await getColumnValues(1,1).then((value) => value);
  
  int userrowindex = await findCurrentUserRowIndex().then((value) => value + 1);
  //print('userrowindex: '+userrowindex.toString());
  return await getCellValue(1,userrowindex, 4).then((value) => value.split(','));
}
Future<void> updateUserMoney(String money)async{
  int userrowindex = await findCurrentUserRowIndex().then((value) => value + 1);
  await updateCellValue(1,userrowindex, 7, money);
}
Future<int> findCurrentUserRowIndex()async{
  List<String> usernames = await getColumnValues(1,1).then((value) => value);
 // print(usernames);
  return usernames.indexOf(FirebaseAuth.instance.currentUser!.displayName!) + 1;
}
Future<void> updateBoughtColorsGS(List<bool> bought) async {
  int userrowindex = await findCurrentUserRowIndex().then((value) => value + 1);
  await updateCellValue(1,userrowindex, 4, bought.map((e) => e ? 'true' : 'false').toList().join(',').toLowerCase());
}
// Retrieves and returns the user times data from the Google Sheets based on the current user's row index.
Future<List<Map<String,String>>> fetchUserTimesGS() async {
  int userrowindex = await findCurrentUserRowIndex().then((value) => value + 1);
  List<Map<String,String>> times =  await getCellValue(1,userrowindex, 9).then((value) => value.split(',').map((e) => {e.split(':')[0]: e.split(':')[1]}).toList());
  return times;
}
Future<void> updateUserTimesGS(List<Map<String,dynamic>> times) async {
  int userrowindex = await findCurrentUserRowIndex().then((value) => value + 1);
  await updateCellValue(1,userrowindex, 9, times.map((e) => e.keys.first + ':' + e.values.first).toList().join(','));
}


Future<List<int>> fetchBoughtIndexGS() async {
    List<int> a = [];
    List<Map<String, String>> times =
        await fetchUserTimesGS().then((value) => value);
    for (int i = 0; i < times.length; i++) {
      times[i].forEach((key, value) {
        if (value != "60") {
          a.add(i);
        }
      });
    }
    return a;
  }
 Future<int> findCountryIncomeAndAddGS(
      List<double> howmanyincomes) async {
    List<int> indexes = [];
    await fetchBoughtIndexGS().then((value) {
      indexes = value;
    });

    List<int> incomes = [];
    await getColumnValues(0, 4).then((value) => incomes = value.map((e) => int.parse(e)).toList());
    //for (var i = 0; i < indexes.length; i++) {
    //  incomes.add(await countries
    //      .get()
    //      .then((value) => value.docs[indexes[i]].data()['income']));
    //}
    int userrowindex = await findCurrentUserRowIndex().then((value) => value + 1);
    int oldmoney = await getCellValue(1, userrowindex, 7).then((value) => int.parse(value));
    //int oldmoney = await users
    //    .doc(FirebaseAuth.instance.currentUser!.displayName)
    //    .get()
    //    .then((value) => Map<String, dynamic>.from(value.data()!)['money']);
    List<Map<String, String>> test = List<Map<String, String>>.filled(CountryImageNames.countryandcitynumber, {'60': '60'});
    for (var i = 0; i < indexes.length; i++) {
      test[indexes[i]] = {
        DateTime.now().hour.toString() : DateTime.now().minute.toString()
      };
    }
    int sum = 0;
    for (var i = 0; i < incomes.length; i++) {
      sum = sum + (incomes[i] * howmanyincomes[i]).floor();
    }
    await updateCellValue(1, userrowindex, 7, (oldmoney + sum).toString());
    await updateCellValue(1, userrowindex, 9, test.map((e) => e.keys.first + ':' + e.values.first).toList().join(','));
    //print('sum $sum');
   //users.doc(FirebaseAuth.instance.currentUser!.displayName).update({
   //  'money': (oldmoney + sum),
   //  'times': test,
   //});
    return sum;
  }
  Future<List<String>> counterHelper(Map<String,List<String>> element, List<String> productions, List<List<String>> owners)async{
    List<String> counter = [];
    element.values.first.forEach((neededitem) async {
            
            
            
            for (var i = 0; i < productions.length; i++) {
                
                if (productions[i] == neededitem && !owners[i].contains(FirebaseAuth.instance.currentUser!.displayName)) {
                  counter.add(neededitem);
                }
                else if(productions[i] == neededitem && owners[i].contains(FirebaseAuth.instance.currentUser!.displayName)){
                  counter.remove(neededitem);
                  
                  break;
                }
                
            }
          });
          return counter;
  }
  Future<Map<bool, String>> checkNeededProductionsBoughtBeforeGS(
      List<Map<String, List<String>>> pairs,
      String wanttobuyproduct,
      List<String> productions,
      List<List<String>> owners) async {
    List<String> counter = [];
    
    if (pairs.every((element) => element.keys.first != wanttobuyproduct)) {
      
      return {true: 'You successfully bought all needed productions!'};
    } else {
      for (var element in pairs) {
        if (element.keys.first == wanttobuyproduct) {
          counter = await counterHelper(element,productions,owners).then((value) => value);
          print(counter);
        }
      }
      
    }
    return counter == [] || counter.isEmpty
        ? {true: ''}
        : {false: '\n     ' + counter.toSet().join('  ,  ').toUpperCase()};
  }

}
/*
// Çalışma sayfasını silme fonksiyonu
Future<void> deleteWorksheet(String sheetName) async {
  final ss = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = ss.worksheetByTitle(sheetName);
  if (worksheet != null) {
    await ss.removeWorksheet(worksheet);
  }
}
*/
/*
// Belirli bir hücre aralığını getirme fonksiyonu
Future<List<List<String>>> getRangeValues(String range) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  return await worksheet!.values.allInRange(range);
}
*/
/*
 // Belirli bir hücreyi boşaltma fonksiyonu
Future<void> clearCell(int rowIndex, int columnIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.values.clearCell(column: columnIndex, row: rowIndex);
}
*/
/*
// Belirli bir sütunu boşaltma fonksiyonu
Future<void> clearColumn(int columnIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.values.clearColumn(columnIndex);
}

// Belirli bir satırı boşaltma fonksiyonu
Future<void> clearRow(int rowIndex) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.values.clearRow(rowIndex);
}

// Belirli bir hücre aralığını boşaltma fonksiyonu
Future<void> clearRange(String range) async {
  await sheet!.values.clearRange(range);
}

// Belirli bir hücreye not ekleme fonksiyonu
Future<void> addNoteToCell(int rowIndex, int columnIndex, String note) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  await worksheet!.values.insertNote(note, column: columnIndex, row: rowIndex);
}

// Belirli bir satıra not ekleme fonksiyonu
Future<void> addNoteToRow(int rowIndex, String note) async {
  await sheet!.values.insertNoteRow(note, row: rowIndex);
}

// Belirli bir sütuna not ekleme fonksiyonu
Future<void> addNoteToColumn(int columnIndex, String note) async {
  await sheet!.values.insertNoteColumn(note, column: columnIndex);
}
*/

/*
// Belirli bir hücre aralığını sıralama fonksiyonu
Future<void> sortRange(String range, bool ascending) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  final sortedRange = await worksheet!.values. sortRange(range, ascending: ascending);
  return sortedRange;
}

// Bir çalışma sayfasındaki belirli bir sütunu alfabetik olarak sıralama fonksiyonu
Future<void> sortColumnAlphabetically(int columnIndex) async {
  await sheet!.values.sortColumn(columnIndex, ascending: true);
}

// Bir çalışma sayfasındaki belirli bir satırı alfabetik olarak sıralama fonksiyonu
Future<void> sortRowAlphabetically(int rowIndex) async {
  await sheet!.values.sortRow(rowIndex, ascending: true);
}

// Bir çalışma sayfasındaki belirli bir hücre aralığındaki verileri toplama fonksiyonu
Future<double> sumRange(String range) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  final values = await worksheet!.values. allInRange(range);
  return values.map((row) => row.map(double.parse).reduce((a, b) => a + b)).reduce((a, b) => a + b);
}

// Bir çalışma sayfasındaki belirli bir sütundaki verileri toplama fonksiyonu
Future<double> sumColumn(int columnIndex) async {
  final values = await sheet!.values.column(columnIndex);
  return values.map(double.parse).reduce((a, b) => a + b);
}

// Bir çalışma sayfasındaki belirli bir satırdaki verileri toplama fonksiyonu
Future<double> sumRow(int rowIndex) async {
  final values = await sheet!.values.row(rowIndex);
  return values.map(double.parse).reduce((a, b) => a + b);
}
*/


// Tüm satırları getirme fonksiyonu
//Future<List<Map<String, dynamic>>> getAllRows() async {
//  final sheet = await gsheets.spreadsheet(_spreadsheetID);
//  final worksheet = await sheet.worksheetByIndex(0);
//  final rows = await worksheet!.values.map.allRows();
//  return rows ?? [];
//}
