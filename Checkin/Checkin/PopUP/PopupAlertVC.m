//
//  PopupAlertVC.m
//  Checkin
//
//  Created by Rajat Lala on 19/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import "PopupAlertVC.h"
#import "JsonClass.h"
#import "Checkin-Swift.h"

@interface PopupAlertVC ()
{
    MBProgressHUD *HUD;
}
@end

@implementation PopupAlertVC

@synthesize delegate;

-(void)viewWillAppear:(BOOL)animated
{
    self.lblMsg.text=NSLocalizedString(@"LOGOUT_MSG", "");
    [self.btnNo setTitle:NSLocalizedString(@"NO", "") forState:UIControlStateNormal];
    [self.btnYes setTitle:NSLocalizedString(@"YES", "") forState:UIControlStateNormal];
    self.lblAlert.text=NSLocalizedString(@"ALERT", "");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.cornerRadius=5.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)yesPress:(id)sender {
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:NSLocalizedString(@"PLEASE_WAIT", "")];
    HUD.delegate=self;
    [HUD show:YES];
    
    AppDelegate *appDelegae = [[UIApplication sharedApplication] delegate];
    if (appDelegae.checkInternetConnection)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timerInvalidate" object:nil userInfo:nil];
    }
    
    NSString *strURL = @"http://192.168.1.27:8000/api/v1/user_session";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] forKey:@"user_id"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"] forKey:@"password"];
    [dict setObject:@"Xe30299322233" forKey:@"device_id"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"CHECKOUTCALL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [JsonClass JsonCallBackDelete:@"http://192.168.1.27:8000/api/v1/user_session" parameter:dict sucessBlock:^(id responseObject) {
        [self.delegate dismissPopUpViewYes:self];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"CheckIn"])
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CheckIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [HUD hide:YES];

    }failureBlock:^(NSError *error) {
        NSLog(@"Error %@", error);

        [HUD hide:YES];
        //[self.delegate dismissPopUpViewYes:self];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT", @"") message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil] show];

    }];
    

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
    AppDelegate *appDelegae = [[UIApplication sharedApplication] delegate];

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"CheckIn"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CheckIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSDate* datetime = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss 'UTC'"];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
        
        NSString* dateString = [dateFormatter stringFromDate:datetime];
        
        
        NSString *stringHour=[[NSUserDefaults standardUserDefaults] valueForKey:@"TimerMinutes"];
        
        NSString *countryCode = [[NSLocale currentLocale]objectForKey:NSLocaleCountryCode];
        
        
        NSMutableDictionary *dataSend = [[NSMutableDictionary alloc]init];
        
        [dataSend setObject:dateString forKey:@"date"];
        [dataSend setObject:stringHour forKey:@"value"];
        [dataSend setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"KPI_ID"] forKey:@"kpi_id"];
        [dataSend setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] forKey:@"email"];
        
        NSMutableDictionary *dataInner = [[NSMutableDictionary alloc]init];
        [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"proj_tmp"] forKey:@"project_nr"];
        [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"city_tmp"] forKey:@"location"];
        [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"Task_tmpD"] forKey:@"task_id"];
        [dataInner setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"Work_tmpD"] forKey:@"working_type"];

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
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SystemTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [dataSend setObject:dataInner forKey:@"kpi_properties"];
        printf("111111111111111111111111111111111111111111111111");
        
        NSMutableArray *CurrentCheckout=[dataSend mutableCopy];
        
        
        if (appDelegae.checkInternetConnection)
        {
            [JsonClass JsonCallBackCheckout:@"http://192.168.1.27:8000/api/v1/kpi_entry/entry" parameter:CurrentCheckout sucessBlock:^(id responseObject) {
                NSLog(@"%@",responseObject);
                
            }failureBlock:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", "") message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"OK", "") otherButtonTitles:nil, nil] show];
                // [self.delegate dismissPopUpViewYes:self];
                [HUD hide:YES];
            }];
        }
    }
    [self SendPendingData];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"TimerTimer"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Boottime"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"TimerMinutes"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(IBAction)noPress:(id)sender {
    [self.delegate dismissPopUpViewNo:self];
}


-(void)SendPendingData
{
    AppDelegate *app=[[UIApplication sharedApplication] delegate];
    if (app.checkInternetConnection)
    {
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"PendingCheckout"] != nil)
        {
            NSMutableArray *PendingCheckOutFail = [[NSMutableArray alloc] init];
            
            NSMutableArray *PendingCheckOut = [[NSUserDefaults standardUserDefaults]valueForKey:@"PendingCheckout"];
            NSLog(@"%@",PendingCheckOut);
                [JsonClass JsonCallBackCheckout:@"http://192.168.1.27:8000/api/v1/kpi_entry/entry" parameter:PendingCheckOut sucessBlock:^(id responseObject) {
                    NSLog(@"%@",responseObject);
                    if ([[responseObject valueForKey:@"result_code"]isEqualToString:@"1"])
                    {
                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"PendingCheckout"];
                    }
                }failureBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", "") message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"OK", "") otherButtonTitles:nil, nil] show];
                }];
        }
    }
}
@end
