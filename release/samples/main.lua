local tapfortap = require "plugin.tapfortap"
local widget = require "widget"

local MALE = 0
local FEMALE = 0

local function adViewListener(event)
    print(event.name, "adViewListener " .. event.event .. " " .. event.message)
end

local function appWallListener(event)
    print(event.name, "appWallListener " .. event.event .. " " .. event.message)
end

local function interstitialListener(event)
    print(event.name, "interstitialListener " .. event.event .. " " .. event.message)
end

local function showAd( event )
    if event.phase == "ended" then
        tapfortap.createAdView(0,0)
    end
end

local function removeAd( event )
    if event.phase == "ended" then
        tapfortap.removeAdView()
    end
end

local function showInterstitial( event )
    if event.phase == "ended" then
        tapfortap.showInterstitial()
    end
end

local function showAppWall( event )
    if event.phase == "ended" then
        tapfortap.showAppWall()
    end
end

local showAdButton = widget.newButton{
    id = "showAdButton",
    label = "Show Banner",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = showAd
}

local removeAdButton = widget.newButton{
    id = "removeAdButton",
    label = "Remove Banner",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = removeAd
}

local showInterstitialButton = widget.newButton{
    id = "showInterstitialButton",
    label = "Show Interstitial",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = showInterstitial
}

local showAppWallButton = widget.newButton{
    id = "showAppWallButton",
    label = "Show AppWall",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = showAppWall
}

showAdButton.x = display.contentCenterX
showAdButton.y = 100
removeAdButton.x = display.contentCenterX
removeAdButton.y = showAdButton.y + showAdButton.height + 15
showInterstitialButton.x = display.contentCenterX
showInterstitialButton.y = removeAdButton.y + removeAdButton.height + 15
showAppWallButton.x = display.contentCenterX
showAppWallButton.y = showInterstitialButton.y + showInterstitialButton.height + 15

tapfortap.initialize("a49b3abbbefbb948776b0edaa8718367")
tapfortap.setYearOfBirth(1989)
tapfortap.setGender(MALE)
tapfortap.setLocation(48.418264494187454, -123.30814361572266)
tapfortap.setUserAccountId("test account")
tapfortap.prepareInterstitial()
tapfortap.prepareAppWal()
tapfortap.setAdViewListener(adViewListener)
tapfortap.setAppWallListener(appWallListener)
tapfortap.setInterstitialListener(interstitialListener)
