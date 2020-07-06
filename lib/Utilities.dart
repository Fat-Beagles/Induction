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
}