//
//  ViewController.h
//  CoolApp
//
//  Created by Yavor Georgiev on 4.01.16 г..
//  Modified by NathanaelA on 10/10/17.
//  Copyright © 2016 г. NativeScript. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)activateNativeScript:(id)sender;

- (void) receiveNativeScriptNotification:(NSNotification *) notification;

@end

