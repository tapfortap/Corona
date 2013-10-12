//
//  Copyright (c) 2013 TapForTap. All rights reserved.
//

package plugin.tapfortap;

import android.content.Context;

import com.naef.jnlua.LuaState;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;

import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;
import com.ansca.corona.CoronaLua;
import com.ansca.corona.CoronaRuntime;
import com.ansca.corona.CoronaRuntimeListener;

import plugin.tapfortap.TapForTap.*;
import plugin.tapfortap.AdView.*;
import plugin.tapfortap.Interstitial.*;
import plugin.tapfortap.AppWall.*;
import plugin.tapfortap.EventHelper.*;

public class LuaLoader implements JavaFunction, CoronaRuntimeListener {
	private static final String TAG = LuaLoader.class.getName();

	public LuaLoader() {
		Context applicationContext = CoronaEnvironment.getApplicationContext();
		if (applicationContext == null) {
			throw new IllegalArgumentException("Application Context cannot be null.");
		}
		com.ansca.corona.CoronaEnvironment.addRuntimeListener(this);
	}

	@Override
	public int invoke(LuaState luaState) {
		NamedJavaFunction[] luaFunctions = new NamedJavaFunction[] {
			new TapForTap.InitializeTapForTap(),
			new TapForTap.SetYearOfBirth(),
			new TapForTap.SetGender(),
			new TapForTap.SetLocation(),
			new TapForTap.SetUserAccountId(),
			new TapForTap.GetVersion(),
			new AdView.CreateAdView(),
			new AdView.RemoveAdView(),
			new AdView.SetAdViewListener(),
			new AdView.DisableAutoScale(),
			new Interstitial.PrepareInterstitial(),
			new Interstitial.ShowInterstitial(),
			new Interstitial.SetInterstitialListener(),
			new Interstitial.InterstitialIsReady(),
			new AppWall.PrepareAppWall(),
			new AppWall.ShowAppWall(),
			new AppWall.SetAppWallListener(),
			new AppWall.AppWallIsReady(),
			new TapForTap.SetDevelopment()
		};
        com.tapfortap.TapForTap.PLUGIN_VERSION = "0.1.2";
		String libName = luaState.toString(1);
		luaState.register(libName, luaFunctions);

		return 1;
	}

	@Override
	public void onLoaded(CoronaRuntime runtime) {
		EventHelper.runtime = runtime;
	}

	@Override
	public void onStarted(CoronaRuntime runtime) {
	}

	@Override
	public void onSuspended(CoronaRuntime runtime) {
	}

	@Override
	public void onResumed(CoronaRuntime runtime) {
	}

	@Override
	public void onExiting(CoronaRuntime runtime) {
	}
}