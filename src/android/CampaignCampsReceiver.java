package com.appice.cordova;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import semusi.activitysdk.ContextSdk;

/**
 * Created by aman on 14/03/16.
 */

public class CampaignCampsReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            sendCallback(intent.getExtras(), context);
        } catch (Exception e) {
        }
    }

    public void sendCallback(Bundle extra, Context context) {
        try {
            // value of user click on campaign
            String tap = extra.getString("tap");
            // value of clicked is True/False based upon user click or not
            String url = extra.getString("url");
			String cdata = extra.getString("cdata");

            JSONObject json = new JSONObject();

            try {
                // gather deeplink data
                if (url != null && url.length() > 0) {
                    HashMap<String, Object> deeplinkData = ContextSdk.gatherDeepLinkData(Uri.parse(url));
                    Set<String> keys = deeplinkData.keySet();
                    for (String key : keys) {
                        try {
                            json.put(key, deeplinkData.get(key));
                        } catch (JSONException e) {
                        }
                    }
                }
            } catch (Exception e) {
            }
            
            // Gather extra data from json object root
            try {
                if (cdata != null && cdata.length() > 0) {
                    JSONObject croot = new JSONObject(cdata);
                    if (croot != null && croot.length() > 0) {
                        Iterator<String> it = croot.keys();
                        while (it.hasNext()) {
                            String key = it.next();
                            Object obj = croot.get(key);
                            if (obj.getClass().equals(String.class))
                                json.put(key, URLDecoder.decode((String) obj, "UTF-8"));
                            else
                                json.put(key, obj);

                        }
                    }
                }
            } catch (Exception e) {
            }

            json.put("tap", tap);

            try {
                if (url != null && url.length() > 0) {
                    Uri path = Uri.parse(url);
                    json.put("host", path.getHost());
                    json.put("path", path.getPath());
                }
            } catch (Exception e) {
            }

            AppICEPlugin.sendNotification(json, context);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
