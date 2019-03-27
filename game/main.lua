local composer = require( "composer" )

-- Set physics
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")
 
local scene = composer.newScene()

math.randomseed( os.time() )

local meters = 0
local metersText
local metersLoop

local score = 0
local scoreText
local scoreLoop

local cloundScene
local grassScene
local backgroundScene

local level = 1
local velocityLevel = level*0.5
local updateLevel

local life = 4
local cont = 0

local extraPointTable = {}
local obstacleTable = {}
local scenesTable = {}

-- Background day
local background1 = display.newImageRect("images/background/amanhecer.png", 600, 380)
background1.x = display.contentCenterX
background1.y = display.contentCenterY

-- Meters bar
local uiGroup = display.newGroup()
metersText = display.newText( uiGroup, meters, 0, 20, native.systemFont, 20 )
metersText:setFillColor( 0.2, 0.6, 0.9 )

scoreText = display.newText( uiGroup, score, 0, 40, native.systemFont, 20 )
scoreText:setFillColor( 0 )

display.setStatusBar( display.HiddenStatusBar )

-- Set floor and sky limit
local floor = display.newRect( 130, 290, 1000, 10 )
floor:setFillColor( 1 )
floor.alpha = 0
floor.name = "Floor"
physics.addBody( floor, "static" )

local sky = display.newRect( 130, 1, 1000, 10 )
sky:setFillColor( 0.7 )
sky.alpha = 0
sky.name = "Sky"
physics.addBody( sky, "static" )

-- Show the square
local square = display.newImageRect("images/square/full-life.png", 30, 30)
square.x = display.contentCenterX-200
square.y = display.contentCenterY+100
square.myName = "square"
physics.addBody( square, "dynamic", { bounce= 0 } )

--------------- Functions ---------------
local function pushSquare()
    square:applyLinearImpulse( 0, -0.05, square.x, square.y )
end
background1:addEventListener( "tap", pushSquare )

---- Background movimentation 
local function cloudMoviment()

    local nuvem = display.newImageRect("images/nuvem.png", 95, 55 )
    physics.addBody( nuvem, "dynamic", { bounce = 0, isSensor = true } )
    nuvem.gravityScale = 0
    nuvem.myName = "nuvem"
    nuvem.x = display.contentWidth+100
    nuvem.y = display.contentHeight-math.random(150, 250)
    nuvem.alpha = 0.5
    nuvem:setLinearVelocity( -100, 0 )

    scenesTable[#scenesTable+1] = nuvem

end

local function grassMoviment()

    local grass = display.newImageRect("images/grass-test.png", 75, 15 )
    physics.addBody( grass, "dynamic", { bounce = 0, isSensor = true } )
    grass.gravityScale = 0
    grass.myName = "nuvem"
    grass.x = display.contentWidth+100
    grass.y = 282
    grass.alpha = 0.3
    grass:setLinearVelocity( -100, 0 )

    scenesTable[#scenesTable+1] = grass

end

local function changeBackground()

    background1.alpha = 0
    cont = cont + 1
    if( cont == 1 ) then
        local background = display.newImageRect("images/background/amanhecer.png", 600, 380)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

    elseif( cont == 2 ) then
        local background = display.newImageRect("images/background/manha.png", 600, 380)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

    elseif( cont == 3 ) then
        local background = display.newImageRect("images/background/meio-dia.png", 600, 380)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

    elseif( cont == 4 ) then
        local background = display.newImageRect("images/background/entardecer.png", 600, 380)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

    elseif( cont == 5 ) then
        local background = display.newImageRect("images/background/noite.png", 600, 380)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        cont = 0
    end

end

--backgroundScene = timer.performWithDelay( 500, changeBackground, -1 )

local function updateVelocity()
    level = level + 1 
    velocityLevel = level*0.5
end

---- Create obstacles
local function createObstacles()

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- Retangle
        local newObstacle = display.newImageRect("images/obstaculo-1.png", 45, 95 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0, isSensor = false } )
        newObstacle.gravityScale = 10
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-50
        newObstacle:setLinearVelocity( -300*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 2 ) then
        -- Pentagon
        local newObstacle = display.newImageRect( "images/obstaculo-2.png", 40, 40 )
        physics.addBody( newObstacle, "dynamic", { bounce = 0, isSensor = true } )
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-150
        newObstacle:setLinearVelocity( -300*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    elseif( whereFrom == 3 ) then
        -- Parallelogram
        local newObstacle = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( newObstacle, "dynamic", { radius = 25, bounce = 0, isSensor = true } )
        newObstacle.gravityScale = 0
        newObstacle.myName = "obstacle"
        newObstacle.x = display.contentWidth+100
        newObstacle.y = display.contentHeight-250
        newObstacle:setLinearVelocity( -300*velocityLevel, 0 )

        obstacleTable[#obstacleTable+1] = newObstacle

    end
 
end

---- Extra Points
local function extraPoint()

    local whereFrom = math.random( 2 )
    whereFrom = 1
    local extra

    if ( whereFrom == 1 ) then
        -- square
        extra = display.newImageRect("images/square/1-life.png", 40, 40 )
        physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
        extra.gravityScale = 0
        extra.myName = "extra"
        extra.x = display.contentWidth+100
        extra.y = display.contentHeight-math.random( 50, 200 )
        extra:setLinearVelocity( -80*velocityLevel, 0 )

        extraPointTable[#extraPointTable+1] = extra
    end
    -- elseif( whereFrom == 2 ) then
    --     -- Circle
    --     extra = display.newImageRect( "images/pontos-extras-2.png", 40, 40 )
    --     physics.addBody( extra, "dynamic", { bounce = 0, isSensor = true } )
    --     extra.gravityScale = 0
    --     extra.myName = "extra"
    --     extra.x = display.contentWidth+100
    --     extra.y = display.contentHeight-math.random( 100, 200 )
    --     extra:setLinearVelocity( -100*velocityLevel, -10 )

    --     extraPointTable[#extraPointTable+1] = extra
    -- end

end

---- Game looping
local function updateDistance()
    meters = meters + 1
    metersText.text = meters .. " m"  
end

local function gameLoop()

    createObstacles()

    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( thisObstacle.x < -100 or thisObstacle.x > display.contentWidth + 100 )
            then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
            end
        end
    end

    if( #extraPointTable ~= 0 ) then
        for i = #extraPointTable, 1, -1  do
            local thisExtraPoint = extraPointTable[i]

            if ( thisExtraPoint.x < -100 or thisExtraPoint.x > display.contentWidth + 100 )
            then
                display.remove( thisExtraPoint )
                table.remove( extraPointTable, i )
            end
        end
    end

    if( #scenesTable ~= 0 ) then
        for i = #scenesTable, 1, -1  do
            local thisScenes = scenesTable[i]

            if ( thisScenes.x < -100 or thisScenes.x > display.contentWidth + 100 )
            then
                display.remove( thisScenes )
                table.remove( scenesTable, i )
                thisScenes:toFront()
            end
        end
    end

    return true
end

--- Looping
-- Scenes
cloundScene = timer.performWithDelay( 500, grassMoviment, 0 )
grassScene = timer.performWithDelay( 3000, cloudMoviment, 0 )
-- Game
metersLoop = timer.performWithDelay( 500/velocityLevel, updateDistance, -1 )
scoreLoop = timer.performWithDelay( 50000*velocityLevel, extraPoint, 0 )
updateLevel = timer.performWithDelay( 50000, updateVelocity, -1 )
gameLoopTimer = timer.performWithDelay( 5000-(500/velocityLevel), gameLoop, 0 )

local function showLife()

    if( life == 3 ) then
        square = display.newImageRect("images/3-life.png", 30, 30)
        square.x = display.contentCenterX-200
        square.y = display.contentCenterY+100
        square.myName = "square"
        physics.addBody( square, "dynamic", { bounce= 0 } )
    end

end

local function onCollision( event )
 
    local obj1 = event.object1
    local obj2 = event.object2

    if ( ( obj1.myName == "square" and obj2.myName == "extra" ) or 
         ( obj1.myName == "extra" and obj2.myName == "square" ) ) then

        --
        display.remove(obj2)

        for i = #extraPointTable, 1, -1 do
            if ( extraPointTable[i] == obj1 or extraPointTable[i] == obj2 ) then
                table.remove( extraPointTable, i )
                print(#extraPointTable .. "removeu")
                break
            end
        end

        score = score + 1
        scoreText.text = score

    end

    if ( ( obj1.myName == "square" and obj2.myName == "obstacle" ) or 
         ( obj1.myName == "obstacle" and obj2.myName == "square" ) ) then

        life = life - 1

        display.remove(obj1)
        display.remove(obj2)
                    
        --
        timer.cancel(metersLoop)
        timer.cancel(scoreLoop)
        timer.cancel(updateLevel)
        timer.cancel(cloundScene)
        timer.cancel(grassScene)
        timer.cancel(gameLoopTimer)
        --

        local text = display.newText("Distância: " .. meters .. " m", display.contentCenterX, 150, native.systemFont, 25)
        local text2 = display.newText("Scores: " .. score, display.contentCenterX, 100, native.systemFont, 30)
        text2:setFillColor( 0.2, 0.6, 0.9 )
        text:setFillColor( 0 )

    end
    --
end

Runtime:addEventListener( "collision", onCollision )