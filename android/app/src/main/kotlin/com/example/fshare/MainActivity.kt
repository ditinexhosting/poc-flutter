package com.example.fshare

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.facebook.FacebookSdk
import com.facebook.CallbackManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginManager
import com.facebook.login.LoginResult
import com.facebook.share.model.ShareLinkContent
import com.facebook.share.model.ShareHashtag
import com.facebook.share.widget.ShareDialog
import com.facebook.share.Sharer
import android.app.Activity
import android.net.Uri
import android.util.Log
import java.util.*


class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    lateinit var callbackManager: CallbackManager
    lateinit var shareDialog: ShareDialog
    lateinit var flutterCallback: MethodChannel.Result

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            flutterCallback = result
            if (call.method == "getBatteryLevel") {
                val link : String? = call.argument<String>("link")
                val quote : String? = call.argument<String>("quote")
                val hashtag : String? = call.argument<String>("hashtag")
                getBatteryLevel(link, quote, hashtag)
            } else {
                result.notImplemented()
            }
        }
        
    }
    
    private fun getBatteryLevel(link: String?, quote: String?, hashtag: String?){

        callbackManager = CallbackManager.Factory.create()
        shareDialog = ShareDialog(this);
        // Callback not working though
        shareDialog.registerCallback(callbackManager,
                    object : FacebookCallback<Sharer.Result> {
                        override fun onSuccess(result: Sharer.Result) {
                            Log.d("MainActivity", "WTF >>Facebook token: " + result)
                        }

                        override fun onCancel() {
                            Log.d("MainActivity", "WTF >>Facebook onCancel.")

                        }

                        override fun onError(error: FacebookException) {
                            Log.d("MainActivity", "WTF >>Facebook onError.")
                        }
                    })

        var builder = ShareLinkContent.Builder()
        builder = builder.setContentUrl(Uri.parse(link))  
        if(quote!=="")
            builder.setQuote(quote)
        if(hashtag!=="")
            builder.setShareHashtag(ShareHashtag.Builder()
            .setHashtag(hashtag)
            .build())
        shareDialog.show(builder.build())

        /*callbackManager = CallbackManager.Factory.create()
            LoginManager.getInstance().logInWithReadPermissions(this, Arrays.asList("public_profile", "email","public_actions"))
            LoginManager.getInstance().registerCallback(callbackManager,
                    object : FacebookCallback<LoginResult> {
                        override fun onSuccess(loginResult: LoginResult) {
                            Log.d("MainActivity", "WTF >>Facebook token: " + loginResult.accessToken.token)
                            //startActivity(Intent(applicationContext, AuthenticatedActivity::class.java))
                        }

                        override fun onCancel() {
                            Log.d("MainActivity", "WTF >>Facebook onCancel.")
                            result.success("Cancel")

                        }

                        override fun onError(error: FacebookException) {
                            Log.d("MainActivity", "WTF >>Facebook onError.")

                        }
                    })
        */
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d("WTF >>", "WTF >> Activity Happen "+resultCode)
        if(resultCode==0)
            flutterCallback.error("UNAVAILABLE", "Failed to share.", null)
        else
            flutterCallback.success("Success code : "+resultCode)
        callbackManager.onActivityResult(requestCode, resultCode, data)
    }

}