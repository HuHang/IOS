//
//  ChangeCity.m
//  Checkin
//
//  Created by Rajat Lala on 16/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import "ChangeCity.h"
#import "UIViewController+MJPopupViewController.h"
#import "PopupAlertVC.h"
#import "ViewController.h"
#import "JsonClass.h"

@interface ChangeCity ()<popUpViewDelegate1>
{
    NSMutableArray *ArrTbl;
    NSMutableArray *pickerArray,*arrChar ;
    NSMutableDictionary *arrFinalDic;
    NSString *SelectedCity;
    NSMutableArray *AllCity;
    NSMutableDictionary *responseDict;
}
@end

@implementation ChangeCity

-(void)viewWillAppear:(BOOL)animated
{
    //[self CallJsonMethod];
    self.tblChangeCity.sectionIndexColor = [UIColor colorWithRed:1.0/255.0 green:156.0/255.0 blue:220.0/255.0 alpha:1];
    [self.btnCancel setTitle:NSLocalizedString(@"CANCEL", "") forState:UIControlStateNormal];
    
    AllCity=[[NSMutableArray alloc] init];
    
    NSArray *arrAllKeys=[[[NSUserDefaults standardUserDefaults] valueForKey:@"CityDictionary"] allKeys];
    for (int i =0; i<arrAllKeys.count; i++)
    {
        for (int j=0; j<[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CityDictionary"] objectForKey:[arrAllKeys objectAtIndex:i]] count]; j++)
        {
            
            [AllCity addObject:[NSString stringWithFormat:@"%@%@",[arrAllKeys objectAtIndex:i],[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CityDictionary"] objectForKey:[arrAllKeys objectAtIndex:i]] objectAtIndex:j] objectForKey:@"name"]]];
            
        }
    }
    NSArray *SortedArr = [AllCity sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [AllCity removeAllObjects];
    AllCity=[SortedArr mutableCopy];
    
    [self createSactionList:AllCity];
    [self.tblChangeCity reloadData];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"filter"];


}
-(void)CallJsonMethod
{
    AllCity=[[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.27:8000/api/v1/system/cities?%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CountyCode"]];
    
    [JsonClass JsonCallBackCity:url username:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"] countrycode:nil sucessBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        responseDict=[responseObject mutableCopy];
        NSArray *arrAllKeys=[responseDict allKeys];
        for (int i =0; i<arrAllKeys.count; i++)
        {
            for (int j=0; j<[[responseDict objectForKey:[arrAllKeys objectAtIndex:i]] count]; j++)
            {
                
                [AllCity addObject:[NSString stringWithFormat:@"%@%@",[arrAllKeys objectAtIndex:i],[[[responseDict objectForKey:[arrAllKeys objectAtIndex:i]] objectAtIndex:j] objectForKey:@"name"]]];
                
            }
        }
        NSArray *SortedArr = [AllCity sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [AllCity removeAllObjects];
        AllCity=[SortedArr mutableCopy];
        
        [self createSactionList:AllCity];
        //[self initUI];
        [self.tblChangeCity reloadData];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"filter"];
        } failureBlock:^(NSError *error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *lang = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];

    arrChar = [[NSMutableArray alloc]init];
    arrFinalDic = [[NSMutableDictionary alloc]init];
    self.tblChangeCity.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tblChangeCity.sectionIndexColor = [UIColor blackColor];
}
-(void)createSactionList:(NSMutableArray *)wordArray {
    for(char c='A'; c<='Z'; c++)
    {
        NSMutableArray *arrayOfNames = [[NSMutableArray alloc] init];
        
        for(int i=0;i<[wordArray count];i++)
        {
            NSString *temp = [wordArray objectAtIndex:i];
            if (temp.length>1)
            {
                NSString *tempAtIndex=[temp substringWithRange:NSMakeRange(0, 1)];
                if([[tempAtIndex uppercaseString] isEqualToString:[NSString stringWithFormat:@"%c",c]])
                {
                    [arrayOfNames addObject:[wordArray objectAtIndex:i]];
                }
            }
        }
        if([arrayOfNames count] >0)
        {
            [arrChar addObject:[NSString stringWithFormat:@"%c",c]];
            [arrFinalDic setObject:arrayOfNames forKey:[NSString stringWithFormat:@"%c",c]];
        }
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [arrChar count];
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return [pickerArray count];
    return [[arrFinalDic objectForKey:[arrChar objectAtIndex:section]] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [arrChar objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCity" forIndexPath:indexPath];
    
    cell.textLabel.text=[[[arrFinalDic objectForKey:[arrChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] substringFromIndex:1];
    
    cell.textLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:140.0/255.0 alpha:1];
    
    return cell;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arrChar;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedCity=[[arrFinalDic objectForKey:[arrChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self.delegate selectedCity:SelectedCity];
    [self dismissViewControllerAnimated:YES completion:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
  //  view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:140.0/255.0 alpha:1]];
}

- (IBAction)btnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)btnLogout:(id)sender
{
    PopupAlertVC *detailViewController = [[PopupAlertVC alloc] initWithNibName:@"PopupAlertVC" bundle:nil];
    detailViewController.delegate=self;
    [self presentPopupViewController:detailViewController animationType:0];
}

-(void)dismissPopUpViewYes:(UIViewController *)view
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"LOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)dismissPopUpViewNo:(UIViewController *)view
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
