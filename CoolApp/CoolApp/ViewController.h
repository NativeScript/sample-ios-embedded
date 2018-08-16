//
//  ViewController.h
//  CoolApp
//
//  Created by Yavor Georgiev on 4.01.16 г..
//  Copyright © 2016 г. NativeScript. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeScriptEmbedder.h"

@interface ViewController : UIViewController <NativeScriptEmbedderDelegate>

- (IBAction)activateNativeScript:(id)sender;

- (void) receiveNativeScriptNotification:(NSNotification *) notification;

@end

