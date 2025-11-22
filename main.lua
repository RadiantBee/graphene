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
	--[[
	Graph:changeColor("Red LED", 1, 0, 0)
	Graph:changeColor("Green LED", 0, 0.8, 0)
	Graph:changeColor("Blue LED", 0, 0, 1)
	Graph:changeColor("D1 Schottky BAT54", 1, 0.5, 0)
	Graph:changeColor("D2 Rectifying BYM10", 1, 0, 1)
	Graph:changeColor("D3 Pulse LL4148", 0.5, 0, 1)
	Graph:changeColor("D4 Zener TZMB2V7", 0, 0.8, 1)
	--Graph:changeColor("D5 Zener 2 TZMB8V2", 0, 0, 1)
	--Graph:changeColor("Uce[V]", 0, 0, 1)
	--Graph:changeColor("Ic[mA]", 1, 0, 0)
	--]]
	Graph:changeColor("n", 1, 0, 0)
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
	love.graphics.setColor(1, 0, 0)
	--love.graphics.print("y = 4708*x -15", 660, 320)
	--love.graphics.line(Graph:toRealX(0), Graph:toRealY(-15.65524927), Graph:toRealX(0.01), Graph:toRealY(31.4269023))
	--[[
	love.graphics.setColor(1, 0, 0)
	love.graphics.print("y = 0.218753*x", 660, 130)
	love.graphics.line(Graph:toRealX(-7), Graph:toRealY(-1.531271), Graph:toRealX(7), Graph:toRealY(1.531271))
	love.graphics.setColor(0, 0.8, 0)
	love.graphics.print("y = 0.314865*x", 660, 145)
	love.graphics.line(Graph:toRealX(-7), Graph:toRealY(-2.204055), Graph:toRealX(7), Graph:toRealY(2.204055))
	love.graphics.setColor(0, 0, 1)
	love.graphics.print("y = 0.435255*x", 660, 160)
	love.graphics.line(Graph:toRealX(-7), Graph:toRealY(-3.046785), Graph:toRealX(7), Graph:toRealY(3.046785))
	love.graphics.setColor(1, 0, 1)
	love.graphics.print("y = 0.521679*x", 660, 175)
	love.graphics.line(Graph:toRealX(-7), Graph:toRealY(-3.651753), Graph:toRealX(7), Graph:toRealY(3.651753))
	--]]
end
