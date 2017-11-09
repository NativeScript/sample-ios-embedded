//
//  ViewController.h
//  CoolApp
//
//  Created by NathanaelA on 10/10/17.
//  Copyright © 2017 nStudio, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)activateNativeScript:(id)sender;

- (void) receiveNativeScriptNotification:(NSNotification *) notification;

@end

