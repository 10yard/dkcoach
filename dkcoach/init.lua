-- DK Coach by Jon Wilson (10yard)
--
-- Tested with latest MAME versions 0.234 and 0.196
-- Compatible with MAME versions from 0.196
-- Use P2 to toggle the helpfulness setting between 3 (Max), 2 (Min) and 1 (None)
--
-- Minimum start up arguments:
--   mame dkong -plugin dkcoach

local exports = {}
exports.name = "dkcoach"
exports.version = "0.1"
exports.description = "Donkey Kong Coach"
exports.license = "GNU GPLv3"
exports.author = { name = "Jon Wilson (10yard)" }
local dkcoach = exports

function dkcoach.startplugin()
	local char_table = {}
	char_table["0"] = 0x00
	char_table["1"] = 0x01
	char_table["2"] = 0x02
	char_table["3"] = 0x03
	char_table["4"] = 0x04
	char_table["5"] = 0x05
	char_table["6"] = 0x06
	char_table["7"] = 0x07
	char_table["8"] = 0x08
	char_table["9"] = 0x09
	char_table[" "] = 0x10
	char_table["A"] = 0x11
	char_table["B"] = 0x12
	char_table["C"] = 0x13
	char_table["D"] = 0x14
	char_table["E"] = 0x15
	char_table["F"] = 0x16
	char_table["G"] = 0x17
	char_table["H"] = 0x18
	char_table["I"] = 0x19
	char_table["J"] = 0x1a
	char_table["K"] = 0x1b
	char_table["L"] = 0x1c
	char_table["M"] = 0x1d
	char_table["N"] = 0x1e
	char_table["O"] = 0x1f
	char_table["P"] = 0x20
	char_table["Q"] = 0x21
	char_table["R"] = 0x22
	char_table["S"] = 0x23
	char_table["T"] = 0x24
	char_table["U"] = 0x25
	char_table["V"] = 0x26
	char_table["W"] = 0x27
	char_table["X"] = 0x28
	char_table["Y"] = 0x29
	char_table["Z"] = 0x2a
	char_table["_"] = 0x2f
	char_table["<"] = 0x30
	char_table[">"] = 0x31
	char_table["="] = 0x34
	char_table["-"] = 0x35
	char_table["!"] = 0x38
	char_table["'"] = 0x3d
	local help_setting_name = {}
	help_setting_name[1] = " NO"
	help_setting_name[2] = "MIN"
	help_setting_name[3] = "MAX"
	local help_setting = 3
	local spring_startx_default = 22
	local spring_starty_default = 224
	local spring_startx_coach = 180
	local spring_starty_coach = 112
	local barrel_startx_default = 63
	local barrel_starty_default = 240
	local barrel_startx_coach = 115
	local barrel_starty_coach = 206

	function initialize()
		last_help_toggle = os.clock()
		mame_version = tonumber(emu.app_version())
		if mame_version >= 0.227 then
			cpu = manager.machine.devices[":maincpu"]
			scr = manager.machine.screens[":screen"]
			mem = cpu.spaces["program"]
		elseif mame_version >= 0.196 then
			cpu = manager:machine().devices[":maincpu"]
			scr = manager:machine().screens[":screen"]
			mem = cpu.spaces["program"]
		else
			print("----------------------------------------------------------")
			print("The dkcoach plugin requires MAME version 0.196 or greater.")
			print("----------------------------------------------------------")
		end
	end

	function main()
		if mame_version >= 0.196 then
			stage = mem:read_i8(0x6227)
			mode2 = mem:read_u8(0xc600a)

			-- overwrite the rom's highscore text with title and display the active help setting.
			write_message(0x76e0, "    DK COACH   ".."TOGGLE")
			write_message(0x7521, help_setting_name[help_setting].." HELP")

			-- check for P2 button press.
			if string.sub(int_to_bin(mem:read_i8(0x7d00)), 5, 5) == "1" then
				if os.clock() - last_help_toggle > 0.25 then
					-- toggle the active help setting
					help_setting = help_setting - 1
					if help_setting < 1 then
						help_setting = 3
					end
					last_help_toggle = os.clock()
				end
			end
			
			-- stage specific action during gamplay			
			if mode2 == 0xc then
				if stage == 1 then
					barrel_coach()
				elseif stage == 3 then
					spring_coach()
				end
			end
		end
	end

    function barrel_coach()
		if help_setting > 1 then
			-- Change Jumpman's start position to focus coaching on DK's Girder.
			if mem:read_u8(0x694c) == barrel_startx_default and mem:read_u8(0x694f) == barrel_starty_default then
				write_message(0x7619, "-START HERE")
				change_jumpman_position(barrel_startx_coach, barrel_starty_coach)
			else
				if mem:read_u8(0x694f) < barrel_starty_coach then
					write_message(0x7619, "           ")
				end
			end		
		
			jm_x = mem:read_u8(0x6203)
			jm_y = mem:read_u8(0x6205)
			-- convert Jumpman position to drawing system coordinates
			dx = jm_x - 16
			dy = 250 - jm_y
			-- mark Jumpman's location with a spot (for debug)
			-- version_draw_box(dy - 1, dx - 1, dy + 1, dx + 1, 0xffffffff, 0xffffffff)

			if help_setting == 3 then
				-- 3rd girder
				draw_zone("mostlysafe", 94, 120, 75, 137)
				draw_zone("safe", 95, 137, 76, 160)

				-- 4th girder
				draw_zone("safe", 126, 130, 106, 150)
				draw_zone("hazard", 127, 80, 107, 130)

				draw_zone("mostlysafe", 131, 59, 110, 73)

				draw_zone("mostlysafe", 130, 40, 111, 51)

				-- 5th girder
				draw_zone("safe", 162, 128, 142, 183)
				draw_zone("safe", 163, 193, 147, 218)
			end

			if dx >= 120 and dx <= 160 and dy <= 95 and dy >= 75 then
				--version_draw_box(95,120, 75, 160, 0xffffffff, 0x0)
				write_message(0x76f4, "STEER")
			elseif dx >= 80 and dx <= 150 and dy <= 127 and dy >= 106 then
				--version_draw_box(127,80, 106, 150, 0xffffffff, 0x0)
				write_message(0x772c, "WATCH")
				write_message(0x772d, "KONG!")
				write_message(0x7550, "STEER")
			elseif dx >= 53 and dx <=73 and dy <= 131 and dy >= 110 then
				--version_draw_box(131,73, 110, 52, 0xffffffff, 0x0)
				write_message(0x772c, "   WAIT")
				write_message(0x762c, "UNTIL CLEAR")
				write_message(0x74ac, "   ")
				write_message(0x76d0, "STEER")
				write_message(0x7550, "STEER")
			elseif dx >= 10 and dx <= 51 and dy <= 130 and dy >= 111 then
				--version_draw_box(130,10, 111, 51, 0xffffffff, 0x0)
				write_message(0x772c, "WATCH")
				write_message(0x772d, "KONG!")
				write_message(0x76d0, "STEER")
				write_message(0x7550, "STEER")
			else
				-- clear screen info
				write_message(0x76d0, "     ")
				write_message(0x7550, "     ")
				write_message(0x76f4, "      ")
				write_message(0x772c, "       ")
				write_message(0x762c, "           ")
				write_message(0x74ac, "   ")
				write_message(0x772c, "     ")
				write_message(0x772d, "     ")
			end
		else
			-- Clear screen info
			write_message(0x76d0, "     ")
			write_message(0x7550, "     ")
			write_message(0x76f4, "      ")
			write_message(0x772c, "       ")
			write_message(0x762c, "           ")
			write_message(0x74ac, "   ")
			write_message(0x772c, "     ")
			write_message(0x772d, "     ")		
			write_message(0x7619, "           ")
		end
	end

	function spring_coach()
		if help_setting > 1 then
			-- Reset spring types at start of stage
			if mode == 0xb then
				s_type = nil
				s_type_trailing = nil
			end
			
			-- Change Jumpman's start position to focus coaching on DK's Girder.
			if mem:read_u8(0x694c) == spring_startx_default and mem:read_u8(0x694f) == spring_starty_default then
				write_message(0x75ed, "START ")
				write_message(0x75ee, "HERE__")
				change_jumpman_position(spring_startx_coach, spring_starty_coach)
			else
				if mem:read_u8(0x694f) < spring_starty_coach then
					write_message(0x75ed, "      ")
					write_message(0x75ee, "      ")
				end
			end

			if help_setting == 3 then
				-- Draw safe spots.  Box includes a transparent bottom so you can reference jumpman's feet.  Feet need to stay within box to be safe.
				draw_zone("safe", 185, 148, 168, 168)
				draw_zone("safe", 185, 100, 168, 118)
			end

			-- Determine the spring type (0-15) of generated springs
			for _, address in pairs({0x6500, 0x6510, 0x6520, 0x6530, 0x6540, 0x6550}) do
				local s_x = mem:read_u8(address + 3)
				local s_y = mem:read_u8(address + 5)
				if s_y == 80 then             -- y start position of new springs is always 80
					if s_x >= 248 then        -- x start position is between 248 and 7
						s_type = s_x - 248
					elseif s_x <= 7 then
						s_type = s_x + 8
					end
				end
				if (s_x >= 130 and s_x < 170 and s_y == 80) or s_type_trailing == nil or mem:read_i8(0x6229) < 4 then
					-- Remember type of the trailing string.
					s_type_trailing = s_type
				end
			end

			if s_type ~= nil then
				-- Update screen with spring info
				write_message(0x77a5, "T="..string.format("%02d", s_type))
				write_message(0x77a6, "       ")
				if s_type >= 13 then
					write_message(0x77a6, "'LONG'")
				elseif s_type <= 5 then
					write_message(0x77a6, "'SHORT'")
				end
				if help_setting == 3 then
					--1st and 2nd bounce boxes use the latest spring type.
					draw_zone("hazard", 183, 20 + s_type, 168, 33 + s_type)
					draw_zone("hazard", 183, 20 + s_type + 50, 168, 33 + s_type + 50)
					--3rd bounce box uses the trailing spring type on levels 4 and above
					draw_zone("hazard", 183, 20 + s_type_trailing + 100, 168, 33 + s_type_trailing + 100)
				end
			end
		else
			-- Clear screen info
			write_message(0x77a5, "    ")
			write_message(0x77a6, "       ")
			write_message(0x75ed, "      ")
			write_message(0x75ee, "      ")

			-- Change Jumpman's position back to default if necessary.
			if os.clock() - last_help_toggle < 0.05 then
				if mem:read_u8(0x694c) == spring_startx_coach and mem:read_u8(0x694f) == spring_starty_coach then
					change_jumpman_position(spring_startx_default, spring_starty_default)
				end
			end
		end
	end

	function change_jumpman_position(x, y)
		mem:write_u8(0x694c, x)
		mem:write_u8(0x694f, y)
		mem:write_u8(0x6203, x)
		mem:write_u8(0x6205, y)
	end

	function write_message(start_address, text)
		-- write characters of message to DK's video ram
		local _char_table = char_table
		for key=1, string.len(text) do
			mem:write_i8(start_address - ((key - 1) * 32), _char_table[string.sub(text, key, key)])
		end
	end	

	function version_draw_box(y1, x1, y2, x2, c1, c2)
		-- This function handles the version specific syntax of draw_box
		if mame_version >= 0.227 then
			scr:draw_box(y1, x1, y2, x2, c1, c2)
		else
			scr:draw_box(y1, x1, y2, x2, c2, c1)
		end
	end

	function draw_zone(type, y1, x1, y2, x2)
		if type == "hazard" then
			version_draw_box(y1, x1, y2, x2, 0xffff0000, 0x66ff0000)
			scr:draw_line(y1, x1, y2, x2, 0xffff0000)
			scr:draw_line(y2, x1, y1, x2, 0xffff0000)
		elseif type == "safe" then
			version_draw_box(y1, x1, y2, x2, 0xff00ff00, 0x00000000)
			version_draw_box(y1, x1, y2 + 3, x2, 0x00000000, 0x6000ff00)
		elseif type == "mostlysafe" then
			version_draw_box(y1, x1, y2, x2, 0xffffd800, 0x00000000)
			version_draw_box(y1, x1, y2 + 3, x2, 0x00000000, 0x60ffd800)
		end
	end

	function int_to_bin(x)
		local ret = ""
		while x~=1 and x~=0 do
			ret = tostring(x%2) .. ret
			x=math.modf(x/2)
		end
		ret = tostring(x)..ret
		return string.format("%08d", ret)
    end

	emu.register_start(function()
		initialize()
	end)

	emu.register_frame_done(main, "frame")
end
return exports