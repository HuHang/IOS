//
//  JsonClass.h
//  Checkin
//
//  Created by Rajat Lala on 15/10/15.
//  Copyright © 2015 Solulab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <mach/mach_time.h>
#import  <sys/sysctl.h>

@interface JsonClass : NSObject

+(void)JsonCallBack:(NSString *)url
          parameter:(NSDictionary *)params
        sucessBlock:(void (^)(id responseObject))sucess
       failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallBackGET:(NSString *)url
          parameter:(NSDictionary *)params
        sucessBlock:(void (^)(id responseObject))sucess
       failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallBackCity:(NSString *)url
               username:(NSString *)uname
               password:(NSString *)psw
               countrycode:(NSString *)ccode
            sucessBlock:(void (^)(id responseObject))sucess
           failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallQuote:(NSString *)url
               username:(NSString *)uname
               password:(NSString *)psw
            countrycode:(NSString *)ccode
            sucessBlock:(void (^)(id responseObject))sucess
           failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallBackDelete:(NSString *)url
                parameter:(NSDictionary *)params
              sucessBlock:(void (^)(id responseObject))sucess
             failureBlock:(void (^)(NSError *error))fail;


+(void)JsonCallBackCheckout:(NSString *)url
                parameter:(NSMutableArray *)params
              sucessBlock:(void (^)(id responseObject))sucess
             failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallBackGetHistory:(NSString *)url
                     fromDate:(NSString *)fDate
                       toDate:(NSString *)tDate
                        pages:(NSString *)page
                        sizes:(NSString *)size
                  sucessBlock:(void (^)(id responseObject))sucess
                 failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallBackTime:(NSString *)url
               username:(NSString *)uname
               password:(NSString *)psw
            countrycode:(NSString *)ccode
            sucessBlock:(void (^)(id responseObject))sucess
           failureBlock:(void (^)(NSError *error))fail;

+(void)JsonCallBackKPI:(NSString *)url
             parameter:(NSDictionary *)params
           sucessBlock:(void (^)(id responseObject))sucess
          failureBlock:(void (^)(NSError *error))fai;

+(time_t)uptime;
+ (void)dismissAlert:(UIAlertView *)alertView;
+ (void)showPopupWithTitle:(NSString *)title
                    mesage:(NSString *)message
              dismissAfter:(NSTimeInterval)interval;
+(BOOL) containString : (NSString*) string;

@end

