local Graph = require("src/graph")

function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineStyle("smooth")
	Graph:loadData("inputData")
	-- graph settings:

	--Graph.yLogScale = true
	--Graph.xLogScale = true
	--Graph.xStepDelta = 10

	Graph:loadDataUnc("uncData")

	Graph:print()
	-- colors for individual plots
	-- Graph:changeColor("I = 0A", 0.5, 0, 0.5)
	Graph:changeColor("I = 1A", 1, 0, 0)
	Graph:changeColor("I = 1.5A", 0, 0.8, 0)
	Graph:changeColor("I = 2A", 0, 0, 1)
	Graph:changeColor("I = 2.5A", 1, 0, 1)
	--Graph:changeColor("D4 Zener 1 TZMB2V7", 1, 0, 0)
	--Graph:changeColor("D5 Zener 2 TZMB8V2", 0, 0, 1)
	--[[
	Graph:changeColor("Red LED", 1, 0, 0)
	Graph:changeColor("Green LED", 0, 1, 0)
	Graph:changeColor("Blue LED", 0, 0, 1)

	Graph:changeColor("D1 Schottky BAT54", 0.5, 0.5, 0)
	Graph:changeColor("D2 Rectifying BYM10", 0, 0.8, 0.8)
	Graph:changeColor("D3 Pulse LL4148", 0.8, 0, 0.8)
	Graph:changeColor("D4 Zener TZMB2V7", 0.2, 0.5, 0.3)
	]]
	--
	Graph:makePlots()
	--Graph:printPlots()
	--Graph:printPlotsUnc()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "r" then
		love.event.quit("restart")
	end
end

function love.update() end

function love.draw()
	Graph:draw()
	Graph:drawPlots()
end
