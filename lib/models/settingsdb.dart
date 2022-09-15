class SettingsDb {
  String password;
  String theme;
  String sort;
  int visibility;

  SettingsDb(this.password, this.theme, this.sort, this.visibility);
  SettingsDb.fromMap(Map<String, dynamic> settingsMMap) {
    this.password = settingsMMap["password"];
    this.theme = settingsMMap["theme"];
    this.sort = settingsMMap["sort"];
    this.visibility = settingsMMap["visibility"];
  }
  @override
  String toString() {
    return 'SettingsDB{password: $password,theme: $theme, sort: $sort, visibility:$visibility}';
  }
}
