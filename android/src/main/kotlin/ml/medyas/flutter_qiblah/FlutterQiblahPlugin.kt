package ml.medyas.flutter_qiblah

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterQiblahPlugin */
class FlutterQiblahPlugin() : FlutterPlugin, MethodCallHandler {
    private var context: Context? = null

    constructor(context: Context) : this() {
        this.context = context
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(FlutterQiblahPlugin(flutterPluginBinding.applicationContext))
    }

    companion object {
        private const val METHOD_CHANNEL = "ml.medyas.flutter_qiblah"
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when(call.method) {
            // Check whether the device supports the TYPE_ROTATION_VECTOR sensor
            "androidSupportSensor" -> {
                val sensorManager = context?.getSystemService(Context.SENSOR_SERVICE) as SensorManager
                val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR) ?: null
                result.success(sensor != null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
