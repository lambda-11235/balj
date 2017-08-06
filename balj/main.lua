

function love.load(args)
  require "load_level"


  ball_force = 400
  block_width = 50
  ball_radius = block_width/3
  lost = false
  won = false
  start_time = love.timer.getTime()
  time = 0


  update_dimensions()
  love.graphics.setFont(love.graphics.newFont("fonts/DejaVuSans.ttf", 50))


  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)


  objects = {}

  objects.blocks = {}
  init_level(load_level(args[2]))

  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, init_posx, init_posy, "dynamic")
  objects.ball.shape = love.physics.newCircleShape(ball_radius)
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
  objects.ball.fixture:setRestitution(0.9)
  objects.ball.fixture:setUserData("ball")
end


function love.update(dt)
  update_dimensions()

  if not lost and not won then
    world:update(dt)
    time = love.timer.getTime() - start_time
  end

  if love.keyboard.isDown("escape") or love.keyboard.isDown("q") then
    love.event.quit()
  end

  local left = love.keyboard.isDown("left")
  local right = love.keyboard.isDown("right")
  local down = love.keyboard.isDown("down")
  local up = love.keyboard.isDown("up")

  if left then
    objects.ball.body:applyForce(-ball_force, 0)
  end

  if right then
    objects.ball.body:applyForce(ball_force, 0)
  end

  if up then
    local _, g = world:getGravity()
    local weight = objects.ball.body:getMass() * g
    objects.ball.body:applyForce(0, -weight)
  end

  if down then
    objects.ball.body:applyForce(0, ball_force)
  end

  if love.keyboard.isDown("backspace") then
    objects.ball.body:setPosition(init_posx, init_posy)
    objects.ball.body:setLinearVelocity(0, 0)

    lost = false
    won = false

    start_time = love.timer.getTime()
  end
end


function love.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", width/2.0, height/2.0, objects.ball.shape:getRadius())

  -- TODO: Figure out a better way to draw relative to ball.
  for _, block in pairs(objects.blocks) do
    local x = block.body:getX() - objects.ball.body:getX() - block_width/2 + width/2
    local y = block.body:getY() - objects.ball.body:getY() - block_width/2 + height/2

    if block.fixture:getUserData() == "regular" then
      love.graphics.setColor(0, 0, 255)
    elseif block.fixture:getUserData() == "death" then
      love.graphics.setColor(255, 0, 0)
    elseif block.fixture:getUserData() == "goal" then
      love.graphics.setColor(0, 255, 0)
    end

    love.graphics.rectangle("fill", x, y, block_width, block_width)
  end

  if lost then
    love.graphics.setColor(255, 100, 100)
    center_print('You Lost!', width/2, height/2)
  elseif won then
    love.graphics.setColor(100, 255, 100)
    center_print('You Won!', width/2, height/2)
  end

  local minutes, seconds = math.floor(time/60), time%60
  local time_str = string.format("%02d:%05.2f", minutes, seconds)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(time_str, 0, 0)
end


function center_print(s, x, y)
  love.graphics.print(s, x - love.graphics.getFont():getWidth(s)/2,
                         y - love.graphics.getFont():getHeight(s)/2)
end


function update_dimensions()
  width, height, _ = love.window.getMode()
end


function init_level(lvl)
  for i, bs in pairs(lvl) do
    for j, block_type in pairs(bs) do
      if block_type == 1 then
        init_posx, init_posy = from_lvl_pos(j, i)
      elseif block_type == 2 or block_type == 3 or block_type == 4 then
        local new_block = {}
        local x, y = from_lvl_pos(j, i)
        new_block.body = love.physics.newBody(world, x, y)
        new_block.shape = love.physics.newRectangleShape(block_width, block_width)
        new_block.fixture = love.physics.newFixture(new_block.body, new_block.shape);

        if block_type == 2 then
          new_block.fixture:setUserData("regular")
        elseif block_type == 3 then
          new_block.fixture:setUserData("death")
        elseif block_type == 4 then
          new_block.fixture:setUserData("goal")
        end

        table.insert(objects.blocks, new_block)
      end
    end
  end
end


function from_lvl_pos(x, y)
  local nx = x * block_width - block_width/2.0
  local ny = y * block_width - block_width/2.0
  return nx, ny
end


function beginContact(a, b, coll)
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
  local block_fixture

  if a:getUserData() == "ball" then
    block_fixture = b
  else
    block_fixture = a
  end

  if block_fixture:getUserData() == "death" then
    lost = true
  elseif block_fixture:getUserData() == "goal" then
    won = true
  end
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end
