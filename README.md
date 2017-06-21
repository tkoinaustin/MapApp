# TKOMapApp
### aka, Map App
Use the Open Cage API for forward Geocoding lookups

## App Store
This project has been accepted by Apple and is available for free in the [App Store](https://itunes.apple.com/us/app/tkomapapp/id1244478409?ls=1&mt=8). The apps functionality is minimal, but I have it available for download so you can play with it. The source code is available here and you can see it in action as well what the back end is doing. 

## About the code
There is a lot going on in the program. I use SwiftyJSON because it's close to insanity not to when dealing with JSON structures. I also make regular use of PromiseKit to handle the asynchronous calls in a more reasonable manner. Both of these pods are used regularly in my projects. 

This project was an experiment in reactive programming. I included RxSwift and RxCocoa to take them out for a test drive. I do like what they are capable of, but it really is a different way of thinking about programming. My current employer has not committed to reactive programming, but has not ruled it out either, so I will probably continue to use it. 

Ultimately all I am doing is accessing public API's, which is what the majority of mobile apps need to do, if they need access to any information at all. The API class combined with the Endpoint class do most of the heavy lifting for accessing data.

I have also added a few niceties. There is a FTUE view that will show up once to give the use an overview of the app, as well as an intro that is there for eye candy.

## Installation

Clone the project using the 'Clone or Download' link

## Dependencies

You will need Cocoapods install on your development computer, see: [Cocoapods](https://cocoapods.org)

Then run the usual 'pod install' to install the required modules. You need to close the project and open the workspace from now on.

## Watch your language!

I use SwiftLint to enforce good hygene. If you do not have SwiftLint installed it skips the check. To get SwiftLint go [here](https://github.com/realm/SwiftLint) and follow the instructions.

## Updating the OpenCage API Key

Follow the instructions to obtain your free API key [here](https://geocoder.opencagedata.com/api)

### Then, in your project directory:

Copy 'TKOMapApp/APIinfo.plist.template' to 'TKOMapApp/APIinfo.plist'

Add 'TKOMapApp/APIinfo.plist' to your project

Open and edit the file, add your key value to the OpenCageAPIkey entry under Root

### Build and run

If there is a problem with the API key setup, the program will tell you
