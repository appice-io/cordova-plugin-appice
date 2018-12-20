package com.appice.cordova;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.RequiresApi;

import java.util.Timer;
import java.util.TimerTask;

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class NotificationEventService extends JobService {

    @Override
    public boolean onStartJob(JobParameters params) {
        if (params != null) {
            PersistableBundle bundle = params.getExtras();
            if (bundle != null) {
                final Bundle bundle1 = toBundle(bundle);
                if (bundle1 != null) {
                    new Timer("AppICE-NotifService-Timer").schedule(new TimerTask() {
                        @Override
                        public void run() {
                            CampaignCampsReceiver rc = new CampaignCampsReceiver();
                            rc.sendCallback(bundle1, getApplicationContext());
                        }
                    }, 2 * 1000);
                }
            }
        }

        return true;
    }

    public static Bundle toBundle(PersistableBundle persistableBundle) {
        try {
            if (persistableBundle == null) {
                return null;
            }
            Bundle bundle = new Bundle();
            if (Build.VERSION.SDK_INT >= 21)
                bundle.putAll(persistableBundle);
            return bundle;
        } catch (Exception e) {
        }

        return null;
    }

    @Override
    public boolean onStopJob(JobParameters params) {
        return false;
    }
}

