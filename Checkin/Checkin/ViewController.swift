//
//  ViewController.swift
//  Checkin
//
//  Created by Rajat Lala on 15/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MBProgressHUDDelegate {

    // MARK: - Declaration
    // MARK:
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    
    var HUD : MBProgressHUD!
    
    // MARK: - Default Methods

    override func viewWillAppear(animated: Bool)
    {
        if(NSUserDefaults.standardUserDefaults().valueForKey("KPI_ID") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "KPI_ID")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        let language = NSLocale.preferredLanguages().first as String!
        print(language)
        print(NSBundle.mainBundle().preferredLocalizations[0] as NSString)
        
        btnLogin.layer.cornerRadius = 5
    
        
    if((NSUserDefaults.standardUserDefaults().valueForKey("CheckIn")) != nil)
        {
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinTimer") as! CheckinTimer
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "callnotificationViewController", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("notificationCall:"), name: "callnotificationViewController", object:nil)
        
        txtUsername.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("USERNAME", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        txtPassword.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("PASSWORD", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])

        btnLogin.setTitle(NSLocalizedString("LOGIN", comment: ""), forState: UIControlState.Normal)
        
        txtUsername.text="jlr0@leoni.com"
        txtPassword.text="123456@"
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.JSONCall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NotificationsCall Methods
    // MARK:
    func notificationCall(notification:NSNotification)
    {
        let data = notification.userInfo?["msg"] as! NSArray
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if(NSUserDefaults.standardUserDefaults().objectForKey("viewcontrollerentry") != nil)
            {
                let stringentry : String = NSUserDefaults.standardUserDefaults().objectForKey("viewcontrollerentry") as! String
                if stringentry == "YES"
                {
                    let stringCheck : String = NSUserDefaults.standardUserDefaults().objectForKey("tosterDipslay") as! String
                    
                    if (stringCheck == "YES")
                    {
                        let alertObj:UIAlertView = UIAlertView.init(title: nil, message: "\(data.objectAtIndex(0))", delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
                        
                        alertObj.show()
                        
                        NSUserDefaults.standardUserDefaults().setObject("NO", forKey: "viewcontrollerentry")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                }
            }
        })
    }
    
    // MARK: - JSONCall Method
    // MARK:
    
    func JSONCall()
    {
        
        //User info
        let strURL = String(format: "http://192.168.1.27:3000/api/v1/custom/user_info?%@", txtUsername.text!)
        
        JsonClass.JsonCallBackCity(strURL, username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: "", sucessBlock: { (responce:AnyObject!) -> Void in
            let responseDict = responce as! NSDictionary
            print(responseDict)
            }) { (error:NSError!) -> Void in
                print(error)
        }
    }
    
    // MARK: - Button Events
    // MARK:
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func btnLogin(srender: AnyObject)
    {
        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.labelText = NSLocalizedString("PLEASE_WAIT", comment: "")
        HUD.delegate=self
        self.HUD.show(true)
        
        var dict = [String: AnyObject]()
        
       //let UUIDstr =    UIDevice.currentDevice().identifierForVendor?.UUIDString

        dict["user_id"] = txtUsername.text
        dict["password"] = txtPassword.text
        dict["device_id"] = "Xe30299322233"
        //dict["device_id"] = UUIDstr

        if(appDelegate.checkInternetConnection()==true)
        {
            if(txtUsername.text == "" || txtUsername.text == nil)
            {
                self.HUD.hide(true);
                let msg = NSLocalizedString("ENTER_USERNAME", comment: "")//"Please enter Username!"
                let alert: UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
            }
            else if(txtPassword.text == "" || txtPassword.text == nil)
            {
                self.HUD.hide(true);
                let msg = NSLocalizedString("ENTER_PASSWORD", comment: "")//"Please enter Password!"
                let alert: UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                alert.message = msg
                alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                alert.show()
            }
            else
            {
                let valid = isValidEmail(txtUsername.text!) as Bool
                if(valid == true)
                {
                    JsonClass.JsonCallBack("http://192.168.1.27:3000/api/v1/user_session", parameter: dict as [NSObject : AnyObject]!, sucessBlock: { (responce:AnyObject!) -> Void in
                        print(responce)
                        let msg = "result_code"
                        let dic = responce as! NSDictionary
                        //if("\(dic.objectForKey(msg))"=="1")
                        print(dic.objectForKey(msg)!)
                        
                        if(dic.objectForKey(msg)!.isEqualToString("1"))
                        {
                            NSUserDefaults.standardUserDefaults().setValue(self.txtUsername.text, forKey: "username")
                            NSUserDefaults.standardUserDefaults().setValue(self.txtPassword.text, forKey: "password")
                            NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "viewcontrollerentry")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CheckinDescription") as! CheckinDescription
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            self.HUD.hide(true);
                        }
                        else
                        {
                            let msg = (dic.objectForKey("msg") as! NSArray)[0]
                            let alert: UIAlertView = UIAlertView()
                            alert.delegate = self
                            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                            alert.message = msg as? String
                            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                            alert.show()
                            self.HUD.hide(true);
                            
                        }
                        }) { (error:NSError!) -> Void in
                            print(error)
                            let msg = (NSLocalizedString("TIME_OUT", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
                            let alert: UIAlertView = UIAlertView()
                            alert.delegate = self
                            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                            alert.message = msg
                            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                            alert.show()
                            self.HUD.hide(true);
                    }
                }
                else
                {
                    let msg = (NSLocalizedString("INVALID_EMAIL", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
                    let alert: UIAlertView = UIAlertView()
                    alert.delegate = self
                    alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
                    alert.message = msg
                    alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
                    alert.show()
                    self.HUD.hide(true);
                }
            }
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
            self.HUD.hide(true);
        }
    }
    
    // MARK: - Textfields Method
    // MARK:
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
}

