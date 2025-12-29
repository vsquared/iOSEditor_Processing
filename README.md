# iOSEditor_Processing
This MacOS Processing (v4.4.10) demo will allow the user to test run iOS apps on a simulator app (not on actual device). Installation of XCode is required for the simulator and sdk as well as two '.jar' files: dd-plist.jar for creating an Info.plist and rsyntaxtextarea-3.6.0.jar for syntax highlighting. The '.jar' files are pre-installed inside a 'code' folder in the sketch folder.  If for some reason they don't work, the easiest way to install them is to drag 'n drop them onto the '.pde' file open in the Processing editor.  The '.jar' files are also available in a separate folder or may be download from the provided urls.  Test code using Swift's UIKit is provided and may serve as a template for other iOS apps. It is recommended to create a separate folder on your Desktop to hold all of the test '.swift' files and corresponding iOS apps. The XCode sdk path is hard-coded in the source code (buildExecutable(), line 313) and may need to be changed for your system.  The 'folderStr' (line 44) should also be set in code for your system (may also be transitorily set by the toolbar button).

An iOS app bundle is basically a folder with an '.app' extension and containing an executable and Info.plist files.  If there is a problem creating the iOS app bundle you will likely see the simulator home screen with an app icon that has a superimposed cloud with a downward arrow.  This app is not runnable and should be deleted.  When a failure occurs it usually is because the executable was not created.  You may right click on the iOS app icon and select Show Package Contents to see bundle files. 

Steps necessary for the code to work correctly:

1. Load Sims at startup
2. Build iOS app bundle containing an executable and Info.plist files 
3. Boot Simulator
4. Install iOS App
5. Launch iOS App
6. Launch Simulator
7. Be patient - it takes a while to do all this

The progress of each step is printed in the log area at the bottom; each will have an exit code of '0' when working correctly.

To use the app:
1. 'File/open' the 'yellow.swift' test file
2. Select a simulator to use (eg, iPhone 16 Pro)
3. Hit the 'Run' button and patiently wait (takes time to run through multiple steps).
   
Output:

<img width="458" height="977" alt="yellow" src="https://github.com/user-attachments/assets/e30a0ef3-1c97-44e2-8c29-dc09b19bac02" />
