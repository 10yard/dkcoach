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
	local debug = false

	local message_table = {}
	-- Barrels stage
	message_table["-START HERE"] = 0x7619
	message_table["WAIT"] = 0x76cd
	message_table["UNTIL CLEAR"] = 0x762d
	message_table["WILD !!"] = 0x77a5

	-- Springs stage
	message_table["START"] = 0x75ed
	message_table["HERE__"] = 0x75ee
	message_table["'LONG' "] = 0x77a6
	message_table["'SHORT'"] = 0x77a6

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
			stage, mode2 = mem:read_i8(0x6227), mem:read_u8(0xc600a)

			-- overwrite the rom's highscore text with title and display the active help setting.
			write_message(0x76e0, "    DK COACH   TOGGLE")
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
		jm_x, jm_y, jm_jump = mem:read_u8(0x6203), mem:read_u8(0x6205), mem:read_u8(0x6216)
		-- convert Jumpman position to drawing system coordinates

		if jm_jump == 0 or dx == nil or dy == nil then
			dx, dy = jm_x - 16, 250 - jm_y
		end

		if debug then
			-- mark Jumpman's location with a spot and output x, y to console
			version_draw_box(dy - 1, dx - 1, dy + 1, dx + 1, 0xffffffff, 0xffffffff)
			print(dx.."  "..dy)
		end

		if help_setting > 1 then
			-- Display safe spots
			--2nd girder
			draw_zone("mostlysafe", 62, 74, 43, 96)

			-- 3rd girder
			draw_zone("mostlysafe", 94, 120, 75, 142)
			draw_zone("safe", 95, 142, 76, 162)

			-- 4th girder
			draw_zone("safe", 125, 130, 105, 150)
			draw_zone("safe", 131, 64, 110, 74)
			draw_zone("mostlysafe", 130, 40, 111, 51)

			-- 5th girder
			draw_zone("safe", 155, 10, 135, 30)
			draw_zone("mostlysafe", 160, 96, 140, 118)
			draw_zone("safe", 162, 192, 146, 208)
		end

		if help_setting == 3 then
			-- Change Jumpman's start position to focus coaching on DK's Girder.
			if mem:read_u8(0x694c) == barrel_startx_default and mem:read_u8(0x694f) == barrel_starty_default then
				write_from_table({"-START HERE"})
				change_jumpman_position(barrel_startx_coach, barrel_starty_coach)
			elseif mem:read_u8(0x694f) ~= barrel_starty_coach then
				clear_from_table({"-START HERE"})
			end

			-- Detect wild barrels
			local wild = false
			for _, address in pairs({0x6700, 0x6720, 0x6740, 0x6760, 0x6780, 0x67a0, 0x67c0, 0x67e0}) do
				local b_status, b_crazy, b_y = mem:read_u8(address), mem:read_u8(address + 1), mem:read_u8(address + 5)
				if b_status ~= 0 and b_crazy == 1 and b_y < 236 then
					wild = true
				end
			end

			-- Issue wild barrel warning
			if wild then
				local _dx, _dy = jm_x - 16, 250 - jm_y
				draw_zone("hazard", _dy - 6, _dx - 10, _dy + 16, _dx + 10)
				if flash then
					write_from_table({"WILD !!"})
				end
			else
				clear_from_table({"WILD !!"})
			end

			-- Display steering guides
			if dx >= 62 and dx <= 96 and dy <= 62 and dy >= 43 then
				draw_zone("ladder", 67, 96, 42, 104)
			elseif dx >= 120 and dx <= 162 and dy <= 94 and dy >= 75 then
				draw_zone("ladder", 103, 64, 72, 72)
				draw_zone("ladder", 100, 112, 74, 120)
			elseif dx >= 80 and dx <= 150 and dy <= 125 and dy >= 105 then
				draw_zone("ladder", 136, 168, 104, 176)
			elseif dx >= 10 and dx <= 74 and dy <= 131 and dy >= 111 then
				draw_zone("ladder", 136, 168, 104, 176)
				draw_zone("ladder", 131, 72, 110, 80)
			elseif dx >= 96 and dx <= 184 and dy <= 160 and dy >= 140 then
				draw_zone("ladder", 164, 88, 139, 96)
			elseif dx >= 192 and dx <= 208 and dy <= 162 and dy >= 146 then
				draw_zone("ladder", 164, 88, 139, 96)
				draw_zone("ladder", 161, 184, 145, 192)
			end

			if dy <= 139 and dy >= 109 then
				write_from_table({"WAIT", "UNTIL CLEAR"})
			else
				clear_from_table({"WAIT", "UNTIL CLEAR"})
			end
		else
			clear_from_table({"WAIT", "UNTIL CLEAR", "-START HERE", "WILD !!"})
		end
	end

	function spring_coach()
		if help_setting > 1 then
			-- Reset spring types at start of stage
			if mode2 == 0xb then
				s_type, s_type_trailing = nil, nil
			end
			
			-- Change Jumpman's start position to focus coaching on DK's Girder.
			if mem:read_u8(0x694c) == spring_startx_default and mem:read_u8(0x694f) == spring_starty_default then
				write_from_table({"START", "HERE__"})
				change_jumpman_position(spring_startx_coach, spring_starty_coach)
			else
				if mem:read_u8(0x694f) < spring_starty_coach then
					clear_from_table({"START", "HERE__"})
				end
			end

			if help_setting == 3 then
				-- Draw safe spots.  Box includes a transparent bottom so you can reference jumpman's feet.  Feet need to stay within box to be safe.
				draw_zone("safe", 185, 148, 168, 168)
				draw_zone("safe", 185, 100, 168, 118)
			end

			-- Determine the spring type (0-15) of generated springs
			for _, address in pairs({0x6500, 0x6510, 0x6520, 0x6530, 0x6540, 0x6550}) do
				local s_x, s_y = mem:read_u8(address + 3), mem:read_u8(address + 5)
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
				clear_from_table({"'LONG' ","'SHORT'"})
				if s_type >= 13 then
					write_from_table({"'LONG' "})
				elseif s_type <= 5 then
					write_from_table({"'SHORT'"})
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
			clear_from_table({"'LONG' ","'SHORT'"})
			clear_from_table({"START", "HERE__"})

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

	function write_from_table(messages)
		-- load messages from table and display on screen
		local _message_table = message_table
		for _, message in pairs(messages) do
			address = _message_table[message]
			if address ~= nil then
				write_message(address, message)
			end
		end
	end

	function clear_from_table(messages)
		-- load messages from table and clear from screen
		local _message_table = message_table
		for _, message in pairs(messages) do
			address = _message_table[message]
			if address ~= nil then
				local _spaces = string.format("%"..string.len(message).."s","")
				write_message(address, _spaces)
			end
		end
	end

	function version_draw_box(y1, x1, y2, x2, c1, c2)
		-- Handle the version specific syntax of draw_box
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
		elseif type == "ladder" and flash() then
			version_draw_box(y1, x1, y2 , x2, 0x0, 0xbb0000ff)
		end
	end

	function flash()
		-- flash in time with 1UP
		return math.fmod(mem:read_u8(0xc601a), 32) <= 16
	end

	function int_to_bin(x)
		-- convert integer to binary
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