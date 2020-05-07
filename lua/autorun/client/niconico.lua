-- All messages floating along the screen
local NNDMessages = {}

-- Lots of solid colors for readability
local NNDColors = {
	Color(255, 255, 255),
	Color(255, 0, 0),
	Color(255, 255, 0),
	Color(0, 255, 255),
	Color(0, 255, 255)
}

-- Parameters for velocity and position
local Resolution = 5000
local Speed = 500
local YDisplace = 200

-- Nico Nico Douga style chat
hook.Add("OnPlayerChat", "InterpretNNDChat", function(p, txt)
	print(RealFrameTime())
	local msgtxt = p:GetName()..": "..txt
	local vert = math.Rand(0, YDisplace * 2)
	local color = table.Random(NNDColors)

	local message = { 0, vert, color, msgtxt }
	table.insert(NNDMessages, message)

	return ""
end )

hook.Add("DrawOverlay", "DrawNNDChat", function()
	-- Most obtuse deafult font we can find
	surface.SetFont("DermaLarge")

	for i, msg in pairs(NNDMessages) do
		-- Advance along the screen (and scale by FPS)
		msg[1] = msg[1] + (Speed * RealFrameTime())

		-- Scroll from the right
		local relpos = (Resolution - msg[1]) / Resolution
		local pos = relpos * ScrW()

		-- Use our randomized color
		surface.SetTextColor(msg[3].r, msg[3].g, msg[3].b)

		-- Actually draw
		surface.SetTextPos(pos, msg[2])
		surface.DrawText(msg[4])

		-- Remove messages as they reach the edge of the screen
		local width = surface.GetTextSize(msg[4])
		if pos + width < 0 then
			table.remove(NNDMessages, i)
		end
	end
end )
