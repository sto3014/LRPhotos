use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

property map_macroman_to_unicode : {¬
	"0x00C4", ¬
	"0x00C5", ¬
	"0x00C7", ¬
	"0x00C9", ¬
	"0x00D1", ¬
	"0x00D6", ¬
	"0x00DC", ¬
	"0x00E1", ¬
	"0x00E0", ¬
	"0x00E2", ¬
	"0x00E4", ¬
	"0x00E3", ¬
	"0x00E5", ¬
	"0x00E7", ¬
	"0x00E9", ¬
	"0x00E8", ¬
	"0x00EA", ¬
	"0x00EB", ¬
	"0x00ED", ¬
	"0x00EC", ¬
	"0x00EE", ¬
	"0x00EF", ¬
	"0x00F1", ¬
	"0x00F3", ¬
	"0x00F2", ¬
	"0x00F4", ¬
	"0x00F6", ¬
	"0x00F5", ¬
	"0x00FA", ¬
	"0x00F9", ¬
	"0x00FB", ¬
	"0x00FC", ¬
	"0x2020", ¬
	"0x00B0", ¬
	"0x00A2", ¬
	"0x00A3", ¬
	"0x00A7", ¬
	"0x2022", ¬
	"0x00B6", ¬
	"0x00DF", ¬
	"0x00AE", ¬
	"0x00A9", ¬
	"0x2122", ¬
	"0x00B4", ¬
	"0x00A8", ¬
	"0x2260", ¬
	"0x00C6", ¬
	"0x00D8", ¬
	"0x221E", ¬
	"0x00B1", ¬
	"0x2264", ¬
	"0x2265", ¬
	"0x00A5", ¬
	"0x00B5", ¬
	"0x2202", ¬
	"0x2211", ¬
	"0x220F", ¬
	"0x03C0", ¬
	"0x222B", ¬
	"0x00AA", ¬
	"0x00BA", ¬
	"0x03A9", ¬
	"0x00E6", ¬
	"0x00F8", ¬
	"0x00BF", ¬
	"0x00A1", ¬
	"0x00AC", ¬
	"0x221A", ¬
	"0x0192", ¬
	"0x2248", ¬
	"0x2206", ¬
	"0x00AB", ¬
	"0x00BB", ¬
	"0x2026", ¬
	"0x00A0", ¬
	"0x00C0", ¬
	"0x00C3", ¬
	"0x00D5", ¬
	"0x0152", ¬
	"0x0153", ¬
	"0x2013", ¬
	"0x2014", ¬
	"0x201C", ¬
	"0x201D", ¬
	"0x2018", ¬
	"0x2019", ¬
	"0x00F7", ¬
	"0x25CA", ¬
	"0x00FF", ¬
	"0x0178", ¬
	"0x2044", ¬
	"0x20AC", ¬
	"0x2039", ¬
	"0x203A", ¬
	"0xFB01", ¬
	"0xFB02", ¬
	"0x2021", ¬
	"0x00B7", ¬
	"0x201A", ¬
	"0x201E", ¬
	"0x2030", ¬
	"0x00C2", ¬
	"0x00CA", ¬
	"0x00C1", ¬
	"0x00CB", ¬
	"0x00C8", ¬
	"0x00CD", ¬
	"0x00CE", ¬
	"0x00CF", ¬
	"0x00CC", ¬
	"0x00D3", ¬
	"0x00D4", ¬
	"0xF8FF", ¬
	"0x00D2", ¬
	"0x00DA", ¬
	"0x00DB", ¬
	"0x00D9", ¬
	"0x0131", ¬
	"0x02C6", ¬
	"0x02DC", ¬
	"0x00AF", ¬
	"0x02D8", ¬
	"0x02D9", ¬
	"0x02DA", ¬
	"0x00B8", ¬
	"0x02DD", ¬
	"0x02DB", ¬
	"0x02C7"}


property hex_chars : "0123456789ABCDEF"

on macromanToUnicode(code)
	if code ≤ 127 then
		return code
	else
		return hexToNumber(item (code - 127) of map_macroman_to_unicode)
	end if
end macromanToUnicode
--
-- converts a base string to decimal integer
-- case sensetive because of the offset command
on BaseToDec(h)
	set m to length of hex_chars
	set n to 0
	set i to -1
	repeat with this_char in reverse of characters of h
		set i to i + 1
		set o to (offset of this_char in hex_chars)
		if o is 0 then
			set n to 0
			exit repeat
		end if
		set char_val to o - 1
		set n to n + char_val * (m ^ i)
	end repeat
	return n div 1
end BaseToDec

on hexToNumber(hex)
	set AppleScript's text item delimiters to "0x"
	set hexString to text item 2 of hex
	set AppleScript's text item delimiters to " "
	return BaseToDec(hexString)
end hexToNumber

on mapMacRomanToUnicode(code)
	if code ≤ 127 then
		return code
	else
		return hexToNumber(unicodeString to item (code - 127) of map_1252mac_to_unicode)
	end if
	
end mapMacRomanToUnicode

on toUTF8(strMacRoman)
	local result_utf8
	set result_utf8 to ""
	repeat with pos from 1 to count strMacRoman
		set code to (the ASCII number item pos of strMacRoman)
		set result_utf8 to result_utf8 & unicode_to_utf8(macromanToUnicode(code))
	end repeat
	return result_utf8
end toUTF8

on unicode_to_utf8(code)
	-- converts numeric UTF code (U+code) to UTF-8 string
	set t to {}
	set h to 128
	repeat while code ≥ h
		set end of t to 128 + code mod 64
		-- t[#t+1] = 128 + code%64
		set code to floor(code / 64)
		-- code = floor(code/64)
		if h > 32 then
			set h to 32
		else
			set h to h / 2
		end if
		-- h = h > 32 and 32 or h/2
	end repeat
	set end of t to 256 - 2 * h + code
	set res to ""
	repeat with pos from (count of t) to 1 by -1
		set res to res & (ASCII character item pos of t)
	end repeat
	return res
	-- t[#t+1] = 256 - 2*h + code
	-- return char(unpack(t)):reverse()
end unicode_to_utf8

on floor(x)
	set y to x div 1
	if x < 0 and x mod 1 is not 0 then
		set y to y - 1
	end if
	return y
end floor


