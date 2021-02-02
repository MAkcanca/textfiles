package com.example.textfiles;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.io.File;
import java.nio.charset.StandardCharsets;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.textile.ipfslite.Peer;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "cambaz.textfiles/ipfs";
    private static final String REPO_NAME = "ipfslite";
    private static Peer ipfsPeer;
    private static boolean isFetchComplete = false;
    private static byte[] fetchedData;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startPeer")) {
                                StartPeer(getApplicationContext());
                                result.success(true);
                            } else if (call.method.equals("startfetchData")) {
                                fetchedData = null;
                                isFetchComplete = false;
                                new Handler(Looper.getMainLooper()).post(new Runnable() {
                                    @Override
                                    public void run() {
                                        Peer.GetFileHandler h = new Peer.GetFileHandler() {
                                            @Override
                                            public void onNext(byte[] data) {
                                                fetchedData = data;
                                            }

                                            @Override
                                            public void onComplete() {
                                                isFetchComplete = true;
                                            }

                                            @Override
                                            public void onError(Throwable t) {

                                            }
                                        };
                                        GetData(call.argument("cid"), h);
                                        result.success(null);
                                    }
                                });

                            } else if (call.method.equals("getData")) {
                                if(isFetchComplete){
                                    result.success(new String(fetchedData, StandardCharsets.UTF_8));
                                } else {
                                    result.success(null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    public void StartPeer(Context ctx) {
        new Thread(() -> {
            try {
                ipfsPeer = new Peer(createRepo(ctx), false, true);
                Peer.start();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

    public void GetData(String cidParam, Peer.GetFileHandler handler) {
        byte[] data = new byte[0];
        try {
            ipfsPeer.getFile(cidParam, handler);
        } catch (Exception e) {
            e.printStackTrace();
        }
        //return new String(data, StandardCharsets.UTF_8);
        //Log.d("ipfs", new String(data, StandardCharsets.UTF_8));
    }

    static String createRepo(Context ctx) throws Exception {
        String path = new File(ctx.getFilesDir(), REPO_NAME).getAbsolutePath();
        new File(path);
        return path;
    }
}
