//
//  HistoryPage.swift
//  Checkin
//
//  Created by Rajat Lala on 29/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit

class HistoryPage: UIViewController,popUpViewDelegate1 {

    @IBOutlet var tblHistory: UITableView!
    var popUpViewObjTime : PopupAlertVC!
    var refreshControl:UIRefreshControl!
    var PageCount : Int! = 1
    var HUD : MBProgressHUD!
    var PendingArray : NSMutableArray = []

    override func viewWillAppear(animated: Bool) {
        if((NSUserDefaults.standardUserDefaults().valueForKey("LOGIN")?.isEqualToString("YES")) != nil)
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }

        if(RefreshAfterSubmit==true)
        {
            self.RefreshAfterSubmitCall()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tblHistory.addSubview(refreshControl)
        tblHistory.separatorStyle=UITableViewCellSeparatorStyle.None

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func RefreshAfterSubmitCall()
    {
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

                }
                else
                {
                    self.showAlertNoData()
                }
            }
            self.tblHistory.reloadData()

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
                }
                else
                {
                    self.showAlertNoData()
                }
                self.tblHistory.reloadData()
                
        }
        RefreshAfterSubmit=false
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
    // MARK: - Button Events
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
    // MARK: - TableView Methods
    // MARK: - 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return HistoryData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell =  tblHistory.dequeueReusableCellWithIdentifier("HistoryCell")
        
        
        let lblHour = cell?.viewWithTag(101) as! UILabel
        let lblDate = cell?.viewWithTag(102) as! UILabel
        let lblStatus = cell?.viewWithTag(103) as! UILabel
        let hours = HistoryData.objectAtIndex(indexPath.row).objectForKey("value") as? String
        
        let strHour = NSString(format: "%@ %@",hours!, NSLocalizedString("MINUTES", comment: ""))
        lblHour.text = strHour as String
        
        let str = HistoryData.objectAtIndex(indexPath.row).objectForKey("date") as? String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(str!)
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter1.timeZone = NSTimeZone.localTimeZone()

        let timeStamp1 = dateFormatter1.stringFromDate(date!)
        print(timeStamp1)
        
        lblDate.text = timeStamp1
        
        
        if(HistoryData.objectAtIndex(indexPath.row).objectForKey("status") as? String != nil )
        {
            if(HistoryData.objectAtIndex(indexPath.row).objectForKey("status")!.isEqualToString("Unsubmitted"))
            {
                lblStatus.text = NSLocalizedString("UNSUBMITTED", comment: "")
                lblStatus.textColor=UIColor.redColor()
                lblHour.textColor=UIColor.lightGrayColor()
            }
            else
            {
                lblStatus.text = HistoryData.objectAtIndex(indexPath.row).objectForKey("status") as? String
                lblStatus.textColor=UIColor.redColor()
                lblHour.textColor=UIColor.lightGrayColor()
            }

        }
        else
        {
            lblStatus.text = NSLocalizedString("SUBMITTED", comment: "")
            lblStatus.textColor=UIColor.lightGrayColor()
            lblHour.textColor=UIColor.lightGrayColor()
        }
        
        if(JsonClass.containString(strHour as String))
        {
            lblHour.textColor=UIColor.redColor()
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.refreshControl.endRefreshing()
        print("You selected cell #\(indexPath.row)!")
        HistoryClickedData=NSMutableDictionary()
        HistoryClickedData = HistoryData.objectAtIndex(indexPath.row) as! NSMutableDictionary
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryDetail") as! HistoryDetail
        vc.dictAllData = HistoryClickedData
        self.presentViewController(vc, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 68.0
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

    // MARK: - RefreshCall Methods
    // MARK: -
    
    func refresh(sender:AnyObject)
    {

        let kpi  = NSUserDefaults.standardUserDefaults().valueForKey("KPI_ID")?.intValue
        let URL = NSString(format: "http://192.168.1.27:8000/api/v1/kpi_entry/entry?kpi_id=%d&page=%d&size=10",kpi!,PageCount) as String

        JsonClass.JsonCallBackGetHistory(URL, fromDate: "", toDate: "", pages: "", sizes: "", sucessBlock: { (responce:AnyObject!) -> Void in
            
            let dic = responce as! NSDictionary
            
            if(dic.objectForKey("result_code")! as! String == "1")
            {
                var tmpOldDataArray : NSMutableArray!
                tmpOldDataArray = NSMutableArray()
                tmpOldDataArray=HistoryData.mutableCopy()as! NSMutableArray
                HistoryData = NSMutableArray()
                HistoryData = tmpOldDataArray.mutableCopy()as! NSMutableArray
                
               let tmpDataArray=dic.valueForKey("msg") as! NSMutableArray

                for var i = 0; i < tmpDataArray.count; i++
                {
                    HistoryData.addObject(tmpDataArray.objectAtIndex(i))
                }
                self.tblHistory.reloadData()
            }
            
            print(responce)
            self.refreshControl.endRefreshing()

            
            }) { (error:NSError!) -> Void in
                print(error)
                self.refreshControl.endRefreshing()
  
        }
        
        PageCount=PageCount+1
    }

}
