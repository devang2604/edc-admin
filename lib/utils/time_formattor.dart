import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeFormatattor {
  static String getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return "${years}y";
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return "${months}mo";
    } else if (difference.inDays > 0) {
      return "${difference.inDays}d";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m";
    } else {
      return "Just now";
    }
  }

  /// Returns a string representing the time ago in words.
  /// If more than 1 day ago, returns the date in the format of 'MMM d, yyyy'.
  static String getTimeAgoInWords(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);
    if (difference.inDays > 0) {
      return DateFormat('MMM d, yyyy').format(date);
    } else {
      return getTimeAgo(timestamp);
    }
  }

  static String getDateAndTime(Timestamp createdAt) {
    var date = createdAt.toDate();
    var formatter = DateFormat('dd MMM yyyy, hh:mm a');
    return formatter.format(date);
  }

  static String getTimeFromDatetimeString(String dateTimeString) {
    //Ex. 10:00 AM
    var formatter = DateFormat('hh:mm a');
    DateTime dateTime = DateTime.parse(dateTimeString);
    return formatter.format(dateTime);
  }

  static String timeFromDatetime(DateTime dateTime) {
    //Ex. 10:00 AM
    var formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  static String getDateFromDateTime(DateTime dateTime) {
    //Ex. 15 Oct
    var formatter = DateFormat('dd MMM');
    return formatter.format(dateTime);
  }

//Steam of type boolean
  static Stream<int> availabilityStream(
      DateTime? bookingStart, DateTime? bookingEnd) {
    if (bookingStart == null || bookingEnd == null) {
      return Stream.value(-1);
    }
    //Return 1 if current time is between bookingStart and bookingEnd or 2 minutes before bookingStart
    //Return 0 if current time 2 hours is after bookingEnd
    return Stream.periodic(const Duration(microseconds: 5), (i) {
      DateTime now = DateTime.now();
      if (now.isAfter(bookingStart.subtract(const Duration(minutes: 2))) &&
          now.isBefore(bookingEnd)) {
        return 1;
      } else if (now.isAfter(bookingEnd.add(const Duration(hours: 2)))) {
        return 0;
      } else {
        return -1;
      }
    });
  }
}
