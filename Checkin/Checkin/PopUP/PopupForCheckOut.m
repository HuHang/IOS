//
//  PopupForCheckOut.m
//  Checkin
//
//  Created by Rajat Lala on 19/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import "PopupForCheckOut.h"
#import "Checkin-Swift.h"

@interface PopupForCheckOut ()
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UILabel *lblAlertMsg;

@end

@implementation PopupForCheckOut

-(void)viewWillAppear:(BOOL)animated
{
    self.lblAlertMsg.text=[NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"CHECKOUT_MSG", ""), [[NSUserDefaults standardUserDefaults] valueForKey:@"TimerString"]];
    [self.btnNo setTitle:NSLocalizedString(@"NO", "") forState:UIControlStateNormal];
    [self.btnYes setTitle:NSLocalizedString(@"YES", "") forState:UIControlStateNormal];
    self.lblAlert.text=NSLocalizedString(@"ALERT", "");

   // self.lblAlertMsg.text=[NSString stringWithFormat:@"Are you sure you want to Check out? Total time logged : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"TimerString"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius=5.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnCheckout:(id)sender
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:NSLocalizedString(@"PLEASE_WAIT", "")];
    HUD.delegate=self;
    [HUD show:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timerInvalidate" object:nil userInfo:nil];

    [JsonClass JsonCallBackTime:@"http://192.168.1.27:8000/api/v1/system/utc" username:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] password: [[NSUserDefaults standardUserDefaults] valueForKey:@"password"] countrycode:@""sucessBlock:^(id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"CheckoutInterNet"];
        [self callingJsonMethod];
        
    }failureBlock:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"CheckoutInterNet"];
        [self callingJsonMethod];
    }];
    
}

-(void)callingJsonMethod
{
    NSDate* datetime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss 'UTC'"];
    NSString* dateString = [dateFormatter stringFromDate:datetime];
    
    NSString *stringHour=[[NSUserDefaults standardUserDefaults] valueForKey:@"TimerMinutes"];
    
//    NSString *strBeginTime=[[NSUserDefaults standardUserDefaults] valueForKey:@"strBeginTime"];
//    NSString *strFinishTime=[[NSUserDefaults standardUserDefaults] valueForKey:@"strFinishTime"];
    
    NSString *countryCode = [[NSLocale currentLocale]objectForKey:NSLocaleCountryCode];
    
    
    NSMutableDictionary *dataSend = [[NSMutableDictionary alloc]init];
    
    [dataSend setObject:dateString forKey:@"date"];
    [dataSend setObject:stringHour forKey:@"value"];
    
//    [dataSend setObject:strBeginTime forKey:@"start_at"];
//    [dataSend setObject:strFinishTime forKey:@"end_at"];

    [dataSend setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"KPI_ID"] forKey:@"kpi_id"];
    [dataSend setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] forKey:@"email"];
    
    NSMutableDictionary *dataInner = [[NSMutableDictionary alloc]init];
    [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"proj_tmp"] forKey:@"project_nr"];
    [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"city_tmp"] forKey:@"location"];
    [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"Task_tmpD"] forKey:@"task_id"];
    [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"Work_tmpD"] forKey:@"working_type"];
    
    [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"strBeginTime"] forKey:@"start_at"];
    [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"strFinishTime"] forKey:@"end_at"];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CheckinInterNet"]isEqualToString:@"YES"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"CheckoutInterNet"]isEqualToString:@"YES"])
    {
        [dataInner setObject:@"NO" forKey:@"exception"];
    }
    else
    {
        [dataInner setObject:@"YES" forKey:@"exception"];
    }
    
    if([stringHour containsString:@"-"])
    {
        [dataInner setObject:@"YES" forKey:@"exception"];
    }
    
    [dataSend setObject:@"Unsubmitted" forKey:@"status"];
    [dataSend setObject:dataInner forKey:@"kpi_properties"];
     printf("2222222222222222222222222222222222222222");
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:dataSend];
    
    
    AppDelegate *appDelegae = [[UIApplication sharedApplication] delegate];
    if (appDelegae.checkInternetConnection)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"CHECKOUTCALL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [JsonClass JsonCallBackCheckout:@"http://192.168.1.27:8000/api/v1/kpi_entry/entry" parameter:dataArray sucessBlock:^(id responseObject) {
            [self.delegate dismissPopUpCheckOutYes:self];
            [HUD hide:YES];
            
        }failureBlock:^(NSError *error) {
            [HUD hide:YES];
            [self.delegate dismissPopUpCheckOutYes:self];
        }];
        
    }
    else
    {
        NSMutableArray *PendingArray=[[NSMutableArray alloc] init];
        PendingArray=[[[NSUserDefaults standardUserDefaults] valueForKey:@"PendingCheckout"]mutableCopy];
        if (PendingArray==nil)
        {
            PendingArray=[[NSMutableArray alloc] init];
        }
        [PendingArray addObject:dataSend];
        
        [[NSUserDefaults standardUserDefaults] setObject:PendingArray forKey:@"PendingCheckout"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [HUD hide:YES];
        [self.delegate dismissPopUpCheckOutYes:self];
        
    }
    //[self.delegate dismissPopUpCheckOutYes:self];
    
    [self.navigationController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    CheckinDescription* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinDescription"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CheckIn"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"TimerTimer"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Boottime"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"TimerMinutes"];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"strBeginTime"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"strFinishTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (IBAction)btnNO:(id)sender
{
    [self.delegate dismissPopUpCheckOutNo:self];
}

@end
