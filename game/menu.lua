local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )
-- Set physics
local physics = require("physics")
physics.start()
----------------------------------------------------------
W = display.contentWidth  
H = display.contentHeight 

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
local bgAmanhecer
local bgManha
local bgMeioDia
local bgEntardecer
local bgAnoitecer
local bgNoite
local bgChange

local retangle
local trapeze
local parallelogram

local title
local title1
local start

local btnStart
local opt

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------

----------------------------------------------------------
local obstacleTable = {}
local pausarObstaculo = false
local hora = 0
----------------------------------------------------------
local function changeBackground()
    hora = hora + 1

    if( hora == 1 ) then

        bgAmanhecer.alpha  = 1
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0    

    elseif( hora == 2 ) then -- manhã
        bgAmanhecer.alpha  = 0 
        bgManha.alpha      = 1
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0 
    elseif( hora == 3 ) then -- meio dia
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 1
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha = 0 
    elseif( hora == 4 ) then -- entardecer
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 1
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 0 
    elseif( hora == 5 ) then -- anoitecer
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 1
        bgNoite.alpha      = 0 
    elseif( hora == 6 ) then -- noite
        bgAmanhecer.alpha  = 0
        bgManha.alpha      = 0
        bgMeioDia.alpha    = 0
        bgEntardecer.alpha = 0
        bgAnoitecer.alpha  = 0
        bgNoite.alpha      = 1

        hora = 0
    end

end

local function createObstacle()
    local whereFrom = math.random( 3 )

    if( whereFrom == 1 ) then 
        retangle = display.newImageRect("images/obstaculo-5.png", 45, 95 )
        physics.addBody( retangle, "dynamic", { isSensor = true } )
        retangle.gravityScale = 0
        retangle.myName = "obstacle"

        retangle.x = W+100
        retangle.y = H-70
        retangle:setLinearVelocity( -100, 0 )

        sceneGroup:insert(retangle)
        obstacleTable[#obstacleTable+1] = retangle

    elseif( whereFrom == 2 ) then
        trapeze = display.newImageRect( "images/obstaculo-4.png", 60, 40 )
        physics.addBody( trapeze, "dynamic", { isSensor = true } )
        trapeze.gravityScale = 0
        trapeze.myName = "obstacle"

        trapeze.x = W+100
        trapeze.y = H-150
        trapeze:setLinearVelocity( -150, 0 )

        sceneGroup:insert(trapeze)
        obstacleTable[#obstacleTable+1] = trapeze

    elseif( whereFrom == 3 ) then
        parallelogram = display.newImageRect( "images/obstaculo-3.png", 50, 80 )
        physics.addBody( parallelogram, "dynamic", { radius = 25, isSensor = true } )
        parallelogram.gravityScale = 0
        parallelogram.myName = "obstacle"

        parallelogram.x = W+100
        parallelogram.y = H-250
        parallelogram:setLinearVelocity( -200, 0 )

        sceneGroup:insert(parallelogram)
        obstacleTable[#obstacleTable+1] = parallelogram

    end
end

local function gameLoop()

    createObstacle()

    -- Remove obstacles
    if( #obstacleTable ~= 0 ) then
        for i = #obstacleTable, 1, -1  do
            local thisObstacle = obstacleTable[i]

            if ( ( thisObstacle.x < -100 ) or ( thisObstacle.x > W + 100 ) )
            then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
                print("removeu obstaculo")
            end
        end
    end

end

--                      COMPOSER                        --
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
--                      COMPOSER                        --


composer.recycleOnSceneChange = true;
function scene:create( event )
    sceneGroup = self.view

        ----------------------------
        -------- BACKGROUND --------
        bgAmanhecer = display.newImageRect("images/background/amanhecer.png", 600, 380)
        bgAmanhecer.x = X
        bgAmanhecer.y = Y
        bgAmanhecer.alpha = 1

        bgManha = display.newImageRect("images/background/manha.png", 600, 380)
        bgManha.x = X
        bgManha.y = Y
        bgManha.alpha = 0

        bgMeioDia = display.newImageRect("images/background/meio-dia.png", 600, 380)
        bgMeioDia.x = X
        bgMeioDia.y = Y
        bgMeioDia.alpha = 0

        bgEntardecer = display.newImageRect("images/background/entardecer.png", 600, 380)
        bgEntardecer.x = X
        bgEntardecer.y = Y
        bgEntardecer.alpha = 0

        bgAnoitecer = display.newImageRect("images/background/anoitecer.png", 600, 380)
        bgAnoitecer.x = X
        bgAnoitecer.y = Y
        bgAnoitecer.alpha = 0

        bgNoite = display.newImageRect("images/background/noite.png", 600, 380)
        bgNoite.x = X
        bgNoite.y = Y
        bgNoite.alpha = 0

        -------------------------------
        -------- SKY AND FLOOR --------
        floor = display.newRect( 130, 299, 1000, 10 )
        floor:setFillColor( 1 )
        floor.alpha = 0
        floor.name = "Floor"
        physics.addBody( floor, "static" )
        
        sky = display.newRect( 130, 1, 1000, 10 )
        sky:setFillColor( 0.7 )
        sky.alpha = 0
        sky.name = "Sky"
        physics.addBody( sky, "static" )

        btnStart = display.newRect( 240, 260, 110, 30 )
        btnStart:setFillColor( 0.5, 1, 1 )
        btnStart.alpha = 0.01
        physics.addBody( btnStart, "static" )
        -----------------------
        -------- TITLE --------
        title = display.newImageRect("images/run.png", 100, 40)
        title.x = X
        title.y = Y-80
        title.alpha = 1
        physics.addBody( title, "static", { isSensor = false } )
        title:toFront()

        title1 = display.newImageRect("images/square-title.png", 250, 70)
        title1.x = X
        title1.y = Y-20
        title1.alpha = 1
        physics.addBody( title1, "static", { isSensor = false } )
        title1:toFront()

        ----------------------------------
        -------- START AND OPTION --------
        start = display.newImageRect("images/start.png", 100, 20)
        start.x = X
        start.y = Y+100
        start.alpha = 1
        physics.addBody( start, "static", { isSensor = false } )
        start:toFront()

        opt = display.newImageRect("images/option.png", 30, 30)
        opt.x = X+260
        opt.y = Y-135
        opt.alpha = 1
        physics.addBody( opt, "static", { isSensor = false } )
        opt:toFront()

        ------------------------
        -------- INSERT --------
        sceneGroup:insert(bgAmanhecer)
        sceneGroup:insert(bgManha)
        sceneGroup:insert(bgMeioDia)
        sceneGroup:insert(bgEntardecer)
        sceneGroup:insert(bgAnoitecer)
        sceneGroup:insert(bgNoite)

        sceneGroup:insert(title)
        sceneGroup:insert(title1)
        sceneGroup:insert(start)
        sceneGroup:insert(opt)

        sceneGroup:insert(sky)
        sceneGroup:insert(floor)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
        bgChange = timer.performWithDelay( 350, changeBackground, -1 )
        gameLoopTimer = timer.performWithDelay( 2000, gameLoop, -1 )

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --audio.play( musicGame )
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
     
  
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
      
    end
end

function scene:destroy( event )
  
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
  
end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene