//
//  CheckinDescription.swift
//  Checkin
//
//  Created by Rajat Lala on 15/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit
import CoreLocation

class CheckinDescription: UIViewController,CLLocationManagerDelegate,popUpViewDelegate1,getWorkingTaskDelgate,popUpDelegate,MPGTextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, MBProgressHUDDelegate,popUpKpiIDDelegate {
    
    // MARK: - Declaration
    // MARK:
    
    let locationManager = CLLocationManager()
    @IBOutlet var viewPopup : UIView!
    var flagpopup : Bool!

    
    var HUD : MBProgressHUD!

    var arrsearchingValue : NSMutableArray = []
    var arrAllProjectnumber : NSMutableArray = []
    var arrAll : NSMutableArray = []
    var PendingArray : NSMutableArray = []
    var defaults : NSUserDefaults?
    @IBOutlet var tblserachingList: UITableView!
    @IBOutlet var srcollviewObj:UIScrollView!
    
    var touchScroll : UITapGestureRecognizer!
    var touchView : UITapGestureRecognizer!
    
    
    
    var projectNumber : NSString!
    var userName : String!
    
    var PendingData : PopupAlertVC!
    
    @IBOutlet var lblQuote: UILabel!
    //@IBOutlet var txtProjectNumber: UITextField!
    @IBOutlet var txtProjectNumber: MPGTextField!

    @IBOutlet var btnChange: UIButton!
    @IBOutlet var btnCheckIn: UIButton!
    @IBOutlet var lblCityName: UILabel!

    @IBOutlet var btnWorkingList: UIButton!
    @IBOutlet var btnTasklist: UIButton!
    @IBOutlet var btnDropWorking: UIButton!
    @IBOutlet var btnDropTask: UIButton!
    
    
    var tmpArray : NSMutableArray = []





    // MARK: - Default Method
    // MARK:
    
    
    override func viewWillAppear(animated: Bool) {
        
        viewPopup.hidden=true
        viewPopup.alpha=0.0;
        flagpopup=false
        
        btnCheckIn.showsTouchWhenHighlighted = true;
        btnChange.showsTouchWhenHighlighted = true;

        if((NSUserDefaults.standardUserDefaults().valueForKey("LOGIN")?.isEqualToString("YES")) != nil)
        {
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "LOGIN")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Login") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "callnotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("notificationCall:"), name: "callnotification", object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        
        lblCityName.text=NSLocalizedString("CHANGE_CITY", comment: "")
        
        if(WorkingList == nil && taskList == nil && CityDictionary == nil)
        {
            if(appDelegate.checkInternetConnection())
            {
                CountryCodeString = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
                print(CountryCodeString)
                self.JSONCall()
            }
            else
            {
                let msg = (NSLocalizedString("NO_INTERNET", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
                let alert: UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
            }
        }
        
        lblQuote.text=greeting as String?

        btnCheckIn.layer.cornerRadius = 5
        btnChange.layer.cornerRadius = 5

        //for Location Update
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        projectNumber = NSUserDefaults.standardUserDefaults().valueForKey("username")! as! NSString
        userName=projectNumber.substringToIndex(6)

        //Define Localized String
        txtProjectNumber.text=NSLocalizedString("PROJECT_NUMBER", comment: "")
        txtProjectNumber.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("PROJECT_NUMBER", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])

        btnChange.setTitle(NSLocalizedString("CHANGE", comment: ""), forState: UIControlState.Normal)
        btnCheckIn.setTitle(NSLocalizedString("CHECK_IN", comment: ""), forState: UIControlState.Normal)
        btnWorkingList.setTitle(NSLocalizedString("WORKING_TYPE", comment: ""), forState: UIControlState.Normal)
        btnTasklist.setTitle(NSLocalizedString("TASK_ID", comment: ""), forState: UIControlState.Normal)
        
        tblserachingList.hidden=true
        tblserachingList.dataSource=self
        tblserachingList.delegate=self
        tblserachingList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        tblserachingList.tableFooterView=UIView(frame: CGRectZero)
        let currentValue = NSUserDefaults.standardUserDefaults().objectForKey("projectnumber")
        print(currentValue)
        
        //Exists
        
        if(currentValue == nil)
        {
            NSUserDefaults.standardUserDefaults() .setObject([""], forKey: "projectnumber")
        }
        else
        {
            self.addvalueInArr()
        }
        
        
        PendingData=PopupAlertVC()
        PendingData.SendPendingData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Notification Call Method
    // MARK:
    func notificationCall(notification:NSNotification)
    {
        let data = notification.userInfo?["msg"] as! NSArray
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let stringentry : String = NSUserDefaults.standardUserDefaults().objectForKey("entry") as! String
            
            if stringentry == "YES"
            {
                //            NSNotificationCenter.defaultCenter().removeObserver(self, name: "callnotification", object: nil)
                
                let stringCheck : String = NSUserDefaults.standardUserDefaults().objectForKey("tosterDipslay") as! String
                
                if (stringCheck == "YES")
                {
                    
                    let alertObj:UIAlertView = UIAlertView.init(title: nil, message: "\(data.objectAtIndex(0))", delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
                    alertObj.show()

                    NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "entry")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            }
        })
    }
    
    

    // MARK: - Keyboard Method
    // MARK:
    func keyboardWillHide(notification: NSNotification)
    {
        tblserachingList.hidden=true
    }
    
    // MARK: - Textfields Method
    // MARK:
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        if(arrsearchingValue.count != 0)
        {
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            print(prospectiveText)
            
            arrsearchingValue = NSUserDefaults.standardUserDefaults().objectForKey("projectnumber")?.mutableCopy() as! NSMutableArray
            
            let resultPredicate = NSPredicate(format: "SELF BEGINSWITH[c] %@", prospectiveText)
            
            let filteredArray_convers = arrsearchingValue.filteredArrayUsingPredicate(resultPredicate) as NSArray
            
            print(arrsearchingValue)
            
            if(filteredArray_convers.count > 0)
            {
                arrAllProjectnumber .removeAllObjects()
                arrAllProjectnumber .addObjectsFromArray(filteredArray_convers as [AnyObject])
                tblserachingList.hidden=false
            }
            
            if(filteredArray_convers.count == 0)
            {
                arrAllProjectnumber.removeAllObjects()
                tblserachingList.hidden=true;
            }
            
            if (prospectiveText.characters.count == 0)
            {
                arrAllProjectnumber.removeAllObjects()
                arrAllProjectnumber .addObjectsFromArray(arrsearchingValue as [AnyObject])
                tblserachingList.hidden=true;
            }
            tblserachingList .reloadData()
        }
        else
        {
            tblserachingList.hidden=true;
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        tblserachingList.hidden=true
        txtProjectNumber.resignFirstResponder()
        srcollviewObj.contentOffset=CGPointMake(0, 0);
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "callScrollUp", userInfo: nil, repeats: false)

    }
    
    // MARK: - Other Method
    // MARK:
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer)
    {
        self.popupClose()
    }
    
    func popupOpen()
    {
        viewPopup.hidden=false
        flagpopup = true
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.viewPopup.alpha=1.0;
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    func popupClose()
    {
        flagpopup = false
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.viewPopup.alpha=0.0;
            }) { (Bool) -> Void in
                self.viewPopup.hidden=true
        }
    }
    
    func callScrollUp()
    {
        if IS_IPHONE_4
        {
            UIView .animateWithDuration(0.3, animations: { () -> Void in
                self.srcollviewObj.contentOffset=CGPointMake(0, 150);
                }) { (Bool) -> Void in}
        }
        else if IS_IPHONE_5
        {
            UIView .animateWithDuration(0.3, animations: { () -> Void in
                self.srcollviewObj.contentOffset=CGPointMake(0, 100);
                }) { (Bool) -> Void in}
        }
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView == srcollviewObj
        {
            
        }
        
    }

    
    // MARK: - Location Method
    // MARK:
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                print("Error:" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0
            {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Error with data")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        self.locationManager.stopUpdatingLocation()
        lblCityName.text = placemark.locality
        print(placemark.addressDictionary)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        countryName = placemark.country
        
        var currentLocale:NSLocale!
        currentLocale = NSLocale.currentLocale()
        let theCountryCode : String! = currentLocale.objectForKey(NSLocaleCountryCode) as? String
        NSUserDefaults.standardUserDefaults().setValue(theCountryCode, forKey: "CountyCode")
        NSUserDefaults.standardUserDefaults().synchronize()
        print(placemark.country)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    func checkLocationServiceOnOff() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
                print("No access")
                return false
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Access")
                return true
                
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    
    func openLocationSettingScreen() {
        if #available(iOS 8.0, *) {
            UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Button Event
    // MARK:
    @IBAction func btnCheckIn(sender: AnyObject)
    {
        
        
        if(
            txtProjectNumber.text=="Project Number" ||
                txtProjectNumber.text=="Projektnummer" ||
                txtProjectNumber.text=="")
        {
            let msg = NSLocalizedString("PROJECT_FIELD", comment: "")//"If you don't allow this app to get your current location, we will not able to validate your city!"
            let alert: UIAlertView = UIAlertView()
            alert.delegate = nil
            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
            alert.message = msg
            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
            alert.show()
        }else if (btnWorkingList.titleLabel?.text == "工作类型" || btnTasklist.titleLabel?.text == "任务标识" || lblCityName.text=="切换" || txtProjectNumber.text=="项目编号") {
            tmpArray.addObject(txtProjectNumber.text!)
            
            txtProjectNumber.text = userName
            
            NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "CheckIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            arrAll = NSUserDefaults.standardUserDefaults().objectForKey("projectnumber")?.mutableCopy() as! NSMutableArray
            
            if arrAll.containsObject(txtProjectNumber.text!)
            {
                print("Value Is There")
            }
            else
            {
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "projectnumber")
                arrAll.addObject(txtProjectNumber.text!)
            }
            
            NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "entry")
            NSUserDefaults.standardUserDefaults().setObject(arrAll, forKey: "projectnumber")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.addvalueInArr()
            
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinTimer") as! CheckinTimer
            self.navigationController?.pushViewController(vc, animated: true)
            
            NSUserDefaults.standardUserDefaults().setObject(txtProjectNumber.text, forKey:"proj_tmp")
            NSUserDefaults.standardUserDefaults().setObject("CO Task", forKey:"Task_tmpD")
            NSUserDefaults.standardUserDefaults().setObject("Working Time", forKey:"Work_tmpD")
            NSUserDefaults.standardUserDefaults().setObject("上海", forKey:"city_tmp")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }


        else if(btnWorkingList.titleLabel?.text == "Working Type" || btnWorkingList.titleLabel?.text == "Arbeitsorte")
        {
            let msg = NSLocalizedString("WORKING_FIELD", comment: "")//"If you don't allow this app to get your current location, we will not able to validate your city!"
            let alert: UIAlertView = UIAlertView()
            alert.delegate = nil
            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
            alert.message = msg
            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
            alert.show()
        }
        else if(btnTasklist.titleLabel?.text == "Task ID" ||
            btnTasklist.titleLabel?.text == "Task- ID")
            {
                let msg = NSLocalizedString("TASK_FIELD", comment: "")//"If you don't allow this app to get your current location, we will not able to validate your city!"
                let alert: UIAlertView = UIAlertView()
                alert.delegate = nil
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
            }
            
        
        
        else if(lblCityName.text=="" || lblCityName.text==nil || lblCityName.text=="Change City" || lblCityName.text=="Stadt wechseln")
        {
            self.showAlertLocationField()
        }
        else
        {
            //Bluetooth
            
            if(Validation=="BLE1")
            {
                let msg = (NSLocalizedString("CONNECT_BLE", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
                let alert: UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
            }
            else{
                tmpArray.addObject(txtProjectNumber.text!)
                
                NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "CheckIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                arrAll = NSUserDefaults.standardUserDefaults().objectForKey("projectnumber")?.mutableCopy() as! NSMutableArray
                
                if arrAll.containsObject(txtProjectNumber.text!)
                {
                    print("Value Is There")
                }
                else
                {
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: "projectnumber")
                    arrAll.addObject(txtProjectNumber.text!)
                }
                
                NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "entry")                
                NSUserDefaults.standardUserDefaults().setObject(arrAll, forKey: "projectnumber")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.addvalueInArr()
                
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinTimer") as! CheckinTimer
                self.navigationController?.pushViewController(vc, animated: true)
                
                NSUserDefaults.standardUserDefaults().setObject(txtProjectNumber.text, forKey:"proj_tmp")
                NSUserDefaults.standardUserDefaults().setObject(btnTasklist.titleLabel!.text, forKey:"Task_tmpD")
                NSUserDefaults.standardUserDefaults().setObject(btnWorkingList.titleLabel!.text, forKey:"Work_tmpD")
                NSUserDefaults.standardUserDefaults().setObject(lblCityName.text, forKey:"city_tmp")
                NSUserDefaults.standardUserDefaults().synchronize()
    
            }
        }
    }

    @IBAction func btnChange(sender: AnyObject)
    {
        if(CityDictionary != nil)
        {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ChangeCity") as! ChangeCity
            vc.delegate=self
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else
        {
            self.OpenAlertView()
        }
    }
    
    
    @IBAction func btnTask(sender: AnyObject)
    {
        if(taskList != nil)
        {
            Working_Task="Task"
            self.redirectToTableView()
        }
        else
        {
            self.OpenAlertView()
        }
    }
    @IBAction func btnWorking(sender: AnyObject)
    {
        if(WorkingList != nil)
        {
            Working_Task="Working"
            self.redirectToTableView()
        }
        else
        {
            self.OpenAlertView()
        }
    }
    
    @IBAction func btnDropTask(sender: AnyObject)
    {
        if(taskList != nil)
        {
            Working_Task="Task"
            self.redirectToTableView()
        }
        else
        {
            self.OpenAlertView()
        }
    }
    @IBAction func btnDropWorkin(sender: AnyObject)
    {
        if(WorkingList != nil)
        {
            Working_Task="Working"
            self.redirectToTableView()
        }
        else
        {
            self.OpenAlertView()
        }
    }
    func addvalueInArr()
    {
        arrAllProjectnumber = NSUserDefaults.standardUserDefaults().objectForKey("projectnumber")?.mutableCopy() as! NSMutableArray
        
        arrsearchingValue = arrAllProjectnumber
        
    }
    func redirectToTableView()
    {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Working_Task_VC") as! Working_Task_VC
        vc.delegate=self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func OpenAlertView()
    {
        let msg = (NSLocalizedString("PLEASE_REFRESH", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
        let alert: UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
        alert.message = msg
        alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
        alert.show()
    }
    
    @IBAction func btnLogout(sender: AnyObject)
    {
            if flagpopup == false
            {
                self.popupOpen()
            }
            else
            {
                self.popupClose()
            }
        }
    
    
    @IBAction func btnRefresh(sender: AnyObject)
    {
        if(appDelegate.checkInternetConnection())
        {
            self.JSONCall()
        }
        else
        {
            let msg = (NSLocalizedString("NO_INTERNET", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
            alert.message = msg
            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
            alert.show()
        }
    }
    
    @IBAction func btnpopuplogout(sender: AnyObject)
    {
        self.popupClose()
        
        let popUpViewObjTime = PopupAlertVC(nibName : "PopupAlertVC", bundle : nil)
        
        popUpViewObjTime.delegate=self
        
        self.presentPopupViewController(popUpViewObjTime, animationType: MJPopupViewAnimationFade)
    }
    
    @IBAction func btnpopupHistory(sender: AnyObject)
    {
        self.popupClose()

        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.labelText = NSLocalizedString("PLEASE_WAIT", comment: "")
        HUD.delegate=self
        self.HUD.show(true)
        
        let kpi  = NSUserDefaults.standardUserDefaults().valueForKey("KPI_ID")?.intValue
        let URLstr = String(format: "http://192.168.1.27:8000/api/v1/kpi_entry/entry?kpi_id=%d&page=0&size=10",kpi!)
        
        JsonClass.JsonCallBackGetHistory(URLstr, fromDate: "", toDate: "", pages: "", sizes: "", sucessBlock: { (responce:AnyObject!) -> Void in
            self.HUD.hide(true)
            
            let dic = responce as! NSDictionary
            
            if(dic.objectForKey("result_code")! as! String == "1")
            {
                HistoryData = NSMutableArray()
                
                if(NSUserDefaults.standardUserDefaults().valueForKey("PendingCheckout") != nil)
                {
                    self.PendingArray = NSUserDefaults.standardUserDefaults().valueForKey("PendingCheckout") as! NSMutableArray
                    if(self.PendingArray.count > 0)
                    {
                        for var i = 0; i < self.PendingArray.count ; i++
                        {
                            print(self.PendingArray[i])
                            HistoryData.addObject(self.PendingArray[i])
                        }
                    }
                }
               
                var ResponseData : NSMutableArray!
                ResponseData = NSMutableArray()
                ResponseData = dic.valueForKey("msg")?.mutableCopy() as! NSMutableArray
                
                for var i = 0; i < ResponseData.count ; i++
                {
                    print(ResponseData[i])
                    HistoryData.addObject(ResponseData[i])
                }
                
                if(HistoryData.count > 0)
                {
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryPage") as! HistoryPage
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else
                {
                    self.showAlertNoData()
                }
            }
            else
            {
                if(dic.valueForKey("msg")?.objectAtIndex(0) as? String != nil)
                {
                    let msg = dic.valueForKey("msg")?.objectAtIndex(0) as? String
                    let alert: UIAlertView = UIAlertView()
                    alert.delegate = nil
                    alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                    alert.message = msg
                    alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                    alert.show()
                }
            }
            
            print(responce)

            }) { (error:NSError!) -> Void in
                print(error)
                self.HUD.hide(true)
                if(NSUserDefaults.standardUserDefaults().valueForKey("PendingCheckout") != nil)
                {
                    HistoryData = NSMutableArray()
                    self.PendingArray = NSUserDefaults.standardUserDefaults().valueForKey("PendingCheckout") as! NSMutableArray
                    if(self.PendingArray.count > 0)
                    {
                        for var i = 0; i < self.PendingArray.count ; i++
                        {
                            HistoryData.addObject(self.PendingArray[i])
                        }
                    }
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryPage") as! HistoryPage
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else
                {
                    self.showAlertNoData()
                }

                
        }

    }
    
    @IBAction func btnSetting(sender: AnyObject)
    {
        self.popupClose()
        
        let popUpViewObj = PopupKPI(nibName : "PopupKPI", bundle : nil)
        
        popUpViewObj.delegate=self
        
        self.presentPopupViewController(popUpViewObj, animationType: MJPopupViewAnimationFade)
    }
    // MARK: - Delegate Methods

    func dismissPopUpKPIYes(view: UIViewController!) {
        
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    func dismissPopUpKPINo(view: UIViewController!)
    {
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    func dismissPopUpViewYes(view: UIViewController!) {
        
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Login") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func dismissPopUpViewNo(view: UIViewController!)
    {
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    func getWorkingTaskData(str:NSString)
    {
        if(Working_Task == "Working")
        {
            btnWorkingList.setTitle(str as String, forState:UIControlState.Normal)
        }
        else
        {
            btnTasklist.setTitle(str as String, forState:UIControlState.Normal)
        }
    }
    
    func selectedCity(city: String!) {
    
        
        let cleanedString = String(city.characters.dropFirst())
        lblCityName.text=cleanedString as String
    }
    
    func showAlertNoData()
    {
        let msg = NSLocalizedString("NO_DATA", comment: "")//"All fields are mandatory!"
        let alert: UIAlertView = UIAlertView()
        alert.delegate = nil
        alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
        alert.message = msg
        alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
        alert.show()
    }
    func showAlertLocationField()
    {
        if(self.checkLocationServiceOnOff())
        {
            let msg = NSLocalizedString("SELECT_CITY", comment: "")//"If you don't allow this app to get your current location, we will not able to validate your city!"
            let alert: UIAlertView = UIAlertView()
            alert.delegate = nil
            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
            alert.message = msg
            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
            alert.show()
        }
        else
        {
                    let msg = NSLocalizedString("LOCATION_FIELD", comment: "")//"If you don't allow this app to get your current location, we will not able to validate your city!"
                    let alert: UIAlertView = UIAlertView()
                    alert.delegate = self
                    alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                    alert.message = msg
                    alert.addButtonWithTitle(NSLocalizedString("CANCEL", comment: ""))
                    alert.addButtonWithTitle(NSLocalizedString("SETTING", comment: ""))

                    alert.show()
        }

        
    }
    
    // MARK: - Alert Delegate Methods
    // MARK: -
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if (buttonIndex == 1) {
            self.openLocationSettingScreen()
        }
    }
    
    
    func dataForPopoverInTextField(textField: MPGTextField!) -> [AnyObject]! {
            return tmpArray as [AnyObject]
        }
    
    // MARK: - Textfield Delegate Methods
    // MARK: -
    func textFieldShouldSelect(textField: MPGTextField!) -> Bool
    {
        return true
    }
    func textField(textField: MPGTextField!, didEndEditingWithSelection result: [NSObject : AnyObject]!) {
        print(result)
    }
    
    // MARK: - JSONCall Methods
    // MARK: -
    
    func JSONCall()
    {
        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.labelText = NSLocalizedString("PLEASE_WAIT", comment: "")
        HUD.delegate=self
        self.HUD.show(true)
        
        //Task ID
        JsonClass.JsonCallBackCity("http://192.168.1.27:8000/api/v1/custom/task_ids", username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: CountryCodeString, sucessBlock: { (responce:AnyObject!) -> Void in
            taskList = NSMutableArray()
            taskListCode = NSMutableArray()

            let dic = responce as! NSArray
            for var i = 0 ; i < dic.count ; i++
            {
                taskListCode.addObject(dic.objectAtIndex(i).objectForKey("code")!)

                taskList.addObject(dic.objectAtIndex(i).objectForKey("name")!)
            }
            self.HUD.hide(true)
            print(taskList)
            }) { (error:NSError!) -> Void in
                print(error)
                self.HUD.hide(true)
            }
        
        //Working Types
        JsonClass.JsonCallBackCity("http://192.168.1.27:8000/api/v1/custom/working_types", username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: CountryCodeString, sucessBlock: { (responce:AnyObject!) -> Void in
            WorkingList = NSMutableArray()
            WorkingListCode = NSMutableArray()
            WorkingListCheckinValidation = NSMutableArray()
            WorkingListCheckoutValidation = NSMutableArray()

            let dic = responce as! NSArray
            for var i = 0 ; i < dic.count ; i++
            {
                WorkingListCode.addObject(dic.objectAtIndex(i).objectForKey("code")!)
                WorkingList.addObject(dic.objectAtIndex(i).objectForKey("name")!)
                
                WorkingListCheckinValidation.addObject(dic.objectAtIndex(i).objectForKey("check_in_validate")!)
                WorkingListCheckoutValidation.addObject(dic.objectAtIndex(i).objectForKey("check_out_validate")!)

            }
            self.HUD.hide(true)

            print(WorkingList)
            }) { (error:NSError!) -> Void in
                print(error)
        }
        
        //City
        let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        let urlstr = NSString(format: "http://192.168.1.27:8000/api/v1/system/cities?%@",countryCode)
        JsonClass.JsonCallBackCity(urlstr as String, username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: CountryCodeString, sucessBlock: { (responce:AnyObject!) -> Void in
            CityDictionary = responce as! NSMutableDictionary
            NSUserDefaults .standardUserDefaults().setObject(CityDictionary, forKey: "CityDictionary")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.HUD.hide(true)

            print(CityDictionary)
            }) { (error:NSError!) -> Void in
                print(error)
                let msg = (NSLocalizedString("TIME_OUT", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
                let alert: UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
                self.HUD.hide(true)

        }
        
        
        //Greetings
        
        let url = NSString(format: "http://192.168.1.27:8000/api/v1/custom/greetings?user_id=%@&location=null&page=null",NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String)
        
        JsonClass.JsonCallBackCity(url as String, username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: CountryCodeString, sucessBlock: { (responce:AnyObject!) -> Void in
            let ree = responce as! NSDictionary!
            greeting = ree.objectForKey("greeting") as! NSString
            self.lblQuote.text=greeting as String
            print(ree)
            self.HUD.hide(true)

            }) { (error:NSError!) -> Void in
                print(error)
                self.lblQuote.text=NSLocalizedString("QUOTE", comment: "")
                self.HUD.hide(true)
        }
    }
    
    // MARK: - tableview Methods
    // MARK: -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAllProjectnumber.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = arrAllProjectnumber.objectAtIndex(indexPath.row) as? String
        tblserachingList.separatorStyle=UITableViewCellSeparatorStyle.None
        //        tblserachingList.frame=CGRectMake(tblserachingList.frame.origin.x, tblserachingList.fr, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        cell.textLabel?.textColor=UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        cell.textLabel?.font = UIFont(name:"Avenir", size:14)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        txtProjectNumber.text = arrAllProjectnumber.objectAtIndex(indexPath.row) as? String
        tblserachingList.hidden=true
        txtProjectNumber.resignFirstResponder()
        
    }
}


