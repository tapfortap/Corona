//
//  Copyright (c) 2013 TapForTap. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "CoronaRuntime.h"

#include "PluginTapForTap.h"
#include "PluginTapForTapEventHelper.h"

static TFTBanner *banner = nil;
static PluginTapForTapEventHelper *eventHelper = nil;
static TFTInterstitial *interstital = nil;
static TFTAppWall *appWall = nil;

const char PluginTapForTap::kName[] = "plugin.tapfortap";
const char PluginTapForTap::kEvent[] = "plugin.tapfortap.event";

void showAd(lua_State *luaState, lua_Integer horiztonalAligment, lua_Integer verticalAlignment, lua_Integer xOffset, lua_Integer yOffset, lua_Number scale);
void getInterstitial(void);
void getAppWall(void);

PluginTapForTap::PluginTapForTap()
{
    bannerListener = NULL;
    interstitialListener = NULL;
    appWallListener = NULL;
}

int PluginTapForTap::Open(lua_State *luaState)
{
	const char kMetatableName[] = __FILE__;
	CoronaLuaInitializeGCMetatable(luaState, kMetatableName, Finalizer);

	const luaL_Reg kVTable[] =
	{
		{ "initialize", initializeTapForTap },
        { "setYearOfBirth",  setYearOfBirth},
        { "setGender",  setGender},
        { "setLocation",  setLocation},
        { "setUserAccountId",  setUserAccountId},
        { "getVersion", getVersion },
		{ "createAdView", createAdView },
        { "removeAdView", removeAdView },
        { "disableAutoScale", disableAutoScale },
        { "setAdViewListener", setAdViewListener },
        { "prepareInterstitial",  prepareInterstitial},
        { "showInterstitial",  showInterstitial},
        { "interstitialIsReady",  interstitialIsReady},
        { "setInterstitialListener", setInterstitialListener },
        { "prepareAppWall",  prepareAppWall},
        { "showAppWall",  showAppWall},
        { "appWallIsReady",  appWallIsReady},
        { "setAppWallListener", setAppWallListener },
        { "setDevelopment", setDevelopment },
		{ NULL, NULL }
	};

	PluginTapForTap *library = new PluginTapForTap;
	CoronaLuaPushUserdata(luaState, library, kMetatableName);
	luaL_openlib(luaState, kName, kVTable, 1);

    eventHelper = [[PluginTapForTapEventHelper alloc] initWithLibrary:library withLuaState:luaState];
    [TFTTapForTap performSelector: @selector(setPluginVersion:) withObject: @"0.1.2"];

	return 1;
}

int PluginTapForTap::Finalizer(lua_State *luaState)
{
	PluginTapForTap *pluginTapForTap = ToLibrary(luaState);
    if(pluginTapForTap == NULL) {
        return 0;
    }

    removeAdView(luaState);
    interstital = nil;
    appWall = nil;

    if(pluginTapForTap->bannerListener) {
        CoronaLuaDeleteRef(luaState, pluginTapForTap->bannerListener);
    }

    if(pluginTapForTap->interstitialListener) {
        CoronaLuaDeleteRef(luaState, pluginTapForTap->interstitialListener);
    }

    if(pluginTapForTap->appWallListener) {
        CoronaLuaDeleteRef(luaState, pluginTapForTap->appWallListener);
    }

	delete pluginTapForTap;

	return 0;
}

int PluginTapForTap::initializeTapForTap(lua_State *luaState)
{
    const char *apiKey = lua_tostring(luaState, 1);
    [TFTTapForTap performSelector: @selector(setPlugin:) withObject: @"corona"];
    [TFTTapForTap initializeWithAPIKey:[NSString stringWithUTF8String:apiKey]];
    return 0;
}

int PluginTapForTap::setYearOfBirth(lua_State *luaState)
{
    lua_Integer yearOfBirth = lua_tointeger(luaState, 1);
    [TFTTapForTap setYearOfBirth:yearOfBirth];
    return 0;
}

int PluginTapForTap::setGender(lua_State *luaState)
{
    lua_Integer gender = lua_tointeger(luaState, 1);
    if (gender == 0) {
        [TFTTapForTap setGender:MALE];
    } else if(gender == 1) {
        [TFTTapForTap setGender:FEMALE];
    } else {
        [TFTTapForTap setGender:NONE];
    }
    return 0;
}

int PluginTapForTap::setLocation(lua_State *luaState)
{
    CLLocationDegrees latitude = lua_tonumber(luaState, 1);
    CLLocationDegrees longitude = lua_tonumber(luaState, 2);

    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    [TFTTapForTap setLocation:location];

    return 0;
}

int PluginTapForTap::setUserAccountId(lua_State *luaState)
{
    const char* userAcountId = lua_tostring(luaState, 1);
    [TFTTapForTap setUserAccountId:[NSString stringWithUTF8String:userAcountId]];
    return 0;
}

int PluginTapForTap::getVersion(lua_State *luaState)
{
    const char *version = [[TFTTapForTap performSelector: @selector(pluginVersion)] UTF8String];
    int length = [[TFTTapForTap performSelector: @selector(pluginVersion)] length];
    lua_pushlstring (luaState, version, length);
    return 1;
}

void showAd(lua_State *luaState, lua_Integer horiztonalAligment, lua_Integer verticalAlignment, lua_Integer xOffset, lua_Integer yOffset, lua_Number scale)
{

    void *platformContext = CoronaLuaGetContext(luaState);
    id<CoronaRuntime> runtime = (__bridge id<CoronaRuntime>)platformContext;

    CGRect rect = runtime.appViewController.view.bounds;
    float viewHeight = rect.size.height;
    float viewWidth = rect.size.width;


    uint32_t width = (uint32_t)(320 * scale);
    uint32_t height = (uint32_t)(50 * scale);

    uint32_t xCoordinate = 0;
    uint32_t yCoordinate = 0;
    uint32_t autoResizingMask = 0;

    // Set the coordinates
    // Set the UIViewAutoresizing to handle orientation changes
    switch (verticalAlignment) {
        case 1:
            yCoordinate = 0;
            autoResizingMask |= UIViewAutoresizingFlexibleBottomMargin;
            break;
        case 2:
            yCoordinate = (viewHeight - height) / 2;
            autoResizingMask |= UIViewAutoresizingFlexibleBottomMargin;
            autoResizingMask |= UIViewAutoresizingFlexibleTopMargin;
            break;
        case 3:
            yCoordinate = (viewHeight - height);
            autoResizingMask |= UIViewAutoresizingFlexibleTopMargin;
            break;
        default:
            yCoordinate = (viewHeight - height);
            autoResizingMask |= UIViewAutoresizingFlexibleTopMargin;
            break;
    }


    switch (horiztonalAligment) {
        case 1:
            xCoordinate = 0;
            autoResizingMask |= UIViewAutoresizingFlexibleRightMargin;
            break;
        case 2:
            xCoordinate = (viewWidth - width) / 2;
            autoResizingMask |= UIViewAutoresizingFlexibleRightMargin;
            autoResizingMask |= UIViewAutoresizingFlexibleLeftMargin;
            break;
        case 3:
            xCoordinate = (viewWidth - width);
            autoResizingMask |= UIViewAutoresizingFlexibleLeftMargin;
            break;
        default:
            xCoordinate = (viewWidth - width) / 2;
            autoResizingMask |= UIViewAutoresizingFlexibleRightMargin;
            autoResizingMask |= UIViewAutoresizingFlexibleLeftMargin;
            break;
    }

    // Clamp the view
    uint32_t left = xCoordinate + xOffset;
    uint32_t top = yCoordinate + yOffset;

    banner = [TFTBanner bannerWithFrame:CGRectMake(left, top, width, height) delegate:eventHelper];
    banner.autoresizingMask = autoResizingMask;
    eventHelper.banner = banner;
    [runtime.appViewController.view addSubview: banner];
}

int PluginTapForTap::removeAdView(lua_State *luaState)
{
    [banner stopShowingAds];
    [banner removeFromSuperview];
    banner = nil;
    return 0;
}

int PluginTapForTap::disableAutoScale(lua_State *luaState) {
    return 0;
}

int PluginTapForTap::createAdView(lua_State *luaState)
{
    lua_Integer verticalAlignment = lua_isnoneornil(luaState, 1) ? 0 : lua_tointeger(luaState, 1);
    lua_Integer horiztonalAligment = lua_isnoneornil(luaState, 2) ? 0 : lua_tointeger(luaState, 2);

    lua_Integer xOffset = lua_isnoneornil(luaState, 3) ? 0 : lua_tointeger(luaState, 3);
    lua_Integer yOffset = lua_isnoneornil(luaState, 4) ? 0 : lua_tointeger(luaState, 4);
    lua_Number scale =  lua_isnoneornil(luaState, 5) ? 1 : lua_tonumber(luaState, 5);
    removeAdView(luaState);
    showAd(luaState, horiztonalAligment, verticalAlignment, xOffset, yOffset, scale);
    return 0;
}

int PluginTapForTap::setAdViewListener(lua_State* luaState)
{
	Self *library = ToLibrary(luaState);
    if(library->bannerListener)
    {
        CoronaLuaDeleteRef(luaState, library->bannerListener);
        library->bannerListener = NULL;
    }

    if (CoronaLuaIsListener(luaState, 1, kEvent))
	{
		CoronaLuaRef listener = CoronaLuaNewRef(luaState, 1);
        library->bannerListener = listener;
	}
    return 0;
}

void getInterstitial()
{
    if (interstital == nil) {
        interstital = [TFTInterstitial interstitialWithDelegate:eventHelper];
    }
}

int PluginTapForTap::prepareInterstitial(lua_State *luaState)
{
    getInterstitial();
    [interstital load];
    return 0;
}

int PluginTapForTap::showInterstitial(lua_State *luaState)
{
    getInterstitial();
    void *platformContext = CoronaLuaGetContext(luaState);
    id<CoronaRuntime> runtime = (__bridge id<CoronaRuntime>)platformContext;
    [interstital showAndLoadWithViewController:runtime.appViewController];
    return 0;
}

int PluginTapForTap::interstitialIsReady(lua_State *luaState)
{
    BOOL isReady = NO;
    if (interstital != nil) {
        isReady = interstital.readyToShow;
    }
    lua_pushboolean (luaState, isReady);
    return 1;
}

int PluginTapForTap::setInterstitialListener(lua_State *luaState)
{
    Self *library = ToLibrary(luaState);
    if(library->interstitialListener)
    {
        CoronaLuaDeleteRef(luaState, library->interstitialListener);
        library->interstitialListener = NULL;
    }

    if (CoronaLuaIsListener(luaState, 1, kEvent))
	{
		CoronaLuaRef listener = CoronaLuaNewRef(luaState, 1);
        library->interstitialListener = listener;
	}
    return 0;
}

void getAppWall(void) {
    if (appWall == nil) {
        appWall = [TFTAppWall appWallWithDelegate:eventHelper];
    }
}

int PluginTapForTap::prepareAppWall(lua_State *luaState)
{
    getAppWall();
    [appWall load];
    return  0;
}

int PluginTapForTap::showAppWall(lua_State *luaState)
{
    getAppWall();
    void *platformContext = CoronaLuaGetContext(luaState);
    id<CoronaRuntime> runtime = (__bridge id<CoronaRuntime>)platformContext;
    [appWall showAndLoadWithViewController:runtime.appViewController];
    return 0;
}

int PluginTapForTap::appWallIsReady(lua_State *luaState)
{
    BOOL isReady = NO;
    if (appWall != nil) {
        isReady = appWall.readyToShow;
    }
    lua_pushboolean (luaState, isReady);
    return 1;
}

int PluginTapForTap::setAppWallListener(lua_State *luaState)
{
    Self *library = ToLibrary(luaState);
    if(library->appWallListener)
    {
        CoronaLuaDeleteRef(luaState, library->appWallListener);
        library->appWallListener = NULL;
    }

    if (CoronaLuaIsListener(luaState, 1, kEvent))
	{
		CoronaLuaRef listener = CoronaLuaNewRef(luaState, 1);
        library->appWallListener = listener;
	}
    return 0;
}

int PluginTapForTap::setDevelopment(lua_State *luaState)
{
    [TFTTapForTap performSelector: @selector(setEnvironment:) withObject: @"development"];
    return 0;
}

PluginTapForTap* PluginTapForTap::ToLibrary(lua_State *luaState)
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata(luaState, lua_upvalueindex(1));
	return library;
}

CORONA_EXPORT int luaopen_plugin_tapfortap(lua_State *luaState)
{
	return PluginTapForTap::Open(luaState);
}
