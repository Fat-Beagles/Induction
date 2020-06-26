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
  static String getMonthString(int x){
    String month = "";
    switch(x){
      case 1: {
        month="JANUARY";
      }
      break;
      case 2: {
        month="FEBRUARY";
      }
      break;
      case 3: {
        month="MARCH";
      }
      break;
      case 4: {
        month="APRIL";
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
        month="AUGUST";
      }
      break;
      case 9: {
        month="SEPTEMBER";
      }
      break;
      case 10: {
        month="OCTOBER";
      }
      break;
      case 11: {
        month="NOVEMBER";
      }
      break;
      case 12: {
        month="DECEMBER";
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
}