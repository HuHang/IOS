//
//  PopupKPI.h
//  Checkin
//
//  Created by Rajat Lala on 16/11/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol popUpKpiIDDelegate
-(void)dismissPopUpKPIYes:(UIViewController *)view;
-(void)dismissPopUpKPINo:(UIViewController *)view;
@end

@interface PopupKPI : UIViewController <MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UILabel *HeaderLbl;
@property (strong, nonatomic) IBOutlet UITextField *txtKpiID;
@property (strong, nonatomic) IBOutlet UIButton *btnNo;
- (IBAction)btnNo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnYes;
- (IBAction)btnYes:(id)sender;
@property (strong, nonatomic) id <popUpKpiIDDelegate> delegate;

@end
