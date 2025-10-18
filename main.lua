local Graph = require("src/graph")

function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineStyle("smooth")
	Graph:loadData("inputDataLED")
	-- graph settings:

	Graph.axisLineWidth = 1

	Graph.makeGrid = true
	Graph.gridLineWidth = 1

	Graph.makeBoundary = true

	Graph.stepNumeration = true
	Graph.showUncertainty = false -- requires adittional file with uncertainties

	Graph.showPoints = true
	Graph.pointRad = 3
	Graph.pointStyle = "fill"
	Graph.pointLineWidth = 1

	Graph.showPlotRough = true
	Graph.showPlotSmooth = false

	Graph.plotLineWidth = 2

	Graph.showCaptions = true
	Graph.xCaptionMargin = 70
	Graph.yCaptionMargin = 15

	Graph:print()
	-- colors for individual plots
	Graph:changeColor("Red LED", 1, 0, 0)
	Graph:changeColor("Green LED", 0, 1, 0)
	Graph:changeColor("Blue LED", 0, 0, 1)

	Graph:makePlots()
	Graph:printPlots()
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
