package com.example.bsg;

/**
 * Created by Develop on 6/6/2016.
 */
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapPrimitive;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import java.util.Timer;
import java.util.TimerTask;

public class MsgService extends Service  {
    public Context context;

    Timer timer;
    TimerTask timerTask;


    public final int NOTI_ID = 4444;

    private final String NAMESPACE = "http://localhost/";
    private final String URL = "http://192.168.100.248/Service1.asmx";
    private final String SOAP_ACTION = "http://localhost/BSG";
    private final String METHOD_NAME = "BSG";

    @Override
    public IBinder onBind(Intent arg0) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        timer = new Timer();
        timerTask = new TimerTask() {
            @Override
            public void run() {
                cancelNotification();
                showNotification();
                SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);
                //Property which holds input parameters
                PropertyInfo userid = new PropertyInfo();
                //Set Name
                //userid.setName("userid");
                //Set Value
              //  userid.setValue("aladin");
                //Set dataType
               // userid.setType(double.class);
                //Add the property to request object
                request.addProperty("userid", "aladin");
                //Create envelope
                SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
                        SoapEnvelope.VER11);
                envelope.dotNet = true;
                //Set output SOAP object
                envelope.setOutputSoapObject(request);
                //Create HTTP call object
                //AndroidHttpTransport
                HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);

                try {
                    //Invole web service
                    androidHttpTransport.call(SOAP_ACTION, envelope);
                    //Get the response
                    //SoapPrimitive response = (SoapPrimitive) envelope.getResponse();
                    //Assign it to fahren static variable
                   // String result = response.toString();
                    Object result = envelope.getResponse();
                    Log.i("DebugPoc", result.toString());

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };

        timer.schedule(timerTask, 0 ,15000);


        Toast.makeText(this, "Service Created", Toast.LENGTH_LONG).show();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Let it continue running until it is stopped.
        Toast.makeText(this, "Service Started", Toast.LENGTH_LONG).show();
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Toast.makeText(this, "Service Destroyed", Toast.LENGTH_LONG).show();
    }

    public void cancelNotification(){
        NotificationManager mNotiManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        try{
            mNotiManager.cancel(NOTI_ID);

        }catch (Exception e){

        }
    }

    public void showNotification()
    {
        NotificationManager mNotiManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);


        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent pi = PendingIntent.getActivity(this, 0, intent, 0);

        Notification.Builder builder = new Notification.Builder(this);
        builder.setSmallIcon(R.drawable.icon).setTicker("APP").setWhen(System.currentTimeMillis());
        builder.setContentText("APP is running");
        builder.setContentTitle("APP");
        builder.setContentIntent(pi);

        Notification notification = builder.getNotification();
        mNotiManager.notify(NOTI_ID, notification);
    }
}
