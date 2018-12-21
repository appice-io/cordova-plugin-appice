cordova.define("cordova-plugin-appice.AppICE", function(require, exports, module) {

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

  var inputArr = [];
  var inputs = document.getElementsByTagName('input');
  for (var index = 0; index < inputs.length; ++index) {
      var element = inputs[index];
      var data = {
          "t":element.tagName,
          "i":element.id,
          "n":element.name,
          "y":element.getBoundingClientRect().top + window.scrollY,
          "x":element.getBoundingClientRect().left + window.scrollX,
          "w":element.getBoundingClientRect().width,
          "h":element.getBoundingClientRect().height
      };
      inputArr.push(data);
  }

  cordova.exec(success, error, "AppICEPlugin", "trackScreens", [{"old":e.oldURL, "new":e.newURL, "loc":location.hash, "h":document.documentElement.clientHeight, "w":document.documentElement.clientWidth, "arr":inputArr}]);
};

AppICE.prototype.initSdk = function(appID, appKey, apiKey, gcmID, success, error) {
  cordova.exec(success, error, "AppICEPlugin", "initSdk", [{"appID":appID, "appKey":appKey, "apiKey":apiKey, "gcmID":gcmID}]);

  var inputArr = [];
  var inputs = document.getElementsByTagName('input');
  for (var index = 0; index < inputs.length; ++index) {
      var element = inputs[index];
      var data = {
          "t":element.tagName,
          "i":element.id,
          "n":element.name,
          "y":element.getBoundingClientRect().top + window.scrollY,
          "x":element.getBoundingClientRect().left + window.scrollX,
          "w":element.getBoundingClientRect().width,
          "h":element.getBoundingClientRect().height
      };
      inputArr.push(data);
   }

   cordova.exec(success, error, "AppICEPlugin", "trackScreens", [{"old":e.oldURL, "new":e.newURL, "loc":location.hash, "h":document.documentElement.clientHeight, "w":document.documentElement.clientWidth, "arr":inputArr}]);
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

AppICE.prototype.trackTouchS = function(e, success, error) {
    var touchobj = e.changedTouches[0]
    swipedir = 'none'
    dist = 0
    startX = touchobj.pageX
    startY = touchobj.pageY
    startTime = new Date().getTime()
};

AppICE.prototype.trackTouchE = function(e, success, error) {
    var touchobj = e.changedTouches[0]
    distX = touchobj.pageX - startX
    distY = touchobj.pageY - startY
    elapsedTime = new Date().getTime() - startTime
    if (elapsedTime <= 1500) {
        if (Math.abs(distX) >= 150 && Math.abs(distY) <= 250) {
            swipedir = (distX < 0)? 'left' : 'right'
        }
        else if (Math.abs(distY) >= 150 && Math.abs(distX) <= 250) {
            swipedir = (distY < 0)? 'up' : 'down'
        }
    }

    console.log('swipe : ' + swipedir + ' , distX: ' + distX + ' , distY: ' + distY);

    var inputArr = [];
    var inputs = document.getElementsByTagName('input');
    for (var index = 0; index < inputs.length; ++index) {
        var element = inputs[index];
        var data = {
            "t":element.tagName,
            "i":element.id,
            "n":element.name,
            "y":element.getBoundingClientRect().top + window.scrollY,
            "x":element.getBoundingClientRect().left + window.scrollX,
            "w":element.getBoundingClientRect().width,
            "h":element.getBoundingClientRect().height
        };
        inputArr.push(data);
    }

    if (swipedir == 'none') {
        var t = e.target;
        cordova.exec(success, error, "AppICEPlugin", "trackTouches", [{"type":t.tagName, "id":t.id, "name":t.name, "py":t.getBoundingClientRect().top + window.scrollY, "px":t.getBoundingClientRect().left + window.scrollX, "pw":t.getBoundingClientRect().width, "ph":t.getBoundingClientRect().height, "x":touchobj.screenX, "y":touchobj.screenY, "h":document.documentElement.clientHeight, "w":document.documentElement.clientWidth, "arr":inputArr}]);
    }
    else {
        cordova.exec(success, error, "AppICEPlugin", "trackSwipes", [{"type":swipedir, "x1":startX, "y1":startY, "x2":touchobj.screenX, "y2":touchobj.screenY, "h":document.documentElement.clientHeight, "w":document.documentElement.clientWidth, "arr":inputArr}]);
    }
};

AppICE.prototype.trackScreens = function(e, success, error) {
    var inputArr = [];
    var inputs = document.getElementsByTagName('input');
    for (var index = 0; index < inputs.length; ++index) {
        var element = inputs[index];
        var data = {
            "t":element.tagName,
            "i":element.id,
            "n":element.name,
            "y":element.getBoundingClientRect().top + window.scrollY,
            "x":element.getBoundingClientRect().left + window.scrollX,
            "w":element.getBoundingClientRect().width,
            "h":element.getBoundingClientRect().height
        };
        inputArr.push(data);
    }

    cordova.exec(success, error, "AppICEPlugin", "trackScreens", [{"old":e.oldURL, "new":e.newURL, "loc":location.hash, "h":document.documentElement.clientHeight, "w":document.documentElement.clientWidth, "arr":inputArr}]);
};

module.exports = new AppICE();

});
