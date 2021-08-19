-- DK Coach by Jon Wilson (10yard)
-- mame dkong -plugin dkcoach

local exports = {}
exports.name = "dkcoach"
exports.version = "1.0.0"
exports.description = "Donkey Kong Coach"
exports.license = "The BSD 3-Clause License"
exports.author = { name = "Jon Wilson (10yard)" }
local dkcoach = exports

function spring_coach()
	if mem:read_i8(0xc6227) == 3 then       -- Springs stage
		if mem:read_i8(0xc600a) == 0xc then -- During gameplay
			
			-- Draw safe spots.  Box includes a transparent bottom so you can reference jumpman's feet.  Feet need to stay inside the box to be safe.
			draw_box("safe", 185, 148, 168, 168)
			draw_box("safe", 185, 100, 168, 118)
			
			-- Determine the spring type (0-15) of generated springs
			for i, addr in ipairs({0xc6500, 0xc6510, 0xc6520, 0xc6530, 0xc6540, 0xc6550}) do
				s_x = mem:read_u8(addr + 3)
				s_y = mem:read_u8(addr + 5)
				if s_y == 80 then             -- y start position of new springs is always 80
					if s_x >= 248 then        -- x start position is between 248 and 7
						s_type = s_x - 248
					elseif s_x <= 7 then
						s_type = s_x + 8
					end
				end
				if (s_x >= 130 and s_x < 170 and s_y == 80) or s_type_trailing == nil or mem:read_i8(0xc6229) < 4 then
					-- Remember type of the trailing string.
					s_type_trailing = s_type
				end
			end
			
			if s_type ~= nil then
				-- Update screen with spring info
				write_message(0xc77a5, "T="..string.format("%02d", s_type))
				write_message(0xc77a6, "       ")
				if s_type >= 13 then
					write_message(0xc77a6, "(LONG)")
				elseif s_type <= 6 then
					write_message(0xc77a6, "(SHORT)")
				end
				
				--1st and 2nd bounce boxes using latest spring type info.
				draw_box("bounce", 183, 20 + s_type, 168, 33 + s_type)
				draw_box("bounce", 183, 20 + s_type + 50, 168, 33 + s_type + 50)
				--3rd bounce box 
				--At level 4,  the springs move faster so the trailing spring will be the hazard to avoid.
				draw_box("bounce", 183, 20 + s_type_trailing + 100, 168, 33 + s_type_trailing + 100)	
			end
		else
			-- Clear screen info
			write_message(0xc77a5, "    ")		
			write_message(0xc77a6, "       ")
		end
	end
end


function initialize()
		cpu = manager.machine.devices[":maincpu"]
		mem = cpu.spaces["program"]
		scr = manager.machine.screens[":screen"]
		dkchars = {}
		dkchars["0"] = 0x00
		dkchars["1"] = 0x01
		dkchars["2"] = 0x02
		dkchars["3"] = 0x03
		dkchars["4"] = 0x04
		dkchars["5"] = 0x05
		dkchars["6"] = 0x06
		dkchars["7"] = 0x07
		dkchars["8"] = 0x08
		dkchars["9"] = 0x09
		dkchars[" "] = 0x10
		dkchars["A"] = 0x11
		dkchars["B"] = 0x12
		dkchars["C"] = 0x13
		dkchars["D"] = 0x14
		dkchars["E"] = 0x15
		dkchars["F"] = 0x16
		dkchars["G"] = 0x17
		dkchars["H"] = 0x18
		dkchars["I"] = 0x19
		dkchars["J"] = 0x1a
		dkchars["K"] = 0x1b
		dkchars["L"] = 0x1c
		dkchars["M"] = 0x1d
		dkchars["N"] = 0x1e
		dkchars["O"] = 0x1f
		dkchars["P"] = 0x20
		dkchars["Q"] = 0x21
		dkchars["R"] = 0x22
		dkchars["S"] = 0x23
		dkchars["T"] = 0x24
		dkchars["U"] = 0x25
		dkchars["V"] = 0x26
		dkchars["W"] = 0x27
		dkchars["X"] = 0x28
		dkchars["Y"] = 0x29
		dkchars["Z"] = 0x2a
		dkchars["="] = 0x34
		dkchars["("] = 0x3b
		dkchars[")"] = 0x3c
end

function dkcoach.startplugin()

	function write_message(start_address, text)
		-- write characters of message to DK's video ram
		local _dkchars = dkchars
		for key=1, string.len(text) do
			mem:write_i8(start_address - ((key - 1) * 32), _dkchars[string.sub(text, key, key)])
		end
	end	

	function draw_box(type, y1, x1, y2, x2)
		if type == "bounce" then
			scr:draw_box(y1, x1, y2, x2, 0xffff0000, 0x66ff0000)
			scr:draw_line(y1, x1, y2, x2, 0xffff0000)
			scr:draw_line(y2, x1, y1, x2, 0xffff0000)
		elseif type == "safe" then
			scr:draw_box(y1, x1, y2, x2, 0xff00ff00, 0x00000000)
			scr:draw_box(y1, x1, y2 + 4, x2, 0x00000000, 0x6000ff00)
		end
	end

	emu.register_start(function()
		initialize()
	end)

	emu.register_frame_done(spring_coach, "frame")

end
return exports