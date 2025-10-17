local graph = {}

graph.leftmostX = 250
graph.upmostY = 50

graph.makeBoundary = true

graph.arrowHeight = 10
graph.arrowWidth = 5

graph.xAxisLineLength = 500
graph.yAxisLineLength = 500

graph.xAxisCaption = "Ud[U]"
graph.yAxisCaption = "Id[mA]"

graph.xAxisCaptionMargin = 38
graph.yAxisCaptionMargin = 50

graph.textHeight = 5

graph.xStepDelta = 10
graph.yStepDelta = 10

graph.stepLength = 4

graph.xStepAmount = 10
graph.yStepAmount = 10

graph.xStepDist = graph.xAxisLineLength / graph.xStepAmount
graph.yStepDist = graph.yAxisLineLength / graph.yStepAmount

graph.stepNumeration = true

graph.textNumMargin = 8

graph.makeGrid = true

graph.loadData = function(self, filename)
	assert(filename, "filename was not given!")
end

graph.toRealX = function(self, x)
	return self.leftmostX + self.xAxisLineLength / 2 + x * self.xStepDelta / 2
end
graph.toRealY = function(self, y)
	return self.upmostY + self.yAxisLineLength / 2 - y * self.yStepDelta / 2
end
graph.toRealPos = function(self, x, y)
	return self.toRealX(x), self.toRealY(y)
end

graph.draw = function(self)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineStyle("smooth")

	if self.makeGrid then
		love.graphics.setColor(0.8, 0.8, 0.8)
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
		love.graphics.setColor(0, 0, 0)
	end
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
	love.graphics.line(self.xAxisLineLength / 2 - self.arrowWidth + self.leftmostX, self.arrowHeight + self.upmostY, self.xAxisLineLength / 2 + self.leftmostX, self.upmostY, self.xAxisLineLength / 2 + self.arrowWidth + self.leftmostX, self.arrowHeight + self.upmostY)
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
		for i = 0, self.xStepAmount - 1, 1 do
			tempVal = self.xStepDelta - self.xStepDelta * (self.xStepAmount / 2 - i + 1)
			love.graphics.print(
				tempVal ~= 0 and tempVal or "",
				self.leftmostX + self.xStepDist * i - self.textNumMargin,
				self.yAxisLineLength / 2 + self.upmostY - self.stepLength + self.textHeight
			)
		end
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

return graph
