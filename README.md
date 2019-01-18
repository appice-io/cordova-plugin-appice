```
// Steps to use plugin

// Create sample project or use your own
if (cordova-plugin) {
    // Use below to create project 
    // myfolder : directory under which app to create
    // org.apache.cordova.myApp : app package name
    // myApp : app name
    cordova create myfolder org.apache.cordova.myApp myApp
}
else if (ionic-plugin) {
    // Use below to create project
    // myfolder : directory under which app to create
    // sidemenu : ionic framework to use
    ionic start myfolder sidemenu
}

// Switch to myfolder
cd myfolder

// Add android platform to project
if (cordova-plugin) {
    // If you are using plugin as cordova wrapper
    cordova platform add android --save
}
else if (ionic-plugin) {
    // If you are using plugin as ionic wrapper
    ionic platform add android
}

// Add appice plugin to project
if (cordova-plugin) {
    // If you are using plugin from npm install
    cordova plugin add cordova-plugin-appice --variable APPICE_APP_ID="appid" --variable APPICE_API_KEY="apikey" --variable APPICE_APP_KEY="appkey"
    
    // If you are using plugin from github install
    cordova plugin add https://github.com/AppICEIO/cordova-plugin-appice.git --variable APPICE_APP_ID="appid" --variable APPICE_API_KEY="apikey" --variable APPICE_APP_KEY="appkey"
    
    // If you are using plugin from local file system
    cordova plugin add /Volumes/Data/workspace_Appice/cordova-plugin-appice --variable APPICE_APP_ID="appid" --variable APPICE_API_KEY="apikey" --variable APPICE_APP_KEY="appkey"
}
else if (ionic-plugin) {
    // If you are using plugin as ionic wrapper
    cordova plugin add https://github.com/AppICEIO/cordova-plugin-appice.git
}

// Sync project with plugin and platform
if (cordova-plugin) {
    // If you are using plugin as cordova wrapper
    cordova prepare
}
else if (ionic-plugin) {
    // If you are using plugin as ionic wrapper
    ionic prepare
}

// To validation integration process
AppICE.validateIntegration(function(success) {
	console.log("Integration Success");
}, function(error) {
	console.error("Ingetration Error : " + error);
});

// To handle notification click handling
AppICE.onNotificationOpen(function(notification) {
    console.log("Notification Data : " + JSON.stringify(notification));
}, function(error) {
    console.error("Notification Error : " + error);
});

// To use appice in your project
// Custom gcm-id for already existing gcm being used
AppICE.initSdk("<app_id>","<app_key>","<api_key>","<Custom gcm id to use>");

// To send events via appice - only key
AppICE.tagEvent("<Key of event>");

// To send events via appice - with key and data
var dataObj = {
    "key1":"val1"
};
AppICE.tagEvent("<Key of event>", dataObj);

// To set custom variables
AppICE.setCustomVariable("<variable name>", "<variable value>");

// To set user info
AppICE.setUser("<user-name>", "<user-phone>", "<user-email>");

// Build project and run
if (cordova-plugin) {
    // If you are using plugin as cordova wrapper
    cordova build android
    cordova run android
}
else if (ionic-plugin) {
    // If you are using plugin as ionic wrapper
    ionic run android -l -c
}

```
