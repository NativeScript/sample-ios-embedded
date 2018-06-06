# NativeScript Embedding in an Native iOS application

This repo contains a full XCode native sample app (*CoolApp*) with NativeScript app (*nsapp*) embedded into it.  

## Installation & Running the example application

Now there are a couple things you need to do before you can run it.  We assume you have NativeScript and Cocoapods support in your environment; if not; please read the documetation at http://nativescript.org on how to install everything you need.

- Clone this repo
- open a terminal and then navigate to where you downloaded this repo at
- `cd nsapp`
- `tns install && tns build ios`
- `cd ../CoolApp`
- `pod install`

You should now be able to open the `CoolApp/CoolApp.xcworkspace` up in **XCode** and then run the application on a simulator or device.

##Embedding NativeScript in your own project

For very detailed documentation on the entire process, which walks you through all the steps to make this process work; please read the [HOWTO.md](HOWTO.md) file.

