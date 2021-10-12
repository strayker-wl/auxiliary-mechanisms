--=============================================--
--====                 lib                  ===--
--=============================================--

function string.split(str, divider)
    if divider == '' then
        return str
    end
    local pos = 0
    local arr = {}
    -- for each divider found
    for st, sp in function()
        return str:find(divider, pos, true)
    end do
        table.insert(arr, str:sub(pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, str:sub(pos))
    return arr
end


--=============================================--
--====                debug                 ===--
--=============================================--

local debugOn = true

local function debug(str)
    if not debugOn then
        return
    end
    game.print(str)
end

local function message(str)
    str = "[TESSERACT] " .. str
    game.print(str)
end

local function warn(str)
    str = "[TESSERACT] WARNING! " .. str
    game.print(str)
end

--=============================================--
--====                 data                 ===--
--=============================================--

local function initData()
    global.tesseract = global.tesseract or {}
    global.tesseract.data = global.tesseract.data or {}
    global.tesseract.queue = global.tesseract.queue or {}
    global.tesseract.senders = global.tesseract.senders or {} -- для ускорения работы алгоритма поиска добавлен массив всех сендеров
    global.tesseract.receivers = global.tesseract.receivers or {} -- для ускорения работы алгоритма поиска добавлен массив всех ресиверов
    global.tesseract.gui = global.tesseract.gui or {}
end

local function pushTesseract(buffer, controlUnit)
    local id = controlUnit.unit_number
    global.tesseract.data[tostring(id)] = {
        buffer = buffer,
        controlUnit = controlUnit,
        bufferId = buffer.unit_number
    }
end

local function checkTesseracts()
    for id, data in pairs(global.tesseract.data) do
        if not (data.buffer and data.buffer.valid and data.controlUnit and data.controlUnit.valid) then
            global.tesseract.data[tostring(id)] = nil
            warn("ERR#01: remove broken tesseract id=" .. id)
        else
            if not data.bufferId or data.bufferId == 0 then
                global.tesseract.data[tostring(id)].bufferId = data.buffer.unit_number
            end
        end
    end
    for id, data in pairs(global.tesseract.senders) do
        if not global.tesseract.data[tostring(id)] then
            global.tesseract.senders[tostring(id)] = nil
            warn("ERR#02: remove broken sender id=" .. id)
        end
    end
    local tempReceivers = {}
    for i, data in ipairs(global.tesseract.receivers) do
        if data.id and global.tesseract.data[tostring(data.id)] then
            table.insert(tempReceivers, data)
        end
    end
    local oldCount = 0
    if tempReceivers and #tempReceivers and #tempReceivers > 0 then
        oldCount = #global.tesseract.receivers
        global.tesseract.receivers = tempReceivers
        warn("ERR#03: fix receivers, old count=" .. oldCount .. "  new count=" .. #global.tesseract.receivers)
    end
    local tempQueue = {}
    for i, idx in ipairs(global.tesseract.queue) do
        if global.tesseract.data[tostring(idx)] then
            table.insert(tempReceivers, idx)
        end
    end
    if tempQueue and #tempQueue and #tempQueue > 0 then
        oldCount = #global.tesseract.queue
        global.tesseract.queue = tempQueue
        warn("ERR#04: fix queue, old count = " .. oldCount .. "  new count=" .. #global.tesseract.queue)
    end
end

local function removeTesseract(id, isDie)
    if id then
        local removeId = nil
        if global.tesseract.data[tostring(id)] then
            removeId = tostring(id) -- это controlUnit
        else
            for idx, data in pairs(global.tesseract.data) do
                if data.bufferId == id then
                    -- ищем ид через буффер который пришел в эвенте
                    removeId = tostring(idx)
                    break
                end
            end
        end
        if not removeId or removeId == 0 or removeId == "0" or removeId == "" then
            if not isDie then
                warn("ERR#05: not found id")
                checkTesseracts()
            end
            return
        end
        global.tesseract.data[removeId] = nil -- удаляем данные тесеракта
        if global.tesseract.senders[removeId] then
            -- ищем и удаляем из сендеров, если он есть
            global.tesseract.senders[removeId] = nil
        end
        for i, qid in ipairs(global.tesseract.queue) do
            -- ищем и удаляем из очереди, если он есть
            if tostring(qid) == removeId then
                table.remove(global.tesseract.queue, i)
                break
            end
        end
        for i, data in ipairs(global.tesseract.receivers) do
            -- ищем и удаляем из ресиверов, если он есть
            if tostring(data.id) == removeId then
                table.remove(global.tesseract.receivers, i)
                break
            end
        end
    end
end

local function isHaveTesseractData(id)
    return id and global.tesseract.data[tostring(id)]
end

local function setTesseractData(id, field, value)
    if not global.tesseract.data[tostring(id)] then
        return
    end
    global.tesseract.data[tostring(id)][field] = value
end

local function getTesseractData(id, field)
    if not global.tesseract.data[tostring(id)] or not global.tesseract.data[tostring(id)][field] then
        return nil
    end
    return global.tesseract.data[tostring(id)][field]
end

local function setGuiTempData(pid, field, value)
    if not global.tesseract.gui[tostring(pid)] then
        global.tesseract.gui[tostring(pid)] = {}
    end
    global.tesseract.gui[tostring(pid)][field] = value
end

local function getGuiTempData(pid, field)
    if not global.tesseract.gui[tostring(pid)] or not global.tesseract.gui[tostring(pid)][field] then
        return nil
    end
    return global.tesseract.gui[tostring(pid)][field] or nil
end

local function resetGuiTempData(pid)
    if global.tesseract.gui[tostring(pid)] then
        global.tesseract.gui[tostring(pid)] = nil
    end
end

local function pushToSender(id)
    if global.tesseract.senders[tostring(id)] then
        return
    end
    local time = getTesseractData(id, "time")
    if not time then
        warn("ERR#06: time is not configured for this tesseract")
        return
    end
    global.tesseract.senders[tostring(id)] = game.tick + time * 60
end

local function removeFromSenders(id)
    if global.tesseract.senders[tostring(id)] then
        global.tesseract.senders[tostring(id)] = nil
    end
end

local function updateSender(id)
    if not global.tesseract.senders[tostring(id)] then
        warn("ERR#07: not found sender")
        return
    end
    local time = getTesseractData(id, "time")
    if not time then
        warn("ERR#08: time is not configured for this tesseract")
        return
    end
    global.tesseract.senders[tostring(id)] = game.tick + time * 60
end

local function isInReceivers(id)
    for i, data in ipairs(global.tesseract.receivers) do
        if data.id == id then
            return true, i
        end
    end
    return false, nil
end

local function pushToReceivers(id)
    if isInReceivers(id) then
        return
    end
    local net = getTesseractData(id, "net")
    if not net then
        warn("ERR#09: net is not configured for this tesseract: ")
        return
    end
    table.insert(global.tesseract.receivers, {
        id = id,
        net = net
    })
end

local function removeFromReceivers(id)
    local isIn, i = isInReceivers(id)
    if isIn then
        table.remove(global.tesseract.receivers, i)
    end
end

local function getReceiversByNet(net)
    local list = {}
    for i, data in ipairs(global.tesseract.receivers) do
        if data.net == net then
            table.insert(list, { idx = i, id = data.id })
        end
    end
    return list
end

local function updateReceiver(idx)
    local receiver = table.remove(global.tesseract.receivers, idx)
    table.insert(global.tesseract.receivers, receiver) -- перепихиваем найденный ресивер в конец
end

local function checkQueue(id)
    for i, qid in ipairs(global.tesseract.queue) do
        if qid == id then
            return i
        end
    end
    return false
end

local function pushToQueue(id)
    if not checkQueue(id) then
        table.insert(global.tesseract.queue, id)
        updateSender(id)
    end
end

local function removeFromQueue(id)
    for i, qid in ipairs(global.tesseract.queue) do
        if qid == id then
            table.remove(global.tesseract.queue, i)
            return
        end
    end
end

local function getSenderIdFromQueue()
    if global.tesseract.queue and #global.tesseract.queue then
        return table.remove(global.tesseract.queue, 1)
    end
    return nil
end

--=============================================--
--====                entity                ===--
--=============================================--

local bufferNames = {
    "am-tesseract-buffer-1",
    "am-tesseract-buffer-2",
    "am-tesseract-buffer-3",
    "am-tesseract-fluid-buffer-1",
    "am-tesseract-fluid-buffer-2",
    "am-tesseract-fluid-buffer-3",
}

local controlUnitNames = {
    "am-tesseract-control-unit-1",
    "am-tesseract-control-unit-2",
    "am-tesseract-control-unit-3",
    "am-tesseract-fluid-control-unit-1",
    "am-tesseract-fluid-control-unit-2",
    "am-tesseract-fluid-control-unit-3",
}

local dummyNames = {
    "am-tesseract-dummy-1",
    "am-tesseract-dummy-2",
    "am-tesseract-dummy-3",
    "am-tesseract-fluid-dummy-1",
    "am-tesseract-fluid-dummy-2",
    "am-tesseract-fluid-dummy-3",
}

local entityNames = {
    "am-tesseract-buffer-1",
    "am-tesseract-buffer-2",
    "am-tesseract-buffer-3",
    "am-tesseract-fluid-buffer-1",
    "am-tesseract-fluid-buffer-2",
    "am-tesseract-fluid-buffer-3",
    "am-tesseract-control-unit-1",
    "am-tesseract-control-unit-2",
    "am-tesseract-control-unit-3",
    "am-tesseract-fluid-control-unit-1",
    "am-tesseract-fluid-control-unit-2",
    "am-tesseract-fluid-control-unit-3",
}

local entityComponentDependence = {
    ["am-tesseract-buffer-1"] = "am-tesseract-control-unit-1",
    ["am-tesseract-control-unit-1"] = "am-tesseract-buffer-1",
    ["am-tesseract-buffer-2"] = "am-tesseract-control-unit-2",
    ["am-tesseract-control-unit-2"] = "am-tesseract-buffer-2",
    ["am-tesseract-buffer-3"] = "am-tesseract-control-unit-3",
    ["am-tesseract-control-unit-3"] = "am-tesseract-buffer-3",
    ["am-tesseract-fluid-buffer-1"] = "am-tesseract-fluid-control-unit-1",
    ["am-tesseract-fluid-control-unit-1"] = "am-tesseract-fluid-buffer-1",
    ["am-tesseract-fluid-buffer-2"] = "am-tesseract-fluid-control-unit-2",
    ["am-tesseract-fluid-control-unit-2"] = "am-tesseract-fluid-buffer-2",
    ["am-tesseract-fluid-buffer-3"] = "am-tesseract-fluid-control-unit-3",
    ["am-tesseract-fluid-control-unit-3"] = "am-tesseract-fluid-buffer-3",
}

local function isTesseract(str)
    local template = "am-tesseract"
    local len = template:len()
    if str:len() < len then
        return false
    end
    return str:sub(1, len) == template
end

local function isBuffer(str)
    local template = "buffer"
    return str:find(template) ~= nil
end

local function isDummy(str)
    local template = "dummy"
    return str:find(template) ~= nil
end

local function isControlUnit(str)
    local template = "control"
    return str:find(template) ~= nil
end

local function isTesseractAtPoint(surface, position)
    return surface.count_entities_filtered({
        name = entityNames,
        area = {
            -- из рассчета что минимальный размер 3х3
            { position.x - 1, position.y - 1, },
            { position.x + 1, position.y + 1, },
        },
    }) > 0
end

local function isTesseractGhostDoubledAtPoint(surface, position)
    return surface.count_entities_filtered({
        ghost_name = entityNames,
        area = {
            { position.x - 1, position.y - 1, },
            { position.x + 1, position.y + 1, },
        },
    }) > 2
end

local function isControlUnitGhostAtPoint(surface, position)
    return surface.count_entities_filtered({
        ghost_name = controlUnitNames,
        area = {
            { position.x - 1, position.y - 1, },
            { position.x + 1, position.y + 1, },
        },
    }) > 0
end

local function isBufferGhostAtPoint(surface, position)
    return surface.count_entities_filtered({
        ghost_name = bufferNames,
        area = {
            { position.x - 1, position.y - 1, },
            { position.x + 1, position.y + 1, },
        },
    }) > 0
end

local function removeGhosts(surface, position)
    local ghosts = surface.find_entities_filtered({
        ghost_name = entityNames,
        area = {
            { position.x - 1, position.y - 1, },
            { position.x + 1, position.y + 1, },
        },
    })
    for _, ghost in ipairs(ghosts) do
        if ghost.valid then
            ghost.destroy()
        end
    end
end

local function getParams(name)
    return {
        tier = name:sub(-1),
        isFluid = name:find("fluid") ~= nil,
        ghost = false
    }
end

local function getBufferName(params)
    local name = "am-tesseract-"
    if params.isFluid then
        name = name .. "fluid-"
    end
    name = name .. "buffer-" .. params.tier
    return name
end

local function getControlUnitName(params)
    local name = "am-tesseract-"
    if params.isFluid then
        name = name .. "fluid-"
    end
    name = name .. "control-unit-" .. params.tier
    return name
end

local function createComponents(entity, params)
    local controlUnit = nil
    local buffer = nil
    if not params.ghost then
        buffer = entity.surface.create_entity({
            name = getBufferName(params),
            position = entity.position,
            force = entity.force,
        })
    end
    if params.ghost or buffer then
        controlUnit = entity.surface.create_entity({
            name = getControlUnitName(params),
            position = entity.position,
            force = entity.force,
        })
    end
    if not params.ghost and not controlUnit and buffer then
        buffer.destroy()
        buffer = nil
    end
    return buffer, controlUnit
end

local function removeComponents(entity, isDie)
    local object = entity.surface.find_entities_filtered({
        name = entityComponentDependence[entity.name],
        area = {
            { entity.position.x - 1, entity.position.y - 1 },
            { entity.position.x + 1, entity.position.y + 1 },
        },
    })
    if object and object[1] and object[1].valid then
        if isBuffer(object[1].name) then
            removeTesseract(object[1].unit_number, isDie)
        end
        object[1].destroy()
    end
end

local function onEntityCreated(event)
    local entity = event.created_entity

    if not entity or not entity.valid then
        return
    end
    if entity.name == "entity-ghost"
            and entity.ghost_name
            and isTesseract(entity.ghost_name)
    then
        if isTesseractAtPoint(entity.surface, entity.position) then
            removeGhosts(entity.surface, entity.position)
            return
        end

        if isTesseractGhostDoubledAtPoint(entity.surface, entity.position) then
            entity.destroy()
            return
        end

        local controlUnit = isControlUnitGhostAtPoint(entity.surface, entity.position)
        local buffer = isBufferGhostAtPoint(entity.surface, entity.position)

        if not (controlUnit and buffer) and not event.item then
            warn("ERR#10: Broken tesseract in blueprint! Include both entities of tesseract.")
            entity.destroy()
            return
        end
    end
    local objectIsTesseract = isTesseract(entity.name)

    if not objectIsTesseract then
        return
    end

    local params = getParams(entity.name)
    -- placed from item
    if objectIsTesseract and isDummy(entity.name) then
        removeGhosts(entity.surface, entity.position)
        local buffer, controlUnit = createComponents(entity, params)
        if buffer and controlUnit then
            pushTesseract(buffer, controlUnit)
        else
            warn("ERR#11: Placing tesseract failed.")
        end
        entity.destroy()
        return
    end
    -- placed from blueprint
    if objectIsTesseract and isBuffer(entity.name) then
        removeGhosts(entity.surface, entity.position)
        params.ghost = true

        local buffer = entity
        local _, controlUnit = createComponents(entity, params)
        if controlUnit then
            pushTesseract(buffer, controlUnit)
        else
            buffer.destroy()
            warn("ERR#12: Placing tesseract from blueprint failed.")
        end
    end
end

local function onEntityRemoved(event)
    local entity = event.entity
    if not entity or not entity.valid then
        return
    end

    if isTesseract(entity.name) then
        removeTesseract(entity.unit_number, false)
        removeComponents(entity, false)
        return
    end

    if entity.name == "entity-ghost"
            and entity.ghost_name
            and isTesseract(entity.ghost_name)
    then
        removeGhosts(entity.surface, entity.position)
    end
end

local function onEntityDamaged(event)
    local entity = event.entity

    if not entity or not entity.valid then
        return
    end

    if isTesseract(entity.name) then
        if entity.health < 1 then
            if isBuffer(entity.name) then
                removeTesseract(entity.unit_number, false)
            end
            removeComponents(entity, true)
            entity.destroy()
        end
    end
end

--=============================================--
--====                 gui                  ===--
--=============================================--

local function notify(id, text, force)
    if not text then
        return
    end
    if not global.tesseract.data[tostring(id)] then
        warn("ERR#13: not found entity")
        return
    end
    local lastNotifyTick = getTesseractData(id, "lastNotifyTick")
    if not force and (lastNotifyTick and game.tick - lastNotifyTick < 600) then
        return
    end
    setTesseractData(id, "lastNotifyTick", game.tick)
    local controlUnit = getTesseractData(id, "controlUnit")
    controlUnit.surface.create_entity({
        name = "flying-text",
        position = controlUnit.position,
        color = { r = 1, g = 0, b = 0 },
        text = text,
    })
end

local function closeTesseractGui(pid)
    resetGuiTempData(pid)
    local player = game.players[pid]
    if player.gui.left.tesseractGui then
        player.gui.left.tesseractGui.destroy()
    end
end

local function loadGuiData(pid, entity)
    local id = entity.unit_number
    if not id then
        closeTesseractGui(pid)
        warn("ERR#14: not found tesseract")
        return
    end
    local player = game.players[pid]
    if not player.gui.left.tesseractGui then
        warn("ERR#15: Tesseract GUI not found!")
        closeTesseractGui(pid)
        return
    end
    local worktype = getTesseractData(id, "worktype")
    if worktype and worktype == 2 then
        -- не прерываем загрузку, т.к. должны записать переключатель
        player.gui.left.tesseractGui["tesseract.worktype"].switch_state = "right"
        setGuiTempData(pid, "worktype", worktype)
    else
        player.gui.left.tesseractGui["tesseract.worktype"].switch_state = "left"
        setGuiTempData(pid, "worktype", worktype or 1)
    end
    local tnet = getTesseractData(id, "net")
    local time = getTesseractData(id, "time")
    if not (tnet and time) then
        --warn("ERR#16: Tesseract settings was broken")
        return
    end
    local anet = string.split(tnet, "_")
    if not (anet and anet[1] and anet[2] and anet[3]) then
        return
    end
    local SignalID = {
        type = anet[1],
        name = anet[2]
    }
    local net = SignalID.type .. "_" .. SignalID.name .. "_"
    local subnet = anet[3]
    player.gui.left.tesseractGui.table["tesseract.net"].elem_value = SignalID
    setGuiTempData(pid, "net", net)
    player.gui.left.tesseractGui.table["tesseract.subnet"].text = subnet
    setGuiTempData(pid, "subnet", subnet)
    player.gui.left.tesseractGui.table["tesseract.time"].text = tostring(time)
    setGuiTempData(pid, "time", time)
end

local function openTesseractGui(pid, entity)
    local player = game.players[pid]
    local frame = player.gui.left.add { type = "frame", name = "tesseractGui", direction = "vertical", caption = { "tesseract-gui-title" } }
    frame.add { type = "label", name = "unit-number-lable", caption = "id #" .. entity.unit_number }
    frame.add { type = "label", name = "info-lable", caption = { "tesseract-gui-info" } }
    frame.add { type = "switch", name = "tesseract.worktype", switch_state = "left", allow_none_state = false, left_label_caption = { "tesseract-gui-type-left" }, right_label_caption = { "tesseract-gui-type-right" } }
    frame.add { type = "table", name = "table", column_count = 2 }
    frame.table.add { type = "label", name = "net-lable", caption = { "tesseract-gui-net" } }
    frame.table.add { type = "choose-elem-button", name = "tesseract.net", elem_type = "signal" }
    frame.table.add { type = "label", name = "subnet-lable", caption = { "tesseract-gui-subnet" } }
    frame.table.add { type = "textfield", name = "tesseract.subnet", numeric = true, allow_decimal = false, allow_negative = false }
    frame.table.add { type = "label", name = "time-lable", caption = { "tesseract-gui-time" } }
    frame.table.add { type = "textfield", name = "tesseract.time", numeric = true, allow_decimal = false, allow_negative = false }
    frame.add { type = "label", name = "time-note-lable", caption = { "tesseract-gui-time-note" } }
    frame.add { type = "table", name = "buttons", column_count = 2 }
    frame.buttons.add { type = "button", name = "tesseract.save", caption = { "tesseract-gui-apply" } }
    setGuiTempData(pid, "entity", entity.unit_number)
    loadGuiData(pid, entity)
end

local function saveGuiData(pid)
    if not pid then
        return
    end
    local id = getGuiTempData(pid, "entity")
    if id and
            getGuiTempData(pid, "worktype") and
            getGuiTempData(pid, "net") and
            getGuiTempData(pid, "subnet") and
            (getGuiTempData(pid, "time") or getGuiTempData(pid, "worktype") == 2)
    then
        local time = getGuiTempData(pid, "time")
        if not time then --для ресивера время не обязательно
            if getGuiTempData(pid, "worktype") == 2 then
                time = 1 -- чтобы не переписывать все условия устанавливаем 1 а не 0
            else
                warn("ERR#28: cant save tesseract data if its not full configured")
                closeTesseractGui(pid)
                return
            end
        end
        setTesseractData(id, "net", getGuiTempData(pid, "net") .. getGuiTempData(pid, "subnet"))
        setTesseractData(id, "time", time)
        setTesseractData(id, "worktype", getGuiTempData(pid, "worktype"))
        if getGuiTempData(pid, "worktype") == 1 then
            pushToSender(id)
            removeFromReceivers(id)
            updateSender(id)
        else
            pushToReceivers(id)
            removeFromSenders(id)
            removeFromQueue(id)
        end
        message("Tesseract settings saved")
        closeTesseractGui(pid)
    else
        warn("ERR#17: cant save tesseract data if its not full configured")
        closeTesseractGui(pid)
    end
end

local function onClickTesseractGui(pid, fields)
    --local fieldName = table.remove(nameArr,1)
    local player = game.players[pid]
    local id = getGuiTempData(pid, "entity")
    if id == nil then
        warn("ERR#18: Tesseract not found!")
        closeTesseractGui(pid)
        return
    end
    if not player.gui.left.tesseractGui then
        warn("ERR#19: Tesseract GUI not found!")
        closeTesseractGui(pid)
        return
    end
    local field = fields[1]
    if not field then
        return
    end
    if field == "worktype" then
        local element = player.gui.left.tesseractGui["tesseract.worktype"]
        local value = element.switch_state
        if value then
            if value == "left" then
                setGuiTempData(pid, "worktype", 1)
            else
                setGuiTempData(pid, "worktype", 2)
            end
        else
            setGuiTempData(pid, "worktype", nil)
        end
        return
    elseif field == "net" then
        local element = player.gui.left.tesseractGui.table["tesseract.net"]
        local value = element.elem_value
        if value and value.type and value.name then
            local net = value.type .. "_" .. value.name .. "_"
            setGuiTempData(pid, "net", net)
        else
            setGuiTempData(pid, "net", nil)
        end
        return
    elseif field == "subnet" then
        local element = player.gui.left.tesseractGui.table["tesseract.subnet"]
        local value = element.text
        if value then
            local iValue = tonumber(value)
            if iValue and iValue ~= 0 then
                setGuiTempData(pid, "subnet", iValue)
            else
                setGuiTempData(pid, "subnet", nil)
            end
        else
            setGuiTempData(pid, "subnet", nil)
        end
        return
    elseif field == "time" then
        local element = player.gui.left.tesseractGui.table["tesseract.time"]
        local value = element.text
        if value then
            local iValue = tonumber(value)
            if iValue and iValue ~= 0 then
                setGuiTempData(pid, "time", iValue)
            else
                setGuiTempData(pid, "time", nil)
            end
        else
            setGuiTempData(pid, "time", nil)
        end
        return
    elseif field == "save" then
        saveGuiData(pid)
        return
    end
end

local function guiEventHandler(event)
    local element = event.element.name
    local guiEvent = string.split(element, ".")
    local elementIdentifier = table.remove(guiEvent, 1)
    if elementIdentifier == "tesseract" and guiEvent then
        local pid = event.player_index
        onClickTesseractGui(pid, guiEvent)
    end
end

local function onGuiOpened(event)
    local pid = event.player_index
    if not pid then
        warn("ERR#20: Not found player")
    end
    closeTesseractGui(pid)
    if event.gui_type == defines.gui_type.entity
            and event.entity and event.entity.valid
            and isTesseract(event.entity.name) and isControlUnit(event.entity.name)
    then
        openTesseractGui(pid, event.entity)
    end
end

local function onGuiClosed(event)
    local pid = event.player_index
    closeTesseractGui(pid)
end

--=============================================--
--====                 net                  ===--
--=============================================--

local function isFluid(entity)
    local name = entity.name
    local template = "fluid"
    return name:find(template) ~= nil
end

local function getFluidCount(entity)
    local content = entity.get_fluid_contents()
    local fluid = nil
    for fluidName, fluidCount in pairs(content) do
        fluid = fluidName
        break
    end
    return entity.get_fluid_count(), entity.prototype.fluid_capacity, fluid
end

local function getStackCount(name, count)
    local stackSize = game.item_prototypes[name].stack_size
    return math.ceil(count / stackSize), stackSize
end

local function getContentStacksCount(content)
    local stacks = 0
    for name, count in pairs(content) do
        local stackCount, _ = getStackCount(name, count)
        stacks = stacks + stackCount
    end
    return stacks
end

local function getInventoryCount(entity)
    local inventory = entity.get_inventory(defines.inventory.chest)
    local content = inventory.get_contents()
    local usedSlots = getContentStacksCount(content)
    return usedSlots, #inventory
end

local function isEmpty(entity)
    if isFluid(entity) then
        return entity.get_fluid_count() < 1
    end
    return entity.get_inventory(defines.inventory.chest).is_empty()
end

local function onNthTickCheckQueue()
    -- проверка всех телепортов отмеченных как передатчик и добавление их в очередь
    for id, time in pairs(global.tesseract.senders) do
        if time < game.tick then
            pushToQueue(id)
        end
    end
end

local function onNthTickSend()
    -- изъятие первого из очереди и отработка
    local senderId = getSenderIdFromQueue()
    if not senderId then
        return
    end
    -- проверяем на валидность сендера
    local sender = getTesseractData(senderId, "buffer")
    if not sender or not sender.valid then
        removeTesseract(senderId, false)
        warn("ERR#21: detected and removed broken tesseract id=" .. senderId)
        return
    end
    -- проверяем что есть энергия
    local senderControlUnit = getTesseractData(senderId, "controlUnit")
    if senderControlUnit and senderControlUnit.valid then
        if not senderControlUnit.is_connected_to_electric_network() then
            return
        end
    else
        removeTesseract(senderId, false)
        warn("ERR#22: detected and removed broken tesseract id=" .. senderId)
    end
    -- если он пустой то дальше не идем
    if isEmpty(sender) then
        return
    end
    -- проверяем что он в сети
    local net = getTesseractData(senderId, "net")
    if not net then
        warn("ERR#24: no net")
        return
    end
    -- собираем ресиверы в массив
    local receivers = getReceiversByNet(net)
    if not receivers or not #receivers or #receivers == 0 then
        notify(senderId, "no target", false)
        return
    end
    local senderType = isFluid(sender)
    for _, receiverData in ipairs(receivers) do
        -- прогоняем все ресиверы пока не найдем подходящий
        local receiverId = receiverData.id
        local receiver = getTesseractData(receiverId, "buffer")
        if receiver and receiver.valid then
            local receiverType = isFluid(receiver)
            if receiverType == senderType then -- если оба жидкостные или оба вещевые
                -- проверяем что есть энергия
                local receiverControlUnit = getTesseractData(receiverId, "controlUnit")
                if receiverControlUnit and receiverControlUnit.valid then
                    if receiverControlUnit.is_connected_to_electric_network() then
                        if senderType then
                            --is fluid
                            local senderFluidCount, senderCapacity, senderFluidName = getFluidCount(sender)
                            if senderFluidCount ~= 0 and senderFluidName then
                                --если есть что отправлять
                                local receiverFluidCount, receiverCapacity, receiverFluidName = getFluidCount(receiver)
                                if
                                (
                                        (not receiverFluidName) --если в точке назначения ничего нету
                                                or (receiverFluidName and senderFluidName == receiverFluidName) -- или есть тоже самое
                                )
                                then
                                    if receiverCapacity * 0.75 > receiverFluidCount then
                                        -- и в ресивере еще осталось место
                                        if isEmpty(receiver) then
                                            receiver.clear_fluid_inside()
                                        end
                                        local temperature = sender.fluidbox[1].temperature
                                        local freeCount = receiverCapacity - receiverFluidCount
                                        local insertCount = 0
                                        local clearSender = false
                                        if freeCount < senderFluidCount then
                                            insertCount = freeCount
                                        else
                                            insertCount = senderFluidCount
                                            clearSender = true
                                        end
                                        receiver.insert_fluid({
                                            name = senderFluidName,
                                            amount = insertCount,
                                            temperature = temperature
                                        })
                                        if clearSender then
                                            sender.clear_fluid_inside() -- очищаем буфер сендера
                                        else
                                            sender.remove_fluid({
                                                name = senderFluidName,
                                                amount = insertCount,
                                                temperature = temperature
                                            }) -- убираем из буфера сендера отправленное количество жидкости
                                        end
                                        updateReceiver(receiverData.idx) -- переносим ресивер в конец очереди
                                        return -- выходим из цикла на первом же подходящем ресивере
                                    end
                                else
                                    notify(senderId, "wrong fluid type in one of receivers ( id " .. receiverId .. " )", true)
                                end
                            end
                        else
                            -- is not fluid
                            local senderItemCount, senderCapacity = getInventoryCount(sender)
                            if senderItemCount ~= 0 then
                                --если есть что отправлять
                                local receiverItemCount, receiverCapacity = getInventoryCount(receiver)
                                if receiverCapacity * 0.75 > receiverItemCount then
                                    -- в ресивере еще есть место
                                    local freeCount = receiverCapacity - receiverItemCount
                                    local senderInventory = sender.get_inventory(defines.inventory.chest)
                                    local content = senderInventory.get_contents()
                                    local receiverInventory = receiver.get_inventory(defines.inventory.chest)
                                    receiverInventory.sort_and_merge() -- все мержим в стаки
                                    for name, count in pairs(content) do
                                        local insertStackCount, stackSize = getStackCount(name, count)
                                        local insertCount = 0
                                        if insertStackCount <= freeCount then
                                            -- если отправляемых предметов меньше чем свободного места в ресивере
                                            insertCount = count -- отправляем все
                                            freeCount = freeCount - insertStackCount -- и обновляем свободное место
                                        else
                                            insertCount = freeCount * stackSize -- считаем сколько предметов можем отправить
                                            freeCount = 0 -- и указываем что места не осталось
                                        end
                                        receiverInventory.insert({ -- пихаем предметы в ресивер
                                            name = name,
                                            count = insertCount
                                        })
                                        senderInventory.remove({ -- и удаляем их из сендера
                                            name = name,
                                            count = insertCount
                                        })
                                        if freeCount == 0 then
                                            break
                                        end
                                    end
                                    updateReceiver(receiverData.idx) -- переносим ресивер в конец очереди
                                    return -- выходим из цикла на первом же подходящем ресивере
                                end
                            end
                        end
                    end
                else
                    removeTesseract(receiverId, false)
                    warn("ERR#25: detected and removed broken tesseract id=" .. receiverId)
                end
            end
        else
            removeTesseract(receiverId, false)
            warn("ERR#27: detected and removed broken tesseract id=" .. receiverId)
        end
    end
end

--=============================================--
--====                event                 ===--
--=============================================--

script.on_configuration_changed(function()
    initData()
    checkTesseracts()
end)

script.on_init(function()
    initData()
    checkTesseracts()
end)

script.on_load(function()
    --checkTesseracts()
    --initData()
end)

script.on_event({ defines.events.on_built_entity, defines.events.on_robot_built_entity }, onEntityCreated)
script.on_event({ defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died }, onEntityRemoved)
script.on_event({ defines.events.on_entity_damaged }, onEntityDamaged)
script.on_event({ defines.events.on_gui_opened }, onGuiOpened)
script.on_event({ defines.events.on_gui_closed }, onGuiClosed)
script.on_event(defines.events.on_gui_click, guiEventHandler)
script.on_event(defines.events.on_gui_text_changed, guiEventHandler)
script.on_event(defines.events.on_gui_elem_changed, guiEventHandler)
script.on_nth_tick(math.ceil(60 / math.min(60, settings.global["strayker-tesseract-check-per-second"].value or 10)), onNthTickSend)
script.on_nth_tick(60, onNthTickCheckQueue)