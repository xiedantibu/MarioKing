local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)
GameScene.winSize=cc.Director:getInstance():getWinSize()
GameScene.scheduleID=nil

--Map相关字段
GameScene.mainLayer=nil
GameScene.mainMap=nil
GameScene.mapSize=nil
GameScene.mapMaxH=0.0
GameScene.beginPos=cc.p(0,0)

--Mario相关字段
GameScene.marioSize=nil
GameScene.mario=nil
GameScene.curPos=nil
GameScene.isSky=false

GameScene.moveDelta=0
GameScene.moveOffset=0
GameScene.jumpOffset=0
GameScene.ccMoveDelta=0.05
GameScene.ccMoveOffset=2.0
GameScene.ccJumpOffset=0.4

--控制相关字段
GameScene.leftKeyDown=false
GameScene.rightKeyDown=false
GameScene.jumpKeyDown=false
GameScene.fireKeyDown=false

--UI
GameScene.gameOver=nil
GameScene.passFailure=nil
GameScene.passSucess=nil
GameScene.retry=nil


function GameScene:ctor()
    self.mainLayer=cc.Layer:create()
    --play bg music
    self:playBgMusic()
end

function GameScene.create()
    local scene = GameScene.new()
    scene:initLayer()
    scene:addChild(scene.mainLayer)
    return scene
end

--初始化layer
function GameScene:initLayer()
    self.mainLayer=cc.Layer:create()

    --初始化Map和Mario
    self:initMap()
    self:initMario()
    
    self:initUI()


    self.mainLayer:setPosition(self.beginPos)

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

    local eventDispatch=self.mainLayer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(touchListener,self.mainLayer)
    eventDispatch:addEventListenerWithSceneGraphPriority(keyListener,self.mainLayer)

    local function tick(dt)
        self:update(dt)
    end  

    self.schedulerID=cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,0,false)

    local function onNodeEvent(event)
        if "exit" == event then
            cclog("GameScene exit")
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        end
    end
    self.mainLayer:registerScriptHandler(onNodeEvent)
end

--初始化地图
function GameScene:initMap()
    local gameMap=require("GameMap")
    self.mainMap=gameMap.create(tmx_map_1)
    self.mainMap:setPosition(cc.p(0,0))
    self.mapSize=cc.size(self.mainMap.tileSize.width*self.mainMap.mapSize.width,self.mainMap.tileSize.height*self.mainMap.mapSize.height)
    cclog("map size:%d,%d",self.mapSize.width,self.mapSize.height)
    self.mainLayer:addChild(self.mainMap)
end

--初始化mario
function GameScene:initMario()
    local mario=require("Mario")
    self.mario=mario.create()
    self.mario:setAnchorPoint(0.5,0)
    self.mario:setPosition(self.mainMap.birthPos)
    self.marioSize=self.mario:getContentSize()
    cclog("Play Init End")
    self.mainLayer:addChild(self.mario)
end

function GameScene:initUI()
    local centerP=cc.p(self.winSize.width/2,self.winSize.height/2)
    
	self.gameOver=cc.Sprite:create(pic_gameover)
	self.gameOver:setPosition(centerP.x,centerP.y+50)
	self.gameOver:setVisible(false)
	self:addChild(self.gameOver)
	
	self.passFailure=cc.Sprite:create(pic_pass_failure)
	self.passFailure:setPosition(centerP.x,centerP.y+50)
    self.passFailure:setVisible(false)
	self:addChild(self.passFailure)
	
    self.passSucess=cc.Sprite:create(pic_pass_sucess)
    self.passSucess:setPosition(centerP.x,centerP.y+50)
    self.passSucess:setVisible(false)
    self:addChild(self.passSucess)
	
	local function onRetry(sender,event)
		local scene=require("GameScene")
		local gameScene=scene.create()
        cc.Director:getInstance():replaceScene(gameScene)
	end
	self.retry=cc.MenuItemImage:create(pic_retry_normal,pic_retry_select)
	self.retry:setPosition(centerP)
	self.retry:setVisible(false)
	self.retry:setEnabled(false)
	self.retry:registerScriptTapHandler(onRetry)
	
	self.menu=cc.Menu:create(self.retry)
	self.menu:setAnchorPoint(0,0)
	self.menu:setPosition(0,0)
	
	self:addChild(self.menu,100)
end

--播放音乐音效
function GameScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(music_bg_music)
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
        self.isLeftKeyDown=false
        self.moveOffset=0
        self.moveDelta=0
        self.mario:setMarioState(MarioState.NORMAL_LEFT)
    elseif cc.KeyCode.KEY_D==keyCode then
        self.rightKeyDown=false
        self.isRightKeyDown=false
        self.moveOffset=0
        self.moveDelta=0
        self.mario:setMarioState(MarioState.NORMAL_RIGHT)
    elseif cc.KeyCode.KEY_J==keyCode then
        self.fireKeyDown=false
    elseif cc.KeyCode.KEY_K==keyCode then
        self.jumpKeyDown=false
    else
    end
end

function GameScene:updateControl()
    if not self.mario.isDead then
        if self.leftKeyDown then
            self.isLeftKeyDown=true
            self.moveOffset=-self.ccMoveOffset
            self.moveDelta=-self.ccMoveDelta
            self.mario:setMarioState(MarioState.LEFT)
        elseif self.rightKeyDown then
            self.isRightKeyDown=true
            self.moveOffset=self.ccMoveOffset
            self.moveDelta=self.moveDelta
            self.mario:setMarioState(MarioState.RIGHT)
        else
        end
        if self.jumpKeyDown then
            if not self.isSky then
                self.jumpOffset=6
                self.isSky=true
                self.mario.isFlying=true
            end
            cc.SimpleAudioEngine:getInstance():playEffect(music_jump)
        end
        if self.fireKeyDown then
        end
    end
end

--移动Layer显示区域
function GameScene:setSceneScrollPosition()
    --暂时考虑水平移动
    local marioPosX=self.mario:getPositionX()
    local anchorX=6*16
    local x=math.max(anchorX,marioPosX)
    x=anchorX-x
    if self.mapSize.width+x <= self.winSize.width then
        x=self.winSize.width-self.mapSize.width
    end
    self.mainLayer:setPosition(x,0)
end

function GameScene:collisionV()
    local marioPos=self.curPos
    --cclog("MarioPos:%d,%d",marioPos.x,marioPos.y)
    --cclog("MarioSize:%d,%d",self.marioSize.width,self.marioSize.height)
    if marioPos.y<=0 then
        --cclog("Mario Died")
        self.mario.isDead=true
        local pos=cc.p(marioPos.x,1)
        self.mario:dieForTrap()
        cc.SimpleAudioEngine:getInstance():stopMusic()
        cc.SimpleAudioEngine:getInstance():playEffect(music_diaoruxianjingsi)
        return
    end
    local topY=self.mapSize.height-self.marioSize.height-2
    if marioPos.y>=topY then
        --cclog("Mario in the Top")
        self.jumpOffset=0
        self.isSky=false
        local pos=cc.p(marioPos.x,topY)
        self.curPos=pos
        self.mario:setPosition(pos)
        return
    end
    for marioIdx=6,self.marioSize.width-7 do
        local upCollisionPos=cc.p(marioPos.x-self.marioSize.width/2+marioIdx,marioPos.y+self.marioSize.height)
        local upTileCoord=self.mainMap:pointToTileCoord(upCollisionPos)
        --cclog("upCollisionPos:%d,%d",upCollisionPos.x,upCollisionPos.y)
        --cclog("upTileCoord:%d,%d",upTileCoord.x,upTileCoord.y)
        if self.mainMap:isMarioEatMushroom(upTileCoord) then
            self.mario:changeForGotMushroom()
        end
        local upPos=self.mainMap:tileCoordToPoint(upTileCoord)
        upPos=cc.p(marioPos.x,upPos.y-self.marioSize.height)
        --cclog("upPos:%d,%d",upPos.x,upPos.y)
        local tileType=self.mainMap:tileTypeAtCoord(upTileCoord)
        --cclog("up tileType:%d",tileType)
        local flagUp=false
        if TileType.BRICK==tileType or TileType.LAND==tileType then
            if self.jumpOffset>0 then
                self.mainMap:breakBrick(upTileCoord,self.mario.bodyType)
                self.jumpOffset=0
                self.curPos=upPos
                self.mario:setPosition(upPos)
                flagUp=true
            end
        elseif TileType.COIN==tileType then
        else
        end--end if TileType
        if flagUp then
            self.jumpOffset=self.jumpOffset-self.ccJumpOffset
            return
        end
    end--end for
    for marioIdx=4,self.marioSize.width-5 do
        local downCollisionPos=cc.p(marioPos.x-self.marioSize.width/2+marioIdx,marioPos.y)
        local downTileCoord=self.mainMap:pointToTileCoord(downCollisionPos)
        if self.mainMap:isMarioEatMushroom(downTileCoord) then
            self.mario:changeForGotMushroom()
        end
        downTileCoord.y=downTileCoord.y+1
        if downTileCoord.y>=self.mainMap.mapSize.height then
            return
        end
        --cclog("downCollisionPos:%d,%d",downCollisionPos.x,downCollisionPos.y)
        local downPos=self.mainMap:tileCoordToPoint(downTileCoord)
        downPos=cc.p(marioPos.x,downPos.y+self.mainMap.tileSize.height)
        --cclog("downPos:%d,%d",downPos.x,downPos.y)
        --cclog("downTileCoord:%f,%f",downTileCoord.x,downTileCoord.y)
        local tileType=self.mainMap:tileTypeAtCoord(downTileCoord)
        --cclog("down tileType:%d",tileType)
        local flagDown=false--判断是否落地
        if TileType.BRICK==tileType or TileType.LAND==tileType or TileType.PIPE==tileType then
            if self.jumpOffset<0 then
                self.jumpOffset=0
                self.curPos=downPos
                self.mario:setPosition(downPos)
                self.isSky=false
                self.mario.isFlying=false
                local fc=self.mario.face
                if MarioState.LEFT==fc then
                    if self.isLeftKeyDown then
                        self.mario:setMarioState(MarioState.LEFT)
                    else
                        self.mario:setMarioState(MarioState.NORMAL_LEFT)
                    end
                elseif MarioState.RIGHT==fc then
                    if self.isRightKeyDown then
                        self.mario:setMarioState(MarioState.RIGHT)
                    else
                        self.mario:setMarioState(MarioState.NORMAL_RIGHT)
                    end
                else
                end--end if MarioState             
            end--end if self.jumpOffset
            flagDown=true
        elseif TileType.FLAGPOLE==tileType then
        elseif TileType.COIN==tileType then
        else
        end
        if flagDown then
            return
        end
    end--end for
    self.jumpOffset=self.jumpOffset-self.ccJumpOffset
end

function GameScene:collisionH()
    local halfSZ=self.marioSize.width/2
    local marioPos=self.curPos
    if marioPos.x<=halfSZ then
        marioPos.x=halfSZ
    end
    if marioPos.x>=self.mapSize.width-halfSZ then
        marioPos.x=self.mapSize.width-halfSZ
    end
    self.curPos=marioPos
    self.mario:setPosition(marioPos)
end

function GameScene:update(delta)
    if self.mario.isDead then
        self:stopForFail()
        return
    end
    self:updateControl()
    self.curPos=cc.p(self.mario:getPositionX(),self.mario:getPositionY())
    local offset=cc.p(self.moveOffset,self.jumpOffset)
    self.curPos=cc.pAdd(self.curPos,offset)
    if self.isSky then
        local fc=self.mario.face
        if fc==MarioState.LEFT then
            self.mario:setMarioState(MarioState.JUMP_LEFT)
        elseif fc==MarioState.RIGHT then
            self.mario:setMarioState(MarioState.JUMP_RIGHT)
        else
        end
    end
    self.mario:setPosition(self.curPos)
    self:setSceneScrollPosition()
    self:collisionH()
    self:collisionV()
end

function GameScene:stopForFail()
	if self.mario.lifeCnt==0 then
	   cc.SimpleAudioEngine:getInstance():stopMusic()
	   cc.SimpleAudioEngine:getInstance():playEffect(music_gameover)
	   self.gameOver:setVisible(true)
	else
	   self.passFailure:setVisible(true)
	end
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    local delay=cc.DelayTime:create(3)
    local function onFail()
    	self:reshowPassFailure()
    end
    self.mainLayer:runAction(cc.Sequence:create(delay,cc.CallFunc:create(onFail)))
end

function GameScene:reshowPassFailure()
    if self.mario.lifeCnt==0 then
        self:toMainMenu()
    else
        self.retry:setVisible(true)
        self.retry:setEnabled(true)
    end
end

function GameScene:toMainMenu()
	local scene=require("MainMenu")
	local menuScene=scene.create()
	cc.Director:getInstance():replaceScene(menuScene)
end

return GameScene