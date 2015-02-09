local GameMap=class("GameMap",function (tmxFile)
    return cc.TMXTiledMap:create(tmxFile)
end)

GameMap.enemyList={}
GameMap.spList={}
GameMap.itemCoordList={}
GameMap.mushroomCoordList={}
GameMap.mushSprite=nil
GameMap.mushTileCoord=nil
GameMap.resetCoinPoint=nil
GameMap.brokenCoin=nil
GameMap.birthPos=nil

function GameMap.create(tmxFile)
    local gameMap=GameMap.new(tmxFile)
    gameMap:extraInit()
    return gameMap
end

function GameMap:ctor()
	self.brokenCoin=cc.SpriteFrame:create(pic_tmx_map,cc.rect(1,18,16,16))
	self.brokenCoin:retain()
end

function GameMap:extraInit()
    self.tileSize=self:getTileSize()
    self.mapSize=self:getMapSize()
    
    --map=cc.TMXTiledMap:new()
    self.brickLayer=self:getLayer("brick")
    --self.pipeLayer=self:getLayer("pipe")
    self.landLayer=self:getLayer("land")
    self.trapLayer=self:getLayer("trap")
    self.objectLayer=self:getObjectGroup("objects")
    --self.coinLayer=self:getLayer("coin")
    --self.flagpoleLayer=self:getLayer("flagpole")
    self:initObjects()

end

function GameMap:initObjects()
    local objects=self.objectLayer:getObjects()
    --cclog("objects type:%s",type(objects))
    --cclog("object count:%d",#objects)
    for i,v in ipairs(objects) do
        --cclog("object type:%s",type(v))
        --cclog("name:%s,type:%s",v.name,v.type)
        --cclog("x:%d,y:%d",v.x,v.y)
        --cclog("width:%d,height:%d",v.width,v.height)
        local x,y=v.x,v.y-self.tileSize.height
        local tileCoord=self:pointToTileCoord(cc.p(x,y))
        if v.name=="enemy" then
            if v.type=="mushroom" then
                local enemy=require("Enemy")
                local mushroom=enemy.create()
                mushroom.position=cc.p(x,y)
                self.enemyList[#self.enemyList+1]=mushroom
            end
        elseif v.name=="others" then
            if v.type=="BirthPoint" then
                self.birthPos=self:tileCoordToPoint(tileCoord)
                self.birthPos.x=self.birthPos.x+self.tileSize.width/2
                cclog("birth pos:%d,%d",self.birthPos.x,self.birthPos.y)
            end
        elseif v.name=="mushroom" then
            if v.type=="MushroomReward" then
                self.mushroomCoordList[#self.mushroomCoordList+1]=tileCoord
            end
        else
        end
    end--end for
    self:launchEnemyInMap()
end

function GameMap:tileTypeAtCoord(tileCoord)
    local id= self.brickLayer:getTileGIDAt(tileCoord)
    if id>0 then
        return TileType.BRICK
    end 
    id=self.landLayer:getTileGIDAt(tileCoord)
    if id>0 then
        return TileType.LAND
    end
    id= self.trapLayer:getTileGIDAt(tileCoord)
    if id>0 then
        return TileType.TRAP
    end 
--  id=self.pipeLayer:getTileGIDAt(tileCoord)
--  if id>0 then
--     return TileType.PIPE
--  end
--    id=self.coinLayer :getTileGIDAt(tileCoord)
--    if id>0 then
--        return TileType.COIN
--    end
--    id=self.flagpoleLayer:getTileGIDAt(tileCoord)
--    if id>0 then
--        return TileType.FLAGPOLE
--    end
    return TileType.NONEH
end

function GameMap:pointToTileCoord(pos)
	local x=pos.x/self.tileSize.width
	local y=self.mapSize.height-1-pos.y/self.tileSize.height
	--[a? b:c] is [a and b or c]
	x=x-math.floor(x)>=0.5 and math.ceil(x) or math.floor(x)
    y=y-math.floor(y)>=0.5  and math.ceil(y) or math.floor(y)
	local p=cc.p(x,y)
	return p
end

function GameMap:tileCoordToPoint(tileCoord)
    local x=tileCoord.x*self.tileSize.width
    local y=(self.mapSize.height-1-tileCoord.y)*self.tileSize.height
    local p=cc.p(x,y)
	return p
end

function GameMap:launchEnemyInMap()
    cclog("enemy count:%d",#self.enemyList)
    for k,v in ipairs(self.enemyList) do
        cclog("pos:%d,%d",v.position.x,v.position.y)
        v:setPosition(v.position)
        self:addChild(v,7)
    end
end

function GameMap:isMarioEatMushroom(tileCoord)
	if self.mushSprite==nil then
	   return false
	end
	if tileCoord.x==self.mushTileCoord.x and tileCoord.y==self.mushTileCoord.y then
	   self.mushSprite:removeFromParent(true)
	   self.mushTileCoord=cc.p(0,0)
	   self.mushSprite=nil
	else
	   return false
	end
end

function GameMap:breakBrick(tileCoord,bodyType)
    local gId=self.brickLayer:getTileGIDAt(tileCoord)
    local pd=self:getPropertiesForGID(gId)
    if pd~=nil then
        cclog("pd:%s,%d",type(pd),pd)
        --TODO 该方法待改善，getPropertiesForGID返回的是整形，91,601是Tiled软件给出的砖块类型数值
        if pd==601 then
            if not self:itemInList(self.itemCoordList,tileCoord) then
                self.itemCoordList[#self.itemCoordList+1]=tileCoord
                if self:itemInList(self.mushroomCoordList,tileCoord) then
                    self.resetCoinPoint=tileCoord
                    self:resetCoinBrick()
                    self:showNewMushroom(tileCoord,bodyType)
                    self:removeItem(self.mushroomCoordList,tileCoord)
                end
            else
                cc.SimpleAudioEngine:getInstance():playEffect(music_dingyikuaizhuan)
            end
        elseif pd==91 then--普通砖块
            if bodyType==MarioBodyState.NORMAL then
                self:showBrickBroken(tileCoord)
                self.brickLayer:removeTileAt(tileCoord)
            else
                self:showBrickJump(tileCoord)
                cc.SimpleAudioEngine:getInstance():playEffect(music_dingyikuaizhuan)
            end
        else
        end
    end
end

function GameMap:showBrickBroken(tileCoord)
    cc.SimpleAudioEngine:getInstance():playEffect(music_dingpozhuan)
	local pos=self:tileCoordToPoint(tileCoord)
	pos=cc.pAdd(pos,cc.p(self.tileSize.width/2,self.tileSize.height/2))
	local frame=cc.SpriteFrame:create(pic_single_block,cc.rect(0,0,8,8))
	local sps={}
    for i=0,4 do
        local sp=cc.Sprite:createWithSpriteFrame(frame)
        sp:setPosition(pos)
        self.spList[#self.spList+1]=sp
        sps[#sps+1]=sp
        self:addChild(sp)
    end
    local tileSZ=self.tileSize
    local leftUp=cc.JumpBy:create(0.2,cc.p(tileSZ.width*2,tileSZ.height),10,1)
    local rightUp=cc.JumpBy:create(0.2,cc.p(tileSZ.width*2,tileSZ.height),10,1)
    local leftDown=cc.JumpBy:create(0.2,cc.p(tileSZ.width*3,tileSZ.height),5,1)
    local rightDown=cc.JumpBy:create(0.2,cc.p(tileSZ.width*3,tileSZ.height),5,1)
    
    local function clearSpriteArray()
        for i=1,#self.spList do
            self.spList[i]:removeFromParent(true)
        end
    end
    
    sps[1]:runAction(leftUp)
    sps[2]:runAction(rightUp)
    sps[3]:runAction(leftDown)
    sps[4]:runAction(cc.Sequence:create(rightDown,cc.CallFunc:create(clearSpriteArray)))

end

function GameMap:showBrickJump(tileCoord)
    local sp=self.brickLayer:getTileAt(tileCoord)
    local jumBy=cc.JumpBy:create(0.2,cc.p(0,0),self.tileSize.height*0.5,1)
    sp:runAction(jumBy)
    
end

function GameMap:showNewMushroom(tileCoord,bodyType)
	cc.SimpleAudioEngine:getInstance():playEffect(music_dingchumoguhuohua)
	self.mushTileCoord=cc.p(tileCoord.x,tileCoord.y-1)
	local pos=self:tileCoordToPoint(self.mushTileCoord)
	pos=cc.pAdd(pos,cc.p(self.tileSize.width/2,self.tileSize.height/2))
	if bodyType==MarioBodyState.SMALL then
	   self.mushSprite=cc.Sprite:create(pic_rewardMushroom,cc.rect(0,0,16,16))
	elseif MarioBodyState.NORMAL==bodyType then
	   self.mushSprite=cc.Sprite:create(pic_toolMushroom,cc.rect(0,0,18,18))
	else
	end
	self.mushSprite:setPosition(pos)
    self:addChild(self.mushSprite)
	--local mushMove=cc.MoveBy:create(0.4,cc.p(0,self.tileSize.height))
	--self.mushSprite:runAction(mushMove)

end

function GameMap:itemInList(list,tileCoord)
    for i=1,#list do
        local coord=list[i]
        if coord.x==tileCoord.x and coord.y==tileCoord.y then
            return true
        end
    end	
    return false
end

function GameMap:removeItem(list,tileCoord)
	for i=1,#list do
	   local coord=list[i]
        if coord.x==tileCoord.x and coord.y==tileCoord.y then
            list[i]=nil
            break
        end 
	end
end

function GameMap:resetCoinBrick()
	local sp=self.brickLayer:getTileAt(self.resetCoinPoint)
    sp:setSpriteFrame(self.brokenCoin)
end

return GameMap