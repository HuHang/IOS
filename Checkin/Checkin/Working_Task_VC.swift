//
//  Working_Task_VC.swift
//  Checkin
//
//  Created by Rajat Lala on 20/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

import UIKit
protocol getWorkingTaskDelgate
{
    func getWorkingTaskData(str:NSString)
}

class Working_Task_VC: UIViewController, popUpViewDelegate1 {

    @IBOutlet var btnCancel: UIButton!
    var popUpViewObjTime : PopupAlertVC!


    var delegate : getWorkingTaskDelgate!
    
    @IBOutlet var tblWorking: UITableView!
    
    override func viewWillAppear(animated: Bool)
    {
        btnCancel.setTitle(NSLocalizedString("CANCEL", comment: ""), forState: UIControlState.Normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblWorking.registerClass(UITableViewCell.self, forCellReuseIdentifier: "WorkingCell")
        // Do any additional setup after loading the view.
    }

    // MARK: - TableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(Working_Task == "Working")
        {
            if(WorkingList.count>0)
            {
                return WorkingList.count;
            }
            else
            {
                return 0
            }
        }
        else
        {
            if(taskList.count>0)
            {
                return taskList.count;
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell =  tblWorking.dequeueReusableCellWithIdentifier("WorkingCell")
        
        if(Working_Task == "Working")
        {
            cell!.textLabel?.text = WorkingList[indexPath.row] as? String
        }
        else
        {
            cell!.textLabel?.text = taskList[indexPath.row] as? String
        }
        
        cell?.textLabel?.textColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        if(Working_Task == "Working")
        {
            Working_Code = WorkingListCode[indexPath.row] as! NSString;
            
            if(WorkingListCheckinValidation[indexPath.row] as! String=="BLE")
            {
                Validation="BLE"
            }
            else
            {
                Validation="";
            }
            NSUserDefaults.standardUserDefaults().setObject(WorkingListCode[indexPath.row], forKey:"working_tmp")
            delegate.getWorkingTaskData(WorkingList[indexPath.row] as! NSString)
        }
        else
        {
            Task_Code = taskListCode[indexPath.row] as! NSString;
            
            NSUserDefaults.standardUserDefaults().setObject(taskListCode[indexPath.row], forKey:"task_tmp")

            delegate.getWorkingTaskData(taskList[indexPath.row] as! NSString)
        }

        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    // MARK: - JSON METHOD CALL
    func JsonCall ()
    {
        
        //TASK API
        JsonClass.JsonCallBackCity("http://192.168.1.27:8000/api/v1/custom/task_ids", username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: "", sucessBlock: { (responce:AnyObject!) -> Void in
            let dic = responce as! NSArray
            for var i = 0 ; i < dic.count ; i++
            {
                taskList.addObject(dic.objectAtIndex(i).objectForKey("name")!)
            }
            print(taskList)
            self.tblWorking.reloadData()
            }) { (error:NSError!) -> Void in
                print(error)

        }
        
        
        
        //Working API
        JsonClass.JsonCallBackCity("http://192.168.1.27:8000/api/v1/custom/working_types", username: NSUserDefaults.standardUserDefaults().valueForKey("username")! as! String, password: NSUserDefaults.standardUserDefaults().valueForKey("password")! as! String, countrycode: "", sucessBlock: { (responce:AnyObject!) -> Void in
            let dic = responce as! NSArray
            for var i = 0 ; i < dic.count ; i++
            {
                WorkingList.addObject(dic.objectAtIndex(i).objectForKey("name")!)
            }
            print(taskList)
            self.tblWorking.reloadData()
            }) { (error:NSError!) -> Void in
                print(error)
        }
        
    }

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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
