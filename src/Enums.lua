--Mario or ENEMY Direction
MarioState={}
MarioState.LEFT=1--向左运动
MarioState.RIGHT=2--向右运动
MarioState.JUMP_LEFT=3--向左跳跃
MarioState.JUMP_RIGHT=4--向右跳跃
MarioState.NORMAL_LEFT=5--面朝左静止
MarioState.NORMAL_RIGHT=6--面朝右静止
MarioState.FIRE=7--发射子弹

MarioBodyState={}
--Mario Body Type
MarioBodyState.NORMAL=1
MarioBodyState.SMALL=2
MarioBodyState.FIREABLE=3

--Animation type
AnimType={}
AnimType.LEFT=1
AnimType.RIGHT=2
AnimType.SMALL_LEFT=1
AnimType.SMALL_RIGHT=2

--Tile Type
TileType={}
TileType.LAND=1
TileType.BRICK=2
TileType.TRAP=3
TileType.PIPE=4
TileType.COIN=5
TileType.NONEH=6
TileType.NONEV=7
TileType.FLAGPOLE=8

--Enemy STATE
E_STATE_ACTIVE=1
E_STATE_NONACTIVE=2
E_STATE_OVER=3