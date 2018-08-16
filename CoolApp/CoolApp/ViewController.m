//
//  ViewController.m
//  CoolApp
//
//  Created by Yavor Georgiev on 4.01.16 г..
//  Modified by NathanaelA on 10/10/17.
//  Copyright © 2016 г. NativeScript. All rights reserved.
//

#import "ViewController.h"
#import <NativeScript/NativeScript.h>
#import <JavaScriptCore/JavaScript.h>
#import <JavaScriptCore/JSStringRefCF.h>

@implementation ViewController {
    TNSRuntime *_runtime;
    Boolean hasStarted;
    int counter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    counter=0;
    [self _initializeRuntime];
    
    [NativeScriptEmbedder sharedInstance].delegate = self;
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
    
    // This enables NativeScript Logging to the Console
    [TNSRuntimeInspector setLogsToSystemConsole:YES];
    
    
    // This code is used for creating a communication channel from NativeScript back into your Native code base.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNativeScriptNotification:)
                                                 name: @"NativeScriptNotification"
                                               object:nil];

}

/**
 This is an example function will talk into the
 JavaScript engine and get a value from the "Global" object.
 You can actually get and set values inside the engine using simular code
 **/
- (NSString *)_getJSValue: (NSString *)key {
    JSValueRef error = NULL;
    JSStringRef propertyName = JSStringCreateWithCFString((__bridge CFStringRef)(key));
    JSObjectRef globalObject = JSContextGetGlobalObject(_runtime.globalContext);
    
    JSValueRef result = JSObjectGetProperty(_runtime.globalContext, globalObject, propertyName, &error);
    JSStringRelease(propertyName);
    
    NSString *stringResult = NULL;
    if (error) {
        JSStringRef stringifiedError = JSValueToStringCopy(_runtime.globalContext, error, NULL);
        NSLog(@"Error from NativeScript: %@", JSStringCopyCFString(kCFAllocatorDefault, stringifiedError));
        JSStringRelease(stringifiedError);
    } else {
        JSStringRef stringifiedResult = JSValueToStringCopy(_runtime.globalContext, result, NULL);
        stringResult = CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, stringifiedResult));
        NSLog(@"Result from NativeScript: %@", stringResult);
        JSStringRelease(stringifiedResult);
        
    }
    return stringResult;
}

/**
 This function wraps up sending and running a NSString into the NativeScript engine
 **/
- (void)_runScript: (NSString *)source {
    JSValueRef error = NULL;
    JSStringRef script = JSStringCreateWithCFString((__bridge CFStringRef)(source));
    JSEvaluateScript(_runtime.globalContext, script, NULL, NULL, 0, &error);
    JSStringRelease(script);
    
    if (error) {
        JSStringRef stringifiedError = JSValueToStringCopy(_runtime.globalContext, error, NULL);
        NSLog(@"Error: %@", JSStringCopyCFString(kCFAllocatorDefault, stringifiedError));
        JSStringRelease(stringifiedError);
        return;
    }
}

- (void)activateNativeScript:(id)sender {
    // Here we are calling into the Standard NS libraries to just open a dialog box
    NSString *source = @"var alertView = UIAlertView.alloc().init();"
    "alertView.title = 'A message from NativeScript';"
    "alertView.message = 'Hello!';"
    "alertView.addButtonWithTitle('Dismiss');"
    "alertView.show();";
    
    // Here we open a different Screen, the standard NativeScript demo with one small change.
    NSString *source2 = @"var application = require('application');"
    "application.start({ moduleName: 'clicker' });";
    
    // Look we are re-opening up the main-page screen again, you can do this all day log.
    NSString *source3 = @"var application = require('application');"
    "application.start({ moduleName: 'main-page' });";
 
    // This is how we are communicating into the running program
    // This JavaScript routine handles doing whatever we need the message to do;
    // Normally in an app; this function would probably be a event listener, that would receive the event
    // and then posts the event to any JavaScript listeners that are waiting for any events.
    NSString *source3a = @"global.messageFromNative('{\"do\": \"add\", \"value1\": 1, \"value2\": 1}');";

    
    
    // executeModule is only allowed to be ran once, so that function launches the application almost exactly
    // like NativeScript normally would.   However, the easier way to do this is the "else" side of the loop
    // it is really the better way to do it; and you do NOT ever need to call executeModule if you just want to
    // use the runScript method
    if (!hasStarted) {
        hasStarted = YES;
        // executeModule can ONLY be ran once!
        [ _runtime executeModule: @"./"];
    } else {
        if (counter == 0) {
            // Just to show you how you can read a variable from the JavaScript global scope object
            // You can do this on each loop, but no need to dirty the logs with basically the same values
            [ self _getJSValue: @"_NativeScriptValue" ];
        }
        
        counter++;
        switch (counter) {
            case 1:
                [ self _runScript: source ];
                break;
            case 2:
                [ self _runScript: source2 ];
                break;
            case 3:
                // Look we Start a new screen
                [ self _runScript: source3 ];
                // Then we send it a call with data it needs to do!
                // This is the KEY; you can send data and execute functions inside the VM
                // AT ANY time, while the NS app is running, so this
                // Allows you to communicate inside the application any values
                [ self _runScript: source3a ];
                counter = 0;
                break;
        }
    }
    
}

// We use this to receive back any communication from NativeScript application.
// I just log it out, but you can take the result and do whatever you need with it...
- (void) receiveNativeScriptNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"NativeScriptNotification"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *value = [userInfo objectForKey:@"result"];
        NSLog (@"Successfully received %@ from NativeScript!", value);

    }
    
    
}

- (id)presentNativeScriptApp: (UIViewController*) vc {
    [self presentViewController:vc animated:YES completion:NULL];
    return 0;
}

@end

