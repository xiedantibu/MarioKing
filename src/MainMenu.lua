local MainMenu = class("MainMenu",function()
    return cc.Scene:create()
end)

function MainMenu.create()
    local scene = MainMenu.new()
    scene:addChild(scene:createMenuLayer())
    return scene
end

function MainMenu:createMenuLayer()
    local ly=cc.Layer:create()
    
    local size=cc.Director:getInstance():getWinSize()
    local centerP=cc.p(size.width/2,size.height/2)
	local bg=cc.Sprite:create(pic_bg)
	bg:setPosition(centerP)
	ly:addChild(bg)
	
    local function onStartGame(sender)
        cclog("onStartGame")
        local scene=require("GameScene")
        local gameScene=scene.create()
        cc.Director:getInstance():replaceScene(gameScene)
	end
	local startMI=cc.MenuItemImage:create(pic_start_normal,pic_start_select)
	startMI:registerScriptTapHandler(onStartGame)
	startMI:setPosition(centerP.x,centerP.y)
	
    local function onSettingGame(sender)
        cclog("onSettingGame")
    end
	local settingMI=cc.MenuItemImage:create(pic_setting_normal,pic_setting_select)
    settingMI:registerScriptTapHandler(onSettingGame)
	settingMI:setPosition(centerP.x,centerP.y-30)
	
    local function onAboutGame(sender)
        cclog("onAboutGame")
    end
    local aboutMI=cc.MenuItemImage:create(pic_about_normal ,pic_about_select)
    aboutMI:registerScriptTapHandler(onAboutGame)
    aboutMI:setPosition(centerP.x,centerP.y-60)
    
    local function onQuitGame(sender)
        cclog("onQuitGame")
    end
    local quitMI=cc.MenuItemImage:create(pic_quit_normal,pic_quit_select)
    quitMI:registerScriptTapHandler(onQuitGame)
    quitMI:setPosition(centerP.x,centerP.y-90)
	
	local menus=cc.Menu:create(startMI,settingMI,aboutMI,quitMI)
	menus:setPosition(0,0)
	ly:addChild(menus)
	
	return ly
end

return MainMenu