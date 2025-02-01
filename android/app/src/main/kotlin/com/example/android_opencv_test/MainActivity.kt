package com.example.android_opencv_test

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        init {
            System.loadLibrary("native-lib")
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor, "com.example.android_opencv_test")
        channel.setMethodCallHandler { methodCall, result ->
            when(methodCall.method) {
                "getPlatformVersion" -> {
                    result.success("Android Version: ${Build.VERSION.RELEASE}")
                }

                "addition" -> {
                    val a = methodCall.argument<Int>("a") ?: 0
                    val b = methodCall.argument<Int>("b") ?: 0
                    result.success(addition(a, b))
                }

                "subtraction" -> {
                    val a = methodCall.argument<Int>("a") ?: 0
                    val b = methodCall.argument<Int>("b") ?: 0
                    result.success(subtraction(a, b))
                }

                "grayimage" -> {
                    result.success(grayimage())
                }

                else -> result.notImplemented()
            }
        }
    }

    external fun addition(a: Int, b: Int): Int

    external fun subtraction(a: Int, b: Int): Int

    external fun grayimage(): ByteArray
}
