//
//  STSwizzle.h
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>


#pragma mark - Tools -

#pragma mark - Private -

static NSString * const STAPE_SWIZZLE_PREFIX = @"epats_";
static inline SEL stape_swizzled_selector(SEL original_selector) {
    return NSSelectorFromString([STAPE_SWIZZLE_PREFIX stringByAppendingString:NSStringFromSelector(original_selector)]);
}

#pragma mark - Basic swizzling -

static inline void stape_swizzle_2(Class target_class, Class swizzled_class, SEL original_selector, SEL swizzled_selector) {
    Method original_method = class_getInstanceMethod(target_class, original_selector);
    Method swizzled_method = class_getInstanceMethod(swizzled_class, swizzled_selector);
    
    // Try class methods if no instance
    if (!original_method || !swizzled_method) {
        original_method = class_getClassMethod(target_class, original_selector);
        swizzled_method = class_getClassMethod(target_class, swizzled_selector);
    }
    
    // Should be some client code error, fail silently
    if (!original_method || !swizzled_method) {
        return;
    }
    
    BOOL didAddMethod = class_addMethod(target_class, original_selector, method_getImplementation(swizzled_method), method_getTypeEncoding(swizzled_method));
    
    if (didAddMethod) {
        class_replaceMethod(target_class, swizzled_selector, method_getImplementation(original_method), method_getTypeEncoding(original_method));
    } else {
        method_exchangeImplementations(original_method, swizzled_method);
    }
}

static inline void stape_swizzle(Class target_class, SEL original_selector, SEL swizzled_selector) {
    stape_swizzle_2(target_class, target_class, original_selector, swizzled_selector);
}

static inline void stape_swizzle_selector(SEL selector, Class klass) {
    SEL swizzledSelector = stape_swizzled_selector(selector);
    stape_swizzle(klass, selector, swizzledSelector);
}

#pragma mark - Block based swizzling -

static inline void stape_swizzle_protocol_method(SEL original_selector, Protocol *protocol, Class target_class, id hook_block) {
    SEL swizzled_selector = stape_swizzled_selector(original_selector);
    
    // Swizzle in case target implements method
    IMP hook_implementation = imp_implementationWithBlock(hook_block);
    Method original_method = class_getInstanceMethod(target_class, original_selector);
    if (original_method) {
        struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, original_selector, NO, YES);
        class_addMethod(target_class, swizzled_selector, hook_implementation, methodDescription.types);
        Method swizzled_method = class_getInstanceMethod(target_class, swizzled_selector);
        method_exchangeImplementations(original_method, swizzled_method);
    }
}

static inline void stape_swizzle_method(SEL original_selector, Class target_class, id hook_block) {
    BOOL isInstanceMethod = YES;
    Method original_method = class_getInstanceMethod(target_class, original_selector);
    if (original_method == NULL) {
        original_method = class_getClassMethod(target_class, original_selector);
        if (original_method == NULL) {
            return;
        }
        isInstanceMethod = NO;
    }
    
    IMP implementation = imp_implementationWithBlock(hook_block);
    SEL swizzled_selector = stape_swizzled_selector(original_selector);
    
    BOOL methodAdded = NO;
    if (isInstanceMethod) {
        methodAdded = class_addMethod(target_class, swizzled_selector, implementation, method_getTypeEncoding(original_method));
    } else {
        methodAdded = class_addMethod(objc_getMetaClass(NSStringFromClass(target_class).UTF8String), swizzled_selector, implementation, method_getTypeEncoding(original_method));
    }
    if (!methodAdded) {
        return;
    }
    
    Method newMethod;
    if (isInstanceMethod) {
        newMethod = class_getInstanceMethod(target_class, swizzled_selector);
    } else {
        newMethod = class_getClassMethod(objc_getMetaClass(NSStringFromClass(target_class).UTF8String), swizzled_selector);
    }
    
    method_exchangeImplementations(original_method, newMethod);
}

#pragma mark - Isa swizzling -

static inline void copyMethod(SEL selector, Class sourceClass, Class targetClass) {
    Method objectAtIndexDesc = class_getInstanceMethod(sourceClass, selector);
    const char *objectAtIndexTypes = method_getTypeEncoding(objectAtIndexDesc);
    IMP objectAtIndexIMP = class_getMethodImplementation(sourceClass, selector);
    BOOL objectAtIndexAdded = class_addMethod(targetClass, selector, objectAtIndexIMP, objectAtIndexTypes);
    if (!objectAtIndexAdded) {
        NSLog(@"Adding %@ failed...", NSStringFromSelector(selector));
    }
}
