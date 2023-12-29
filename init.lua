-- MIT License

-- Copyright (c) 2023 Northn
-- Read more here:
-- * https://github.com/Northn/mimgui_svg/

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local ffi = require 'ffi'
local mimgui = require 'mimgui'

local mimgui_svg = {}

local libPath = getWorkingDirectory() .. [[\lib\mimgui_svg\mimgui_svg_lib]]

ffi.cdef[[
    LPDIRECT3DTEXTURE9 mimgui_svg_load_from_data(const char *data, const int size, const int width, const int height);
    void mimgui_svg_release(LPDIRECT3DTEXTURE9 tex);
    const char *mimgui_svg_version();
]]

local lib = ffi.load(libPath)

--- Load svg from memory
--- @param src
--- @param size
--- @param width
--- @param height
--- @return LPDIRECT3DTEXTURE9
function mimgui_svg.loadFromMemory(src, size, width, height)
    if type(src) == 'number' then
		src = ffi.cast('LPCVOID', src)
	end
	local tex = lib.mimgui_svg_load_from_data(src, size, width, height)
	if tex == nil then
		return nil
	end
    return ffi.gc(tex, lib.mimgui_svg_release)
end

--- Load svg from file
--- @param src
--- @param size
--- @param width
--- @param height
--- @return LPDIRECT3DTEXTURE9
function mimgui_svg.loadFromFile(src, width, height)
    local f = io.open(src, 'r')
    if not f then
        return nil
    end
    local data = f:read('*a')
    f:close()
    local src = ffi.new('const char*', data)
    local size = #data
    return mimgui_svg.loadFromMemory(src, size, width, height)
end

mimgui_svg.VERSION = lib.mimgui_svg_version()

return mimgui_svg
