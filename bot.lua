-- for ao-effect quest3
LatestGameState = LatestGameState or nil
InAction = InAction or false 
Paying = Paying or false

LockingTarget = LockingTarget or nil

Game = Game or "y2SumslSgziUYIUYYlGXAXPcxLXexIkbaxxsNa9_VXg"
CRED = CRED or "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc"

DirectionMap = {"Up", "Down", "Left", "Right", "UpRight", "UpLeft", "DownRight", "DownLeft"}

targetBotsArr = {
    "mKdpg-ehoQBgI-U7xkEU3Op2gx_VQZgbfkinIYYTeGI",
    "o7ojWM_2GCpjEq9LbQpNt98rK0yYR5sttDbXn_m7jgA",
    "ET1HkDJVwGp9nDDyAeDkCOm7nU4ymi4vkmLS3rdSsXo",
    "30mgE3JEqs8AugY6pvU7rULhH6tlG4O3vVaTpkq475o",
    "fBxEuKHCJ9BWy9dcuJfXjkSFQa3JzRozZwLQgCzFkuw",
    "DdHbetrd4MDVpR9PhfGrp8c0ODaIVcWNWe208CrOtSY",
    "LQi8j9zpZbMn4uAsRFttn1Wt282yKiLFHd5fbluW7bk",
    "PWu5xrOORfcbVPkCXpOlMuvsXuKUoFhChmrBLcS2t5g",
    "M_AiUdJeKFhnOz8HeiUQXcr8NNX-2oHYhSeReuWe_14",
    "xLZ0l0HbAFaxq5n-sSmKZhcFGPvDe1weSYr1vTF6EnY",
    "6-m4zbMA9VLLpXo6xqq2UCydNPtFiSnHHDfWBbPOQHo",
    "M8dBmtGdsa83UQ8npuqdBl0XJwmk6hmPq9JiuPA1kK4",
    "a5Qvu1O66ItP55kNWfm_EhNAUXPYGZkLCKkB7zCGvXE",
    "4NFvD-hvpyOr4IzRlDYyBaqNQLJR7srtOJbUAkH8Gzc",
    "7TR6O945kNFwmtDpW3jlHVU7ZxxjScF2vAmuDdPLn5Q",
    "DoXjMdlQXjvf3UiGry5ggSTNt8elOpFEGoqJ4ioz-68",
    "EALJxoB5JI-7XfVg4Oi3dzgbGgpZIddBNVqEdx_ES34",
    "WfcLC-f72DfFQ-g3ueNzst4e_fB-5OIr8_8nXzLxRU4",
    "8DK4qfJ4ZclwSSdEcb8_IucH4pDZghrNd0btwZ1PvU4",
    "eHHCy8YcqnvsGjkvB72EzQnrlbEe4ETIForCDrkQGbg",
    "GJVGLcouQdkPqDYpS3p6LOUmy7YEfEddQ0U-9dbRih8",
    "uCiLRxpyklG7Dr9taYXcSdDpHepSp-FsA-_790ntuuY",
    "Umr_HFG5PB8rovJyTcLTGlVgRg0josFPGhwTzEf_cow",
    "OZl8GA2JbjNtt2P3l0-fv20TO0G-OPUuwPag-TcOssE",
    "EnuADvlYGmlCF9rokuBkhgTiFU13HiJj7qqNd2EZ_-A",
    "FPG8Cdbc7ppvhZUAQl6ZFlSkDPT__AajwDrbwVD1wYo",
    "aLfaX-zlUXPDObBuEu5vizlWMcOrNV1LNZK59bFq6eA",
    "711pp6is-DBvdicL62Kg7SzTLgaC0aVpP-nQz7AHKQE"
}
weakBot = weakBot or nil
botsInfo = botsInfo or {}

Colors = {
  red = "\27[31m",
  green = "\27[32m",
  blue = "\27[34m",
  reset = "\27[0m",
  gray = "\27[90m"
}

fight = false
-- 
function isInGame()
  for pid, player in pairs(LatestGameState.Players) do
    if pid == ao.id then
      return true
    end
  end
  return false
end

-- check inrange
function inRange(x1, y1, x2, y2, range)
  local rangeX, rangeY = 0, 0
  if math.abs(x1 - x2) > 20 then
    rangeX = 41 - math.abs(x1 - x2)
  else
    rangeX = math.abs(x1 - x2)
  end

  if math.abs(y1 - y2) > 20 then
    rangeY = 41 - math.abs(y1 - y2)
  else
    rangeY = math.abs(y1 - y2)
  end
  return rangeX <= range and rangeY <= range
end


-- Find the weakest target nearby  
function findTargetWeakBot()
    local heathValue = 100
    local energyValue = 100
    local weakPlayer = nil
    for pid, player in pairs(botsInfo) do
      if pid ~= ao.id and player.health < heathValue then
        heathValue = player.health
        energyValue = player.energy
        weakPlayer = pid
      elseif player.health == heathValue and player.energy < energyValue then
        weakPlayer = pid
      end
    end
    
    print(Colors.gray .. "findNearTargetWeakBot:" .. weakPlayer .. Colors.reset)
    weakBot = weakPlayer
  end

-- find the weakest bot from targetBotsArr
function findNearTargetWeakBot(me)
    local weakNearBot = nil
    for pid, player in pairs(botsInfo) do
      if pid ~= ao.id and player.health <= 50  then
        local x1, x2 = adjustPosition(me.x, player.x)
        local y1, y2 = adjustPosition(me.y, player.y)
        if inRange(x1, y1, x2, y2, 10) then
            weakNearBot = pid
          break
        end
      end
    end
    
    if weakNearBot then
      print(Colors.gray .. "weakNearBot:" .. weakNearBot .. Colors.reset)
    end
    weakBot = weakNearBot
  end

-- calculate the direction
function adjustPosition(n1, n2)
  if math.abs(n1 - n2) > 20 then
    if n1 < 20 and n2 >= 20 then
      n2 = n2 - 40
    end
    
    if n1 >= 20 and n2 < 20 then
      n1 = n1 - 40
    end
  end

  return n1, n2
end


local function getDirections(x1, y1, x2, y2, isAway)
  if isAway == nil then
    isAway = false
  end

  x1, x2 = adjustPosition(x1, x2)
  y1, y2 = adjustPosition(y1, y2)
--  print("x1: " .. x1 .. " y1:" .. y1 .. " x2: " .. x2 .. " y2: " .. y2)
  local dx, dy = x2 - x1, y2 - y1
  local dirX, dirY = "", ""
--  print("dx:" .. dx .. " dy:" .. dy)

  if isAway then
    if dx > 0 then dirX = "Left" else dirX = "Right" end
    if dy > 0 then dirY = "Up" else dirY = "Down" end
  else
    if dx > 0 then dirX = "Right" else dirX = "Left" end
    if dy > 0 then dirY = "Down" else dirY = "Up" end
  end
  
  print(dirY .. dirX)
  return dirY .. dirX
end


-- 
function isFight(me, player)
  if fight then
    return true
  end
  return player.health <= me.energy * 2/3 or me.health == 100
end



function moveToTarget(me, player)
  if not isFight(me, player) and inRange(me.x, me.y, player.x, player.y, 3) then
      runaway(me, player)
  elseif isFight(me, player) and inRange(me.x, me.y, player.x, player.y, 1) then
    local playerEnergy = LatestGameState.Players[ao.id].energy
    if playerEnergy == 0 then
      fight = false
    end
    print(Colors.red .. "Target in range, Attacking!" .. Colors.reset)
    ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(playerEnergy)})
  else
    local moveDir = getDirections(me.x, me.y, player.x, player.y, false)
    print(Colors.red .. "Approaching the enemy. Move " .. moveDir .. Colors.reset)
    ao.send({Target = Game, Action = "PlayerMove", Player = ao.id, Direction = moveDir})
  end
end

-- runaway from target
function runaway(me, player)
  local moveDir = getDirections(me.x, me.y, player.x, player.y, true)
  print(Colors.red .. "Runaway, Move " .. moveDir .. Colors.reset)
  ao.send({Target = Game, Action = "PlayerMove", Player = ao.id, Direction = moveDir})
end

-- attack
function attack() 
  local playerEnergy = LatestGameState.Players[ao.id].energy
  if playerEnergy == undefined then
    print(Colors.red .. "Attack-Failed. Unable to read energy." .. Colors.reset)
  elseif playerEnergy == 0 then
    fight = false
    print(Colors.red .. "Attack-Failed. Player has insufficient energy." .. Colors.reset)
  else
    ao.send({Target = Game, Action = "PlayerAttack", Player = ao.id, AttackEnergy = tostring(playerEnergy)})
    print(Colors.red .. "Attacked." .. Colors.reset)
  end
end

-- randomMove
function randomMove()
  print("Moving randomly.")
  local randomIndex = math.random(#DirectionMap)
  ao.send({Target = Game, Action = "PlayerMove", Player = ao.id, Direction = DirectionMap[randomIndex]})
end

-- mapping
function targetBotMaps()
  local cache = {}
  for target, state in pairs(LatestGameState.Players) do
      for i = 1, #targetBotsArr do
          if target == targetBotsArr[i] then 
              cache[target] = state
          end
      end
  end
  botsInfo = cache
end


--#region 
-- find the nearest targetBot from targetBotsArr then lockTarget and attack at the suitable time
--#endregion
function decideNextAction()
    local me = LatestGameState.Players[ao.id]
    if me.health < 10 then
        ao.send({Target = Game, Action = "Withdraw" })
        Paying = false
    end
    findNearTargetWeakBot(me)
    if weakBot == nil then
      findTargetWeakBot()
    end
    local player = botsInfo[weakBot]

    -- no targetPlayers
    if not player then
      ao.send({ Target = Game, Action = "Refresh"})
      return
    end

    if t and LatestGameState.Players[t] then
      print(Colors.gray .. "Target:" .. t .. Colors.reset)
      player = LatestGameState.Players[t]
    else
      t = nil
    end

    moveToTarget(me, player)

  InAction = false
  print("Player state: (health:" .. player.health .. ", energy:" .. player.energy .. ")")
  print("Player Position: (x:" .. player.x .. ", y:" .. player.y .. ")")
  print("You state: (health:" .. me.health .. ", energy:" .. me.energy .. ")")
  print("You Position: (x:" .. me.x .. ", y:" .. me.y .. ")")
end



Handlers.add(
  "HandlerPlaying",
  function (msg)
    if msg.Action == "Player-Moved" or msg.Action == "Successful-Hit" or msg.Action == "Refresh" then
      return true
    else 
      return false
    end
  end,
  function (msg)
    print(msg.Action .. " " .. msg.Data)
    print(Colors.blue .. "Getting game state...after Player-Action" .. Colors.reset)
    ao.send({Target = Game, Action = "GetGameState", Name = Name, Owner = Owner })
    InAction = true
  end
)

-- Withdraw auto pay
Handlers.add(
  "AutoPayAfterWithdraw",
  function (msg)
    if msg.Action == "Removed" then
      return true
    else
      return false
    end
  end,
  function (msg)
    if Paying then
      print("You have paid just now.")
    else
      Paying = true
      print(Colors.red .. "Withdraw CRED. Removed from the Game." .. Colors.reset)
      print("Auto-paying confirmation fees.")
      Send({Target = CRED, Action = "Transfer", Quantity = "1000", Recipient = Game})
    end
  end
)

-- Eliminated auto pay
Handlers.add(
  "AutoPayAfterEliminated",
  Handlers.utils.hasMatchingTag("Action", "Eliminated"),
  function ()
    print("After Eliminated. Auto-paying confirmation fees.")
    ao.send({Target = CRED, Action = "Transfer", Quantity = "1000", Recipient = Game})
    InAction = true
  end
)


Handlers.add(
  "AutoStart",
  Handlers.utils.hasMatchingTag("Action", "Payment-Received"),
  function (msg)
    print(Colors.gray .. "Auto start game...GetGameState... From AutoStart" .. Colors.reset)
    ao.send({Target = Game, Action = "GetGameState", Name = Name, Owner = Owner })
    InAction = true
  end
)

-- Announcement
Handlers.add(
  "PrintAnnouncements",
  Handlers.utils.hasMatchingTag("Action", "Announcement"),
  function (msg)
    if (msg.Event == "Tick" or msg.Event == "Started-Game" or msg.Event == "Cok") and not InAction then
      InAction = true
      ao.send({Target = Game, Action = "GetGameState", Name = Name, Owner = Owner })
    elseif msg.Event == "Attack" then
      print(Colors.red .. msg.Data .. Colors.reset)
      InAction = false
    elseif InAction then
      print(Colors.gray .. "Previous action still in progress. Skipping." .. Colors.reset)
    end
    print(Colors.green .. msg.Event .. ": " .. msg.Data .. Colors.reset)
  end
)

-- GameState
Handlers.add(
  "UpdateGameState",
  Handlers.utils.hasMatchingTag("Action", "GameState"),
  function (msg)
    local json = require("json")

    LatestGameState = json.decode(msg.Data)
    print("Game state updated. Print \'LatestGameState\' for detailed view.")

    targetBotMaps()
    print("Game state updates. Print \'botsInfo\' for targetBotsArr detailed view.")

    if LatestGameState.GameMode ~= "Playing" then
      InAction = false
      print("Not playing state.")
      return
    end

    if isInGame() then
      print(Colors.gray .. "Deciding next action." .. Colors.reset)
      decideNextAction()
    else
      print(Colors.red .. "You are not in game. auto pay now" ..Colors.reset)
      ao.send({Target = CRED, Action = "Transfer", Quantity = "1000", Recipient = Game})
    end
  end
)



Handlers.add(
  "ReturnCred",
  Handlers.utils.hasMatchingTag("Action", "Credit-Notice"),
  function (msg)
    print(Colors.blue .. "Credit Received. Auto Withdraw." .. Colors.reset)
    print(msg.Data)
    ao.send({Target = Game, Action = "Withdraw" })
    Paying = false
  end
)
-- ignore cron
Handlers.add('ignore-cron', 
  Handlers.utils.hasMatchingTag('Action', 'Cron'),
  function () return "" end
)
