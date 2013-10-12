package plugin.tapfortap;

import com.ansca.corona.CoronaEnvironment;

import com.naef.jnlua.LuaState;
import com.naef.jnlua.LuaValueProxy;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;

class Interstitial {
    private static com.tapfortap.Interstitial interstitial;

    private static int prepareInterstitial(LuaState luaState) {
        getInterstitial();
        interstitial.load();
        return 0;
    }

    private static int showInterstitial(LuaState luaState) {
        getInterstitial();
        interstitial.showAndLoad();
        return 0;
    }

    private static int setInterstitialListener(LuaValueProxy listener) {
        getInterstitial();
        EventHelper.interstitialListener = listener;
        return 0;
    }

    private static int interstitialIsReady(LuaState luaState) {
        boolean isReady = false;
        if (interstitial != null) {
            isReady = interstitial.isReadyToShow();
        }
        luaState.pushBoolean(isReady);
        return 1;
    }

    private static synchronized void getInterstitial() {
        if (interstitial == null) {
            interstitial = com.tapfortap.Interstitial.create(CoronaEnvironment.getApplicationContext(), EventHelper.interstitialListenerInstance);
        }
    }

    static class PrepareInterstitial implements NamedJavaFunction {
        @Override
        public String getName() {
            return "prepareInterstitial";
        }

        @Override
        public int invoke(LuaState luaState) {
            return prepareInterstitial(luaState);
        }
    }

    static class ShowInterstitial implements NamedJavaFunction {
        @Override
        public String getName() {
            return "showInterstitial";
        }

        @Override
        public int invoke(LuaState luaState) {
            return showInterstitial(luaState);
        }
    }

    static class InterstitialIsReady implements NamedJavaFunction {
        @Override
        public String getName() {
            return "interstitialIsReady";
        }

        @Override
        public int invoke(LuaState luaState) {
            return interstitialIsReady(luaState);
        }
    }

    static class SetInterstitialListener implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setInterstitialListener";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setInterstitialListener(luaState.getProxy(1));
        }
    }
}