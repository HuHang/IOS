//
//  HistoryDetail.swift
//  Checkin
//
//  Created by Rajat Lala on 29/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit

class HistoryDetail: UIViewController,popUpViewDelegate1,MBProgressHUDDelegate {
    
    @IBOutlet var lblHour: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    var PendingData : PopupAlertVC!
    var popUpViewObjTime : PopupAlertVC!
    var dictAllData : NSMutableDictionary!
    var arrProperties : NSMutableArray = []
    var strDate : NSString!
    var HUD : MBProgressHUD!
    var historyPage : HistoryPage!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var tblHistoryDetail: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool)
    {
        self.tblHistoryDetail.rowHeight=35
        btnSubmit.layer.cornerRadius = 5
        

        if(HistoryClickedData.objectForKey("status") as? String != nil)
        {
            btnSubmit.setTitle(NSLocalizedString("SUBMITTED", comment: ""), forState: UIControlState.Normal)
            btnSubmit.hidden=false
            lblStatus.text=NSLocalizedString("UNSUBMITTED", comment: "")
            lblStatus.textColor=UIColor.redColor()
        }
        else
        {
            btnSubmit.hidden=true
            lblStatus.text=NSLocalizedString("SUBMITTED", comment: "")
            lblStatus.textColor=UIColor.lightGrayColor()
        }
        if(JsonClass.containString(HistoryClickedData.objectForKey("value") as! String))
        {
            lblHour.textColor=UIColor.redColor()
        }
        
        print(dictAllData)
        
        //Date
        strDate = dictAllData.objectForKey("date") as? String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(strDate as String)
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter1.timeZone = NSTimeZone.localTimeZone()
        
        let timeStamp1 = dateFormatter1.stringFromDate(date!)
        print(timeStamp1)

        
        let hours = dictAllData.objectForKey("value") as? String
        let strHour = NSString(format: "%@ %@",hours!, NSLocalizedString("MINUTES", comment: ""))
       // lblHour.text=("\(hours!) Minutes")
        lblHour.text=strHour as String
        lblDate.text=timeStamp1
        let dict = dictAllData.objectForKey("kpi_properties") as! NSMutableDictionary
    
        let strProject_nr : NSString
        if(dict.objectForKey("project_nr") as? String != nil)
        {
            strProject_nr = (dict.objectForKey("project_nr") as? String)!
        }
        else
        {
            strProject_nr = ""
        }
        let strTastId : NSString
        if(dict.objectForKey("task_id") as? String != nil)
        {
            strTastId = (dict.objectForKey("task_id") as? String)!
        }
        else
        {
            strTastId = ""
        }
        let strworkingType : NSString
        if(dict.objectForKey("working_type") as? String != nil)
        {
            strworkingType = (dict.objectForKey("working_type") as? String)!
        }
        else
        {
            strworkingType = ""
        }
        let strCity : NSString
        if(dict.objectForKey("location") as? String != nil)
        {
            strCity = (dict.objectForKey("location") as? String)!
        }
        else
        {
            strCity = ""
        }
        let strExeption : NSString
        if(dict.objectForKey("exception") as? String != nil)
        {
            strExeption = (dict.objectForKey("exception") as? String)!
        }
        else
        {
            strExeption = ""
        }
        let startTime : NSString
        if(dict.objectForKey("start_at") as? String != nil)
        {
            startTime = (dict.objectForKey("start_at") as? String)!
        }
        else
        {
            startTime = ""
        }
        
        let endTime : NSString
        
        if(dict.objectForKey("end_at") as? String != nil)
        {
            endTime = (dict.objectForKey("end_at") as? String)!
        }
        else
        {
            endTime = ""
        }
        
        arrProperties.addObject("\(NSLocalizedString("PROJECT_NR", comment: "")) : \(strProject_nr)")
        arrProperties.addObject("\(NSLocalizedString("TASK_ID", comment: "")) : \(strTastId)")
        arrProperties.addObject("\(NSLocalizedString("WORKING_TYPE", comment: "")) : \(strworkingType)")
        arrProperties.addObject("\(NSLocalizedString("CITY", comment: "")) : \(strCity)")
        arrProperties.addObject("\(NSLocalizedString("EXCEPTION", comment: "")) : \(strExeption)")
        arrProperties.addObject("\(NSLocalizedString("STARTTIME", comment: "")) : \(startTime)")
        arrProperties.addObject("\(NSLocalizedString("ENDTIME", comment: "")) : \(endTime)")

        tblHistoryDetail.separatorStyle=UITableViewCellSeparatorStyle.None
        //tblHistoryDetail.scrollEnabled=false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Event
    // MARK: -
    
    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnLogout(sender: AnyObject)
    {
        popUpViewObjTime = PopupAlertVC(nibName : "PopupAlertVC", bundle : nil)
        
        popUpViewObjTime.delegate = self
        
        self.presentPopupViewController(popUpViewObjTime, animationType: MJPopupViewAnimationFade)
    }
    
    @IBAction func btnSubmit(sender: AnyObject)
    {
        self.SendPendingDataPerticular()
    }
    // MARK: - TableView Methods
    // MARK: -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProperties.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell =  tblHistoryDetail.dequeueReusableCellWithIdentifier("HistoryDetail")
        
        cell?.textLabel!.text = arrProperties.objectAtIndex(indexPath.row) as? String
        cell?.textLabel?.textColor=UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None

        return cell!
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    // MARK: - Delegate Methods
    // MARK: -
    
    func dismissPopUpViewYes(view: UIViewController!) {
        
        
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().setObject("YES", forKey: "LOGIN")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    func dismissPopUpViewNo(view: UIViewController!)
    {
        dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func SendPendingDataPerticular()
    {
        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.labelText = NSLocalizedString("PLEASE_WAIT", comment: "")
        HUD.delegate=self
        self.HUD.show(true)
        if(appDelegate.checkInternetConnection())
        {
        if(NSUserDefaults.standardUserDefaults().valueForKey("PendingCheckout") != nil)
            {
                let PendingCheckOutNew = NSMutableArray()
                let PendingCheckOut = NSMutableArray()
                var PendingCheckOutData = NSMutableArray()
                PendingCheckOutData = NSUserDefaults.standardUserDefaults().valueForKey("PendingCheckout") as! NSMutableArray
                print(PendingCheckOutData)
                
                for var i = 0; i < PendingCheckOutData.count; i++
                {
                    if(PendingCheckOutData[i].valueForKey("date")!.isEqualToString(strDate as String))
                    {
                        PendingCheckOut.addObject(PendingCheckOutData[i])
                    }
                    else
                    {
                        PendingCheckOutNew.addObject(PendingCheckOutData[i])
                    }
                }
                
                JsonClass.JsonCallBackCheckout("http://192.168.1.27:8000/api/v1/kpi_entry/entry", parameter: PendingCheckOut, sucessBlock: { (responce:AnyObject!) -> Void in
                    let dic = responce as! NSDictionary
                    if(dic.valueForKey("result_code" as String)!.isEqualToString("1"))
                    {
                        self.btnSubmit.hidden=true
                        self.lblStatus.text="Submitted"
                        self.lblStatus.textColor=UIColor.lightGrayColor()
                        self.historyPage = HistoryPage()
                        self.dismissViewControllerAnimated(true, completion: nil)
                        RefreshAfterSubmit=true
                        
                        if(PendingCheckOutNew.count==0)
                        {
                            NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"PendingCheckout")
                        }
                        else
                        {
                            NSUserDefaults.standardUserDefaults().setObject(PendingCheckOutNew, forKey:"PendingCheckout")
                        }
                    }
                    self.HUD.hide(true)
                    }) { (error:NSError!) -> Void in
                        print(error)
                        self.HUD.hide(true)
                }
            }
        }
        else
        {
            self.HUD.hide(true)
            let msg = (NSLocalizedString("NO_INTERNET", comment: ""))//"You appear to do not have proper internet connectivity at the moment. Please try again later!"
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = NSLocalizedString("ALERT", comment: "")//"Alert"
            alert.message = msg
            alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
            alert.show()
        }
    }
}
