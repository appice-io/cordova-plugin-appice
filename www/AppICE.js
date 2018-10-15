
//  Copyright (C) 2015 AppICE
//
//  This code is provided under a commercial License.
//  A copy of this license has been distributed in a file called LICENSE
//  with this source code.
//
               
var AppICE = function () {
}
               
AppICE.prototype.startContext = function(gcmID, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "startContext", [{"gcmID":gcmID}]);
};

AppICE.prototype.stopContext = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "stopContext", []);
};

AppICE.prototype.isSemusiSensing = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "isSemusiSensing", []);
};

AppICE.prototype.setAsTestDevice = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setAsTestDevice", []);
};

AppICE.prototype.removeAsTestDevice = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "removeAsTestDevice", []);
};

AppICE.prototype.getIsTestDevice = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getIsTestDevice", []);
};

AppICE.prototype.openPlayServiceUpdate = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "openPlayServiceUpdate", []);
};

AppICE.prototype.getSdkVersion = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getSdkVersion", []);
};

AppICE.prototype.getSdkIntVersion = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getSdkIntVersion", []);
};

AppICE.prototype.setDeviceId = function(deviceID, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setDeviceId", [{"deviceID":deviceID}]);
};

AppICE.prototype.getDeviceId = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getDeviceId", []);
};

AppICE.prototype.getAndroidId = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getAndroidId", []);
};

AppICE.prototype.getAppKey = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getAppKey", []);
}

AppICE.prototype.getApiKey = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getApiKey", []);
}

AppICE.prototype.getAppId = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getAppId", []);
}

AppICE.prototype.getCurrentContext = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getCurrentContext", []);
}

AppICE.prototype.setAlias = function(alias, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setAlias", [{"alias":alias}]);
};

AppICE.prototype.getAlias = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getAlias", []);
};

AppICE.prototype.setUser = function(name, phone, email, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setUser", [{"name":name, "phone":phone, "email":email}]);
};

AppICE.prototype.getUser = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getUser", []);
};

AppICE.prototype.setChildId = function(childID, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setChildId", [{"childID":childID}]);
};

AppICE.prototype.getChildId = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getChildId", []);
};

AppICE.prototype.setReferrer = function(referrer, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setReferrer", [{"referrer":referrer}]);
};

AppICE.prototype.getReferrer = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getReferrer", []);
};

AppICE.prototype.setInstallReferrer = function(installRef, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setInstallReferrer", [{"installRef":installRef}]);
};

AppICE.prototype.getInstallReferrer = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getInstallReferrer", []);
};

AppICE.prototype.setInstaller = function(installer, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setInstaller", [{"installer":installer}]);
};

AppICE.prototype.getInstaller = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getInstaller", []);
};

AppICE.prototype.getGCMSenderId = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getGCMSenderId", []);
};

AppICE.prototype.getDeviceToken = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getDeviceToken", []);
};

AppICE.prototype.setCustomVariable = function(key, value, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setCustomVariable", [{"key":key, "value":value}]);
};

AppICE.prototype.getCustomVariable = function(key, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getCustomVariable", [{"key":key}]);
};

AppICE.prototype.removeCustomVariable = function(key, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "removeCustomVariable", [{"key":key}]);
};

AppICE.prototype.tagEvent = function(key, data, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "tagEvent", [{"key":key, "data":data}]);
};

AppICE.prototype.setSmallIcon = function(icon, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setSmallIcon", [{"icon":icon}]);
};

AppICE.prototype.setSessionTimeout = function(timeout, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "setSessionTimeout", [{"timeout":timeout}]);
};

AppICE.prototype.getSessionTimeout = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "getSessionTimeout", []);
};

AppICE.prototype.onNotificationOpen = function(success, error) {
  cordova.exec(success, error, "AppICEPlugin", "onNotificationOpen", []);
};

module.exports = new AppICE();
