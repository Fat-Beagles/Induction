import 'dart:math';

import 'package:flutter/material.dart';

class Utilities {
  static double guidelineBaseWidth = 375;
  static double guidelineBaseHeight = 812;

  static double scale(double x, BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return (width/guidelineBaseWidth)*x;
  }

  static double vScale(double x, BuildContext context){
    double height = MediaQuery.of(context).size.height;
    return (height/guidelineBaseHeight)*x;
  }

  static double getRoundImageSize(double size, BuildContext context){
    return min(Utilities.scale(size, context), Utilities.vScale(size, context));
  }

  static String getMonthString(int x){
    String month = "";
    switch(x){
      case 1: {
        month="JAN";
      }
      break;
      case 2: {
        month="FEB";
      }
      break;
      case 3: {
        month="MAR";
      }
      break;
      case 4: {
        month="APR";
      }
      break;
      case 5: {
        month="MAY";
      }
      break;
      case 6: {
        month="JUNE";
      }
      break;
      case 7: {
        month="JULY";
      }
      break;
      case 8: {
        month="AUG";
      }
      break;
      case 9: {
        month="SEPT";
      }
      break;
      case 10: {
        month="OCT";
      }
      break;
      case 11: {
        month="NOV";
      }
      break;
      case 12: {
        month="DEC";
      }
      break;
    }
    return month;
  }

  static String getWeekDayString(int x){
    String wdd = '';
    switch(x){
      case 1: {
        wdd = 'MONDAY';
      }
      break;
      case 2: {
        wdd = 'TUESDAY';
      }
      break;
      case 3: {
        wdd = 'WEDNESDAY';
      }
      break;
      case 4: {
        wdd = 'THURSDAY';
      }
      break;
      case 5: {
        wdd = 'FRIDAY';
      }
      break;
      case 6: {
        wdd = 'SATURDAY';
      }
      break;
      case 7: {
        wdd = 'SUNDAY';
      }
      break;
    }
    return wdd;
  }

  static int compareEvents(dynamic a, dynamic b){
    int startA = int.parse(a['startTime'].toString());
    int startB = int.parse(b['startTime'].toString());
    if(startA < startB){
      return -1;
    }
    else if(startA > startB){
      return 1;
    }
    else{
      return 0;
    }
  }

  static int compareDays(String a, String b){
    List<String> dateA = a.split('-');
    int yearA = int.parse(dateA[2].split(' ')[1]);
    List<String> dateB = b.split('-');
    int yearB = int.parse(dateB[2].split(' ')[1]);
    if(yearA<yearB){
      return -1;
    }
    else if(yearA>yearB){
      return 1;
    }
    else{
      if(int.parse(dateA[1])<int.parse(dateB[1])){
        return -1;
      }
      else if(int.parse(dateA[1])>int.parse(dateB[1])){
        return 1;
      }
      else{
        if(int.parse(dateA[0])<int.parse(dateB[0])){
          return -1;
        }
        else if(int.parse(dateA[0])>int.parse(dateB[0])){
          return 1;
        }
        else{
          return 0;
        }
      }
    }
  }

  static MaterialColor getGroupColor(String color){
    MaterialColor colorToReturn = Colors.grey;
    try{
      switch(color.toLowerCase()){
        case "red": {
          colorToReturn = Colors.red;
        }
        break;
        case "blue": {
          colorToReturn = Colors.blue;
        }
        break;
        case "green": {
          colorToReturn = Colors.green;
        }
        break;
        case "black": {
          colorToReturn = Colors.black;
        }
        break;
      }
    }
    finally {
      // Do nothing. Just to check if color is a string.
    }
    return colorToReturn;
  }
}