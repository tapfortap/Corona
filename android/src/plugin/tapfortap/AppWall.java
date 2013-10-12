package plugin.tapfortap;

import com.ansca.corona.CoronaEnvironment;

import com.naef.jnlua.LuaState;
import com.naef.jnlua.LuaValueProxy;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;

class AppWall {
    private static com.tapfortap.AppWall appWall;

    private static int prepareAppWall(LuaState luaState) {
        getAppWall();
        appWall.load();
        return 0;
    }

    private static int showAppWall(LuaState luaState) {
        getAppWall();
        appWall.showAndLoad();
        return 0;
    }

    private static int setAppWallListener(LuaValueProxy listener) {
        getAppWall();
        EventHelper.appWallListener = listener;
        return 0;
    }

    private static int appWallIsReady(LuaState luaState) {
        boolean isReady = false;
        if (appWall != null) {
            isReady = appWall.isReadyToShow();
        }
        luaState.pushBoolean(isReady);
        return 1;
    }

    private static synchronized void getAppWall() {
        if (appWall == null) {
            appWall = com.tapfortap.AppWall.create(CoronaEnvironment.getApplicationContext(), EventHelper.appWallListenerInstance);
        }
    }

    static class PrepareAppWall implements NamedJavaFunction {
        @Override
        public String getName() {
            return "prepareAppWall";
        }

        @Override
        public int invoke(LuaState luaState) {
            return prepareAppWall(luaState);
        }
    }

    static class ShowAppWall implements NamedJavaFunction {
        @Override
        public String getName() {
            return "showAppWall";
        }

        @Override
        public int invoke(LuaState luaState) {
            return showAppWall(luaState);
        }
    }

    static class AppWallIsReady implements NamedJavaFunction {
        @Override
        public String getName() {
            return "appWallIsReady";
        }

        @Override
        public int invoke(LuaState luaState) {
            return appWallIsReady(luaState);
        }
    }

    static class SetAppWallListener implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setAppWallListener";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setAppWallListener(luaState.getProxy(1));
        }
    }
}