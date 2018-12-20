#!/usr/bin/env node

module.exports = function(context) {

	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var shell = require('shelljs');
	
	var ConfigParser = context.requireCordovaModule("cordova-lib").configparser;
    var config = new ConfigParser("config.xml");
    var appName = config.name();

	var platformRoot = path.join(context.opts.projectRoot, 'platforms/ios');
	var pluginsFirebaseRoot = path.join(context.opts.projectRoot, 'plugins/cordova-plugin-firebase');
	var pluginsAppiceRoot = path.join(context.opts.projectRoot, 'plugins/cordova-plugin-appice');

	var firebaseFile1 = path.join(platformRoot, '/'+appName+'/Plugins/cordova-plugin-firebase/AppDelegate+FirebasePlugin.m');
	if (fs.existsSync(firebaseFile1)) {
		try {
			shell.rm('-Rf', firebaseFile1);
		} catch(err) {
		}
	}

	var modifiedFile1 = path.join(pluginsAppiceRoot, '/src/firebase/modified/ios/AppDelegate+FirebasePlugin.m');
	try {
		shell.cp('-f', modifiedFile1, firebaseFile1);
	} catch(err) {
	}
	var firebaseFile2 = path.join(pluginsFirebaseRoot, '/src/ios/AppDelegate+FirebasePlugin.m');
	if (fs.existsSync(firebaseFile2)) {
		try {
			shell.rm('-Rf', firebaseFile2);
		} catch(err) {
		}
	}
	try {
		shell.cp('-f', modifiedFile1, firebaseFile2);
	} catch(err) {
	}
	
	var platformwww1 = path.join(platformRoot, '/platform_www/plugins/cordova-plugin-appice/www/AppICE.js');
	var platformwww2 = path.join(pluginsAppiceRoot, '/www/AppICE.js');
	if (fs.existsSync(platformwww1)) {
		try {
			shell.rm('-Rf', platformwww1);
		} catch(err) {
		}
	}
	try {
		shell.cp('-f', platformwww2, platformwww1);
	} catch(err) {
	}
}