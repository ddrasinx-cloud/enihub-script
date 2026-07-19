-- ENI Hub v2 | Drawing IMGUI
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

local SECRET = "E7n1HuB_S3cr3t_K3y!_2026#Pr3mium"
local authenticated = false
local keyStr = ""

-- ===== DRAWING =====
local drawObjs={};local conns={}
local function d(t,p)
    local o=Drawing.new(t)
    for k,v in pairs(p)do o[k]=v end
    table.insert(drawObjs,o)
    return o
end
local function c(obj,ev,fn)local con=obj[ev]:Connect(fn)table.insert(conns,con)return con end
local function kill()
    for _,v in ipairs(conns)pcall(v.Disconnect,v)end conns={}
    for _,v in ipairs(drawObjs)pcall(v.Remove,v)end drawObjs={}
end

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

-- ===== COLORS =====
local C = {
    bg = Color3.fromRGB(8,8,12),
    panel = Color3.fromRGB(12,12,16),
    border = Color3.fromRGB(0,180,210),
    text = Color3.fromRGB(215,215,225),
    sub = Color3.fromRGB(130,130,140),
    dim = Color3.fromRGB(70,70,80),
    green = Color3.fromRGB(46,204,113),
    red = Color3.fromRGB(220,60,60),
    btnOff = Color3.fromRGB(45,45,52),
    btnOn = Color3.fromRGB(0,180,210),
    btnHover = Color3.fromRGB(55,55,62),
    inputBg = Color3.fromRGB(16,16,20),
}

-- ===== KEY ENTRY UI =====
local k = {}
k.overlay = d("Square",{Color=Color3.fromRGB(0,0,0),Filled=true,Transparency=0.6})
k.bg = d("Square",{Color=C.panel,Filled=true,Transparency=1})
k.border = d("Square",{Color=C.border,Filled=false,Thickness=2,Transparency=1})
k.title = d("Text",{Text="ENI HUB",Color=C.border,Size=30,Center=true,Font=3,Outline=true,OutlineColor=Color3.new(0,0,0)})
k.sub = d("Text",{Text="ENTER YOUR KEY",Color=C.sub,Size=13,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
k.inBg = d("Square",{Color=C.inputBg,Filled=true,Transparency=1})
k.inBorder = d("Square",{Color=C.border,Filled=false,Thickness=1,Transparency=1})
k.input = d("Text",{Text="",Color=C.text,Size=20,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
k.cursor = d("Text",{Text="|",Color=C.border,Size=20,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
k.status = d("Text",{Text="",Color=C.red,Size=14,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
k.hint = d("Text",{Text="Key from seller  Â·  Enter to submit  Â·  Esc to leave",Color=C.dim,Size=10,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})

local kBlink = true
task.spawn(function() while true do task.wait(0.5) kBlink=not kBlink end end)

local function drawKey(vp)
    local cx,cy = vp.X/2, vp.Y/2
    local pw,ph = 360, 260
    local px,py = cx-pw/2, cy-ph/2
    k.overlay.Size = vp; k.overlay.Visible = true
    k.bg.Position = Vector2.new(px,py); k.bg.Size = Vector2.new(pw,ph); k.bg.Visible = true
    k.border.Position = Vector2.new(px,py); k.border.Size = Vector2.new(pw,ph); k.border.Visible = true
    k.title.Position = Vector2.new(cx, py+28); k.title.Visible = true
    k.sub.Position = Vector2.new(cx, py+56); k.sub.Visible = true
    local ibx,iby,ibw,ibh = cx-150, py+76, 300, 44
    k.inBg.Position = Vector2.new(ibx,iby); k.inBg.Size = Vector2.new(ibw,ibh); k.inBg.Visible = true
    k.inBorder.Position = Vector2.new(ibx,iby); k.inBorder.Size = Vector2.new(ibw,ibh); k.inBorder.Visible = true
    local tw = k.input.TextBounds.X
    k.input.Text = keyStr; k.input.Position = Vector2.new(cx, iby+ibh/2-6); k.input.Visible = true
    k.cursor.Visible = kBlink and true or false; k.cursor.Position = Vector2.new(cx+tw/2+4, iby+ibh/2-6)
    k.status.Position = Vector2.new(cx, py+132); k.status.Visible = true
    k.hint.Position = Vector2.new(cx, py+240); k.hint.Visible = true
end

c(UIS,"InputBegan",function(input)
    if authenticated then return end
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode~=Enum.KeyCode.Unknown then
        local kc=input.KeyCode
        if kc==Enum.KeyCode.Return or kc==Enum.KeyCode.KeypadEnter then
            if#keyStr==0 then return end
            if validateKey(keyStr)then
                k.status.Text="âs Key accepted"k.status.Color=C.green
                task.wait(0.5)authenticated=true;k.status.Text=""
            else
                k.status.Text="ãs Invalid key"k.status.Color=C.red
                keyStr=""
            end;return
        end
        if kc==Enum.KeyCode.Backspace then keyStr=keyStr:sub(1,-2)return end
        local char=input.KeyCode.Name
        if#char==1 and char:match("%w")then
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift)or UIS:IsKeyDown(Enum.KeyCode.RightShift)then keyStr=keyStr..char:upper()
            else keyStr=keyStr..char end
        end
        if char=="Minus"then keyStr=keyStr.."-"end
    end
end)

-- ===== HITBOX HELPERS =====
local mPos = Vector2.new(0,0)
local hovered = nil
local function hit(x,y,w,h)return mPos.X>=x and mPos.X<=x+w and mPos.Y>=y and mPos.Y<=y+h end

-- ===== FEATURES =====
local aimOn=false;local espOn=false;local traceOn=false;local fovOn=false;local radarOn=false
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

-- ===== KEY LOOP =====
local authCon = RunService.RenderStepped:Connect(function()
    local Camera=workspace.CurrentCamera;if not Camera then return end
    if not authenticated then drawKey(Camera.ViewportSize) end
end)

-- ===== MENU AWAIT =====
local waitCon = RunService.RenderStepped:Connect(function()
    if not authenticated then return end
    waitCon:Disconnect();authCon:Disconnect()

    -- hide key UI
    for _,o in pairs(k)do if type(o)=="table"then for _,v in pairs(o)do if type(v)=="userdata"then pcall(function()v.Visible=false end)end end
    elseif type(o)=="userdata"then pcall(function()o.Visible=false end)end end

    -- ===== TOGGLE MENU (Drawing) =====
    local m = {}
    local mw,mh = 210,230
    local mx,my = 20,20
    local dragging = false; local dragOff = Vector2.new()
    local menuOpen = true

    local function menuHit(x,y,w,h)return mPos.X>=x and mPos.X<=x+w and mPos.Y>=y and mPos.Y<=y+h end

    m.bg = d("Square",{Color=C.panel,Filled=true,Transparency=1})
    m.border = d("Square",{Color=C.border,Filled=false,Thickness=2,Transparency=1})
    m.title = d("Text",{Text="ENI Hub",Color=C.border,Size=15,Font=3,Outline=true,OutlineColor=Color3.new(0,0,0)})
    m.ver = d("Text",{Text="v2",Color=C.dim,Size=10,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
    m.cl = d("Text",{Text="-",Color=C.sub,Size=16,Font=2,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)})

    local togDefs={{name="Aimbot",key="aim",y=42},{name="ESP",key="esp",y=68},{name="Tracers",key="trace",y=94},{name="FOV Circle",key="fov",y=120},{name="Radar",key="radar",y=146}}
    local toggles={}
    for _,td in ipairs(togDefs)do
        local t={data=td,on=false}
        t.lbl = d("Text",{Text=td.name,Color=C.text,Size=13,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
        t.bg = d("Square",{Color=C.btnOff,Filled=true,Transparency=1})
        t.txt = d("Text",{Text="OFF",Color=Color3.new(1,1,1),Size=10,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
        toggles[td.key]=t
    end

    m.fovLbl = d("Text",{Text="FOV: 200",Color=C.sub,Size=11,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})
    m.fovHint = d("Text",{Text="<  >",Color=C.dim,Size=13,Font=3,Center=true,Outline=true,OutlineColor=Color3.new(0,0,0)})
    m.exitHint = d("Text",{Text="F3 quit  Â·  Insert hide",Color=Color3.fromRGB(60,60,70),Size=9,Center=true,Font=2,Outline=true,OutlineColor=Color3.new(0,0,0)})

    local function drawMenu()
        if not menuOpen then
            m.bg.Visible=false;m.border.Visible=false;m.title.Visible=false;m.ver.Visible=false;m.cl.Visible=false
            m.fovLbl.Visible=false;m.fovHint.Visible=false;m.exitHint.Visible=false
            for _,t in pairs(toggles)do t.lbl.Visible=false;t.bg.Visible=false;t.txt.Visible=false end
            return
        end
        m.bg.Visible=true;m.border.Visible=true;m.title.Visible=true;m.ver.Visible=true;m.cl.Visible=true
        m.fovLbl.Visible=true;m.fovHint.Visible=true;m.exitHint.Visible=true
        m.bg.Position=Vector2.new(mx,my);m.bg.Size=Vector2.new(mw,mh)
        m.border.Position=Vector2.new(mx,my);m.border.Size=Vector2.new(mw,mh)
        m.title.Position=Vector2.new(mx+14,my+7);m.ver.Position=Vector2.new(mx+mw-32,my+9)
        m.cl.Position=Vector2.new(mx+mw-16,my+8)
        m.fovLbl.Position=Vector2.new(mx+14,my+mh-42);m.fovHint.Position=Vector2.new(mx+mw-28,my+mh-44)
        m.exitHint.Position=Vector2.new(mx+mw/2,my+mh-12)

        -- toggle hover
        hovered=nil
        for _,td in ipairs(togDefs)do
            local t=toggles[td.key]
            local bx,bw,bh=mx+mw-52,40,18;local by=my+td.y
            t.bg.Position=Vector2.new(bx,by);t.bg.Size=Vector2.new(bw,bh)
            t.lbl.Position=Vector2.new(mx+14,my+td.y);t.txt.Position=Vector2.new(bx+bw/2,by+bh/2-3)
            local hov=hit(bx,by,bw,bh)
            if hov then hovered=td.key end
            if not t.on then t.bg.Color=hov and C.btnHover or C.btnOff end
        end

        -- close button hover
        if menuHit(mx+mw-24,my+2,20,20)then m.cl.Color=C.text else m.cl.Color=C.sub end
    end

    c(UIS,"InputBegan",function(input)
        if input.KeyCode==Enum.KeyCode.Insert then menuOpen=not menuOpen end
        if input.KeyCode==Enum.KeyCode.F3 then kill()return end
        if input.KeyCode==Enum.KeyCode.Left or input.KeyCode==Enum.KeyCode.Comma then aimFov=math.max(50,aimFov-10);m.fovLbl.Text="FOV: "..math.floor(aimFov)end
        if input.KeyCode==Enum.KeyCode.Right or input.KeyCode==Enum.KeyCode.Period then aimFov=math.min(500,aimFov+10);m.fovLbl.Text="FOV: "..math.floor(aimFov)end
        if input.UserInputType==Enum.UserInputType.MouseButton1 and menuOpen then
            local mp=UIS:GetMouseLocation()
            -- drag title bar
            if menuHit(mx,my,mw,28)then dragging=true;dragOff=Vector2.new(mp.X-mx,mp.Y-my)end
            -- close button
            if menuHit(mx+mw-24,my+2,20,20)then menuOpen=false return end
            -- toggles
            for _,td in ipairs(togDefs)do
                local t=toggles[td.key]
                local bx,bw,bh=mx+mw-52,40,18;local by=my+td.y
                if menuHit(bx,by,bw,bh)then
                    t.on=not t.on;t.txt.Text=t.on and"ON"or"OFF";t.bg.Color=t.on and C.btnOn or C.btnOff
                    if td.key=="aim"then aimOn=t.on elseif td.key=="esp"then espOn=t.on elseif td.key=="trace"then traceOn=t.on elseif td.key=="fov"then fovOn=t.on elseif td.key=="radar"then radarOn=t.on end
                end
            end
        end
    end)
    c(UIS,"InputEnded",function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

    -- ===== OVERLAY LOOP =====
    c(RunService,"RenderStepped",function()
        mPos=UIS:GetMouseLocation()
        local Camera=workspace.CurrentCamera;if not Camera then return end
        local vp=Camera.ViewportSize;local mid=vp/2

        -- drag
        if dragging then local mp=UIS:GetMouseLocation();mx=mp.X-dragOff.X;my=mp.Y-dragOff.Y end
        drawMenu()

        circle.Visible=fovOn;if fovOn then circle.Radius=aimFov;circle.Position=mPos end
        cx.v.Visible=true;cx.h.Visible=true;cx.dot.Visible=true
        cx.v.From=Vector2.new(mid.X,mid.Y-8);cx.v.To=Vector2.new(mid.X,mid.Y+8)
        cx.h.From=Vector2.new(mid.X-8,mid.Y);cx.h.To=Vector2.new(mid.X+8,mid.Y)
        cx.dot.Position=mid-Vector2.new(1,1)

        if aimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)then
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

print("ENI Hub v2 â¬ enter key to start")
