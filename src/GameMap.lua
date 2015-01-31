local GameMap=class("GameMap",function (tmxFile)
    return cc.TMXTiledMap:create(tmxFile)
end)

GameMap.tileSize=nil
GameMap.mapSize=nil
GameMap.cloudLayer=nil
GameMap.blockLayer=nil
GameMap.pipeLayer=nil
GameMap.landLayer=nil
GameMap.trapLayer=nil
GameMap.objectLayer=nil
GameMap.coinLayer=nil
GameMap.flagpoleLayer=nil
GameMap.enemyList={}
GameMap.birthPos=nil


function GameMap.create(tmxFile)
    local gameMap=GameMap.new(tmxFile)
    gameMap:extraInit()
    return gameMap
end

function GameMap:extraInit()
    self.tileSize=self:getTileSize()
    self.mapSize=self:getMapSize()
    cclog("tile:%d,%d,map:%d,%d",self.tileSize.width,self.tileSize.height,self.mapSize.width,self.mapSize.height)

    --just for easy coding -.-||
    --map=cc.TMXTiledMap:new()
    self.cloudLayer=self:getLayer("cloud")
    self.blockLayer=self:getLayer("block")
    self.pipeLayer=self:getLayer("pipe")
    self.landLayer=self:getLayer("land")
    self.trapLayer=self:getLayer("trap")
    self.objectLayer=self:getObjectGroup("objects")
    self.coinLayer=self:getLayer("coin")
    self.flagpoleLayer=self:getLayer("flagpole")
    cclog("%s,%s,%s,%s",type(self.cloudLayer),type(self.blockLayer),type(self.pipeLayer),type(self.landLayer))
    cclog("%s,%s,%s,%s",type(self.trapLayer),type(self.objectLayer),type(self.coinLayer),type(self.flagpoleLayer))
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
        else
        end
    end--end for
    self:launchEnemyInMap()
end

function GameMap:pointToTileCoord(pos)
	local x=pos.x/self.tileSize.width
	local y=self.mapSize.height-1-pos.y/self.tileSize.height
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

return GameMap