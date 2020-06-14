local e="LeoDeveloper"local t="1.0.3"local a=""for N=1,16 do local S=math.random(1,16)a=a.. ("0123456789abcdef"):sub(S,S)end local o=gui.Reference("Menu")local i do local N=gui.Checkbox(gui.Reference("Misc","General","Extra"),"playerlist.enable","Player List",false)N:SetDescription("Show Player List Window.")i=N end local n={x=100,y=100,w=400,h=400}local s=n.w/2-8 local h=gui.Window("playerlist"..tostring(a),"Player List",n.x,n.y,n.w,n.h)local r={x=8,y=8,w=s,h=n.h-16}local d=gui.Groupbox(h,"Select a player",r.x,r.y,r.w,r.h)local l=gui.Listbox(d,"players",n.h-106)local u={x=r.x+r.w+4,y=r.y,w=n.w-s-16,h=n.h}local c=gui.Groupbox(h,"Per Player Settings",u.x,u.y,u.w,u.h)local m={}local f={}local w={}local y y=function(N)return{set=function(S,H)N.settings[S]=H if#f>0 and f[l:GetValue()+1]==N.info.uid then return m[S].set(H)end end,get=function(S)return N.settings[S]end}end plist={gui={Checkbox=function(N,S,H)local R=gui.Checkbox(c,"settings."..tostring(N),S,H)m[N]={set=function(D)return R:SetValue(D)end,get=function()return R:GetValue()end,default=H}for D,L in pairs(w)do L.settings[N]=H end return R end,Slider=function(N,S,H,R,D,L)local U=gui.Slider(c,"settings."..tostring(N),S,H,R,D,L or 1)m[N]={set=function(C)return U:SetValue(C)end,get=function()return U:GetValue()end,default=H}for C,M in pairs(w)do M.settings[N]=H end return U end,ColorPicker=function(N,S,H,R,D,L)local U=gui.ColorPicker(c,"settings."..tostring(N),H,R,D,L)m[N]={set=function(C)return U:SetValue(unpack(C))end,get=function()return{U:GetValue()}end,default={H,R,D,L}}for C,M in pairs(w)do M.settings[N]={H,R,D,L}end return U end,Text=function(N,S)local H=gui.Text(c,S)local R=S m[N]={set=function(D)H:SetText(D)R=D end,get=function()return R end,default=S}for D,L in pairs(w)do L.settings[N]=S end return S end,Combobox=function(N,S,...)local H=gui.Combobox(c,"settings."..tostring(N),S,...)m[N]={set=function(R)return H:SetValue(R)end,get=function()return H:GetValue()end,default=0}for R,D in pairs(w)do D.settings[N]=0 end return H end,Button=function(N,S)return gui.Button(c,N,function()if#f>0 then return S(f[l:GetValue()+1])else return S()end end)end,Editbox=function(N,S)local H=gui.Editbox(c,N,S)m[N]={set=function(R)return H:SetValue(R)end,get=function()return H:GetValue()end,default=0}for R,D in pairs(w)do D.settings[N]=0 end return H end},GetByUserID=function(N)return y(w[N])end,GetByIndex=function(N)local S=client.GetPlayerInfo(N)if S~=nil then return y(w[S["UserID"]])end for H,R in pairs(w)do if R.info.index==N then return y(R)end end end}local p=nil callbacks.Register("Draw","playerlist.callbacks.Draw",function()h:SetActive(i:GetValue()and o:IsActive())if not h:IsActive()or#f==0 then return end if p~=l:GetValue()then p=l:GetValue()local N=w[f[l:GetValue()+1]].settings for S,H in pairs(m)do H.set(N[S])end else local N=w[f[l:GetValue()+1]].settings for S,H in pairs(m)do N[S]=H.get()end end end)local v=nil callbacks.Register("CreateMove","playerlist.callbacks.CreateMove",function(N)if engine.GetMapName()~=v then v=engine.GetMapName()l:SetOptions()w={}f={}end local S=entities.FindByClass("CCSPlayer")for H=1,#S do local R=S[H]local D=client.GetPlayerInfo(R:GetIndex())["UserID"]if w[D]==nil then table.insert(f,D)w[D]={info={nickname=R:GetName(),uid=D,index=R:GetIndex()},settings={}}local L=w[D].settings for U,C in pairs(m)do L[U]=C.default end l:SetOptions(unpack((function()local U={}local C=1 for M,F in ipairs(f)do U[C]=w[F].info.nickname C=C+1 end return U end)()))elseif w[D].info.nickname~=R:GetName()then w[D].info.nickname=R:GetName()l:SetOptions(unpack((function()local L={}local U=1 for C,M in ipairs(f)do L[U]=w[M].info.nickname U=U+1 end return L end)()))end end end)plist.gui.Checkbox("lby_override.toggle","LBY Override",false)plist.gui.Slider("lby_override.value","LBY Override Value",0,-58,58)callbacks.Register("CreateMove","playerlist.plugins.LBY_Override",function(N)local S=entities.GetLocalPlayer()local H=entities.FindByClass("CCSPlayer")for R=1,#H do local D=false repeat local L=H[R]if not L:IsAlive()then D=true break end local U=plist.GetByIndex(L:GetIndex())if U.get("lby_override.toggle")then L:SetProp("m_flLowerBodyYawTarget",(L:GetProp("m_angEyeAngles").y+U.get("lby_override.value")+180)%360-180)end D=true until true if not D then break end end end)local b=nil local g=false callbacks.Register("AimbotTarget","playerlist.plugins.Priority.AimbotTarget",function(N)if b and N:GetIndex()~=b:GetIndex()then if g then gui.SetValue("rbot.aim.target.lock",false)end b=N g=false elseif g then return gui.SetValue("rbot.aim.target.fov",180)end end)plist.gui.Combobox("priority","Priority","Normal","Friendly","Priority")local k=3 local q={}callbacks.Register("CreateMove","playerlist.plugins.Priority.CreateMove",function(N)local S=entities.GetLocalPlayer()local H=entities.FindByClass("CCSPlayer")for R=1,#H do local D=false repeat local L=H[R]if not L:IsAlive()then D=true break end local U=plist.GetByIndex(L:GetIndex())local C=client.GetPlayerInfo(L:GetIndex())["UserID"]if U.get("priority")==0 and q[C]then L:SetProp("m_iTeamNum",L:GetProp("m_iPendingTeamNum"))q[C]=nil elseif U.get("priority")==1 then L:SetProp("m_iTeamNum",S:GetTeamNumber())q[C]=true elseif U.get("priority")==2 then if L:GetProp("m_iPendingTeamNum")==S:GetTeamNumber()then L:SetProp("m_iTeamNum",(S:GetTeamNumber()-1)%2+2)q[C]=true else if q[C]then L:SetProp("m_iTeamNum",L:GetProp("m_iPendingTeamNum"))q[C]=nil end if not g and L:GetTeamNumber()~=S:GetTeamNumber()then local M=S:GetAbsOrigin()+S:GetPropVector("localdata","m_vecViewOffset[0]")local F=L:GetHitboxPosition(5)engine.SetViewAngles((F-M):Angles())gui.SetValue("rbot.aim.target.fov",k)gui.SetValue("rbot.aim.target.lock",true)b=L g=true end end end D=true until true if not D then break end end end)callbacks.Register("FireGameEvent","playerlist.plugins.Priority.FireGameEvent",function(N)if N:GetName()=="player_death"and g then if client.GetPlayerIndexByUserID(N:GetInt("userid"))==b:GetIndex()then g=false b=nil gui.SetValue("rbot.aim.target.fov",180)return gui.SetValue("rbot.aim.target.lock",false)end end end)plist.gui.Checkbox("force.baim","Force BAIM",false)plist.gui.Checkbox("force.safepoint","Force Safepoint",false)local j={"asniper","hpistol","lmg","pistol","rifle","scout","shared","shotgun","smg","sniper","zeus"}local x={applied=false}local z z=function()if x.applied then print("[PLAYERLIST] WARNING: Force baim has already been applied.")end for N=1,#j do local S=j[N]if gui.GetValue("rbot.hitscan.mode."..tostring(S)..".bodyaim")~=1 then x[S]=gui.GetValue("rbot.hitscan.mode."..tostring(S)..".bodyaim")gui.SetValue("rbot.hitscan.mode."..tostring(S)..".bodyaim",1)end end x.applied=true end local _ _=function()if not x.applied then print("[PLAYERLIST] WARNING: Force baim hasn't been applied.")end for N,S in pairs(x)do local H=false repeat if N=="applied"then H=true break end gui.SetValue("rbot.hitscan.mode."..tostring(N)..".bodyaim",S)H=true until true if not H then break end end x={applied=false}end local E={applied=false}local T={"delayshot","delayshotbody","delayshotlimbs"}local A A=function()if E.applied then print("[PLAYERLIST] WARNING: Force safepoint has already been applied.")end for N=1,#j do local S=j[N]for H=1,#T do local R=T[H]if gui.GetValue("rbot.hitscan.mode."..tostring(S).."."..tostring(R))~=1 then E[tostring(S).."."..tostring(R)]=gui.GetValue("rbot.hitscan.mode."..tostring(S).."."..tostring(R))gui.SetValue("rbot.hitscan.mode."..tostring(S).."."..tostring(R),1)end end end E.applied=true end local O O=function()if not E.applied then print("[PLAYERLIST] WARNING: Force safepoint hasn't been applied.")end for N,S in pairs(E)do local H=false repeat if N=="applied"then H=true break end gui.SetValue("rbot.hitscan.mode."..tostring(N),S)H=true until true if not H then break end end E={applied=false}end local I=nil callbacks.Register("AimbotTarget","playerlist.plugins.FBSP.AimbotTarget",function(N)if not N:GetIndex()then return end I=N local S=plist.GetByIndex(N:GetIndex())if S.get("force.baim")then if not x.applied then z()end elseif x.applied then _()end if S.get("force.safepoint")then if not E.applied then return A()end elseif E.applied then return O()end end)callbacks.Register("FireGameEvent","playerlist.plugins.FBSP.FireGameEvent",function(N)if N:GetName()=="player_death"and I and client.GetPlayerIndexByUserID(N:GetInt("userid"))==I:GetIndex()then I=nil if x.applied then _()end if E.applied then return O()end end end)plist.gui.Checkbox("esp","ESP",false)callbacks.Register("DrawESP","playerlist.plugins.PPE.DrawESP",function(N)local S=N:GetEntity()if not S:IsPlayer()then return end if plist.GetByIndex(S:GetIndex()).get("esp")then draw.Color(0x80,0x80,0x80,0xFF)return draw.OutlinedRect(N:GetRect())end end)