class User{
  String name;
  String role;
  String password;

  static User user = null;

  static User getInstance(){
    if(user == null)
        user = User();
    return user;
  }

  bool isAdmin(){
    return role == "admin";
  }

  bool isAdminOrEditor(){
    return role == "editor" || role == "admin";
  }

  void save() async{
    // TODO - implement
  }

  void forget() async{
    user = null;
  }
}