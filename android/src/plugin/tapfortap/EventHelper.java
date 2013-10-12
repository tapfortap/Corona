package plugin.tapfortap;

import android.util.Log;

import com.ansca.corona.CoronaEnvironment;
import com.ansca.corona.CoronaRuntime;
import com.ansca.corona.CoronaRuntimeTask;
import com.ansca.corona.CoronaRuntimeTaskDispatcher;

import com.naef.jnlua.LuaState;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;
import com.naef.jnlua.LuaValueProxy;
import com.naef.jnlua.LuaRuntimeException;

import com.tapfortap.TapForTap;
import com.tapfortap.Banner;
import com.tapfortap.Banner.BannerListener;
import com.tapfortap.AppWall;
import com.tapfortap.AppWall.AppWallListener;
import com.tapfortap.Interstitial;
import com.tapfortap.Interstitial.InterstitialListener;

public class EventHelper {

    static BannerListenerImplementation bannerListenerInstance = new BannerListenerImplementation();
    static InterstitialListenerImplementation interstitialListenerInstance = new InterstitialListenerImplementation();
    static AppWallListenerImplementation appWallListenerInstance = new AppWallListenerImplementation();

    static LuaValueProxy adViewListener = null;
    static LuaValueProxy interstitialListener = null;
    static LuaValueProxy appWallListener = null;

    static CoronaRuntime runtime = null;

    static void dispatchEvent(final LuaValueProxy listener, final String event, final String message) {
        if(listener == null || runtime == null || runtime.wasDisposed()) {
            return;
        }

        LuaState luaState = runtime.getLuaState();
        if(!luaState.isOpen()) {
            return;
        }

        final CoronaRuntimeTaskDispatcher dispatcher = new CoronaRuntimeTaskDispatcher(luaState);
        CoronaEnvironment.getCoronaActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                CoronaRuntimeTask task = new CoronaRuntimeTask() {
                    @Override
                    public void executeUsing(CoronaRuntime runtime) {
                        try {
                            LuaState luaState = runtime.getLuaState();
                            if (!luaState.isOpen() || listener == null) {
                                return;
                            }

                           listener.pushValue();

                            try {
                                luaState.checkType(-1, com.naef.jnlua.LuaType.FUNCTION);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                                return;
                            }

                            int luaFunctionReferenceKey = luaState.ref(com.naef.jnlua.LuaState.REGISTRYINDEX);
                            luaState.rawGet(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);
                            luaState.unref(com.naef.jnlua.LuaState.REGISTRYINDEX, luaFunctionReferenceKey);
                            luaState.newTable();
                            luaState.pushString("plugin.tapfortap.event");
                            luaState.setField(-2, "name");
                            luaState.pushString(event);
                            luaState.setField(-2, "event");
                            luaState.pushString(message);
                            luaState.setField(-2, "message");

                            luaState.call(1, 0);
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                };
                dispatcher.send(task);
            }
        });
    }

    private static class BannerListenerImplementation implements com.tapfortap.Banner.BannerListener {
        @Override
        public void bannerOnReceive(com.tapfortap.Banner banner) {
            dispatchEvent(adViewListener, "onReceiveAd", "");
        }

        @Override
        public void bannerOnFail(com.tapfortap.Banner banner, String reason, Throwable throwable) {
            dispatchEvent(adViewListener, "onFailToReceiveAd", reason);
        }

        @Override
        public void bannerOnTap(com.tapfortap.Banner banner) {
            dispatchEvent(adViewListener, "onTapAd", "");
        }
    }

    private static class InterstitialListenerImplementation implements com.tapfortap.Interstitial.InterstitialListener {
        @Override
        public void interstitialOnReceive(com.tapfortap.Interstitial interstitial) {
            dispatchEvent(interstitialListener, "onReceiveAd", "");
        }

        @Override
        public void interstitialOnShow(com.tapfortap.Interstitial interstitial) {
            dispatchEvent(interstitialListener, "onShow", "");
        }

        @Override
        public void interstitialOnTap(com.tapfortap.Interstitial interstitial) {
            dispatchEvent(interstitialListener, "onTap", "");
        }

        @Override
        public void interstitialOnDismiss(com.tapfortap.Interstitial interstitial) {
            dispatchEvent(interstitialListener, "onDismiss", "");
        }

        @Override
        public void interstitialOnFail(com.tapfortap.Interstitial interstitial, String reason, Throwable throwable) {
            dispatchEvent(interstitialListener, "onFailToReceiveAd", reason);
        }
    }

    private static class AppWallListenerImplementation implements com.tapfortap.AppWall.AppWallListener {
        @Override
        public void appWallOnReceive(com.tapfortap.AppWall appWall) {
            dispatchEvent(appWallListener, "onReceiveAd", "");
        }

        @Override
        public void appWallOnShow(com.tapfortap.AppWall appWall) {
            dispatchEvent(appWallListener, "onShow", "");
        }

        @Override
        public void appWallOnTap(com.tapfortap.AppWall appWall) {
            dispatchEvent(appWallListener, "onTap", "");
        }

        @Override
        public void appWallOnDismiss(com.tapfortap.AppWall appWall) {
            dispatchEvent(appWallListener, "onDismiss", "");
        }

        @Override
        public void appWallOnFail(com.tapfortap.AppWall appWall, String reason, Throwable throwable) {
            dispatchEvent(appWallListener, "onFailToReceiveAd", reason);
        }
    }
}