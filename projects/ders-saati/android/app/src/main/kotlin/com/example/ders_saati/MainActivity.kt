package com.example.ders_saati

import android.app.Activity
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "ders_saati/ringtone"
	private val REQUEST_RINGTONE = 9001
	private var pendingResult: MethodChannel.Result? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			if (call.method == "pick") {
				if (pendingResult != null) {
					result.error("busy", "Ringtone picker already open", null)
					return@setMethodCallHandler
				}
				pendingResult = result
				val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply {
					putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
					putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)
					putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_RINGTONE)
				}
				startActivityForResult(intent, REQUEST_RINGTONE)
			} else {
				result.notImplemented()
			}
		}
	}

	override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
		super.onActivityResult(requestCode, resultCode, data)
		if (requestCode == REQUEST_RINGTONE) {
			if (pendingResult == null) return
			if (resultCode == Activity.RESULT_OK) {
				val uri: Uri? = data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
				if (uri != null) {
					val title = RingtoneManager.getRingtone(this, uri)?.getTitle(this) ?: uri.toString()
					val map: Map<String, String> = mapOf("uri" to uri.toString(), "title" to title)
					pendingResult?.success(map)
				} else {
					pendingResult?.success(null)
				}
			} else {
				pendingResult?.success(null)
			}
			pendingResult = null
		}
	}
}
