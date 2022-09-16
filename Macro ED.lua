setDefaultTab("HP")

UI.Separator()

UI.Label("HEALT MANA/HP")

UI.Separator()

--[[Cura MANA com Pots e Runas]]

local manaId = 3162
local manaPercent = 80
macro(200, "faster mana runa/pot",  function()
  if (manapercent() <= manaPercent) then
    usewith(manaId, player) 
  end
end)

--[[Cura HP com Pots e Runas]]

local healthId = 3163
local healthPercent = 80
macro(200, "faster health runa/pot",  function()
  if (hppercent() <= healthPercent) then
    usewith(healthId, player) 
  end
end)

--[[Cura com feitiços:]]

local healingSpell = 'Exura Vita'
local hpPercent = 99
macro(50, "faster healing",  function()
  if (hppercent() <= hpPercent) then
    say(healingSpell) 
  end
end)

-- [[Configuração de Curar Status:]]

local PlayerStates = {
  None = 0, Poison = 1, Burn = 2, Energy = 4, Drunk = 8, ManaShield = 16,
  Paralyze = 32, Haste = 64, Swords = 128, Drowning = 256, Freezing = 512,
  Dazzled = 1024, Cursed = 2048, PartyBuff = 4096, PzBlock = 8192,
  Pz = 16384, Bleeding = 32768, Hungry = 65536
}

macro(4000, "Curar Status", function()
    if player:hasState(PlayerStates.Poison, player:getStates()) and
not g_game.isAttacking() then say("exana pox") end
    if player:hasState(PlayerStates.Burn, player:getStates()) and
not g_game.isAttacking() then say("exana flam") end
    if player:hasState(PlayerStates.Paralyze, player:getStates()) and
not g_game.isAttacking() then say("utani hur") end
end)
UI.Separator()

setDefaultTab("Main")

UI.Separator()

UI.Label("SEMPRE ATIVOS")

UI.Separator()

-- [[Configuração para Abrir Bp Principal:]]
macro(5000,"Abrir Main BP",function()
containers = getContainers()
if #containers < 1 and containers[0] == nil then
  local bpItem = getBack()
  if bpItem ~= nil then
    g_game.open(bpItem)
  end
end
end)

-- [[Configuração de Se mover:]]
macro(10000, "Anti Kick",  function()
  local dir = player:getDirection()
  turn((dir + 1) % 4)
  turn(dir)
end)

-- [[Configuração de comprar Epic Bless:]]
buybless = macro(5000,"Bless Automatico",function()
if isInPz() then say("!bless") end
    onTextMessage(function(mode, text)
        if string.find(text, "You already have bless.") then
            buybless.setOff(isOn)
        end
    end)
end)

macro(5000, function()
    if not isInPz() then
        buybless.setOn(isOff)
    end
end)

--[[Auto Utamo Vita]]

macro(100, "Utamo Vita",function()
if not hasManaShield() then
say("Utamo Vita") 
end
end)

-- [[ SEPARADOR ]]
UI.Separator()

UI.Label("MAGIAS")

UI.Separator()

--[[Auto UE Sem Parar  a cada 10s]]

macro(500, "UE Ativo", function()
say("exevo gran mas selva")
end)

--[[Lance feitiço aoe quando mais de X monstros na tela, senão use feitiço de alvo único: (há também uma versão em que ele não lança feitiços aoe se houver jogadores na tela, se alguém precisar)]]

local singleTargetSpell = 'exori frigo'
local multiTargetSpell = 'exevo gran mas selva'
local distance = 3
local amountOfMonsters = 1

macro(250, "UE Perferct",  function()
    local specAmount = 0
    if not g_game.isAttacking() then
        return
    end
    for i,mob in ipairs(getSpectators()) do
        if (getDistanceBetween(player:getPosition(), mob:getPosition())  <= distance and mob:isMonster())  then
            specAmount = specAmount + 1
        end
    end
    if (specAmount >= amountOfMonsters) then    
        say(multiTargetSpell)
    else
        say(singleTargetSpell)
    end
end)

--[[Feitiço multi-alvo com janela de texto para escolher feitiços]]

local distance = 4
local amountOfMonsters = 1
macro(1000, "UE Perferct 2",  function()
    local specAmount = 0
    if not g_game.isAttacking() then
        return
    end
    for i,mob in ipairs(getSpectators()) do
        if (getDistanceBetween(player:getPosition(), mob:getPosition())  <= distance and mob:isMonster())  then
            specAmount = specAmount + 1
        end
    end
    if (specAmount >= amountOfMonsters) then 
        say(storage.Spell2, 250)
    else
        say(storage.Spell1, 250)
    end
end)
addTextEdit("Spell1", storage.Spell1 or "Single target", function(widget, text) 
storage.Spell1 = text
end)
addTextEdit("Spell2", storage.Spell2 or "Multi target", function(widget, text) 
storage.Spell2 = text
end)

-- [[ SEPARADOR ]]
UI.Separator()

UI.Label("SUPORTE")

UI.Separator()

--[[
1. Inicie o script com seu ring normal ligado
2. certifique-se de que a mochila com ring-energe estão sempre abertos
]]

local energy_ring = 3051; -- Your energy ring
local energy_ring_equiped = 11805; -- Ring changes id when equiped
local original_ring = getFinger(); -- Your original ring
local healthp_for_energy = 50;
local healthp_for_original = 80;
local manap_for_original = 25;

macro(1000, "e-ring", function()
  if (manapercent() <= manap_for_original and getFinger():getId() ~= original_ring:getId()) then
    g_game.equipItem(original_ring);
  elseif (hppercent() <= healthp_for_energy and manapercent() >= manap_for_original and getFinger():getId() ~= energy_ring) then
      local ring = findItem(energy_ring);
      if (ring) then
          g_game.equipItem(ring);
      end
  elseif (hppercent() >= healthp_for_original and getFinger():getId() ~= original_ring:getId()) then
      g_game.equipItem(original_ring);
  end
end)

--[[Siga automaticamente um jogador com o nome X:]]


local playerToFollow = 'John Fargo'
macro(1000, "auto follow",  function()
    if g_game.isFollowing() then
        return
    end
    for _, followcreature in ipairs(g_map.getSpectators(pos(), false)) do
        if (followcreature:getName() == playerToFollow and getDistanceBetween(pos(), followcreature:getPosition()) <= 8) then
            g_game.follow(followcreature)
        end
    end
end)

--[[Lançar exura sio automaticamente em um amigo:]]

local friendName = "asd"
macro(100, "heal friend", function()
    local friend = getPlayerByName(friendName)
    if friend and friend:getHealthPercent() < 90 then
        say("exura sio \"" .. friendName)
        delay(1000)
    end
end)

--[[Auto SIO com textwindow para escolher feitiço para servidores personalizados]]

macro(100, "Sio", function()
    local friend = getPlayerByName(storage.friendName)
    local friend1 = getPlayerByName(storage.friend1Name)
    if friend and friend:getHealthPercent() < 80 then
        say("exura sio \""..storage.friendName)
        delay(500)
   elseif friend1 and friend1:getHealthPercent() <= 80 then -- If u need more you can copy this lines
        say("exura sio \""..storage.friend1Name) --
        delay(500) --
    end -- And paste them between this end and the delay
end)
  addTextEdit("friendName", storage.friendName or "Friend Name", function(widget, text) 
    storage.friendName = text
end)
addLabel("Priority 1 ^ Priority 2 v", "Priority 1 ^ Priority 2 v")
  addTextEdit("friend1Name", storage.friend1Name or "Friend Name", function(widget, text)   -- Also copy this lines
    storage.friend1Name = text -- If u add more just rename the Friend1Name to Friend2Name in the lines u paste

end)

-- Configuração de Usar UH: [[
macro(100, "UR/MR Amigo", nil, function()
  local healFriend = getCreatureByName(storage.uhFriend)
  if healFriend then
    local heal_player = healFriend:getName();
    if (heal_player == storage.uhFriend) then
      if (healFriend:getHealthPercent() < tonumber(storage.uhFriendPercent)) then
        useWith(3163, healFriend);
      end
    end
  end
end)
addLabel("uhname", "Nome dos Players:", warTab)
addTextEdit("uhfriend", storage.uhFriend or "", function(widget, text)   
  storage.uhFriend = text
end)
addLabel("uhpercent", "Abaixo de %:", warTab)
addTextEdit("uhfriendpercent", storage.uhFriendPercent or "", function(widget, text)   
  storage.uhFriendPercent = text
end)


-- [[Configuração do Auto Follow:]]
local followThis = tostring(storage.followLeader)

FloorChangers = {
    Ladders = {
        Up = {1948, 5542, 16693, 16692},
        Down = {432, 412, 469, 1949, 469}
    },

    Holes = {
        Up = {},
        Down = {293, 294, 595, 4728, 385, 9853}
    },

    RopeSpots = {
        Up = {386,},
        Down = {}
    },

    Stairs = {
        Up = {16690, 1958, 7548, 7544, 1952, 1950, 1947, 7542, 855, 856, 1978, 1977, 6911, 6915, 1954, 5259, 20492, 1956, 1957, 1955, 5257, 8657, 5070, 1723, 8647},
        Down = {482, 414, 413, 437, 7731, 469, 413, 434, 469, 859, 438, 6127, 566, 7476, 4826, 8932}
    },

    Sewers = {
        Up = {},
        Down = {435}
    },
}

local target = followThis
local lastKnownPosition

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(300, 700))
        end
    end
end

local function handleUse(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(400, 800))
        end
    end
end

local function handleStep(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        autoWalk(pos)
        delay(math.random(400, 800))
    end
end

local function handleRope(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            useWith(3003, newTile:getTopUseThing())
            delay(math.random(400, 800))
        end
    end
end

local floorChangeSelector = {
    Ladders = {Up = handleUse, Down = handleStep},
    Holes = {Up = handleStep, Down = handleStep},
    RopeSpots = {Up = handleRope, Down = handleRope},
    Stairs = {Up = handleStep, Down = handleStep},
    Sewers = {Up = handleUse, Down = handleUse},
}

local function checkTargetPos()
    local c = getCreatureByName(target)
    if c and c:getPosition().z == posz() then
        lastKnownPosition = c:getPosition()
    end
end

local function distance(pos1, pos2)
    local pos2 = pos2 or lastKnownPosition or pos()
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function executeClosest(possibilities)
    local closest
    local closestDistance = 99999
    for _, data in ipairs(possibilities) do
        local dist = distance(data.pos)
        if dist < closestDistance then
            closest = data
            closestDistance = dist
        end
    end

    if closest then
        closest.changer(closest.pos)
    end
end

local function handleFloorChange()
    local c = getCreatureByName(target)
    local range = 4
    local p = pos()
    local possibleChangers = {}
    for _, dir in ipairs({"Down", "Up"}) do
        for changer, data in pairs(FloorChangers) do
            for x = -range, range do
                for y = -range, range do
                    local tile = g_map.getTile({x = p.x + x, y = p.y + y, z = p.z})
                    if tile then
                        if table.find(data[dir], tile:getTopUseThing():getId()) then
                            table.insert(possibleChangers, {changer = floorChangeSelector[changer][dir], pos = {x = p.x + x, y = p.y + y, z = p.z}})
                        end
                    end
                end
            end
        end
    end
    executeClosest(possibleChangers)
end

local function targetMissing()
    for _, n in ipairs(getSpectators(false)) do
        if n:getName() == target then
            return n:getPosition().z ~= posz()
        end
    end
    return true
end

macro(500, "Follow Avançado", "", function(macro)
    local c = getCreatureByName(target)

    if g_game.isFollowing() then
        if g_game.getFollowingCreature() ~= c then
            g_game.cancelFollow()
            g_game.follow(c)
        end
    end

    if c and not g_game.isFollowing() then
        g_game.follow(c)
    elseif c and g_game.isFollowing() and getDistanceBetween(pos(), c:getPosition()) > 1 then
        g_game.cancelFollow()
        g_game.follow(c)
    end

    checkTargetPos()
    if targetMissing() and lastKnownPosition then
        handleFloorChange()
    end
end)

UI.Label("Seguir Personagem:")
addTextEdit("playerToFollow", storage.followLeader or "Trala", function(widget, text)
    storage.followLeader = text
    target = tostring(text)
end)








setDefaultTab("Tools")

UI.Separator()

UI.Label("FACILITADORES")

UI.Separator()

--[[Auto Resetter  a cada 10s]]

macro(10000,"Resetter",function()
 use(10302)
end)

-- [[Configuração de Exp Potions:]]
macro(30000, "Exp Pot 100%", function()
if not isInPz() then use(11372) use(11372) end
end)
macro(30000, "Exp Pot 150%", function()
if not isInPz() then use(7440) use(7440) end
end)


-- [[Configuração de Usar Stamina:]]
macro(30000, "Stamina < 14h", function()
if not isInPz() and stamina() < 840 then use(11588) end
end)
macro(35000, "Stamina < 40h", function()
if not isInPz() and stamina() < 2400 then use(11588) end
end)

--[[Auto MANA PERGAMINHO]]
macro(1000,"MANA PERGAMINHO",function()
 use(11450)
end)

--[[Auto HP PERGAMINHO]]
macro(1000,"HP PERGAMINHO",function()
 use(11510)
end)

UI.Separator()

UI.Label("OUTROS")

UI.Separator()

-- [[Configuração de Juntar Itens:]]
macro(1000, "Juntar Itens", function()
  local containers = g_game.getContainers()
  local toStack = {}
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 100 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            g_game.move(item, stackWith[1], math.min(stackWith[2], item:getCount()))
            return
          end
          toStack[item:getId()] = {container:getSlotPosition(i - 1), 100 - item:getCount()}
        end
      end
    end
  end
end)

-- [[Configuração de Trocar Golds:]]
local moneyIds = {3031, 3035, 3043} -- gold coin, platinium coin, cristal coin
macro(1000, "Trocar Golds", function()
  local containers = getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(moneyIds) do
            if item:getId() == moneyId then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)


-- [[Configuração de Catar Itens no Chao:]]
macro(500, "Catar itens", function()
local pegaritens = {
  um = 6526, dois = 3043,  tres = 3366,  quatro = 3414,  cinco = 3181,  seis = 0,
  sete = 0,  oito = 0,  nove = 0,  dez = 0,  onze = 0,  doze = 0,
  treze = 0,  quatorze = 0,  quinze = 0,  dezesseis = 0,  dezessete = 0,
  dezoito = 0, dezenove = 0, vinte = 0, vinteeum = 0, vinteedois = 0
}
  local z = posz()
  for _, tile in ipairs(g_map.getTiles(z)) do
    if z ~= posz() then return end
    if getDistanceBetween(pos(), tile:getPosition()) <= 7 then
      if tile:getTopLookThing():getId() == pegaritens.um or
         tile:getTopLookThing():getId() == pegaritens.dois or
         tile:getTopLookThing():getId() == pegaritens.tres or
         tile:getTopLookThing():getId() == pegaritens.quatro or
         tile:getTopLookThing():getId() == pegaritens.cinco or
         tile:getTopLookThing():getId() == pegaritens.seis or
         tile:getTopLookThing():getId() == pegaritens.sete or
         tile:getTopLookThing():getId() == pegaritens.oito or
         tile:getTopLookThing():getId() == pegaritens.nove or
         tile:getTopLookThing():getId() == pegaritens.dez or
         tile:getTopLookThing():getId() == pegaritens.onze or
         tile:getTopLookThing():getId() == pegaritens.doze or
         tile:getTopLookThing():getId() == pegaritens.treze or
         tile:getTopLookThing():getId() == pegaritens.quatorze or
         tile:getTopLookThing():getId() == pegaritens.quinze or
         tile:getTopLookThing():getId() == pegaritens.dezesseis or
         tile:getTopLookThing():getId() == pegaritens.dezessete or
         tile:getTopLookThing():getId() == pegaritens.dezoito or
         tile:getTopLookThing():getId() == pegaritens.dezenove or
         tile:getTopLookThing():getId() == pegaritens.vinte or
         tile:getTopLookThing():getId() == pegaritens.vinteeum or
         tile:getTopLookThing():getId() == pegaritens.vinteedois then
            g_game.move(tile:getTopLookThing(), {x = 65535, y=SlotBack, z=0}, tile:getTopLookThing():getCount())
      end
    end
  end
end)

-- [[Configurações de Subir Stealth ring:]]
local ringmana = 3049
local normalring = 11637
local ringmana2 = 3086
local hpPercents = 50
macro(20, "Auto Stealth Ring",function()
  if hppercent() <= hpPercents and getFinger() and getFinger():getId() == normalring then
     moveToSlot(findItem(ringmana), SlotFinger, 1)
     else
if hppercent() >= hpPercents and not g_game.isAttacking() and getFinger() and getFinger():getId() == ringmana2 then
      moveToSlot(findItem(normalring), SlotFinger, 1)
         return
        end
  end
end)

-- [[Configuração de Cortar mato:]]
macro(500, "Cortar mato", function()
local idcanivete = 9596
local mato = {
  um = 2130
}
  local z = posz()
  for _, tile in ipairs(g_map.getTiles(z)) do
    if z ~= posz() then return end
    if getDistanceBetween(pos(), tile:getPosition()) <= 7 then
      if tile:getTopLookThing():getId() == mato.um then
            usewith(idcanivete, tile:getTopLookThing())
      end
    end
  end
end)

UI.Separator()

setDefaultTab("Target")

UI.Separator()

UI.Label("AFK BOT 100%SAFE")

UI.Separator()

macro(4000, "Cave + Target On", function()
if not g_game.isAttacking() then
TargetBot.setOn()
end
end)

-- [[Configurações de Anti PK:]]
local attackPK = macro(100, "Atacar PK de volta", nil, function()
  if attacker then
    if attacker:getPosition() and attacker:getPosition().z == posz() then
      if g_game.isAttacking() then
        if g_game.getAttackingCreature():getName() ~= attacker:getName() then
          g_game.attack(attacker)
        end
      else
        g_game.attack(attacker)
      end
    end
  else
    if not g_game.isAttacking() then
      TargetBot.setOn()
      CaveBot.setOn()
    end
  end
  if targetTime then
    if now - targetTime > 2500 then
      attacker = nil
    end
  end
end)

onMissle(function(missle)
    local src = missle:getSource()
    if src.z ~= posz() then
      return
    end
    local shooterTile = g_map.getTile(src)
    if shooterTile then
      local creatures = shooterTile:getCreatures()
      if creatures[1] then
        if creatures[1]:isPlayer() then
          local destination = missle:getDestination()
          if posx() == destination.x and posy() == destination.y then
            if player:getName() ~= creatures[1]:getName() then
              if attacker ~= creatures[1] then
                attacker = creatures[1]
                targetTime = now
                TargetBot.setOff()
                CaveBot.setOff()
              end
            end
          end
        end
      end
    end
end)

UI.Separator()

UI.Label("PVP")

UI.Separator()

-- [[Configurações de PVP:]]
oldTarget = nil
macro(400, "Ataque travado", function()
if g_game.isAttacking() then
  oldTarget = g_game.getAttackingCreature()
end
if (oldTarget and oldTarget:getPosition()) then
    if (not g_game.isAttacking() and getDistanceBetween(pos(), oldTarget:getPosition()) <= 8) then
        if (oldTarget:getPosition().z == posz()) then
            g_game.attack(oldTarget)
        end
    end
end
end)


macro(4000,"Mas Selva - Spot 7",function()
if g_game.isAttacking() then say("exevo gran mas selva") end
end)

UI.Separator()

UI.Label("RAIDS")

UI.Separator()

local monsterList = {}
local whitelistMonsters = {"emberwing", "skullfrost", "groovebeast", "thundergiant","pet mercenary","pet archer","pet witchdoctor", "pet mage", "pet blaze" , "pet wolf", "pet dog"}

macro(100, "Atk Closest Target", function()
  if g_game.isAttacking() then
    return
  end
  for _,mob in ipairs(getSpectators(posz())) do
    distancia = getDistanceBetween(pos(), mob:getPosition())
    if mob:isMonster() and not table.find(whitelistMonsters, mob:getName():lower()) and distancia >=distMin and distancia <=distMax then
      table.insert(monsterList, {monster = mob, distance = getDistanceBetween(pos(), mob:getPosition())})
    end
  end
  table.sort(monsterList, function(a,b) return a.distance < b.distance end)
  if not g_game.isAttacking() and monsterList[1] then
    g_game.attack(monsterList[1].monster)
  end
  monsterList = {}
end)


macro(100, "Follow Target", function()
g_game.setChaseMode(1)
end)

macro(300, "Auto Pause CaveBot", function()
 if g_game.isAttacking() then
  CaveBot.setOn(false)
 else
  CaveBot.setOn(true)
 end
end)


UI.Separator()

UI.Label("Distância para ataque")
distMin = 1
distMax = 8
function Distancia(parent)
    local panelName = "distancia"
    if not parent then
      parent = panel
    end

    local ui = g_ui.createWidget("DualScrollPanel", parent)
    ui:setId(panelName)
    if not storage[panelName] then
      storage[panelName] = {
        min = 1,
        max = 100,
        text = 'exura'
      }
    end

    ui.title:setOn(storage[panelName].enabled)
    ui.title.onClick = function(widget)
      storage[panelName].enabled = not storage[panelName].enabled
      widget:setOn(storage[panelName].enabled)
    end
 
  
    local updateText = function()
      ui.title:setText("distância >= " .. math.floor(storage[panelName].min*8/100)  .. " e <= " .. math.floor(storage[panelName].max*8/100) .. ' sqms')
    end

    local repeatTime
    ui.scroll1.onValueChange = function(scroll, value)
      storage[panelName].min = value
      updateText()
    end
    ui.scroll2.onValueChange = function(scroll, value)
      storage[panelName].max = value
      updateText()
    end
    ui.text.onTextChange = function(widget, text)
      storage[panelName].text = ""
      updateText()
    end


    ui.scroll1:setValue(storage[panelName].min)
    ui.scroll2:setValue(storage[panelName].max)
    
    macro(1000, function()
      
      if storage[panelName].enabled then
        distMin = math.floor(storage[panelName].min*8/100)
        distMax = math.floor(storage[panelName].max*8/100)
      end
    end)
end
Distancia()

UI.Separator()