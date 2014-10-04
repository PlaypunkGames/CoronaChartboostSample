-- main.lua

local chartboost = require( "plugin.chartboost" )
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios" )

-- The ChartBoost listener function
local function chartBoostListener( event )
    for k, v in pairs( event ) do
        print( tostring(k).. "=".. tostring(v) )
    end
end

-- Your Chartboost app id and signature for iOS
local yourAppID        = "xxxx"
local yourAppSignature = "yyyy"

-- Change the appid/sig for Android
if system.getInfo( "platformName" ) == "Android" then
    yourAppID        = "xxxx"
    yourAppSignature = "yyyy"
end

print( "Chartboost plugin version: ".. chartboost.getPluginVersion() )

-- Initialise ChartBoost
chartboost.init {
        appID        = yourAppID,
        appSignature = yourAppSignature, 
        listener     = chartBoostListener
    }

-- Show Ad button
local showAdButton = widget.newButton
{
    label = "Show Ad",
    onRelease = function( event )
        print( "has cached Ad?: "..tostring( chartboost.hasCachedInterstitial() ))
        print( "has cached more apps?: ".. tostring( chartboost.hasCachedMoreApps() ))
    
        if not chartboost.hasCachedInterstitial() then
            native.showAlert( "No ad available", "Please cache an ad.", { "OK" })
        else
            chartboost.show( "interstitial" )
        end
    end
}
showAdButton.x = display.contentCenterX
showAdButton.y = 150

-- Cache Default Ad
local cacheDefaultAd = widget.newButton
{
    label = "Cache Default Ad",
    onRelease = function( event )
        chartboost.cache( "interstitial" )
    end,
}
cacheDefaultAd.x = display.contentCenterX
cacheDefaultAd.y = showAdButton.y + showAdButton.contentHeight + cacheDefaultAd.contentHeight * 0.5

-- Cache More Apps
local cacheMoreAppsButton = widget.newButton
{
    label = "Cache More Apps",
    onRelease = function( event )
        chartboost.cache( "moreApps" )
    end
}
cacheMoreAppsButton.x = display.contentCenterX
cacheMoreAppsButton.y = cacheDefaultAd.y + cacheDefaultAd.contentHeight + cacheMoreAppsButton.contentHeight * 0.5

-- Show More Apps button
local showMoreAppsButton = widget.newButton
{
    label = "Show More Apps",
    onRelease = function( event )
        chartboost.show( "moreApps" )
    end
}
showMoreAppsButton.x = display.contentCenterX
showMoreAppsButton.y = cacheMoreAppsButton.y + cacheMoreAppsButton.contentHeight + showMoreAppsButton.contentHeight * 0.5

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- IMPORTANT! YOU MUST CALL chartboost.startSession() IN YOUR OWN CODE AS BELOW TO ENSURE PROPER PLUGIN BEHAVIOR
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local function systemEvent( event )
    local phase = event.phase

    if event.type == "applicationResume" then
        -- Start a ChartBoost session
        chartboost.startSession( yourAppID, yourAppSignature )
    end
    
    return true
end

Runtime:addEventListener( "system", systemEvent )
