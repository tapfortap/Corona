//
//  Copyright (c) 2013 TapForTap. All rights reserved.
//

#include "CoronaLua.h"
#include "PluginTapForTap.h"
#import "PluginTapForTapEventHelper.h"

@interface PluginTapForTapEventHelper()
- (void) dispatchEvent:(NSString*) event withMessage:(NSString*) message to:(CoronaLuaRef) listener;
@end

@implementation PluginTapForTapEventHelper

- (id) initWithLibrary:(PluginTapForTap*)_library withLuaState:(lua_State*) _luaState
{
    self = [super init];
    if (self) {
        library = _library;
        luaState = _luaState;
    }
    return self;
}

- (void) dispatchEvent:(NSString*) event withMessage:(NSString*) message to:(CoronaLuaRef) listener
{
    if(!listener) {
        return;
    }

    CoronaLuaNewEvent(luaState, PluginTapForTap::kEvent );

    lua_pushstring(luaState, [event UTF8String]);
    lua_setfield( luaState, -2, "event");

    lua_pushstring(luaState, [message UTF8String]);
    lua_setfield( luaState, -2, "message");

    CoronaLuaDispatchEvent(luaState, listener, 0);
}


- (void) tftBannerDidReceiveAd:(TFTBanner *)banner
{
    [self dispatchEvent:@"onReceiveAd" withMessage: @"" to:library->bannerListener];
}

- (void) tftBanner:(TFTBanner *)banner didFail:(NSString *)reason
{
    [self dispatchEvent:@"onFailToReceiveAd" withMessage: reason to:library->bannerListener];
}

- (void) tftBannerWasTapped:(TFTBanner *)banner
{
    [self dispatchEvent:@"onTapAd" withMessage: @"" to:library->bannerListener];
}

- (void) tftInterstitialDidReceiveAd:(TFTInterstitial *)interstitial
{
    [self dispatchEvent:@"onReceiveAd" withMessage: @"" to:library->interstitialListener];
}

- (void) tftInterstitialDidShow:(TFTInterstitial *)interstitial
{
    [self dispatchEvent:@"onShow" withMessage: @"" to:library->interstitialListener];
}

- (void) tftInterstitialWasTapped:(TFTInterstitial *)interstitial
{
    [self dispatchEvent:@"onTap" withMessage: @"" to:library->interstitialListener];
}

- (void) tftInterstitialWasDismissed:(TFTInterstitial *)interstitial
{
     [self dispatchEvent:@"onDismiss" withMessage: @"" to:library->interstitialListener];
}

- (void) tftInterstitial:(TFTInterstitial *)interstitial didFail:(NSString *)reason
{
     [self dispatchEvent:@"onFailToReceiveAd" withMessage: reason to:library->interstitialListener];
}


- (void)tftAppWallDidReceiveAd:(TFTAppWall *)appWall
{
    [self dispatchEvent:@"onReceiveAd" withMessage: @"" to:library->appWallListener];
}

- (void) tftAppWallDidShow:(TFTAppWall *)appWall
{
    [self dispatchEvent:@"onShow" withMessage: @"" to:library->appWallListener];
}

- (void) tftAppWallWasTapped:(TFTAppWall *)appWall
{
    [self dispatchEvent:@"onTap" withMessage: @"" to:library->appWallListener];
}

- (void) tftAppWallWasDismissed:(TFTAppWall *)appWall
{
    [self dispatchEvent:@"onDismiss" withMessage: @"" to:library->appWallListener];
}

- (void) tftAppWall:(TFTAppWall *)appWall didFail:(NSString *)reason
{
    [self dispatchEvent:@"onFailToReceiveAd" withMessage: reason to:library->appWallListener];
}

@end
