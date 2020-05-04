package com.mrporter.pomangam.flutter_app_test_bootpay_2;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import kr.co.bootpay.Bootpay;
import kr.co.bootpay.BootpayAnalytics;
import kr.co.bootpay.enums.Method;
import kr.co.bootpay.enums.PG;
import kr.co.bootpay.listner.EventListener;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.mrporter.pomangam/bootpay";
  private MethodChannel methodChannel;
  private Handler handler;

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {

    super.onCreate(savedInstanceState);

    methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);

    handler = new Handler(Looper.getMainLooper());

    methodChannel.setMethodCallHandler((call, result) -> {
      if (call.method.equals("openPay")) {
        bootpayRequest();
        result.success("hi success !!");
      } else {
        result.success("no method");
      }
    });
  }

  private void callBack(String msg) {
    handler.post(() -> {
      methodChannel.invokeMethod("handleCallback", msg);
    });
  }

  private void bootpayRequest() {
    CustomEventListener customEventListener = new CustomEventListener();

    BootpayAnalytics.init(this, "5cc70f38396fa67747bd0684");
    Bootpay.init(getFragmentManager())
      .setApplicationId("5cc70f38396fa67747bd0684") // 해당 프로젝트(안드로이드)의 application id 값
      .setPG(PG.KCP) // 결제할 PG 사
      //.setUserPhone("010-1234-5678") // 구매자 전화번호
      .setMethod(Method.VBANK) // 결제수단
      //.isShowAgree(true)
      .setName("싸이버거 세트 외 2건") // 결제할 상품명
      .setOrderId("1234") // 결제 고유번호
      .setPrice(14400) // 결제할 금액
      .addItem("싸이버거 세트", 1, "ITEM_CODE_MOUSE", 5400)
      .addItem("포만감 커스텀 도시락 (3선택)", 2, "ITEM_CODE_KEYBOARD", 4500)
      .onConfirm(customEventListener)
      .onDone(customEventListener)
      .onReady(customEventListener)
      .onCancel(customEventListener)
      .onError(customEventListener)
      .onClose(customEventListener)
      .request();
  }

  class CustomEventListener implements EventListener {

    @Override
    public void onCancel(String s) {
      Log.d("bootpay onCancel", s);
    }

    @Override
    public void onClose(String s) {
      callBack("onClose");
    }

    @Override
    public void onConfirm(String s) {
      callBack("onConfirm");
    }

    @Override
    public void onDone(String s) {
      callBack("onDone");
    }

    @Override
    public void onError(String s) {
      callBack("onError");
    }

    @Override
    public void onReady(String s) {
      callBack("onReady");
    }
  }
}

