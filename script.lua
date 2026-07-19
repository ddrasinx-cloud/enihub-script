-- ENI Hub v2
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local SECRET = "E7n1HuB_S3cr3t_K3y!_2026#Pr3mium"
local authenticated = false
local keyStr = ""
local guiParent

-- ===== GUI PARENT =====
do
    local ok, g = pcall(function()
        local s = Instance.new("ScreenGui")
        s.Name = "ENIHub"
        s.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        if syn and syn.protect_gui then syn.protect_gui(s); s.Parent = game:GetService("CoreGui")
        elseif gethui then s.Parent = gethui()
        else s.Parent = game:GetService("CoreGui") end
        return s
    end)
    if ok and g then guiParent = g end
end

-- ===== DRAWING =====
local drawObjs = {}; local conns = {}
local function d(t,p) local o=Drawing.new(t) for k,v in pairs(p) do o[k]=v end table.insert(drawObjs,o) return o end
local function c(obj,ev,fn) local con=obj[ev]:Connect(fn) table.insert(conns,con) return con end
local function kill() for _,v in ipairs(conns) pcall(v.Disconnect,v) end conns={} for _,v in ipairs(drawObjs) pcall(v.Remove,v) end drawObjs={} end

-- ===== PURE LUA SHA-256 =====
local function ror(x,n)x=x%0x100000000 n=n%32 local low=x%(2^n)local high=math.floor(x/(2^n))return low*2^(32-n)+high end
local function band(x,y)local r=0 local m=1 while x>0 or y>0 do if x%2==1 and y%2==1 then r=r+m end x=math.floor(x/2)y=math.floor(y/2)m=m*2 end return r end
local function bor(x,y)local r=0 local m=1 while x>0 or y>0 do if x%2==1 or y%2==1 then r=r+m end x=math.floor(x/2)y=math.floor(y/2)m=m*2 end return r end
local function bxor(x,y)local r=0 local m=1 while x>0 or y>0 do local a=x%2 local b=y%2 if a~=b then r=r+m end x=math.floor(x/2)y=math.floor(y/2)m=m*2 end return r end
local function lshift(x,n)return x*2^n end
local function rshift(x,n)return math.floor(x/2^n)end
local function bnot(x)return 2^32-1-x end
local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function sha256(msg)
    local H={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
    local ml=#msg*8;msg[#msg+1]=0x80
    while(#msg*8)%512~=448 do msg[#msg+1]=0 end
    for i=7,0,-1 do msg[#msg+1]=band(rshift(ml,i*8),0xff)end
    for i=1,#msg,64 do
        local w={};for j=1,16 do w[j]=0 for k=1,4 do w[j]=bor(lshift(w[j],8),msg[i+(j-1)*4+k-1]or 0)end end
        for j=17,64 do
            local s0=bxor(bxor(ror(w[j-15],7),ror(w[j-15],18)),rshift(w[j-15],3))
            local s1=bxor(bxor(ror(w[j-2],17),ror(w[j-2],19)),rshift(w[j-2],10))
            w[j]=band(w[j-16]+s0+w[j-7]+s1,0xFFFFFFFF)
        end
        local a,b,c,d,e,f,g,h=H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
        for j=1,64 do
            local S1=bxor(bxor(ror(e,6),ror(e,11)),ror(e,25))
            local ch=bor(band(e,f),band(bnot(e),g))
            local t1=band(h+S1+ch+K[j]+w[j],0xFFFFFFFF)
            local S0=bxor(bxor(ror(a,2),ror(a,13)),ror(a,22))
            local maj=bxor(bxor(band(a,b),band(a,c)),band(b,c))
            local t2=band(S0+maj,0xFFFFFFFF)
            h,g,f,e,d,c,b,a=g,f,e,band(d+t1,0xFFFFFFFF),c,b,a,band(t1+t2,0xFFFFFFFF)
        end
        for j=1,8 do H[j]=band(H[j]+({a,b,c,d,e,f,g,h})[j],0xFFFFFFFF)end
    end
    local out={};for i=1,8 do for j=3,0,-1 do out[#out+1]=band(rshift(H[i],j*8),0xff)end end
    return out
end
local function str2bytes(s)local t={}for i=1,#s do t[#t+1]=s:byte(i)end return t end
local function bytes2hex(b)local t={}for i=1,#b do t[#t+1]=string.format("%02x",b[i])end return table.concat(t)end
local function hmacSHA256(msg,secret)
    local key=str2bytes(secret)
    while #key>64 do key=sha256(key)end
    while #key<64 do key[#key+1]=0 end
    local opad={};local ipad={}
    for i=1,64 do opad[i]=bxor(key[i],0x5c);ipad[i]=bxor(key[i],0x36)end
    for i=1,#msg do ipad[#ipad+1]=msg:byte(i)end
    local inner=sha256(ipad)
    for i=1,#inner do opad[#opad+1]=inner[i]end
    return bytes2hex(sha256(opad))
end
local function base64decode(s)
    local b="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    s=s:gsub("[^%w%+%/]","")
    local pad=(4-#s%4)%4;if pad>0 then s=s..string.rep("=",pad)end
    local out={}
    for i=1,#s,4 do
        local v=0;for j=1,4 do local c=s:sub(i+j-1,i+j-1)local idx=c~="="and(b:find(c)or 1)-1 or 0 v=v*64+idx end
        out[#out+1]=band(rshift(v,16),0xff)out[#out+1]=band(rshift(v,8),0xff)out[#out+1]=band(v,0xff)
    end
    local t={};for i=1,#out do if out[i]then t[#t+1]=string.char(out[i])end end
    return table.concat(t)
end
local function validateKey(key)
    key=key:upper()if key:sub(1,4)~="ENI-"then return false end
    local rest=key:sub(5)local parts={}
    for p in rest:gmatch("[^-]+")do parts[#parts+1]=p end
    if #parts~=2 then return false end
    local payload,sig=parts[1],parts[2]
    local expectedSig=hmacSHA256(payload,SECRET):sub(1,12)
    if sig~=expectedSig:upper()then return false end
    local json=base64decode(payload)
    local exp=json:match('"x":([^,}]+)')
    if exp and tonumber(exp)and tonumber(exp)>0 and tonumber(exp)<os.time()*1000 then return false end
    return true
end

-- ===== GUI HELPERS =====
local ac = Color3.fromRGB(0,180,210)
local bg = Color3.fromRGB(10,10,14)
local bg2 = Color3.fromRGB(16,16,20)
local txt = Color3.fromRGB(210,210,220)
local txt2 = Color3.fromRGB(120,120,130)
local red = Color3.fromRGB(220,60,60)
local green = Color3.fromRGB(46,204,113)

local function new(v,p)
    local o = Instance.new(v)
    for k,v in pairs(p or {}) do o[k] = v end
    return o
end

local function makeBtn(parent, text, pos, size, cb)
    local f = new("TextButton",{Text="",BackgroundTransparency=1,Parent=parent})
    local bgF = new("Frame",{BackgroundColor3=Color3.fromRGB(45,45,52),BorderSizePixel=0,Parent=f})
    local lbl = new("TextLabel",{Text=text,BackgroundTransparency=1,TextColor3=txt,TextSize=13,Font=Enum.Font.Gotham,Parent=f})
    local function up(s)
        bgF.BackgroundColor3 = s and Color3.fromRGB(0,180,210) or Color3.fromRGB(45,45,52)
        lbl.TextColor3 = s and Color3.new(1,1,1) or txt
    end
    f.MouseButton1Click:Connect(function() cb(f) end)
    f.MouseEnter:Connect(function() if not f._on then bgF.BackgroundColor3 = Color3.fromRGB(55,55,62) end end)
    f.MouseLeave:Connect(function() if not f._on then bgF.BackgroundColor3 = Color3.fromRGB(45,45,52) end end)
    return f, bgF, lbl, up
end

-- ===== KEY ENTRY GUI =====
local keyGui = guiParent and new("Frame",{
    Name="KeyEntry",Size=UDim2.new(0,380,0,280),Position=UDim2.new(0.5,-190,0.5,-140),
    BackgroundColor3=bg,BorderColor3=ac,BorderSizePixel=2,Parent=guiParent
})
if keyGui then
    local uc = new("UICorner",{CornerRadius=UDim.new(0,8),Parent=keyGui})
    local inn = new("Frame",{Size=UDim2.new(1,-4,1,-4),Position=UDim2.new(0,2,0,2),BackgroundColor3=bg,BorderSizePixel=0,Parent=keyGui})
    new("UICorner",{CornerRadius=UDim.new(0,6),Parent=inn})

    new("TextLabel",{Text="ENI HUB",Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,20),BackgroundTransparency=1,
        TextColor3=ac,TextSize=30,Font=Enum.Font.GothamBold,Parent=inn})
    new("TextLabel",{Text="ENTER YOUR KEY",Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,60),BackgroundTransparency=1,
        TextColor3=txt2,TextSize=13,Font=Enum.Font.Gotham,Parent=inn})

    local ibg = new("Frame",{Size=UDim2.new(0,320,0,46),Position=UDim2.new(0.5,-160,0,98),BackgroundColor3=bg2,BorderSizePixel=0,Parent=inn})
    new("UICorner",{CornerRadius=UDim.new(0,6),Parent=ibg})
    local iborder = new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=1,BorderColor3=ac,Parent=ibg})
    new("UICorner",{CornerRadius=UDim.new(0,6),Parent=iborder})

    local keyDisplay = new("TextLabel",{Text="",Size=UDim2.new(1,-24,1,0),Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1,TextColor3=txt,TextSize=20,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,Parent=ibg})
    local cursorG = new("TextLabel",{Text="_",Size=UDim2.new(0,12,1,0),Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1,TextColor3=ac,TextSize=20,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,Parent=ibg})

    -- animate cursor blink
    local cVis = true
    task.spawn(function() while keyGui and keyGui.Parent do task.wait(0.5) cVis = not cVis cursorG.Visible = cVis end end)

    local uline = new("Frame",{Size=UDim2.new(0,320,0,2),Position=UDim2.new(0.5,-160,0,144),BackgroundColor3=ac,BorderSizePixel=0,Parent=inn})

    local statusLbl = new("TextLabel",{Text="",Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,162),
        BackgroundTransparency=1,TextSize=13,Font=Enum.Font.Gotham,Parent=inn})

    local hintLbl = new("TextLabel",{Text="Key from seller  Â·  Enter to submit",Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,220),
        BackgroundTransparency=1,TextColor3=Color3.fromRGB(80,80,90),TextSize=11,Font=Enum.Font.Gotham,Parent=inn})

    local function updateKeyDisplay()
        keyDisplay.Text = keyStr
        local tw = keyDisplay.TextBounds.X
        cursorG.Position = UDim2.new(0,12+tw,0,0)
    end

    c(UIS,"InputBegan",function(input)
        if authenticated then return end
        if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode~=Enum.KeyCode.Unknown then
            local kc=input.KeyCode
            if kc==Enum.KeyCode.Return or kc==Enum.KeyCode.KeypadEnter then
                if#keyStr==0 then return end
                if validateKey(keyStr)then
                    statusLbl.Text="âs Valid key!"statusLbl.TextColor3=green
                    task.wait(0.5)authenticated=true
                    keyGui:Destroy()
                else
                    statusLbl.Text="âs Invalid key"statusLbl.TextColor3=red
                    keyStr=""updateKeyDisplay()
                end
                return
            end
            if kc==Enum.KeyCode.Backspace then keyStr=keyStr:sub(1,-2)updateKeyDisplay()return end
            local char=input.KeyCode.Name
            if #char==1 and char:match("%w")then
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift)or UIS:IsKeyDown(Enum.KeyCode.RightShift)then keyStr=keyStr..char:upper()
                else keyStr=keyStr..char end
                updateKeyDisplay()
            end
            if char=="Minus"then keyStr=keyStr.."-"updateKeyDisplay()end
        end
    end)
else
    -- fallback drawing UI
    -- (omitted for brevity â¬ Drawing fallback not needed if GUI works)
    print("ENI Hub: GUI parent not available, using console")
end

-- ===== FEATURES =====
local aimOn=false;local espOn=false;local traceOn=false;local fovOn=false;local radarOn=false;local uiOpen=true
local aimFov=200;local smooth=0.6

local espPool={}
local function getEsp(i)
    while #espPool<i do table.insert(espPool,{box=d("Square",{Color=Color3.fromRGB(0,180,210),Thickness=1.5,Filled=false,Transparency=1}),fill=d("Square",{Color=Color3.new(0,0,0),Filled=true,Transparency=0.55}),nam=d("Text",{Color=Color3.fromRGB(220,220,230),Size=13,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)}),dist=d("Text",{Color=Color3.fromRGB(140,140,150),Size=11,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)}),hp=d("Square",{Color=Color3.fromRGB(55,200,95),Filled=true,Transparency=1}),hpb=d("Square",{Color=Color3.fromRGB(30,30,30),Filled=true,Transparency=1}),tr=d("Line",{Color=Color3.fromRGB(0,180,210),Thickness=1,Transparency=1})})end
    return espPool[i]
end
local function hideEsp(i)local e=espPool[i];if not e then return end
    e.box.Visible=false;e.fill.Visible=false;e.nam.Visible=false;e.dist.Visible=false;e.hp.Visible=false;e.hpb.Visible=false;e.tr.Visible=false
end

local circle=d("Circle",{Color=Color3.fromRGB(255,255,255),Thickness=1.5,Transparency=0.45,Radius=200,Filled=false,NumSides=60})
local cx={v=d("Line",{Color=Color3.fromRGB(220,220,230),Thickness=1.5,Transparency=1}),h=d("Line",{Color=Color3.fromRGB(220,220,230),Thickness=1.5,Transparency=1}),dot=d("Square",{Color=Color3.fromRGB(220,220,230),Size=Vector2.new(2,2),Filled=true,Transparency=1})}
local rBg=d("Square",{Color=Color3.fromRGB(0,0,0),Filled=true,Transparency=0.55,Thickness=1.5})
local rR1=d("Circle",{Color=Color3.fromRGB(255,255,255),Radius=65,Filled=false,Transparency=0.75,Thickness=1,NumSides=40})
local rR2=d("Circle",{Color=Color3.fromRGB(255,255,255),Radius=43,Filled=false,Transparency=0.8,Thickness=1,NumSides=30})
local rDot=d("Square",{Color=Color3.fromRGB(255,255,255),Size=Vector2.new(4,4),Filled=true,Transparency=1})
local rDots={}
local function getRD(i)while #rDots<i do table.insert(rDots,{dot=d("Square",{Color=Color3.fromRGB(255,50,50),Size=Vector2.new(4,4),Filled=true,Transparency=1}),lbl=d("Text",{Color=Color3.fromRGB(255,255,255),Size=9,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)})})end return rDots[i]end
local function hideRD(i)local r=rDots[i];if r then r.dot.Visible=false;r.lbl.Visible=false end end

-- wait for auth
local waitCon=RunService.RenderStepped:Connect(function()
    if not authenticated then return end
    waitCon:Disconnect()

    -- ===== TOGGLE MENU GUI =====
    local menuGui = guiParent and new("Frame",{
        Name="ENIMenu",Size=UDim2.new(0,210,0,230),Position=UDim2.new(0,20,0,20),
        BackgroundColor3=bg,BorderColor3=ac,BorderSizePixel=2,Parent=guiParent
    })
    if menuGui then
        new("UICorner",{CornerRadius=UDim.new(0,6),Parent=menuGui})
        local mi = new("Frame",{Size=UDim2.new(1,-4,1,-4),Position=UDim2.new(0,2,0,2),BackgroundColor3=bg,BorderSizePixel=0,Parent=menuGui})
        new("UICorner",{CornerRadius=UDim.new(0,5),Parent=mi})

        -- title bar (draggable)
        local tb = new("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.8,BorderSizePixel=0,Parent=mi})
        new("UICorner",{CornerRadius=UDim.new(0,5),Parent=tb})
        local tFill = new("Frame",{Size=UDim2.new(1,0,1,-5),Position=UDim2.new(0,0,0,5),BackgroundColor3=Color3.fromRGB(0,0,0),BackgroundTransparency=0.8,BorderSizePixel=0,Parent=tb})
        new("TextLabel",{Text="ENI Hub",Size=UDim2.new(0,100,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,TextColor3=ac,TextSize=15,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=tb})
        new("TextLabel",{Text="v2",Size=UDim2.new(0,30,1,0),Position=UDim2.new(1,-40,0,0),BackgroundTransparency=1,TextColor3=txt2,TextSize=10,Font=Enum.Font.Gotham,Parent=tb})
        local closeBtn = new("TextButton",{Text="âÆ",Size=UDim2.new(0,24,0,24),Position=UDim2.new(1,-28,0,2),BackgroundTransparency=1,TextColor3=txt2,TextSize=16,Font=Enum.Font.Gotham,Parent=tb})
        closeBtn.MouseButton1Click:Connect(function() menuGui.Visible = not menuGui.Visible end)
        closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = txt end)
        closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = txt2 end)

        local dragging,dragOff=false

        -- toggles
        local togDefs={{name="Aimbot",key="aim",y=38},{name="ESP",key="esp",y=64},{name="Tracers",key="trace",y=90},{name="FOV Circle",key="fov",y=116},{name="Radar",key="radar",y=142}}
        local toggles={}
        for _,td in ipairs(togDefs)do
            local bgF = new("Frame",{Size=UDim2.new(0,40,0,18),Position=UDim2.new(1,-52,0,td.y),BackgroundColor3=Color3.fromRGB(45,45,52),BorderSizePixel=0,Parent=mi})
            new("UICorner",{CornerRadius=UDim.new(0,3),Parent=bgF})
            local btn = new("TextButton",{Text="OFF",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),TextSize=10,Font=Enum.Font.GothamBold,Parent=bgF})
            local lbl = new("TextLabel",{Text=td.name,Size=UDim2.new(0,140,0,18),Position=UDim2.new(0,12,0,td.y),BackgroundTransparency=1,TextColor3=txt,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=mi})
            local state=false
            btn.MouseButton1Click:Connect(function()
                state=not state
                btn.Text=state and"ON"or"OFF"
                bgF.BackgroundColor3=state and ac or Color3.fromRGB(45,45,52)
                if td.key=="aim"then aimOn=state elseif td.key=="esp"then espOn=state elseif td.key=="trace"then traceOn=state elseif td.key=="fov"then fovOn=state elseif td.key=="radar"then radarOn=state end
            end)
            btn.MouseEnter:Connect(function() if not state then bgF.BackgroundColor3=Color3.fromRGB(55,55,62)end end)
            btn.MouseLeave:Connect(function() if not state then bgF.BackgroundColor3=Color3.fromRGB(45,45,52)end end)
            toggles[td.key]={btn=btn,bg=bgF,lbl=lbl,data=td,on=function()return state end}
        end

        -- FOV control
        local sep = new("Frame",{Size=UDim2.new(1,-24,0,1),Position=UDim2.new(0,12,0,170),BackgroundColor3=Color3.fromRGB(30,30,34),BorderSizePixel=0,Parent=mi})
        local fovLbl = new("TextLabel",{Text="FOV: 200",Size=UDim2.new(0,100,0,18),Position=UDim2.new(0,12,0,178),BackgroundTransparency=1,TextColor3=txt2,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=mi})
        local fovHint = new("TextLabel",{Text="<  >",Size=UDim2.new(0,40,0,18),Position=UDim2.new(1,-48,0,178),BackgroundTransparency=1,TextColor3=Color3.fromRGB(80,80,90),TextSize=13,Font=Enum.Font.GothamBold,Parent=mi})

        -- F3 to kill
        local kHint = new("TextLabel",{Text="F3 to unload",Size=UDim2.new(1,-24,0,18),Position=UDim2.new(0,12,0,210),BackgroundTransparency=1,TextColor3=Color3.fromRGB(60,60,70),TextSize=10,Font=Enum.Font.Gotham,Parent=mi})

        -- drag
        local function startDrag(x,y)dragging=true;dragOff=Vector2.new(x-menuGui.AbsolutePosition.X,y-menuGui.AbsolutePosition.Y)end
        local function endDrag()dragging=false end
        tb.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then startDrag(i.Position.X,i.Position.Y)end end)
        tb.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then endDrag()end end)
        -- drag via UIS as fallback
        c(UIS,"InputEnded",function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

        -- update loop
        local function updateMenu()
            if not menuGui.Visible then
                for _,t in pairs(toggles)do t.bg.Visible=false;t.lbl.Visible=false;t.btn.Visible=false end
                fovLbl.Visible=false;fovHint.Visible=false;sep.Visible=false;kHint.Visible=false
                return
            end
            for _,t in pairs(toggles)do t.bg.Visible=true;t.lbl.Visible=true;t.btn.Visible=true end
            fovLbl.Visible=true;fovHint.Visible=true;sep.Visible=true;kHint.Visible=true
        end

        c(RunService,"RenderStepped",function()
            if dragging then
                local mp=UIS:GetMouseLocation()
                menuGui.Position=UDim2.new(0,mp.X-dragOff.X,0,mp.Y-dragOff.Y)
            end
            updateMenu()
        end)

        -- Insert toggle
        c(UIS,"InputBegan",function(input)
            if input.KeyCode==Enum.KeyCode.Insert then menuGui.Visible=not menuGui.Visible end
            if input.KeyCode==Enum.KeyCode.F3 then kill();if guiParent then guiParent:Destroy()end return end
            if menuGui.Visible then
                if input.KeyCode==Enum.KeyCode.Left or input.KeyCode==Enum.KeyCode.Comma then aimFov=math.max(50,aimFov-10);fovLbl.Text="FOV: "..math.floor(aimFov)end
                if input.KeyCode==Enum.KeyCode.Right or input.KeyCode==Enum.KeyCode.Period then aimFov=math.min(500,aimFov+10);fovLbl.Text="FOV: "..math.floor(aimFov)end
            end
        end)
    end

    -- ===== OVERLAY LOOP =====
    c(RunService,"RenderStepped",function()
        local Camera=workspace.CurrentCamera;if not Camera then return end
        local vp=Camera.ViewportSize;local mid=vp/2;local mPos=UIS:GetMouseLocation()

        circle.Visible=fovOn;if fovOn then circle.Radius=aimFov;circle.Position=mPos end
        cx.v.Visible=true;cx.h.Visible=true;cx.dot.Visible=true
        cx.v.From=Vector2.new(mid.X,mid.Y-8);cx.v.To=Vector2.new(mid.X,mid.Y+8)
        cx.h.From=Vector2.new(mid.X-8,mid.Y);cx.h.To=Vector2.new(mid.X+8,mid.Y)
        cx.dot.Position=mid-Vector2.new(1,1)

        if aimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local best,bd=nil,aimFov
            for _,p in pairs(Players:GetPlayers())do
                if p~=lp then
                    local c2=p.Character
                    if c2 then
                        local head=c2:FindFirstChild("Head");local hum=c2:FindFirstChild("Humanoid")
                        if head and hum and hum.Health>0 then
                            local sp,on=Camera:WorldToViewportPoint(head.Position)
                            if on and sp.Z>0 then
                                local d2=(Vector2.new(sp.X,sp.Y)-mPos).Magnitude
                                if d2<=aimFov and d2<bd then bd=d2;best=head end
                            end
                        end
                    end
                end
            end
            if best then Camera.CFrame=Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position,best.Position),smooth)end
        end

        rBg.Visible=radarOn;rR1.Visible=radarOn;rR2.Visible=radarOn;rDot.Visible=radarOn
        if radarOn then
            local rx,ry=vp.X-145,vp.Y-145;rBg.Position=Vector2.new(rx,ry);rBg.Size=Vector2.new(130,130)
            rR1.Position=Vector2.new(rx+65,ry+65);rR2.Position=Vector2.new(rx+65,ry+65);rDot.Position=Vector2.new(rx+63,ry+63)
            local rdIdx=0;local lpc=lp.Character;local lpr=lpc and lpc:FindFirstChild("HumanoidRootPart")
            if lpr then
                local lpos=lpr.Position;local yaw=math.atan2(-Camera.CFrame.LookVector.X,-Camera.CFrame.LookVector.Z)
                for _,p in pairs(Players:GetPlayers())do
                    if p~=lp then
                        local c2=p.Character
                        if c2 and c2:FindFirstChild("HumanoidRootPart")and c2:FindFirstChild("Humanoid")and c2.Humanoid.Health>0 then
                            local r2=c2.HumanoidRootPart;local rel=(r2.Position-lpos)*Vector3.new(1,0,1)
                            local dist=rel.Magnitude
                            if dist<300 then
                                local ang=math.atan2(rel.X,rel.Z)-yaw;local rd=math.min(dist/300*60,58)
                                local dx=math.sin(ang)*rd;local dy=math.cos(ang)*rd
                                rdIdx=rdIdx+1;local o=getRD(rdIdx)
                                o.dot.Visible=true;o.dot.Position=Vector2.new(rx+63+dx,ry+63+dy)
                                o.lbl.Visible=true;o.lbl.Position=Vector2.new(rx+63+dx,ry+63+dy-8);o.lbl.Text=p.Name:sub(1,8)
                            end
                        end
                    end
                end
            end;for i=rdIdx+1,#rDots do hideRD(i)end
        else for i=1,#rDots do hideRD(i)end end

        local idx=0
        for _,p in pairs(Players:GetPlayers())do
            if p~=lp then
                local c2=p.Character;local hum=c2 and c2:FindFirstChild("Humanoid");local root=c2 and c2:FindFirstChild("HumanoidRootPart")
                local alive=hum and hum.Health>0 and root;local ok=false
                if alive then
                    local sp,on=Camera:WorldToViewportPoint(root.Position)
                    if on and sp.Z>0 then
                        ok=true;idx=idx+1;local e=getEsp(idx)
                        local dist=(root.Position-Camera.CFrame.Position).Magnitude;local size=c2:GetExtentsSize()
                        local bh=math.max(20,math.min(200,400/dist*size.Y*1.5));local bw=bh*0.6;local pos=Vector2.new(sp.X-bw/2,sp.Y-bh/2)
                        e.box.Visible=espOn;e.box.Position=pos;e.box.Size=Vector2.new(bw,bh)
                        e.fill.Visible=espOn;e.fill.Position=pos;e.fill.Size=Vector2.new(bw,bh)
                        local hp=hum.Health/hum.MaxHealth;local hc=Color3.fromRGB(60*(1+(1-hp)),200*hp,60*hp)
                        e.hpb.Visible=espOn;e.hpb.Position=Vector2.new(pos.X-5,pos.Y);e.hpb.Size=Vector2.new(3,bh)
                        e.hp.Visible=espOn;e.hp.Position=Vector2.new(pos.X-5,pos.Y+bh*(1-hp));e.hp.Size=Vector2.new(3,bh*hp);e.hp.Color=hc
                        local nm=p.Name;if #nm>12 then nm=nm:sub(1,12)..".."end
                        e.nam.Visible=espOn;e.nam.Position=Vector2.new(sp.X,pos.Y-15);e.nam.Text=nm
                        e.dist.Visible=espOn;e.dist.Position=Vector2.new(sp.X,pos.Y+bh+2);e.dist.Text=math.floor(dist).."m"
                        if traceOn and espOn then e.tr.Visible=true;e.tr.From=Vector2.new(vp.X/2,vp.Y);e.tr.To=Vector2.new(sp.X,sp.Y)else e.tr.Visible=false end
                    end
                end;if not ok then idx=idx+1;hideEsp(idx)end
            end
        end;for i=idx+1,#espPool do hideEsp(i)end
    end)
end)

print("ENI Hub v2 loaded â¬ enter key to start")
