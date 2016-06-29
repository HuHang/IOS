//
//  Global.swift
//  Checkin
//
//  Created by Rajat Lala on 16/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import Foundation

var countryName : NSString!
var Working_Task : NSString!
var TimerString : NSString!
var TimerMinutes : NSString!
var strBeginTime : String!
var strFinishTime : String!
var taskList : NSMutableArray!
var WorkingList : NSMutableArray!
var taskListCode : NSMutableArray!
var WorkingListCode : NSMutableArray!
var WorkingListCheckinValidation : NSMutableArray!
var WorkingListCheckoutValidation : NSMutableArray!
var CityDictionary : NSMutableDictionary!
var InternetONOFF : NSString!
var Validation : NSString!
var Task_Code : NSString!
var Working_Code : NSString!
var RefreshAfterSubmit : Bool!

var CountryCodeString : String!

var greeting : NSString!
var timer:NSTimer = NSTimer()

var HistoryData : NSMutableArray!
var HistoryClickedData : NSMutableDictionary!




let IS_IPHONE_5 = UIScreen.mainScreen().bounds.size.height == 568 ? true : false as Bool
let IS_IPHONE_4 = UIScreen.mainScreen().bounds.size.height == 480 ? true : false as Bool
let IS_IPHONE_6 = UIScreen.mainScreen().bounds.size.height == 667 ? true : false as Bool
let IS_IPHONE_6_plus = UIScreen.mainScreen().bounds.size.height == 736 ? true : false as Bool
let  IS_IOS8_AND_UP  = (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0
let IS_iPad = UIScreen.mainScreen().bounds.size.height == 1024 ? true : false as Bool

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
