package plugin.tapfortap;

import android.location.Location;

import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;

import com.naef.jnlua.LuaState;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;

import com.naef.jnlua.LuaState;

class TapForTap {
    private static int initialize(LuaState luaState) {
        String apiKey = luaState.toString(1);
        com.tapfortap.TapForTap.PLUGIN = "corona";

        CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
        if(activity == null) {
            throw new IllegalArgumentException("Activity cannot be null.");
        }

        com.tapfortap.TapForTap.initialize(activity, apiKey);
        return 0;
    }

    private static int setYearOfBirth(LuaState luaState) {
        int yearOfBirth = luaState.toInteger(1);
        com.tapfortap.TapForTap.setYearOfBirth(yearOfBirth);
        return 0;
    }

    private static int setGender(LuaState luaState) {
        int gender = luaState.toInteger(1);
        switch(gender) {
            case 0:
                com.tapfortap.TapForTap.setGender(com.tapfortap.TapForTap.Gender.MALE);
                break;
            case 1:
                com.tapfortap.TapForTap.setGender(com.tapfortap.TapForTap.Gender.FEMALE);
                break;
            default:
                com.tapfortap.TapForTap.setGender(com.tapfortap.TapForTap.Gender.NONE);
                break;
        }
        return 0;
    }

    private static int setLocation(LuaState luaState) {
        double latitude = luaState.toNumber(1);
        double longitude = luaState.toNumber(2);
        Location location = new Location("");
        location.setLatitude(latitude);
        location.setLongitude(longitude);
        com.tapfortap.TapForTap.setLocation(location);
        return 0;
    }

    private static int setUserAccountId(LuaState luaState) {
        String userAccountId = luaState.toString(1);
        com.tapfortap.TapForTap.setUserAccountId(userAccountId);
        return 0;
    }

    private static int getVersion(LuaState luaState) {
        luaState.pushString(com.tapfortap.TapForTap.PLUGIN_VERSION);
        return 1;
    }

    private static int setDevelopment(LuaState luaState) {
        com.tapfortap.TapForTap.setEnvironment("development");
        return 0;
    }

    static class InitializeTapForTap implements NamedJavaFunction {
        @Override
        public String getName() {
            return "initialize";
        }

        @Override
        public int invoke(LuaState luaState) {
            return initialize(luaState);
        }
    }

    static class SetYearOfBirth implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setYearOfBirth";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setYearOfBirth(luaState);
        }
    }

    static class SetGender implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setGender";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setGender(luaState);
        }
    }

    static class SetLocation implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setLocation";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setLocation(luaState);
        }
    }

    static class SetUserAccountId implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setUserAccountId";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setUserAccountId(luaState);
        }
    }

    static class GetVersion implements NamedJavaFunction {
        @Override
        public String getName() {
            return "getVersion";
        }

        @Override
        public int invoke(LuaState luaState) {
            return getVersion(luaState);
        }
    }

    static class SetDevelopment implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setDevelopment";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setDevelopment(luaState);
        }
    }
}