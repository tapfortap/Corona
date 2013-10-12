//
//  Copyright (c) 2013 TapForTap. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "PluginTapForTap.h"

@interface PluginTapForTapEventHelper : NSObject<TFTBannerDelegate, TFTAppWallDelegate, TFTInterstitialDelegate> {
    lua_State* luaState;
    PluginTapForTap* library;
}

@property (retain, nonatomic) TFTBanner *banner;
- (id) initWithLibrary:(PluginTapForTap*)_library withLuaState:(lua_State*)_luaState;
@end
