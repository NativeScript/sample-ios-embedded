//
//  CoolApp (NativeScript Side)
//
//  Created by NathanaelA on 10/10/17.
//  Copyright © 2017 nStudio, LLC. All rights reserved.
//


require("./bundle-config");
var application = require("application");
var utils = require('utils/utils');

// We are setting these to be Global so that while you NS app is running you
// can get access to them from anywhere in your JS code.
global.messageFromNative = function(data) {
    var cmd;
    try {
        cmd = JSON.parse(data);
    } catch(err) {
        console.error("Error parsing json", err);
        return;
    }
    if (!cmd || !cmd.do) {
        console.error("Error in json cmd");
        return;
    }
    
    var result=0;
    switch (cmd.do) {
            case 'add': result = cmd.value1 + cmd.value2; break;
            case 'sub': result = cmd.value1 - cmd.value2; break;
            case 'mul': result = cmd.value1 * cmd.value2; break;
            case 'div': result = cmd.value1 / cmd.value2; break;
        default:
            console.log("Unknown cmd", cmd.do);
    }
    console.log("Message Received, value calculated:", result);
    global.messageToNative(result);
}

global.messageToNative = function(message) {
    // Get the app's default notification center
    var center = utils.ios.getter(NSNotificationCenter, NSNotificationCenter.defaultCenter);
    // Add whatever keys and data you want to send back to the Native iOS Application side.
    var dataDictionary = NSDictionary.dictionaryWithObjectForKey(message, "result");
    // Post the message!
    center.postNotificationNameObjectUserInfo("NativeScriptNotification", null, dataDictionary);
}


application.start({ moduleName: "main-page" });

/*
Do not place any code after the application has been started as it will not
be executed on iOS.
*/
