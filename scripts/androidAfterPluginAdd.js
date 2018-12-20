#!/usr/bin/env node

module.exports = function(context) {

	var fs = context.requireCordovaModule('fs');
	var path = context.requireCordovaModule('path');
	var shell = require('shelljs');

	var platformRoot = path.join(context.opts.projectRoot, 'platforms/android');
	var pluginsFirebaseRoot = path.join(context.opts.projectRoot, 'plugins/cordova-plugin-firebase');
	var pluginsAppiceRoot = path.join(context.opts.projectRoot, 'plugins/cordova-plugin-appice');

	var firebaseFile1 = path.join(platformRoot, '/app/src/main/java/org/apache/cordova/firebase/FirebasePluginMessagingService.java');
	if (fs.existsSync(firebaseFile1)) {
		try {
			shell.rm('-Rf', firebaseFile1);
		} catch(err) {
		}
	}

	var modifiedFile1 = path.join(pluginsAppiceRoot, '/src/firebase/modified/android/FirebasePluginMessagingService.java');
	try {
		shell.cp('-f', modifiedFile1, firebaseFile1);
	} catch(err) {
	}
	var firebaseFile2 = path.join(pluginsFirebaseRoot, '/src/android/FirebasePluginMessagingService.java');
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

	var manifestFile = path.join(platformRoot, 'AndroidManifest.xml');
	if (fs.existsSync(manifestFile)) {
		try {
			fs.readFile(manifestFile, 'utf8', function (err,data) {
				if (err) {
					throw new Error('Unable to find AndroidManifest.xml: ' + err);
				}
				var appClass = 'semusi.activitysdk.ContextApplication';
				if (data.indexOf(appClass) == -1) {
					var result = data.replace(/<application/g, '<application android:name="' + appClass + '"');
					fs.writeFile(manifestFile, result, 'utf8', function (err) {
						if (err) {
							throw new Error('Unable to write into AndroidManifest.xml: ' + err);
						}
					});
				}
			});
		} catch(err) {
		}
	}
	else {
		var manifestFileNew = path.join(platformRoot, '/app/src/main/AndroidManifest.xml');
		if (fs.existsSync(manifestFileNew)) {
			try {
				fs.readFile(manifestFileNew, 'utf8', function (err,data) {
					if (err) {
						throw new Error('Unable to find AndroidManifest.xml: ' + err);
					}
					var appClass = 'semusi.activitysdk.ContextApplication';
					if (data.indexOf(appClass) == -1) {
						var result = data.replace(/<application/g, '<application android:name="' + appClass + '"');
						fs.writeFile(manifestFileNew, result, 'utf8', function (err) {
							if (err) {
								throw new Error('Unable to write into AndroidManifest.xml: ' + err);
							}
						});
					}
				});
			} catch(err) {
			}
		}
	}
}