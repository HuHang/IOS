//
//  PopupKPI.m
//  Checkin
//
//  Created by Rajat Lala on 16/11/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import "PopupKPI.h"
#import "JsonClass.h"
#import "Checkin-Swift.h"

@interface PopupKPI ()
{
    MBProgressHUD *HUD;
}
@end

@implementation PopupKPI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.btnNo setTitle:NSLocalizedString(@"NO", "") forState:UIControlStateNormal];
    [self.btnYes setTitle:NSLocalizedString(@"YES", "") forState:UIControlStateNormal];
    
    self.view.layer.cornerRadius=5.0;

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"KPI_ID"] != nil)
    {
        self.txtKpiID.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"KPI_ID"];
    }
    else
    {
        self.txtKpiID.placeholder=NSLocalizedString(@"ENTER_KPI", "");
        //self.txtKpiID.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnNo:(id)sender
{
    [self.delegate dismissPopUpKPINo:self];
}
- (IBAction)btnYes:(id)sender
{
    AppDelegate *appDelegae = [[UIApplication sharedApplication] delegate];
    if (appDelegae.checkInternetConnection)
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:NSLocalizedString(@"PLEASE_WAIT", "")];
        HUD.delegate=self;
        [HUD show:YES];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.txtKpiID.text forKey:@"id"];
        
        [JsonClass JsonCallBackKPI:@"http://192.168.1.27:8000/api/v1/system/validate_kpi" parameter:dic sucessBlock:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *ResponseDic = [responseObject mutableCopy];
            if ([[ResponseDic valueForKey:@"result"] intValue] == 1)
            {
                [[NSUserDefaults standardUserDefaults] setObject:self.txtKpiID.text forKey:@"KPI_ID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.delegate dismissPopUpKPIYes:self];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"KPI" message:[[ResponseDic objectForKey:@"msg"] objectAtIndex:0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            
            [HUD hide:YES];
            
        }failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [[[UIAlertView alloc] initWithTitle:@"KPI" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            [HUD hide:YES];
        }];
    }
    
    
   // [self.delegate dismissPopUpKPIYes:self];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -110; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
