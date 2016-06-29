//
//  ChangeCity.h
//  Checkin
//
//  Created by Rajat Lala on 16/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popUpDelegate

@optional
-(void)dismissPopUpViewYes:(UIViewController *)view;
-(void)dismissPopUpViewNo:(UIViewController *)view;
-(void)selectedCity:(NSString *)city;

@end


@interface ChangeCity : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) id <popUpDelegate> delegate;

- (IBAction)btnCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblChangeCity;
@end
