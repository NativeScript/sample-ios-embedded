# Embedding the NativeScript iOS Runtime in an iOS app

## How to run

1. Execute `npm install` in the project folder in order to pull down the runtime dependency.
2. Open `EmbeddedRuntime.xcodeproj` and press Play.
3. PROFIT!!!

## How to embed the runtime in your app

### Configuring your project

1. Download the `tns-ios` package off of npm.
2. Link against `NativeScript.framework`, found in `path-to-tns-ios/framework/internal/NativeScript/Frameworks`.
3. Add a new Run Script build phase, making sure to place it BEFORE the Compile Sources. Name it "Generate NativeScript metadata" if you like. Assuming the shell is `/bin/sh`, the script is `cd "path-to-tns-ios/framework/internal/metadata-generator/bin" && ./metadata-generation-build-step`
4. Add the following to the Other Linker Flags build setting: `-sectcreate __DATA __TNSMetadata "$(CONFIGURATION_BUILD_DIR)/metadata-$(CURRENT_ARCH).bin"`.

### Using the runtime

An instance of the runtime is created using the `TNSRuntime` class via the `-[TNSRuntime initWithApplicationPath:]` method. This tells the runtime where to look for the `app` folder, which is usually the application bundle. An `app` folder is not required, provided you don't use JavaScript modules.

Before instantiating the runtime, though, you need to feed it the metadata generated in steps 3 and 4 above:

```
extern char startOfMetadataSection __asm("section$start$__DATA$__TNSMetadata");
[TNSRuntime initializeMetadata:&startOfMetadataSection];
```

If you use promises, you will need to schedule the runtime on a runloop using `-[TNSRuntime scheduleInRunLoop:forMode:]`. This is usually the runloop of the thread you will interact with the runtime on.

Finally, you can either evaluate a script directly into the runtime using `JSEvaluateScript` or you can "require" a JavaScript module by calling `-[TNSRuntime executeModule:]` and passing a module identifier just like you would to the JavaScript `require` function. Note that repeated invocations of `executeModule:` on the same instance of the runtime have undefined results and are not supported as of 1.5.2.

See `ViewController.m` for a complete example.

NOTE: NativeScript supports only the C API of JavaScriptCore - the Objective-C API is not enabled as it needs private iOS functions to function. Using the built-in JavaScriptCore framework and NativeScript in the same app will likely not work.