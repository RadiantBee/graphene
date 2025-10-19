local function split(s, delimiter)
	local result = {}
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

local graph = {}

graph.leftmostX = 150
graph.upmostY = 50

graph.makeBoundary = true

graph.arrowHeight = 10
graph.arrowWidth = 5

graph.xAxisLineLength = 500
graph.yAxisLineLength = 500
graph.axisLineWidth = 1

graph.xAxisCaption = "Is[mA]"
graph.yAxisCaption = "Uy[mV]"

graph.xAxisCaptionMargin = 38
graph.yAxisCaptionMargin = 50

graph.textHeight = 5

graph.xLogScale = false
graph.yLogScale = false

graph.xStepDelta = 1
graph.yStepDelta = 0.5

graph.stepLength = 4

graph.xStepAmount = 14
graph.yStepAmount = 14

graph.xStepDist = graph.xAxisLineLength / graph.xStepAmount
graph.yStepDist = graph.yAxisLineLength / graph.yStepAmount

graph.stepNumeration = true

graph.textNumMargin = 8

graph.makeGrid = true
graph.gridLineWidth = 1

graph.showUncertainty = true -- will require another table of values
graph.uncerLineWidth = 1
graph.uncerWingWidth = 3
graph.uncerColor = false -- { 0, 0, 0 } -- set nil if you want them to be the same colot as point

graph.showPoints = true --true
graph.pointRad = 3
graph.pointStyle = "fill"
graph.pointLineWidth = 1

graph.showPlotRough = true
graph.showPlotSmooth = false -- not implemented

graph.plotLineWidth = 1

graph.plotInvertXY = true

graph.showCaptions = true
graph.xCaptionMargin = 60
graph.yCaptionMargin = 15

graph.data = {}
graph.data.y = nil
graph.data.x = {}

graph.unc = {}
graph.unc.y = nil
graph.unc.x = {}

graph.plot = {}

graph.plotUnc = {}

graph.makePlots = function(self)
	if self.plotInvertXY then
		for key, data in pairs(self.data.x) do
			self.plot[key] = {}
			for i, x in ipairs(data) do
				table.insert(self.plot[key], self:toRealX(self.data.y[i]))
				table.insert(self.plot[key], self:toRealY(x))
			end
		end
		if self.showUncertainty then
			for key, data in pairs(self.unc.x) do
				self.plotUnc[key] = {}
				for i, x in ipairs(data) do
					table.insert(self.plotUnc[key], math.abs(self.unc.y[i]) * self.xStepDist)
					table.insert(self.plotUnc[key], math.abs(x) * self.yStepDist)
				end
			end
		end
	else
		for key, data in pairs(self.data.x) do
			self.plot[key] = {}
			for i, x in ipairs(data) do
				table.insert(self.plot[key], self:toRealX(x))
				table.insert(self.plot[key], self:toRealY(self.data.y[i]))
			end
		end
		if self.showUncertainty then
			for key, data in pairs(self.unc.x) do
				self.plotUnc[key] = {}
				for i, x in ipairs(data) do
					table.insert(self.plotUnc[key], math.abs(x) * self.xStepDist)
					table.insert(self.plotUnc[key], math.abs(self.unc.y[i]) * self.yStepDist)
				end
			end
		end
	end
end

graph.printPlots = function(self)
	for key, plot in pairs(self.plot) do
		print(key .. " " .. #plot)
		for _, value in ipairs(plot) do
			io.write(value .. " ")
		end
		print()
	end
end

graph.printPlotsUnc = function(self)
	for key, plot in pairs(self.plotUnc) do
		print(key .. " " .. #plot)
		for _, value in ipairs(plot) do
			io.write(value .. " ")
		end
		print()
	end
end

graph.drawPlots = function(self)
	--love.graphics.circle("fill", self:toRealX(0.05), self:toRealY(-15), 5)

	local j = 0
	for key, plot in pairs(self.plot) do
		love.graphics.setColor(self.data.x[key].color)
		if self.showCaptions then
			love.graphics.print(key, self.leftmostX - self.xCaptionMargin, self.upmostY + j * self.yCaptionMargin)
		end
		if self.showPlotRough then
			love.graphics.setLineWidth(self.plotLineWidth)
			love.graphics.line(plot)
		end
		if self.showPoints then
			love.graphics.setLineWidth(self.pointLineWidth)
			for i = 1, #plot, 2 do
				love.graphics.circle(self.pointStyle, plot[i], plot[i + 1], self.pointRad)
			end
		end
		if self.showUncertainty then
			if self.uncerColor then
				love.graphics.setColor(self.uncerColor)
			end
			love.graphics.setLineWidth(self.uncerLineWidth)
			for i = 1, #plot, 2 do
				-- y uncertainty
				love.graphics.line(
					plot[i],
					plot[i + 1] - self.plotUnc[key][i + 1],
					plot[i],
					plot[i + 1] + self.plotUnc[key][i + 1]
				)
				-- x uncertainty
				love.graphics.line(
					plot[i] - self.plotUnc[key][i],
					plot[i + 1],
					plot[i] + self.plotUnc[key][i],
					plot[i + 1]
				)
				-- y wings
				love.graphics.line(
					plot[i] - self.uncerWingWidth,
					plot[i + 1] - self.plotUnc[key][i + 1],
					plot[i] + self.uncerWingWidth,
					plot[i + 1] - self.plotUnc[key][i + 1]
				)
				love.graphics.line(
					plot[i] - self.uncerWingWidth,
					plot[i + 1] + self.plotUnc[key][i + 1],
					plot[i] + self.uncerWingWidth,
					plot[i + 1] + self.plotUnc[key][i + 1]
				)
				-- x wings
				love.graphics.line(
					plot[i] - self.plotUnc[key][i],
					plot[i + 1] - self.uncerWingWidth,
					plot[i] - self.plotUnc[key][i],
					plot[i + 1] + self.uncerWingWidth
				)
				love.graphics.line(
					plot[i] + self.plotUnc[key][i],
					plot[i + 1] - self.uncerWingWidth,
					plot[i] + self.plotUnc[key][i],
					plot[i + 1] + self.uncerWingWidth
				)
			end
		end
		j = j + 1
	end
end

graph.loadDataUnc = function(self, filename)
	assert(filename, "filename for loading uncertainty was not given!")
	local dataFile = io.open(filename, "r")
	if not dataFile then
		error("Cannot acces the uncertainty file")
	end
	local i = 1
	local currentKey = nil
	for line in dataFile:lines("l") do
		if i == 1 then
			self.unc.y = split(line, " ")
		elseif i % 2 == 0 then
			currentKey = line
		else
			assert(currentKey, "No key was found for x while parsing data! File " .. filename .. " line " .. i)
			self.unc.x[currentKey] = split(line, " ")
		end
		i = i + 1
	end
	dataFile:close()
end

graph.changeColor = function(self, key, r, g, b)
	self.data.x[key].color = { r, g, b }
end

graph.loadData = function(self, filename)
	assert(filename, "filename for loading dataPoints was not given!")
	local dataFile = io.open(filename, "r")
	if not dataFile then
		error("Cannot acces the data file")
	end
	local i = 1
	local currentKey = nil
	for line in dataFile:lines("l") do
		if i == 1 then
			self.data.y = split(line, " ")
		elseif i % 2 == 0 then
			currentKey = line
		else
			assert(currentKey, "No key was found for x while parsing data! File " .. filename .. " line " .. i)
			self.data.x[currentKey] = split(line, " ")
			self.data.x[currentKey].color = { 0, 0, 0 }
		end
		i = i + 1
	end
	dataFile:close()
end

graph.print = function(self)
	io.write("(" .. #self.data.y .. ") y: ")
	for _, value in ipairs(self.data.y) do
		io.write(value .. " ")
	end
	print()
	for key, arr in pairs(self.data.x) do
		io.write("(" .. #self.data.x[key] .. ")[" .. key .. "] -> {")
		for _, value in ipairs(arr) do
			io.write(value .. " ")
		end
		print("}")
	end
end

graph.toRealX = function(self, x)
	if self.xLogScale then
		return self.leftmostX + self.xAxisLineLength / 2 + math.log(x, self.xStepDelta) * self.xStepDist
	else
		return self.leftmostX + self.xAxisLineLength / 2 + (x / self.xStepDelta) * self.xStepDist
	end
end
graph.toRealY = function(self, y)
	if self.yLogScale then
		return self.upmostY + self.yAxisLineLength / 2 - math.log(y, self.yStepDelta) * self.yStepDist
	else
		return self.upmostY + self.yAxisLineLength / 2 - (y / self.yStepDelta) * self.yStepDist
	end
end
graph.toRealPos = function(self, x, y)
	return self.toRealX(x), self.toRealY(y)
end

graph.draw = function(self)
	if self.makeGrid then
		love.graphics.setColor(0.8, 0.8, 0.8)
		love.graphics.setLineWidth(self.gridLineWidth)
		for i = 0, self.xStepAmount - 1, 1 do
			love.graphics.line(
				self.leftmostX + self.xStepDist * i,
				self.upmostY,
				self.leftmostX + self.xStepDist * i,
				self.yAxisLineLength + self.upmostY
			)
		end
		for i = 0, self.yStepAmount - 1, 1 do
			love.graphics.line(
				self.leftmostX,
				self.upmostY + self.yStepDist * (i + 1),
				self.xAxisLineLength + self.leftmostX,
				self.upmostY + self.yStepDist * (i + 1)
			)
		end
	end

	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(self.axisLineWidth)
	love.graphics.line(
		self.leftmostX,
		self.yAxisLineLength / 2 + self.upmostY,
		self.xAxisLineLength + self.leftmostX,
		self.yAxisLineLength / 2 + self.upmostY
	)
	love.graphics.line(
		self.xAxisLineLength / 2 + self.leftmostX,
		self.upmostY,
		self.xAxisLineLength / 2 + self.leftmostX,
		self.yAxisLineLength + self.upmostY
	)
	love.graphics.line(
		self.xAxisLineLength - self.arrowHeight + self.leftmostX,
		self.yAxisLineLength / 2 - self.arrowWidth + self.upmostY,

		self.xAxisLineLength + self.leftmostX,
		self.yAxisLineLength / 2 + self.upmostY,

		self.xAxisLineLength - self.arrowHeight + self.leftmostX,
		self.yAxisLineLength / 2 + self.arrowWidth + self.upmostY
	)
	love.graphics.line(
		self.xAxisLineLength / 2 - self.arrowWidth + self.leftmostX,
		self.arrowHeight + self.upmostY,
		self.xAxisLineLength / 2 + self.leftmostX,
		self.upmostY,
		self.xAxisLineLength / 2 + self.arrowWidth + self.leftmostX,
		self.arrowHeight + self.upmostY
	)
	if self.makeBoundary then
		love.graphics.rectangle("line", self.leftmostX, self.upmostY, self.xAxisLineLength, self.yAxisLineLength)
	end

	if self.xAxisCaption then
		love.graphics.print(
			self.xAxisCaption,
			self.xAxisLineLength + self.leftmostX - self.xAxisCaptionMargin,
			self.yAxisLineLength / 2 + self.upmostY + self.textHeight
		)
	end
	if self.yAxisCaption then
		love.graphics.print(
			self.yAxisCaption,
			self.xAxisLineLength / 2 + self.leftmostX - self.yAxisCaptionMargin,
			self.upmostY
		)
	end

	for i = 0, self.xStepAmount - 1, 1 do
		love.graphics.line(
			self.leftmostX + self.xStepDist * i,
			self.yAxisLineLength / 2 + self.upmostY - self.stepLength,
			self.leftmostX + self.xStepDist * i,
			self.yAxisLineLength / 2 + self.upmostY + self.stepLength
		)
	end
	for i = 0, self.yStepAmount - 1, 1 do
		love.graphics.line(
			self.xAxisLineLength / 2 + self.leftmostX - self.stepLength,
			self.upmostY + self.yStepDist * (i + 1),
			self.xAxisLineLength / 2 + self.leftmostX + self.stepLength,
			self.upmostY + self.yStepDist * (i + 1)
		)
	end

	if self.stepNumeration then
		local tempVal
		if self.xLogScale then
			for i = 0, self.xStepAmount - 1, 1 do
				tempVal = self.xStepDelta ^ (i - self.xStepDelta / 2)
				love.graphics.print(
					tempVal,
					self.leftmostX + self.xStepDist * i - self.textNumMargin,
					self.yAxisLineLength / 2 + self.upmostY - self.stepLength + self.textHeight
				)
			end
		else
			for i = 0, self.xStepAmount - 1, 1 do
				tempVal = self.xStepDelta - self.xStepDelta * (self.xStepAmount / 2 - i + 1)
				love.graphics.print(
					tempVal ~= 0 and tempVal or "",
					self.leftmostX + self.xStepDist * i - self.textNumMargin,
					self.yAxisLineLength / 2 + self.upmostY - self.stepLength + self.textHeight
				)
			end
		end

		if self.yLogScale then
			for i = 1, self.yStepAmount, 1 do
				tempVal = self.yStepDelta ^ (self.yStepAmount / 2 - i)
				love.graphics.print(
					tempVal,
					self.xAxisLineLength / 2 + self.leftmostX - self.textNumMargin * 3,
					self.upmostY + self.yStepDist * i - self.textHeight
				)
			end
		else
			for i = 1, self.yStepAmount, 1 do
				tempVal = self.yStepDelta * (self.yStepAmount / 2 - i)
				love.graphics.print(
					tempVal ~= 0 and tempVal or "",
					self.xAxisLineLength / 2 + self.leftmostX - self.textNumMargin * 3,
					self.upmostY + self.yStepDist * i - self.textHeight
				)
			end
		end
	end
end

return graph
