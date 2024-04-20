import 'package:gsheets/gsheets.dart';

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


 Future<List<String>> getColumn(String columnname) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  return await worksheet!.values.map.columnByKey(columnname).then((value) => value!.values.map((e) => e).toList());
}
Future<List<String>> getRow(String rowname) async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  return await worksheet!.values.map.columnByKey(rowname).then((value) => value!.values.map((e) => e).toList());
}

Future<List<List<dynamic>>> getAllRows() async {
  final sheet = await gsheets.spreadsheet(_spreadsheetID);
  final worksheet = await sheet.worksheetByIndex(0);
  return await worksheet!.values.map.allRows(fromColumn: 1,fromRow: 1).then((value) => value!.map((e) => e.values.map((e) => e).toList()).toList());
  
}
  
}