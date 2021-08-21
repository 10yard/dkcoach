-- DK Coach by Jon Wilson (10yard)
-- Tested with MAME version 0.234
-- Compatible with MAME versions from 0.196
-- Use P2 to toggle the helpfulness setting between 2 (Max), 1 (Min) and 0 (None)
-- mame dkong -plugin dkcoach

local exports = {}
exports.name = "dkcoach"
exports.version = "1.0.0"
exports.description = "Donkey Kong Coach"
exports.license = "The BSD 3-Clause License"
exports.author = { name = "Jon Wilson (10yard)" }
local dkcoach = exports

function dkcoach.startplugin()
	-- Plugin globals
	char_table = {}
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
	char_table["="] = 0x34
	char_table["'"] = 0x3d
	help_setting_name = {}
	help_setting_name[0] = " NO"
	help_setting_name[1] = "MIN"
	help_setting_name[2] = "MAX"

	function initialize()
		help_setting = 2
		last_help_toggle = os.clock()
		version = tonumber(emu.app_version())
		if version >= 0.227 then
			cpu = manager.machine.devices[":maincpu"]
			scr = manager.machine.screens[":screen"]
			mem = cpu.spaces["program"]
		elseif version >= 0.196 then
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
		if version >= 0.196 then
			-- overwrite the rom's highscore text
			write_message(0xc76e0, "   DK COACH    ".."TOGGLE")
			write_message(0xc76e1, "   DK COACH   "..help_setting_name[help_setting].." HELP")

			-- check for P2 button press
			if string.sub(int_to_bin(mem:read_i8(0xc7d00)), 5, 5) == "1" then
				if os.clock() - last_help_toggle > 0.25 then
					help_setting = help_setting - 1
					if help_setting < 0 then
						help_setting = 2
					end
					last_help_toggle = os.clock()
				end
			end

			-- stage specific action
			local stage = mem:read_i8(0xc6227)
			if stage == 3 then
				spring_coach()
			end
		end
	end

	function spring_coach()
		if mem:read_i8(0xc600a) == 0xc and help_setting > 0 then  -- During gameplay
			if help_setting == 2 then
				-- Draw safe spots.  Box includes a transparent bottom so you can reference jumpman's feet.  Feet need to stay within box to be safe.
				draw_zone("spring-safe", 185, 148, 168, 168)
				draw_zone("spring-safe", 185, 100, 168, 118)
			end

			-- Determine the spring type (0-15) of generated springs
			for _, address in pairs({0xc6500, 0xc6510, 0xc6520, 0xc6530, 0xc6540, 0xc6550}) do
				local s_x = mem:read_u8(address + 3)
				local s_y = mem:read_u8(address + 5)
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
					write_message(0xc77a6, "'LONG'")
				elseif s_type <= 6 then
					write_message(0xc77a6, "'SHORT'")
				end
				if help_setting == 2 then
					--1st and 2nd bounce boxes use the latest spring type.
					draw_zone("spring-hazard", 183, 20 + s_type, 168, 33 + s_type)
					draw_zone("spring-hazard", 183, 20 + s_type + 50, 168, 33 + s_type + 50)
					--3rd bounce box uses the trailing spring type on levels 4 and above
					draw_zone("spring-hazard", 183, 20 + s_type_trailing + 100, 168, 33 + s_type_trailing + 100)
				end
			end
		else
			-- Clear screen info
			write_message(0xc77a5, "    ")
			write_message(0xc77a6, "       ")
		end
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
		if version >= 0.227 then
			scr:draw_box(y1, x1, y2, x2, c1, c2)
		else
			scr:draw_box(y1, x1, y2, x2, c2, c1)
		end
	end

	function draw_zone(type, y1, x1, y2, x2)
		if type == "spring-hazard" then
			version_draw_box(y1, x1, y2, x2, 0xffff0000, 0x66ff0000)
			scr:draw_line(y1, x1, y2, x2, 0xffff0000)
			scr:draw_line(y2, x1, y1, x2, 0xffff0000)
		elseif type == "spring-safe" then
			version_draw_box(y1, x1, y2, x2, 0xff00ff00, 0x00000000)
			version_draw_box(y1, x1, y2 + 4, x2, 0x00000000, 0x6000ff00)
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