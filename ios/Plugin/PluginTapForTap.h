//
//  Copyright (c) 2013 TapForTap. All rights reserved.
//

#ifndef _PluginTapForTap_H__
#define _PluginTapForTap_H__

#include "CoronaLua.h"
#include "CoronaMacros.h"
#include "TFTTapForTap.h"

class PluginTapForTap
{
public:
    typedef PluginTapForTap Self;

public:
    static const char kName[];
    static const char kEvent[];

public:
    PluginTapForTap();

public:
    static int Open(lua_State *luaState);

protected:
    static int Finalizer(lua_State *luaState);

public:
    static Self *ToLibrary(lua_State *luaState);

public:
    CoronaLuaRef bannerListener;
    CoronaLuaRef interstitialListener;
    CoronaLuaRef appWallListener;

public:
    static int initializeTapForTap(lua_State *luaState);
    static int setYearOfBirth(lua_State *luaState);
    static int setGender(lua_State *luaState);
    static int setLocation(lua_State *luaState);
    static int setUserAccountId(lua_State *luaState);
    static int getVersion(lua_State *luaState);
    static int createAdView(lua_State *luaState);
    static int createAdViewWithScale(lua_State *luaState);
    static int removeAdView(lua_State *luaState);
    static int disableAutoScale(lua_State *luaState);
    static int setAdViewListener(lua_State *luaState);
    static int prepareInterstitial(lua_State *luaState);
    static int showInterstitial(lua_State *luaState);
    static int interstitialIsReady(lua_State *luaState);
    static int setInterstitialListener(lua_State *luaState);
    static int prepareAppWall(lua_State *luaState);
    static int showAppWall(lua_State *luaState);
    static int appWallIsReady(lua_State *luaState);
    static int setAppWallListener(lua_State *luaState);
    static int setDevelopment(lua_State *luaState);
};

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
// where the '.' is replaced with '_'
CORONA_EXPORT int luaopen_plugin_tapfortap( lua_State *L );

#endif // _PluginLibrary_H__
