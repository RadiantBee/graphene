local Graph = require("src/graph")

function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineStyle("smooth")
	Graph:loadData("inputIcUce")
	-- graph settings:

	--Graph.yLogScale = true
	--Graph.xLogScale = true
	--Graph.xStepDelta = 10

	--Graph:loadDataUnc("uncData")

	Graph:print()
	-- colors for individual plots

	--Graph:changeColor("Ib = 15uA", 1, 0, 0)
	--Graph:changeColor("Ib = 30uA", 0, 0, 1)
	--Graph:changeColor("Ib = 60uA", 0, 0.8, 0)

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
