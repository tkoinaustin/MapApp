# TKOMapApp
### aka, Map App
Use the Open Cage API for forward Geocoding lookups

## Installation

Clone the project using the 'Clone or Download' link

## Dependencies

You will need Cocoapods install on your development computer, see: https://cocoapods.org

Then run the usual 'pod install' to install the required modules. You need to close the project and open the workspace from now on.

## Watch your language!

I use SwiftLint to enforce good hygene. If you do not have SwiftLint installed it skips the check. To get SwiftLint go to https://github.com/realm/SwiftLint and follow the instructions.

## Updating the OpenCage API Key

Follow the instructions to obtain your free API key here: https://geocoder.opencagedata.com/api

### Then, in your project directory:

Copy 'TKOMapApp/APIinfo.plist.template' to 'TKOMapApp/APIinfo.plist'

Add 'TKOMapApp/APIinfo.plist' to your project

Open and edit the file, add your key value to the OpenCageAPIkey entry under Root

### Build and run

If there is a problem with the API key setup, the program will tell you
