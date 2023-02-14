import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/common_widget/Platform_Duyarli_Alert_Dialog/platform_duyarli_alert_dialog.dart';
import 'package:notes/const.dart';
import 'package:notes/models/settings.dart';
import 'package:notes/services/database_helper.dart';
import 'package:notes/ui/Archive_page/archive_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color currentColor;
  Color currentColorDark;
  Color currentColorlight;
  Settings settings = Settings();

  String passwordStr, showPassword = "";
  double ekranYuksekligi, ekranGenisligi;
  bool show = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    currentColor = settings.currentColor;
    passwordStr = settings.password;
    prepareShowPassword();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ekranYuksekligi = size.height;
    ekranGenisligi = size.width;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////appbar guzel olur
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: currentColorDark),
          title: Text(
            "Ayarlar",
            style: TextStyle(color: currentColorDark),
          ),
          backgroundColor: currentColor,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: currentColor,
        body: Column(
          children: [
            // buildHeader(size),
            SizedBox(height: 10),
            changeColorWiget(),
            SizedBox(height: 10),
            currentPassword(),
            SizedBox(height: 10),
            changePassword(),
            Column(
              children: [
                Text(
                  "Uygulamayı Parolasız Kullanmak İçin ",
                  style: headerStyle7.copyWith(color: Colors.grey.shade900),
                ),
                Text(
                  "Parolayı Boş Giriniz ",
                  style: headerStyle7.copyWith(color: Colors.grey.shade900),
                ),
              ],
            ),
            SizedBox(height: 40),
            saveButton(),
            SizedBox(height: 40),
            archiveButton(),
          ],
        ),
      ),
    );
  }

  prepareShowPassword() {
    if (passwordStr != null) {
      setState(() {
        showPassword = "*" * (passwordStr.length);
      });
    }
  }

  Widget buildHeader(Size size) {
    return Container(
      height: 180,
      width: ekranGenisligi,
      color: Colors.grey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: Text(
              "Ayarlar",
              style: headerStyle6,
            ),
          ),
        ],
      ),
    );
  }

  Widget changeColorWiget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Tema Rengi",
            style: headerStyle7.copyWith(color: Colors.grey.shade900),
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade400, elevation: 3),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Bir Renk Seçin"),
                    content: SingleChildScrollView(
                      child: MaterialPicker(
                          pickerColor: settings.currentColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              currentColor = color;
                              settings.currentColor = color;
                            });
                            Navigator.pop(context);
                          }),
                    ),
                  );
                },
              );
            },
            child: Text(
              "Renk Seç",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }

  Widget currentPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Şuanki Parola: ",
          style: headerStyle7.copyWith(color: Colors.grey.shade900),
        ),
        Text(
          passwordStr == ""
              ? "Şuan Parolanız Yok"
              : show
                  ? passwordStr
                  : showPassword,
          style: passwordStr == ""
              ? TextStyle(fontSize: 11)
              : TextStyle(fontSize: 20),
        ),
        passwordStr != null
            ? GestureDetector(
                child: Icon(show ? Icons.visibility_off : Icons.visibility),
                onTap: () {
                  setState(() {
                    show = !show;
                    //show dialog ile guvenlik sorusu filan sorulabılır
                  });
                },
              )
            : Container(
                width: 30,
              )
      ],
    );
  }

  Widget changePassword() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 12, bottom: 24),
      child: GestureDetector(
          child: Container(
            height: 55,
            width: ekranGenisligi,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(3),
              ),
              color: Colors.grey.shade400,
            ),
            child: Center(
              child: Text(
                "Parola Değiştir ",
                style: headerStyle7.copyWith(color: Colors.grey.shade900),
              ),
            ),
          ),
          onTap: () {
            buildForm();
          }),
    );
  }

  void buildForm() {
    GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
    GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
    String password1;
    String oldPassword = settings.password;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Yeni Parolanızı Giriniz",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Form(
                key: formKey1,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      labelText: "Parola",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value.length == 0) {
                        password1 = value;
                        return null;
                      } else {
                        if (value.length <= 3) {
                          return "Lütfen en az 4 karakter giriniz";
                        } else {
                          password1 = value;

                          return null;
                        }
                      }
                    },
                  ),
                ),
              ),
              Form(
                key: formKey2,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      labelText: "Parola tekrarı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != password1) {
                        return "Girilen parolalar eşleşmiyor!!";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                    child: Text(
                      "İptal ❌",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    child: Text(
                      "Kaydet 💾",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      try {
                        if (formKey1.currentState.validate() &&
                            formKey2.currentState.validate()) {
                          passwordStr = password1;
                          settings.password = passwordStr;
                          int sonuc =
                              await databaseHelper.updatePassword(passwordStr);
                          if (sonuc > 0) {
                            print("parola yenılendi");
                          } else {
                            print("parola yenileme basarısız");
                          }
                          prepareShowPassword();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(passwordStr == ""
                                ? "Parola başarıyla KALDIRILDI  👌"
                                : "Parola başarıyla değiştirildi 👌"),
                            duration: Duration(seconds: 2),
                          ));
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e);
                        PlatformDuyarliAlertDialog(
                                baslik:
                                    "Kaydetme Başarısız Oldu :( \nŞuanki Parolanız: ' " +
                                        oldPassword.toString() +
                                        " '",
                                icerik: "Hata: " + e.toString(),
                                anaButonYazisi: "Tamam")
                            .goster(context);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget saveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.black,
            ),
            height: 50,
            width: 50,
            child: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
          ),
          onTap: () {
            refreshTheme();
          },
        ),
        SizedBox(
          width: 150,
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.black,
            ),
            height: 50,
            width: 50,
            child: Icon(
              Icons.save,
              color: Colors.white,
              size: 30,
            ),
          ),
          onTap: () {
            saveTheme();
          },
        ),
      ],
    );
  }

  Future refreshTheme() async {
    try {
      int sonuc = await databaseHelper.updateTheme("4293914607");
      if (sonuc == 0) print("database updatetheme fonksıyonunda hata oldu");
      settings.currentColor = Color(4293914607);
      setState(() {
        settings.currentColor = Color(4293914607);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Tema rengi değiştirildi 👌"),
        duration: Duration(seconds: 2),
      ));
      Navigator.pop(context, "refreshed");
    } catch (e) {
      PlatformDuyarliAlertDialog(
              baslik: "Tema rengi varsayılana dönme işlemi başarısız oldu.",
              icerik: "Hata: " + e.toString(),
              anaButonYazisi: "Tamam")
          .goster(context);
    }
  }

  Future saveTheme() async {
    try {
      int sonuc =
          await databaseHelper.updateTheme(currentColor.value.toString());
      if (sonuc == 0) print("database updatetheme fonksıyonunda hata oldu");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Tema rengi kaydedildi 👌"),
        duration: Duration(seconds: 2),
      ));
      setState(() {});
      Navigator.pop(context, "saved");
    } catch (e) {
      PlatformDuyarliAlertDialog(
              baslik: "Tema rengi değiştirme işlemi başarısız oldu.",
              icerik: "Hata: " + e.toString(),
              anaButonYazisi: "Tamam")
          .goster(context);
    }
  }

  Widget archiveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ////// şifre sorulmalı
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ArchivePage()));
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.black,
              ),
              height: 50,
              width: 50,
              child: Icon(
                Icons.archive_outlined,
                color: Colors.white,
                size: 30,
              )),
        ),
        SizedBox(
          width: 150,
        ),
        visibilityButton(),
      ],
    ); ////icon size ve konum
  }

  Widget visibilityButton() {
    return GestureDetector(
      onTap: () async {
        settings.visibility = settings.visibility == 1 ? 0 : 1;
        await databaseHelper
            .updateVisibility(settings.visibility)
            .then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(settings.visibility == 0
                          ? "Son notlar gizlendi! 👌"
                          : "Son notlar görünür yapıldı! 👌"),
                      duration: Duration(seconds: 3),
                    ),
                  ),
                  setState(() {})
                });
        setState(() {});
        Navigator.pop(context, "saved");

        ////// şifre sorulmalı
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.black,
          ),
          height: 50,
          width: 50,
          child: Icon(
            settings.visibility == 1 ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
            size: 30,
          )),
    ); ////icon size ve konum}
  }
}
