//
//  CheckinTimer.swift
//  Checkin
//
//  Created by Rajat Lala on 15/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit




class CheckinTimer: UIViewController , popUpViewDelegate1, popUpCheckOutDelegate,MBProgressHUDDelegate {
    
    var popupCheckout : PopupForCheckOut!

    
    var strCheckinCheckout : NSString!
    var ticks : Double = 0.0
    var HUD : MBProgressHUD!
    var secs:Int = 0
    
    @IBOutlet var lblHourLogged: UILabel!
    
    var startTime = NSTimeInterval()
    //var timer:NSTimer = NSTimer()
    var sysDate:NSDate=NSDate()
    
    
    var popUpViewObjTime : PopupAlertVC!
    
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnCheckOut: UIButton!
   
    @IBOutlet var lblTimer: UILabel!

   
    override func viewWillAppear(animated: Bool)
    {
        btnCheckOut.showsTouchWhenHighlighted = true
//        btnLogout.enabled = false
//        btnLogout.hidden = true
        //begin time
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        strBeginTime = timeFormatter.stringFromDate(date) as String
        print("beginTime :%@",strBeginTime)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "timerInvalidate:", name:"timerInvalidate", object: nil)

        if((NSUserDefaults.standardUserDefaults().valueForKey("TimerTimer")) != nil)
        {
            secs = Int(NSUserDefaults.standardUserDefaults().valueForKey("TimerTimer")as! String)!
        }
        else
        {
            secs = JsonClass.uptime()
            NSUserDefaults.standardUserDefaults().setObject(String(format: "%d", secs), forKey: "TimerTimer")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        if(appDelegate.checkInternetConnection())
        {
            strCheckinCheckout="CheckinCall"
            self.JSONcall()
            InternetONOFF="ON"
        }
        else
        {
            NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "SystemTime")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            InternetONOFF="OFF"
        }
        
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        lblHourLogged.text=NSLocalizedString("HOURS_LOG", comment: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "CHECKOUTCALL")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        btnCheckOut.setTitle(NSLocalizedString("CHECK_OUT", comment: ""), forState: UIControlState.Normal)
        
        btnCheckOut.layer.cornerRadius = 5

    }
    func JSONcall()
    {
        if(self.strCheckinCheckout .isEqualToString("CheckoutCall"))
        {
        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.labelText = NSLocalizedString("PLEASE_WAIT", comment: "")
        HUD.delegate=self
        self.HUD.show(true)
        }
        JsonClass.JsonCallBackTime("http://192.168.1.27:8000/api/v1/system/utc", username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: "", sucessBlock: { (responce:AnyObject!) -> Void in
            
            if(self.strCheckinCheckout .isEqualToString("CheckinCall"))
            {
                NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "CheckinInterNet")
            }
            else
            {
                NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "CheckoutInterNet")
                self.HUD.hide(true)
              
                self.Redirect()
            }
            
            NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "SystemTime")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let strDate = responce as! NSDictionary
            print(strDate .valueForKey("date"))
            
            //UTC to LocalTimeZone
            let someDateInUTC  = (strDate .valueForKey("date")) as! NSString
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date : NSDate = formatter.dateFromString(someDateInUTC as String)!
            
            self.sysDate = formatter.dateFromString(someDateInUTC as String)!
            
            formatter.timeZone = NSTimeZone.localTimeZone()
            let timeStamp = formatter.stringFromDate(date)
            print(timeStamp)
            
        if(NSUserDefaults.standardUserDefaults().valueForKey("CheckinDate") == nil)
            {
                NSUserDefaults.standardUserDefaults().setObject(date, forKey: "CheckinDate")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            }) { (error:NSError!) -> Void in
                NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "SystemTime")
                NSUserDefaults.standardUserDefaults().synchronize()
                print(error)
                if(self.strCheckinCheckout .isEqualToString("CheckinCall"))
                {
                    NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "CheckinInterNet")
                }
                else
                {
                    NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "CheckoutInterNet")
                    self.HUD.hide(true)
                    self.Redirect()
                }
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            break
            
        case .PortraitUpsideDown:
            break
            
        case .LandscapeLeft:
            break
            
        case .LandscapeRight:
            break
            
        default:
            break
            
        }

    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    }

    func Redirect()
    {
        let popUpViewObjTime = PopupForCheckOut(nibName : "PopupForCheckOut", bundle : nil)
        popUpViewObjTime.delegate = self
        self.presentPopupViewController(popUpViewObjTime, animationType: MJPopupViewAnimationFade)

    }
    @IBAction func btnCheckOut(sender: AnyObject)
    {
        strCheckinCheckout="CheckoutCall"
       // self.JSONcall()
        
        //finish time
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        strFinishTime = timeFormatter.stringFromDate(date) as String
        print("finishTime :%@",strFinishTime)
        
        NSUserDefaults.standardUserDefaults().setObject(lblTimer.text, forKey: "TimerString")
        NSUserDefaults.standardUserDefaults().setObject(TimerMinutes, forKey: "TimerMinutes")
        NSUserDefaults.standardUserDefaults().setObject(strBeginTime, forKey: "strBeginTime")
        NSUserDefaults.standardUserDefaults().setObject(strFinishTime, forKey: "strFinishTime")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let popUpViewObjTime = PopupForCheckOut(nibName : "PopupForCheckOut", bundle : nil)
        popUpViewObjTime.delegate = self
        self.presentPopupViewController(popUpViewObjTime, animationType: MJPopupViewAnimationFade)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLogout(sender: AnyObject)
    {
       

        NSUserDefaults.standardUserDefaults().setObject(TimerString, forKey: "TimerString")
        NSUserDefaults.standardUserDefaults().setObject(TimerMinutes, forKey: "TimerMinutes")
        NSUserDefaults.standardUserDefaults().synchronize()

        
        popUpViewObjTime = PopupAlertVC(nibName : "PopupAlertVC", bundle : nil)
        
        popUpViewObjTime.delegate = self
        
        self.presentPopupViewController(popUpViewObjTime, animationType: MJPopupViewAnimationFade)
        
    }
    
    func dismissPopUpViewYes(view: UIViewController!) {
    
        
    dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "tosterDipslay")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Login") as! ViewController
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinDescription") as! CheckinDescription
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func dismissPopUpViewNo(view: UIViewController!)
    {
    dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }

    
    func dismissPopUpCheckOutYes(view: UIViewController!) {
        
        timer.invalidate()
//        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "CheckIn")
        NSUserDefaults.standardUserDefaults().setObject("YES" , forKey: "tosterDipslay")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "CheckIn")
        NSUserDefaults.standardUserDefaults().synchronize()

    dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        
       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinDescription") as! CheckinDescription
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinTimer") as! CheckinTimer
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func dismissPopUpCheckOutNo(view: UIViewController!)
    {
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    func updateTime()
    {
        let seconds:Int = (JsonClass.uptime() - secs)
        let hh:Int = seconds / 3600
        let mm:Int = seconds / 60 % 60
        let ss:Int = seconds % 60
        
        let strHours = String(format: "%02d",hh)
        let strMinutes = String(format: "%02d",mm)
        let strSeconds = String(format: "%02d",ss)
        
        
        if(timer.valid)
        {
            //let tmpMin : Int = (seconds/60)>10
            
//            if(ss>30)
//            {
//                TimerMinutes = String(format: "%d.0", (seconds / 60) + 1)
//            }
//            else
//            {
//                TimerMinutes = String(format: "%d.0", seconds / 60)
//            }
            TimerMinutes = String(format: "%d.0", seconds)
            print(TimerMinutes)
            NSLog("TimerMinu:qtes : %@", TimerMinutes)
            
//            var TM: Float? = 0;
//            TM = Float(TimerMinutes as String)
            
            if(seconds < 30)
            {
                btnCheckOut.enabled = false
//                btnLogout.enabled = false
                lblTimer.hidden = false
                
                btnCheckOut.backgroundColor=UIColor(red: 128.0/255.0, green: 205.0/255.0, blue: 237.0/255.0, alpha: 1.0)
            }
            else
            {
                btnCheckOut.enabled = true
//                btnLogout.enabled = true
                lblTimer.hidden = true
                
                btnCheckOut.backgroundColor=UIColor(red: 1.0/255.0, green: 156.0/255.0, blue: 220.0/255.0, alpha: 1.0)
                
            }
            
//            TimerString="\(strHours):\(strMinutes):\(strSeconds)"
            TimerString="\(strHours):\(strMinutes):\(seconds)"
            NSLog("TimerString : %@", TimerString)
            lblTimer.text = "\(strHours):\(strMinutes):\(strSeconds)"
            
            if(hh < 0 || mm < 0 || hh < 0)
            {
                self.timeInvalide()
                
                let msg = NSLocalizedString("DATA_CHANGE", comment: "")
                let alert: UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
            }
        }
        else
        {
            let msg = NSLocalizedString("DATA_CHANGE", comment: "")
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
            alert.message = msg
            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if (buttonIndex == 0) {
        
            NSUserDefaults.standardUserDefaults().setObject(TimerMinutes, forKey: "TimerMinutes")

            popupCheckout=PopupForCheckOut()
            popupCheckout.callingJsonMethod()
                        
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Login") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func timeInvalide()
    {
        timer.invalidate()
    }
    @objc func timerInvalidate(notification: NSNotification)
    {
        timer.invalidate()
    }
}
