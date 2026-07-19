-- the use of tests/test.lua is done by comparing the output between 5.1 and 5.3
-- it's not adapted for our case, select a few for basic operations

package.path  = "./?.lua;./?/init.lua"
package.cpath = "./?.so"

require("compat53")
  
local failures = 0
local function test(name, f)
  print("testing " .. name .. "...")
  local ok, err = pcall(require, "compat53." .. name)
  if not ok then
    failures = failures + 1
    print("FAIL: " .. err)
    return
  end

  ok, err = pcall(f)
  if ok then
    print(name .. "... OK")
  else
    failures = failures + 1
    print("FAIL: " .. err)
  end
end

test("utf8", function()
  local unpack = table.unpack or unpack
  local function utf8rt(s)
    local t = { utf8.codepoint(s, 1, #s) }
    local ps, cs = {}, {}
    for p,c in utf8.codes(s) do
      ps[#ps+1], cs[#cs+1] = p, c
    end
    print("utf8.codes", unpack(ps))
    print("utf8.codes", unpack(cs))
    print("utf8.codepoint", unpack(t))
    print("utf8.len", utf8.len(s), #t, #s)
    print("utf8.char", utf8.char(unpack(t)))
  end
  utf8rt("äöüßÄÖÜ")
  utf8rt("abcdefg")
  local s = "äöüßÄÖÜ"
  print("utf8.offset", utf8.offset(s, 1, 1))
  print("utf8.offset", utf8.offset(s, 2, 1))
  print("utf8.offset", utf8.offset(s, 3, 1))
  print("utf8.offset", pcall(utf8.offset, s, 3, 2))
  print("utf8.offset", utf8.offset(s, 3, 3))
  print("utf8.offset", utf8.offset(s, -1, 7))
  print("utf8.offset", utf8.offset(s, -2, 7))
  print("utf8.offset", utf8.offset(s, -3, 7))
  print("utf8.offset", utf8.offset(s, -1))
end)

test("string", function()
  local format = "bBhHlLjJdc3z"
  local s = string.pack(format, -128, 255, -32768, 65535, -2147483648, 4294967295, -32768, 65536, 1.25, "abc", "defgh")
  print("string.unpack", string.unpack(format, s))
end)

test("table", function()
  local t = table.pack("a", nil, "b", nil)
  print("table.(un)pack()", t.n, table.unpack(t, 1, t.n))
end)

if failures == 0 then
  print("tests PASSED")
else
  print("tests FAILED (" .. failures .. " failures)")
  os.exit(1)
end
