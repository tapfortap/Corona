local tapfortap = require "plugin.tapfortap"
local widget = require "widget"

local MALE = 0
local FEMALE = 0

local TOP = 1
local CENTER = 2
local BOTTOM = 3
local LEFT = 1
local RIGHT = 3

-- The ad view listener function. Prints the event's name and message to the console.
local function adViewListener(event)
    print(event.name, "adViewListener " .. event.event .. " " .. event.message)
end

-- The app wall listener function. Prints the event's name and message to the console.
local function appWallListener(event)
    print(event.name, "appWallListener " .. event.event .. " " .. event.message)
end

-- The interstitial listener function. Prints the event's name and message to the console.
local function interstitialListener(event)
    print(event.name, "interstitialListener " .. event.event .. " " .. event.message)
end

-- Function to handle when the showAd button is clicked. It will create an ad view at the bottom center of the screen.
local function showAd( event )
    if event.phase == "ended" then
        tapfortap.createAdView(BOTTOM,CENTER)
    end
end

-- Function to handle when the removeAdView button is clicked. It will remove the current displayed ad view.
local function removeAd( event )
    if event.phase == "ended" then
        tapfortap.removeAdView()
    end
end

-- Function to handle when the showInterstitial button is clicked. It will show an interstitial.
local function showInterstitial( event )
    if event.phase == "ended" then
        tapfortap.showInterstitial()
    end
end

-- Funciton to handle when the showAppWall button is clicked. It will show an app wall.
local function showAppWall( event )
    if event.phase == "ended" then
        tapfortap.showAppWall()
    end
end

-- Configure the showAd button.
local showAdButton = widget.newButton{
    id = "showAdButton",
    label = "Show Banner",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = showAd
}

-- Configure the removeAdButton.
local removeAdButton = widget.newButton{
    id = "removeAdButton",
    label = "Remove Banner",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = removeAd
}

-- Configure the showInterstitial button.
local showInterstitialButton = widget.newButton{
    id = "showInterstitialButton",
    label = "Show Interstitial",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = showInterstitial
}

-- Configure the showAppWall button.
local showAppWallButton = widget.newButton{
    id = "showAppWallButton",
    label = "Show AppWall",
    default = "buttongraphic.png",
    over = "buttongraphic-over.png",
    width = 200, height = 50,
    onEvent = showAppWall
}

-- Setup some buttons to handle showing ads
showAdButton.x = display.contentCenterX
showAdButton.y = 100

removeAdButton.x = display.contentCenterX
removeAdButton.y = showAdButton.y + showAdButton.height + 15

showInterstitialButton.x = display.contentCenterX
showInterstitialButton.y = removeAdButton.y + removeAdButton.height + 15

showAppWallButton.x = display.contentCenterX
showAppWallButton.y = showInterstitialButton.y + showInterstitialButton.height + 15

-- Initialize Tap for Tap with your account API key
tapfortap.initialize("YOUR API KEY")

-- Set the user's year of birth
tapfortap.setYearOfBirth(1989)

-- Set the user's gender to male (0)
tapfortap.setGender(MALE)

-- Set the user's location
tapfortap.setLocation(48.418264494187454, -123.30814361572266)

-- Set your custom account id for the user
tapfortap.setUserAccountId("test account")

-- Prepare an interstitial so when showInterstitial() is called, it will load faster
tapfortap.prepareInterstitial()

-- Prepare an app wall so when showAppWall() is called, it will load faster
tapfortap.prepareAppWall()

-- Set the ad view listener
tapfortap.setAdViewListener(adViewListener)

-- Set the app wall listener
tapfortap.setAppWallListener(appWallListener)

-- Set the interstitial listener
tapfortap.setInterstitialListener(interstitialListener)
