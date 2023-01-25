// ///Methods
// validateEmail(String? value) {
//   String pattern =
//       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//       r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//       r"{0,253}[a-zA-Z0-9])?)*$";
//   RegExp regex = RegExp(pattern);
//   if (value == null || value.isEmpty || !regex.hasMatch(value)) {
//     return 'Enter a valid email address';
//   } else {
//     return null;
//   }
// }

// validatePassword(String? value, {String? password2}) {
//   RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
//   if (value!.isEmpty) {
//     return "Password must be at least 8 characters long";
//   } else if (value.length < 8) {
//     return ("Password must be more than 8 characters");
//   } else if (!regex.hasMatch(value)) {
//     return ("Have upper & lower character and at least 1 digit");
//   } else if (password2 != null && password2 != value) {
//     return ("Passwords do not match");
//   } else {
//     return null;
//   }
// }

// validateRequired(String? value) {
//   if (value!.isEmpty) {
//     return "This field is required";
//   } else {
//     return null;
//   }
// }

// validatePhoneNumber(String? value) {
//   RegExp regExp = RegExp(r'^[0-9]+$');
//   if (value!.isEmpty) {
//     return 'Please enter your 10 digit Mobile Number';
//   }
//   if (value.length != 10) {
//     return 'Mobile Number must be of 10 digit';
//   } else if (!regExp.hasMatch(value)) {
//     return "This field should only contains number. e.g. 2";
//   } else {
//     return null;
//   }
// }

// validateInteger(String? value) {
//   RegExp regExp = RegExp(r'^[0-9]+$');
//   if (value!.isEmpty) {
//     return "This field is required";
//   } else if (!regExp.hasMatch(value)) {
//     return "This field should only contains number. e.g. 2";
//   } else {
//     return null;
//   }
// }

class Validators {
  static String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value, {String? password2}) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (value!.isEmpty) {
      return "Password must be at least 8 characters long";
    } else if (value.length < 8) {
      return ("Password must be more than 8 characters");
    } else if (!regex.hasMatch(value)) {
      return ("Have upper & lower character and at least 1 digit");
    } else if (password2 != null && password2 != value) {
      return ("Passwords do not match");
    } else {
      return null;
    }
  }

  static String? validateRequired(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? value) {
    RegExp regExp = RegExp(r'^[0-9]+$');
    if (value!.isEmpty) {
      return 'Please enter your 10 digit Mobile Number';
    }
    if (value.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else if (!regExp.hasMatch(value)) {
      return "This field should only contains number. e.g. 2";
    } else {
      return null;
    }
  }

  static String? validateInteger(String? value) {
    RegExp regExp = RegExp(r'^[0-9]+$');
    if (value!.isEmpty) {
      return "This field is required";
    } else if (!regExp.hasMatch(value)) {
      return "This field should only contains number. e.g. 2";
    } else {
      return null;
    }
  }

  //To validate user name
  static String? validateUserName(String? value) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (value!.isEmpty) {
      return "This field is required";
    } else if (!regExp.hasMatch(value)) {
      return "This field should only contains number and character. e.g. 2";
    } else {
      return null;
    }
  }
}
