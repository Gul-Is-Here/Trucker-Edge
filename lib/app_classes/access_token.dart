// import 'package:googleapis/authorizedbuyersmarketplace/v1.dart';
// import 'package:googleapis_auth/auth.dart';
// import 'package:googleapis_auth/auth_io.dart';

// class AccessFirebaseToken {
//   static String firebaseMessagingToken =
//       "https://www.googleapis.com/auth/firebase.messaging";
//   Future<String> getAccessToken() async {
//     final client = await clientViaServiceAccount(
//         ServiceAccountCredentials.fromJson({
//           "type": "service_account",
//           "project_id": "trucker-edge-b4b57",
//           "private_key_id": "89336d595736bb85e4c9b835b3bcd46af6b9e963",
//           "private_key":
//               "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDfy6+YVLMhD+X9\nQ3kJNcnWb0BHERVw/c0TBszoD7+fX9iMRcPaVx2xUbw4BfAE4bhcOGPLU5HGQrV1\nuv9HGDEqd++kreRZEARSdzy8x3Ao1h4qSSLUeBP3Dw3BsPp7lt8zE/jXNCW0kB46\nRfcTnW+VWA4hml2fwNPKheWLKQF3kQlTy0gD86mjdjgEVheTucQqeE1JjjTUPVRi\nlWyfCAtHaHYQO9+2m4HVdRCB202xxa7GlPlGtCiaCANTHFepzYMD3w+ZkXI+6tFJ\nd+0cLDwtpRo9brdsf9wScIECNkHASjjyYsxN/l3Pn48XDd8YFWaYrFCa4nInYecu\nxmlwPiKPAgMBAAECggEABasOPdNaB3HJwDoP0YGQ6+o8w4jq5uKBab1mBTP8dwno\nwPPgSelORuLlMPLy4hk2yoAMdh9W9YUbPQY65hYvVCjP8ZN+X6f93OvzifpFY74O\nzqR7WFqDjvA+x7rFAq3kHuCCu0pqDS0KnEk661sKcwPG7hJIflM52Dy/RifPY9Ao\nkxavnwh4t9Bveai5bImVrmaI0H9FdU5bKwr7I7gB0I/v9D8QNZXsuXlnI8c8Gy1j\nyFjr588D3tcNFPpGlLPYE8oWefT+K+vIz2T9tUFrZ8vw9leLExOFXt1+wRhY4dTT\n5tI8MDMxJYW8ZFDAEZY0gavNUmM79j/TbRh77wSB4QKBgQD3Munbc/7/U+x3kuNJ\nUsyO6SZWaN+X/mgdH0l5NzKSm9Hih67ewyy2na9oIIGoi0hBrszSCDE+SKYUoqch\nvAqWYQrusbmA9dMlM9ZGnsuOi02uGGislSjd7DBaG3+oZ/A7jw1gaN5HGcC7y/Yq\nBy4w5KLxqGp7foVJPK2RGJnIPwKBgQDnw3bhdVzo6sl0TxOQ7wNzmXh4iyiP007l\ngyhzTmXmZGhh+yOP3u8mEI/Fo2vuJ/1w3oGh6d66316NKW/P78CTjJyQ1Vl9nHwZ\nMsbazaRMl4bBhpJKY9oNHlHt/G0wvAKIYjulnJjYuItvmm3cbXuhaD8PZ7uL+tLL\n5n4QpMGRsQKBgAsNOatYCkR8Cgxmgsbabs7M2avvUF/JPfpfVbeXoikv0jhgfI71\nBuC7OAZdva49W+Oj3wBc4Wa5dMNjajl14LtMZ2K4i2SamPAG20OZAdzDmZt49+UP\nXh5d2uOMay6qRvFCugRfa+Cd5CIBQmYqoAQLlMVdFDWlOGxHzDK6eNWdAoGBAIxU\nnCzTpVgaobRdFRnSvyJFsN48VGkRp1ns2pdGxwiDj3iUWeoJMIC50nP3CakAacLn\n11I0i3pXOab7igo7vz0YDMzdgfw+vh1701A05+DAdwXC9903LJZ4317cUzkI/fea\nk0cp1JqU00jWFuM7H3qR5mzrgHG3g9+WRorJV7NhAoGBAMH3ZstMYinHRNPvGf7R\nuTtiChk4EI1KQqr+fd0EpktF/Pp+9tsN6J9u29ZDN+ZwYGRxyIqVCfxyDP6+YevG\nvJHXZgSFpKfXPtJ1nBFtJKEIE2Z6D5o6PqeUGvvrKkgYqbF9gO+GhoL3Bc5SiRKB\n8bYIOosveHUz/6OBDfJJGoAG\n-----END PRIVATE KEY-----\n",
//           "client_email":
//               "firebase-adminsdk-g54bi@trucker-edge-b4b57.iam.gserviceaccount.com",
//           "client_id": "111383995762239926889",
//           "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//           "token_uri": "https://oauth2.googleapis.com/token",
//           "auth_provider_x509_cert_url":
//               "https://www.googleapis.com/oauth2/v1/certs",
//           "client_x509_cert_url":
//               "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-g54bi%40trucker-edge-b4b57.iam.gserviceaccount.com",
//           "universe_domain": "googleapis.com"
//         }),
//         [firebaseMessagingToken]);
//     final accessToken = client.credentials.accessToken.data;
//     return accessToken;
//   }
// }
