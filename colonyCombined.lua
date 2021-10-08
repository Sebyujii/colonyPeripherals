colony = peripheral.find("colonyIntegrator")
monL = peripheral.wrap("left")
monT = peripheral.wrap("top")
 
function centerTextL(text, line, txtback, txtcolor, pos)
    monX, monY = monL.getSize()
    monL.setBackgroundColor(txtback)
    monL.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        monL.setCursorPos(x+1, line)
        monL.write(text)
    elseif pos == "left" then
        monL.setCursorPos(2, line)
        monL.write(text) 
    elseif pos == "right" then
        monL.setCursorPos(monX-length, line)
        monL.write(text)
    end
end

function centerTextT(text, line, txtback, txtcolor, pos)
    monX, monY = monT.getSize()
    monT.setBackgroundColor(txtback)
    monT.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        monT.setCursorPos(x+1, line)
        monT.write(text)
    elseif pos == "left" then
        monT.setCursorPos(2, line)
        monT.write(text) 
    elseif pos == "right" then
        monT.setCursorPos(monX-length, line)
        monT.write(text)
    end
end
 
function prepareMonitorL() 
    monL.clear()
    monL.setTextScale(0.5)
    centerTextL("Citizens", 1, colors.black, colors.white, "head")
end

function prepareMonitorT()
    monT.clear()
    centerTextT("Everyone", 1, colors.black, colors.white, "head")
    centerTextT("in Bed?", 2, colors.black, colors.white, "head")
end
 
function printCitizens()
    row = 3
    useLeft = true
    for k, v in ipairs(colony.getCitizens()) do
        if row > 40 then
            useLeft = false
            row = 3
        end
        
        gender = ""
        if v.gender == "male" then
            gender = "M"
        else
            gender = "F"
        end

        if useLeft then
            centerTextL(v.name.. " - ".. gender.. ", State: " ..v.state, row, colors.black, colors.white, "left")        
        else
            centerTextL(v.name.. " - ".. gender.. ", State: " ..v.state, row, colors.black, colors.white, "right")
        end
        row = row+1
    end
	centerTextL("Total: " .. colony.amountOfCitizens() .. " / " .. colony.maxOfCitizens(), row, colors.black, colors.white, "left")
end

function sleepCheck()
    -- guards = 0
    -- shouldSleep = colony.amountOfCitizens()
    allTucked = true
    for k, v in ipairs(colony.getCitizens()) do
        -- if v.work.name ~= "com.minecolonies.coremod.job.Ranger" and v.work.name ~= "com.minecolonies.coremod.job.Knight" and v.state ~= "Sleeping zZZ" then
        if v.work.name ~= "com.minecolonies.coremod.job.Ranger" and v.work.name ~= "com.minecolonies.coremod.job.Knight" and not v.isAsleep then 
            allTucked = false
            print(v.name.. " ist noch nicht im Bett, Job: " ..v.work.name)
        end
        -- if v.work.name == "com.minecolonies.coremod.job.Ranger" or v.work.name == "com.minecolonies.coremod.job.Knight" then
        --     guards = guards + 1
        --     shouldSleep = shouldSleep - 1
        -- end
        -- if v.state == "Sleeping zZZ" then
        --     shouldSleep = shouldSleep - 1
        -- end
    end
    -- if shouldSleep then
    --     centerTextT("yes", 4, colors.black, colors.white, "head")
    -- else
    --     centerTextT("no", 4, colors.black, colors.white, "head")
	-- end
    if allTucked then
        monT.setBackgroundColor(colors.green)
        monT.clear()
        centerTextT("Everyone", 1, colors.green, colors.white, "head")
        centerTextT("in Bed?", 2, colors.green, colors.white, "head")
        centerTextT("yes", 4, colors.green, colors.white, "head")
        print("allTucked - true")
    else
        monT.setBackgroundColor(colors.red)
        monT.clear()
        centerTextT("Everyone", 1, colors.red, colors.white, "head")
        centerTextT("in Bed?", 2, colors.red, colors.white, "head")
        centerTextT("no", 4, colors.red, colors.white, "head")
	end
end
 
while true do
	prepareMonitorL()
    printCitizens()
    if(os.time() < 12.000 and os.time() > 0.541) then
        prepareMonitorT()
        sleepCheck()
    else
        monT.setBackgroundColor(colors.black)
        monT.clear()
        centerTextT("Not Night", 3, colors.black, colors.white, "head")
        print(os.time())
    end
    sleep(10)
end