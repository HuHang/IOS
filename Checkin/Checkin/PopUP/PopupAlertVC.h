//
//  PopupAlertVC.h
//  Checkin
//
//  Created by Rajat Lala on 19/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol popUpViewDelegate1 <MBProgressHUDDelegate>

-(void)dismissPopUpViewYes:(UIViewController *)view;
-(void)dismissPopUpViewNo:(UIViewController *)view;

@end

@interface PopupAlertVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
@property (strong, nonatomic) IBOutlet UILabel *lblMsg;
@property (strong, nonatomic) IBOutlet UIButton *btnNo;
@property (strong, nonatomic) IBOutlet UIButton *btnYes;
@property (strong, nonatomic) id <popUpViewDelegate1> delegate;
-(void)SendPendingData;
@end
