package plugin.tapfortap;

import android.util.DisplayMetrics;
import android.view.Gravity;
import android.widget.FrameLayout;

import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;

import com.naef.jnlua.LuaState;
import com.naef.jnlua.LuaValueProxy;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;

import plugin.tapfortap.EventHelper;

// import android.util.Log;

public class AdView {
    private static com.tapfortap.Banner banner;
    private static FrameLayout layout;
    private static boolean autoScale = true;

    private static int createAdView(LuaState luaState) {
        int horizontalAlignemnt = luaState.isNoneOrNil(1) ? 0 : luaState.toInteger(1);
        int verticalAlignment = luaState.isNoneOrNil(2) ? 0 : luaState.toInteger(2);
        int xOffset = luaState.isNoneOrNil(3) ? 0 : luaState.toInteger(3);
        int yOffset = luaState.isNoneOrNil(4) ? 0 : luaState.toInteger(4);
        double scale = luaState.isNoneOrNil(5) ? 1 : luaState.toNumber(5);

        removeAdView(luaState);
        showAd(luaState, horizontalAlignemnt, verticalAlignment, xOffset, yOffset, scale);
        return 0;
    }

    private static int removeAdView(LuaState luaState) {
        CoronaEnvironment.getCoronaActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if(banner != null) {
                    banner.setListener(null);
                    banner = null;
                }
                if(layout != null) {
                    layout.removeAllViews();
                }
            }
        });
        return 0;
    }

    private static int setAdViewListener(LuaValueProxy listener) {
        EventHelper.adViewListener = listener;
        return 0;
    }

    private static int disableAutoScale(LuaState luaState) {
        autoScale = false;
        return 0;
    }

    private static void showAd(final LuaState luaState, final int verticalAlignment, final int horizontalAlignemnt, final int xOffset, final int yOffset, final double scale) {
        final CoronaActivity activity = CoronaEnvironment.getCoronaActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {

                if(layout == null) {
                    layout = new FrameLayout(activity);
                    FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
                    activity.getOverlayView().addView(layout, layoutParams);
                }

                // Setup the banner
                int width = (int)(320 * scale);
                int height = (int)(50 * scale);

                DisplayMetrics metrics = activity.getResources().getDisplayMetrics();
                if (autoScale) {
                    width = (int)(width * metrics.density);
                    height = (int) (height * metrics.density);
                }

                int gravity = 0;
                switch(horizontalAlignemnt) {
                    case 1:
                        gravity |= Gravity.LEFT;
                        break;
                    case 2:
                        gravity |= Gravity.CENTER_HORIZONTAL;
                        break;
                    case 3:
                        gravity |= Gravity.RIGHT;
                        break;
                    default:
                        gravity |= Gravity.CENTER_HORIZONTAL;
                        break;
                }

                switch(verticalAlignment) {
                    case 1:
                        gravity |= Gravity.TOP;
                        break;
                    case 2:
                        gravity |= Gravity.CENTER_VERTICAL;
                        break;
                    case 3:
                        gravity |= Gravity.BOTTOM;
                        break;
                    default:
                        gravity |= Gravity.BOTTOM;
                        break;
                }

                FrameLayout.LayoutParams viewLayoutParams = new FrameLayout.LayoutParams(width, height, gravity);

                int leftMargin = xOffset;
                int topMargin = yOffset;
                if (autoScale) {
                    leftMargin = (int)(xOffset * metrics.density);
                    topMargin = (int)(yOffset * metrics.density);
                }
                viewLayoutParams.setMargins(leftMargin, topMargin, 0, 0);

                banner = com.tapfortap.Banner.create(activity, EventHelper.bannerListenerInstance);
                banner.setLayoutParams(viewLayoutParams);
                layout.addView(banner);
            }
        });
    }

    static class CreateAdView implements NamedJavaFunction {
        @Override
        public String getName() {
            return "createAdView";
        }

        @Override
        public int invoke(LuaState luaState) {
            return createAdView(luaState);
        }
    }

    static class RemoveAdView implements NamedJavaFunction {
        @Override
        public String getName() {
            return "removeAdView";
        }

        @Override
        public int invoke(LuaState luaState) {
            return removeAdView(luaState);
        }
    }

    static class SetAdViewListener implements NamedJavaFunction {
        @Override
        public String getName() {
            return "setAdViewListener";
        }

        @Override
        public int invoke(LuaState luaState) {
            return setAdViewListener(luaState.getProxy(1));
        }
    }

    static class DisableAutoScale implements NamedJavaFunction {
        @Override
        public String getName() {
            return "disableAutoScale";
        }

        @Override
        public int invoke(LuaState luaState) {
            return disableAutoScale(luaState);
        }
    }
}
