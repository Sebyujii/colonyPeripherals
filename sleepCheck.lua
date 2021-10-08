colony = peripheral.find("colonyIntegrator")
mon = peripheral.wrap("top")

function centerText(text, line, txtback, txtcolor, pos)
    monX, monY = mon.getSize()
    mon.setBackgroundColor(txtback)
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX-length)
    x = math.floor(dif/2)
    
    if pos == "head" then
        mon.setCursorPos(x+1, line)
        mon.write(text)
    elseif pos == "left" then
        mon.setCursorPos(2, line)
        mon.write(text) 
    elseif pos == "right" then
        mon.setCursorPos(monX-length, line)
        mon.write(text)
    end
end

function prepareMonitor() 
    mon.clear()
    mon.setTextScale(0.5)
    centerText("Everyone", 1, colors.black, colors.white, "head") 
    centerText("in Bed?", 2, colors.black, colors.white, "head")
end

function check()
    guards = 0
    shouldSleep = colony.amountOfCitizens()
    for k, v in ipairs(colony.getCitizens()) do
        if v.work.name == "com.minecolonies.coremob.job.Ranger" or v.work.name == "com.minecolonies.coremob.job.Knight" then
            guards = guards + 1
            shouldSleep = shouldSleep - 1
        end
        if v.state == "Sleeping zZZ" then
            shouldSleep = shouldSleep - 1
        end
    end
    prepareMonitor()
    if shouldSleep == 0 then
        centerText("yes", 4, colors.black, colors.white, "left")
    else
        centerText("no", 4, colors.black, colors.white, "left")
	end
end

while true do
    check()
    sleep(10)
end