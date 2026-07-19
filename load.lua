local url = "https://api.github.com/repos/ddrasinx-cloud/enihub-script/contents/script.lua"
local json = game:HttpGet(url)
local b64 = json:match('"content":"(.-)"')
b64 = b64:gsub("%s", "")
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function decode(s)
  local out = ""
  for i = 1, #s, 4 do
    local v = 0
    for j = 1, 4 do
      local c = s:sub(i + j - 1, i + j - 1)
      local idx = 0
      if c ~= "=" then
        idx = (chars:find(c, 1, true) or 1) - 1
      end
      v = v * 64 + idx
    end
    local b2 = v % 256
    local b1 = math.floor(v / 256) % 256
    local b0 = math.floor(v / 65536) % 256
    out = out .. string.char(b0, b1, b2)
  end
  return out
end
local code = decode(b64)
local fn, err = loadstring(code)
if fn then
  fn()
else
  warn("ENI: " .. err)
end
