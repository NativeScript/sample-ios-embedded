//
//  ViewController.m
//  EmbeddedRuntime
//
//  Created by Yavor Georgiev on 4.01.16 г..
//  Copyright © 2016 г. NativeScript. All rights reserved.
//

#import "ViewController.h"
#import <NativeScript/NativeScript.h>
#import <JavaScriptCore/JavaScript.h>
#import <JavaScriptCore/JSStringRefCF.h>

@implementation ViewController {
    TNSRuntime *_runtime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initializeRuntime];
}

- (void)_initializeRuntime {
    // The linker-embedded NativeScript metadata.
    extern char startOfMetadataSection __asm("section$start$__DATA$__TNSMetadata");
    
    // You need to call this method only once in your app.
    [TNSRuntime initializeMetadata:&startOfMetadataSection];
    
    // Tell NativeScript where to look for the app folder. Its existence is optional, though.
    _runtime = [[TNSRuntime alloc] initWithApplicationPath:[[NSBundle mainBundle] bundlePath]];
    
    // Schedule the runtime on the runloop of the thread you'd like promises and other microtasks to run on.
    [_runtime scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)sayHello:(id)sender {
    NSString *source = @"var alertView = UIAlertView.alloc().init();"
                        "alertView.title = 'A message from NativeScript';"
                        "alertView.message = 'Hello!';"
                        "alertView.addButtonWithTitle('Dismiss');"
                        "alertView.show();";
    
    JSStringRef script = JSStringCreateWithCFString((__bridge CFStringRef)(source));
    
    JSValueRef error = NULL;
    JSEvaluateScript(_runtime.globalContext, script, NULL, NULL, 0, &error);
    
    JSStringRelease(script);
    
    if (error) {
        JSStringRef stringifiedError = JSValueToStringCopy(_runtime.globalContext, error, NULL);
        NSLog(@"%@", JSStringCopyCFString(kCFAllocatorDefault, stringifiedError));
        JSStringRelease(stringifiedError);
    }
}

@end
