//
//  ASFirebaseHook.h
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FBEventHandler)(id __nullable name, id __nullable parameters);

@interface STFirebaseHook : NSObject

+ (void)installLogEventHook:(FBEventHandler)eventHandler;

@end

NS_ASSUME_NONNULL_END
