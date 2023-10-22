//
//  STFirebaseHook.m
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

#import "STFirebaseHook.h"

#import <StapeSDK/STSwizzle.h>

@implementation STFirebaseHook

+ (void)installLogEventHook:(FBEventHandler)eventHandler {
    Class FIRAnalyticsPrincipalClass_class = NSClassFromString(@"FIRAnalytics");
    SEL original_selector = NSSelectorFromString(@"logEventWithName:parameters:");
    if (FIRAnalyticsPrincipalClass_class && original_selector) {
        __auto_type hookBlock = ^void (id analytics, id name, id parameters) {
            if (eventHandler) { eventHandler(name, parameters); }
            return ((void(*)(id, SEL, id, id))objc_msgSend)(analytics, stape_swizzled_selector(original_selector), name, parameters);
        };
        stape_swizzle_method(original_selector, FIRAnalyticsPrincipalClass_class, hookBlock);
    }
}

@end
