//
//  JsonClass.m
//  Checkin
//
//  Created by Rajat Lala on 15/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import "JsonClass.h"

@implementation JsonClass

+(void)JsonCallBack:(NSString *)url
          parameter:(NSDictionary *)params
        sucessBlock:(void (^)(id responseObject))sucess
       failureBlock:(void (^)(NSError *error))fail
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *authStr = [params valueForKey:@"password"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedDataWithOptions:80]];
    
    NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }

    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: language forHTTPHeaderField:@"Localization"];

       NSError *error;

    NSData* myJSONData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody: myJSONData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];

    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);

    }];
    [op start];
}



+(void)JsonCallBackCity:(NSString *)url
             username:(NSString *)uname
            password:(NSString *)psw
            countrycode:(NSString *)ccode
           sucessBlock:(void (^)(id responseObject))sucess
          failureBlock:(void (^)(NSError *error))fail
{
NSString *username = uname;
NSString *password = psw;

//HTTP Basic Authentication
NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
NSString *authenticationValue = [authenticationData base64Encoding];
    
NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }


//Set up your request
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

// Set your user login credentials
[request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];

[request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
[request setValue: language forHTTPHeaderField:@"Localization"];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];
}


+(void)JsonCallQuote:(NSString *)url
               username:(NSString *)uname
               password:(NSString *)psw
            countrycode:(NSString *)ccode
            sucessBlock:(void (^)(id responseObject))sucess
           failureBlock:(void (^)(NSError *error))fail
{
    NSString *username = uname;
    NSString *password = psw;
    
    //HTTP Basic Authentication
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }


    
    // Set your user login credentials
    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];
    
    [request setValue: language forHTTPHeaderField:@"Localization"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];
}

+(void)JsonCallBackDelete:(NSString *)url
          parameter:(NSDictionary *)params
        sucessBlock:(void (^)(id responseObject))sucess
       failureBlock:(void (^)(NSError *error))fail
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:30];
    
    [request setHTTPMethod:@"DELETE"];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", authenticationValue];
    
    NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }

    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: language forHTTPHeaderField:@"Localization"];
    
    NSError *error;
    
    NSData* myJSONData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody: myJSONData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];
}




+(void)JsonCallBackCheckout:(NSString *)url
                parameter:(NSMutableArray *)params
              sucessBlock:(void (^)(id responseObject))sucess
             failureBlock:(void (^)(NSError *error))fail
{
    
    NSURL *URL = [NSURL URLWithString:@"http://192.168.1.27:8000/api/v1/kpi_entry/entry"];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    
        NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
        NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authenticationValue = [authenticationData base64Encoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", authenticationValue];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"500" forHTTPHeaderField:@"Content-Length"];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"EN" forHTTPHeaderField:@"Localization"];
    
    NSError *error;
    
        NSData* myJSONData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
        [request setHTTPBody: myJSONData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
        
        NSDictionary *json = [responseObject mutableCopy];
        if ([[json objectForKey:@"result_code"] isEqualToString:@"1"])
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"CHECKOUTCALL"] isEqualToString:@"YES"])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"callnotification" object:nil userInfo:json];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"callnotificationViewController" object:nil userInfo:json];
            }
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"proj_tmp"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"working_tmp"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"task_tmp"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"city_tmp"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];

}

+(void)JsonCallBackGetHistory:(NSString *)url
                  fromDate:(NSString *)fDate
                     toDate:(NSString *)tDate
                    pages:(NSString *)page
                    sizes:(NSString *)size
                sucessBlock:(void (^)(id responseObject))sucess
               failureBlock:(void (^)(NSError *error))fail
{
   // NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://112.124.28.10:8000/api/v1/kpi_entry/entry?1&%@&%@&%@&%@",fDate,tDate,page,size]];
    
    //NSURL *URL = [NSURL URLWithString:@"http://112.124.28.10:8000/api/v1/kpi_entry/entry?kpi_id=1&page=1&size=10"];
    NSURL *URL = [NSURL URLWithString:url];

    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", authenticationValue];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    //[request setHTTPMethod:@"GET"];
    
    [request setHTTPMethod:@"GET"];
    
    NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:language forHTTPHeaderField:@"Localization"];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];

}

+(time_t)uptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"Boottime"]==nil)
    {
        NSString *strBoot = [NSString stringWithFormat:@"%ld",boottime.tv_sec];
        [[NSUserDefaults standardUserDefaults] setObject: strBoot forKey:@"Boottime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        
        int tmm=((now - (boottime.tv_sec)) -[[[NSUserDefaults standardUserDefaults] valueForKey:@"TimerTimer"] intValue]);
       // NSLog(@"%d",tmm);
        
        if(tmm<0)
        {
            uptime = now - [[[NSUserDefaults standardUserDefaults] valueForKey:@"Boottime"] intValue];
        }
        else
        {
            uptime = now - (boottime.tv_sec);
            NSLog(@"Boottime %ld",boottime.tv_sec);
        }
    }
    return uptime;
}
+(void)JsonCallBackTime:(NSString *)url
               username:(NSString *)uname
               password:(NSString *)psw
            countrycode:(NSString *)ccode
            sucessBlock:(void (^)(id responseObject))sucess
           failureBlock:(void (^)(NSError *error))fail
{
    NSString *username = uname;
    NSString *password = psw;
    
    //HTTP Basic Authentication
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    
    NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }
    //Set up your request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:15];

    // Set your user login credentials
    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];
    
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: language forHTTPHeaderField:@"Localization"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];
}

+(void)JsonCallBackKPI:(NSString *)url
                parameter:(NSDictionary *)params
              sucessBlock:(void (^)(id responseObject))sucess
             failureBlock:(void (^)(NSError *error))fail
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [authenticationData base64Encoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", authenticationValue];
    
    NSString *language = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] uppercaseString];
    if([language containsString:@"ZH"] || [language containsString:@"CN"])
    {
        language = @"CN";
    }
    else if ([language containsString:@"DE"])
    {
        language=@"DE";
    }
    else
    {
        language = @"EN";
    }
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: language forHTTPHeaderField:@"Localization"];
    
    NSError *error;
    
    NSData* myJSONData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody: myJSONData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        sucess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        fail(error);
        
    }];
    [op start];
}


+ (void)dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

+ (void)showPopupWithTitle:(NSString *)title
                    mesage:(NSString *)message
              dismissAfter:(NSTimeInterval)interval
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:nil
                              ];
    [alertView show];
    [self performSelector:@selector(dismissAlert:)
               withObject:alertView
               afterDelay:interval
     ];
}

+(BOOL) containString : (NSString*) string
{
    if([string containsString:@"-"])
    {
        return true;
    }
    else
    {
        return false;
    }
}

@end
