//
//  PopupForCheckOut.h
//  Checkin
//
//  Created by Rajat Lala on 19/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popUpCheckOutDelegate

-(void)dismissPopUpCheckOutYes:(UIViewController *)view;
-(void)dismissPopUpCheckOutNo:(UIViewController *)view;

@end

@interface PopupForCheckOut : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
@property (strong, nonatomic) IBOutlet UIButton *btnNo;
@property (strong, nonatomic) IBOutlet UIButton *btnYes;
@property (strong, nonatomic) id <popUpCheckOutDelegate> delegate;
-(void)callingJsonMethod;

- (IBAction)btnCheckout:(id)sender;
- (IBAction)btnNO:(id)sender;

@end
