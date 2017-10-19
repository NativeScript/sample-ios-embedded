//
//  CoolApp (NativeScript Side)
//
//  Created by NathanaelA on 10/10/17.
//  Copyright © 2017 nStudio, LLC. All rights reserved.
//

var Observable = require("data/observable").Observable;
var frame = require("ui/frame");
var application = require('application');


function getMessage(counter) {
    if (counter <= 0) {
        return "Hoorraaay! You unlocked the NativeScript clicker achievement!";
    } else {
        return counter + " taps left";
    }
}

function createViewModel() {
    global._NativeScriptValue = "I'm a NativeScript set value.";

    var viewModel = new Observable();
    viewModel.counter = 10;
    viewModel.message = getMessage(viewModel.counter);

    viewModel.onTap = function() {
        this.counter--;
        this.set("message", getMessage(this.counter));
    }

    viewModel.onDrawing = function() {
       frame.topmost().navigate('drawing');
    }

    viewModel.onClicker = function() {
       frame.topmost().navigate('clicker');
    }

    // This goes back a screen in NativeScript
    viewModel.onBack = function() {
       frame.topmost().goBack();
    }
    
    // This goes back to your Native side of the Application
    viewModel.onBack2 = function() {
        var window = application.ios.nativeApp.keyWindow || (application.ios.nativeApp.windows.count > 0 && application.ios.nativeApp.windows[0]);
	  if (window) {
	    var rootController = window.rootViewController;
          if (rootController) {
            rootController.dismissViewControllerAnimatedCompletion(true, null);
          }
	  }
    }

    return viewModel;
}

exports.createViewModel = createViewModel;
