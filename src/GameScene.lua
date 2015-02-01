local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)
GameScene.winSize=cc.Director:getInstance():getWinSize()
GameScene.scheduleID=nil

GameScene.mainLayer=nil
GameScene.mainMap=nil
GameScene.mapSize=nil
GameScene.mapMaxH=0.0
GameScene.beginPos=nil

GameScene.playerSZ=nil
GameScene.player=nil
GameScene.curPos=nil
GameScene.playerAnchor=cc.p(GameScene.winSize.width/2-80,GameScene.winSize.height/2)
GameScene.isSky=false

GameScene.moveDelta=0
GameScene.moveOffset=0
GameScene.jumpOffset=0
GameScene.ccMoveDelta=0.05
GameScene.ccMoveOffset=2.0
GameScene.ccJumpOffset=0.3

GameScene.leftKeyDown=false
GameScene.rightKeyDown=false
GameScene.jumpKeyDown=false
GameScene.fireKeyDown=false

GameScene.beginPos=cc.p(0,96)
GameScene.backKeyPos=cc.p(84,48)
GameScene.leftKeyPos=cc.p(40,48)
GameScene.rightKeyPos=cc.p(128,48)
GameScene.jumpKeyPos=cc.p(432,35)
GameScene.fireKeyPos=cc.p(353,35)
GameScene.MSetKeyPos=cc.p(260,30)




function GameScene:ctor()
    self.mainLayer=cc.Layer:create()
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
    self.abNormal:retain()
    self.abSelect=cc.SpriteFrame:create(pic_ab_select,abRect)
    self.abSelect:retain()

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
        cclog("Fire")
        self.fireKeyDown=true
    elseif cc.KeyCode.KEY_K==keyCode then
        cclog("Jump")
        self.jumpKeyDown=true
    else
    end

end

function GameScene:onKeyReleased(keyCode,event)
    keyCode=keyCode-3
    if cc.KeyCode.KEY_A==keyCode then
        self.leftKeyDown=false
        self.backKeyImage:setSpriteFrame(self.backKeyNormal)
        self.moveOffset=0
        self.moveDelta=0
        self.player:setMarioState(MarioState.NORMAL_LEFT)
    elseif cc.KeyCode.KEY_D==keyCode then
        self.rightKeyDown=false
        self.backKeyImage:setSpriteFrame(self.backKeyNormal)
        self.moveOffset=0
        self.moveDelta=0
        self.player:setMarioState(MarioState.NORMAL_RIGHT)
    elseif cc.KeyCode.KEY_J==keyCode then
        self.fireKeyDown=false
    elseif cc.KeyCode.KEY_K==keyCode then
        self.jumpKeyDown=false
        self.jumpImage:setSpriteFrame(self.abNormal)
    else
    end
end

function GameScene:updateControl()
    if not self.player.isDead then
        if self.leftKeyDown then
            self.moveOffset=-self.ccMoveOffset
            self.moveDelta=-self.ccMoveDelta
            self.player:setMarioState(MarioState.LEFT)
            self.backKeyImage:setSpriteFrame(self.backKeyLeft)
        elseif self.rightKeyDown then
            self.moveOffset=self.ccMoveOffset
            self.moveDelta=self.moveDelta
            self.player:setMarioState(MarioState.RIGHT)
            self.backKeyImage:setSpriteFrame(self.backKeyRight)
        else
        end
        if self.jumpKeyDown then
            if not self.isSky then
                self.jumpOffset=0
                self.isSky=true
                self.player.isFlying=true
            end
            self.jumpImage:setSpriteFrame(self.abSelect)
        end
        if self.fireKeyDown then
        end
    end
end

function GameScene:setSceneScrollPosition()
    local playerPos=cc.p(self.player:getPositionX(),self.player:getPositionY())
    local x=math.max(playerPos.x,self.playerAnchor.x)
    local y=math.max(playerPos.y,self.playerAnchor.y)
    x=math.min(x,self.mapSize.width-self.playerAnchor.x)
    y=math.min(y,self.mapSize.height-self.playerAnchor.y)
    local actualPos=cc.p(x,y)
    local viewPos=cc.pSub(self.playerAnchor,actualPos)
    local avPosX=math.abs(viewPos.x)
    if avPosX<=self.mapMaxH then
        return
    else
        --cclog("view Pos:%d,%d",avPosX,self.mapMaxH)
        self.mainLayer:setPosition(viewPos)
        self.mapMaxH=avPosX
    end
end

function GameScene:collisionV()
	self.jumpOffset=self.jumpOffset-self.ccJumpOffset
end

function GameScene:update(delta)
    self:updateControl()
    self.curPos=cc.p(self.player:getPositionX(),self.player:getPositionY())
    local offset=cc.p(self.moveOffset,self.jumpOffset)
    self.curPos=cc.pAdd(self.curPos,offset)
    --cclog("curPos:%d,%d",self.curPos.x,self.curPos.y)
    if self.isSky then
        local fc=self.player.face
        if MarioState.LEFT==fc then
            self.player:setMarioState(MarioState.JUMP_LEFT)
        elseif MarioState.RIGHT==fc then
            self.player:setMarioState(MarioState.JUMP_RIGHT)
        else
        end
    end
    self.player:setPosition(self.curPos)
    self:setSceneScrollPosition()
    self:collisionV()
end

return GameScene