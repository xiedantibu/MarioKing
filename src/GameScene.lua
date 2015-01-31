local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

GameScene.scheduleID=nil

GameScene.mainLayer=nil
GameScene.beginPos=nil
GameScene.playerSZ=nil
GameScene.player=nil
GameScene.curPos=nil
GameScene.mainMap=nil
GameScene.mapSize=nil

GameScene.backKeyPos=nil
GameScene.leftKeyPos=nil
GameScene.rightKeyPos=nil
GameScene.jumpKeyPos=nil
GameScene.fireKeyPos=nil
GameScene.MSetKeyPos=nil

GameScene.leftKeyDown=false
GameScene.rightKeyDown=false
GameScene.jumpKeyDown=false
GameScene.fireKeyDown=false

function GameScene:ctor()
	self.beginPos=cc.p(0,96)
	self.backKeyPos=cc.p(84,48)
	self.leftKeyPos=cc.p(40,48)
	self.rightKeyPos=cc.p(128,48)
	self.jumpKeyPos=cc.p(432,35)
	self.fireKeyPos=cc.p(353,35)
	self.MSetKeyPos=cc.p(260,30)
	self.mainLayer=cc.Layer:create()
	
	--key state
	self.leftKeyDown=false
	self.rightKeyDown=false
	self.jumpKeyDown=false
	self.fireKeyDown=false
	
	--play bg music
	--self:playBgMusic()
end

function GameScene.create()
    local scene = GameScene.new()
    scene:addChild(scene:createLayerFarm())
    return scene
end

function GameScene:createLayerFarm()
    local layer=cc.Layer:create()
    
    self:initMap()
    self.mainLayer:addChild(self.mainMap)
    self:initMario()
    self.mainLayer:addChild(self.player)
    
    self.mainLayer:setPosition(self.beginPos)
    layer:addChild(self.mainLayer)
       
    self:createControlLayer(layer)
    
    --register touches listener
    local touchListener=cc.EventListenerTouchAllAtOnce:create()
    touchListener:registerScriptHandler(self.onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN)
    touchListener:registerScriptHandler(self.onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED)
    touchListener:registerScriptHandler(self.onTouchesEnded,cc.Handler.EVENT_TOUCHES_ENDED)
    
    --register keyboard listener
    local function onKeyPressed(keyCode,event)
    	self:onKeyPressed(keyCode,event)
    end
    
    local function onKeyReleased(keyCode,event)
        self:onKeyReleased(keyCode,event)
    end
    
    local keyListener=cc.EventListenerKeyboard:create()
    keyListener:registerScriptHandler(onKeyPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    keyListener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)
    
    local eventDispatch=layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(touchListener,layer)
    eventDispatch:addEventListenerWithSceneGraphPriority(keyListener,layer)
    
    local function tick(dt)
    	self:update(dt)
    end
    
    self.scheduleID=cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,0,false)
       
    return layer
end

function GameScene:createControlLayer(layer)
    
    local winSZ=cc.Director:getInstance():getWinSize()
	local controlBg=cc.Sprite:create(pic_control_bg)
    controlBg:setAnchorPoint(0,0)
    layer:addChild(controlBg)
    
    --direction key
    local backRect=cc.rect(0,0,72,72)
    self.backKeyNormal=cc.SpriteFrame:create(pic_backKey,backRect)
    self.backKeyNormal:retain()
    self.backKeyRight=cc.SpriteFrame:create(pic_backKey_right,backRect)
    self.backKeyRight:retain()
    self.backKeyLeft=cc.SpriteFrame:create(pic_backKey_left,backRect)
    self.backKeyLeft:retain()
    
    
    self.backKeyImage=cc.Sprite:createWithSpriteFrame(self.backKeyNormal)
    self.backKeyImage:setPosition(self.backKeyPos)
    layer:addChild(self.backKeyImage)
	
	--AB key,A:fire,B:jump
    local abRect=cc.rect(0,0,72,50)
    self.abNormal=cc.SpriteFrame:create(pic_ab_normal,abRect)
    self.abSelect=cc.SpriteFrame:create(pic_ab_select,abRect)
    
    self.jumpImage=cc.Sprite:createWithSpriteFrame(self.abNormal)
    self.jumpImage:setPosition(self.jumpKeyPos)
    layer:addChild(self.jumpImage)
    
    self.fireImage=cc.Sprite:createWithSpriteFrame(self.abNormal)
    self.fireImage:setPosition(self.fireKeyPos)
    layer:addChild(self.fireImage)
    
    self.leftKeyMI=cc.MenuItemImage:create(pic_leftright,pic_leftright)
    self.rightKeyMI=cc.MenuItemImage:create(pic_leftright,pic_leftright)
    self.jumpMI=cc.MenuItemImage:create(pic_ab_normal,pic_ab_select)

    self.leftKeyMI:setPosition(self.leftKeyPos)
    self.rightKeyMI:setPosition(self.rightKeyPos)
    self.jumpMI:setPosition(self.jumpKeyPos)
    
    
    self.MSetMI=cc.MenuItemImage:create(pic_M_n,pic_M_s)
    self.MSetMI:setPosition(self.MSetKeyPos)
    
    self.backMenuMI=cc.MenuItemImage:create(pic_back_to_menu,pic_back_to_menu)
    self.backMenuMI:setVisible(false)
    self.backMenuMI:setEnabled(false)  
    self.backMenuMI:setPosition(winSZ.width/2,winSZ.height/2+20)
    
end

function GameScene:initMap()
	local gameMap=require("GameMap")
	self.mainMap=gameMap.create(tmx_map_1)
	self.mainMap:setPosition(cc.p(0,0))
    self.mapSize=cc.size(self.mainMap.tileSize.width*self.mainMap.mapSize.width,self.mainMap.tileSize.height*self.mainMap.mapSize.height)
    cclog("map size:%d,%d",self.mapSize.width,self.mapSize.height)
end

function GameScene:initMario()
	local mario=require("Mario")
	self.player=mario.create()
    self.player:setAnchorPoint(0.5,0)
    self.player:setPosition(self.mainMap.birthPos)
	cclog("Play Init End")
end

function GameScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("OnLand.wma")
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath,true)
end

function GameScene.onTouchesBegan(touches,event)
    cclog("onTouchesBegan")
end

function GameScene.onTouchesMoved(touches,event)
    cclog("onTouchesMoved")
end

function GameScene.onTouchesEnded(touches,event)
    cclog("onTouchesEnded")
end

function GameScene:onKeyPressed(keyCode,event)
    cclog("onKeyPressed:%d,%d,%d,%d,%d",keyCode,cc.KeyCode.KEY_A,cc.KeyCode.KEY_D,cc.KeyCode.KEY_J,cc.KeyCode.KEY_K)
    keyCode=keyCode-3
    if cc.KeyCode.KEY_A==keyCode then
        cclog("Go Left")
        self.leftKeyDown=true
    elseif cc.KeyCode.KEY_D==keyCode then
        cclog("Go Right")
        self.rightKeyDown=true
    elseif cc.KeyCode.KEY_J==keyCode then
        cclog("Jump")
        self.jumpKeyDown=true
    elseif cc.KeyCode.KEY_K==keyCode then
        cclog("Fire")
        self.fireKeyDown=true
    else
    end
    
end

function GameScene:onKeyReleased(keyCode,event)
    keyCode=keyCode-3
    if cc.KeyCode.KEY_A==keyCode then
        self.leftKeyDown=false
        self.backKeyImage:setSpriteFrame(self.backKeyNormal)
    elseif cc.KeyCode.KEY_D==keyCode then
        self.rightKeyDown=false
        self.backKeyImage:setSpriteFrame(self.backKeyNormal)
    elseif cc.KeyCode.KEY_J==keyCode then
        self.jumpKeyDown=false
    elseif cc.KeyCode.KEY_K==keyCode then
        self.fireKeyDown=false
    else
    end
end

function GameScene:updateControl()
	if self.leftKeyDown then
        self.backKeyImage:setSpriteFrame(self.backKeyLeft)
	elseif self.rightKeyDown then
	   self.backKeyImage:setSpriteFrame(self.backKeyRight)
	else
	end
	if self.jumpKeyDown then
	end
	if self.fireKeyDown then
	end
end

function GameScene:update(delta)

    self:updateControl()
	
end

return GameScene