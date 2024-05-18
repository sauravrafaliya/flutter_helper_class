
import 'package:intl/intl.dart';

extension DateUtils on DateTime{

  String get dayMonthYear{
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String get yearMonthDay{
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get bookingFormat{
    return DateFormat('E, MMM d yyyy').format(this);
  }

  String get notificationFormat{
    return DateFormat('MMM d yyyy | h:mm a').format(copyWith(isUtc: true));
  }

  String get weekMDYFormat{
    return DateFormat('EEEE, MMMM dd, yyyy').format(this);
  }


  String get showFormat{
    return DateFormat('E, MMM d yyyy').format(this);
  }

  String get dateToFullStringDate{
    return DateFormat('dd-MM-yyyy hh:mm:ss').format(this);
  }

  String get monthDay{
    return DateFormat('MMMM dd').format(this);
  }

  String get hourMinA{
    return DateFormat('h:mm a').format(copyWith(isUtc: true));
  }

  bool get isToday{
    if(DateTime.now().difference(onlyDate).inDays == 0){
      return true;
    }else{
      return false;
    }
  }

  int get yearsFrom {
    final currentDate = DateTime.now();
    final yearDifference = currentDate.year - year;
    return yearDifference;
  }

  int get monthsFrom{
    final currentDate = DateTime.now();
    final yearDifference = currentDate.year - year;
    final monthDifference = currentDate.month - month;
    return yearDifference * 12 + monthDifference;
  }

  int get weeksFrom{
    final currentDate = DateTime.now();
    final difference = currentDate.difference(copyWith(isUtc: true));
    return (difference.inDays / 7).floor();
  }

  int get daysFrom{
    final currentDate = DateTime.now();
    final difference = currentDate.difference(copyWith(isUtc: true));
    return difference.inDays;
  }

  int get hoursFrom{
    final currentDate = DateTime.now();
    final difference = currentDate.difference(copyWith(isUtc: true));
    return difference.inHours;
  }

  int get minutesFrom{
    final currentDate = DateTime.now();
    final difference = currentDate.difference(copyWith(isUtc: true));
    return difference.inMinutes;
  }

  int get secondsFrom{
    final currentDate = DateTime.now();
    final difference = currentDate.difference(copyWith(isUtc: true));
    return difference.inSeconds;
  }

  String get getCommentTime {
    final sec = secondsFrom;
    final min = minutesFrom;
    final hour = hoursFrom;
    final day = daysFrom;
    final month = monthsFrom;
    final year = yearsFrom;

    if (sec < 60) {
      return '${sec}s ago';
    } else if (min < 60) {
      return '${min}m ago';
    } else if (hour < 24) {
      return '${hour}h ago';
    } else if (day <= 31) {
      return '${day}d ago';
    } else if (month <= 12) {
      return '${month} mon ago';
    } else {
      return '${year}y ago';
    }
  }

  String get getNotificationTime{
    final sec = secondsFrom;
    final min = minutesFrom;
    if (sec < 60) {
      return '${sec}s ago';
    } else if (min < 60) {
      return '${min}m ago';
    } else {
      return hourMinA;
    }
  }

  String get bookingDayLabel{
    if(isToday){
      return "Today";
    }else if(isYesterday){
      return "Yesterday";
    }else{
      return monthDay;
    }
  }

  bool get isYesterday{
    if(DateTime.now().difference(onlyDate.copyWith(isUtc: true)).inDays == 1){
      return true;
    }else{
      return false;
    }
  }

  DateTime get onlyDate{
    return DateTime(year,month,day);
  }

}

extension StringToDate on String{

  DateTime get dmyStringToDate{
    return DateFormat('dd-MM-yyyy').parse(this);
  }

  DateTime get fullStringToDate{
    return DateFormat('dd-MM-yyyy hh:mm:ss').parse(this).copyWith(isUtc: true);
  }

  DateTime get timeToDate{
    return DateFormat('hh:mm:ss').parse(this);
  }

  DateTime get ymdStringToDate{
    return DateFormat('yyyy-MM-dd').parse(this);
  }

  String get bookingDayLabel{
    if(dmyStringToDate.isToday){
      return "Today";
    }else if(dmyStringToDate.isYesterday){
      return "Yesterday";
    }else{
      return dmyStringToDate.monthDay;
    }
  }

}