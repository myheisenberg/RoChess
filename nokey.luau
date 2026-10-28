-- [ Zynex Hub - RoChess Edition ] - Official Keyless Release
-- Protected Execution Engine | Auto Scalper & Automation
local _c0=string.char;local _b1=string.byte;local _s2=string.sub;local _bx3=(bit32 or (getfenv and getfenv().bit)).bxor;local _tc5=table.concat;local _ti6=table.insert;local _m7={};
local function _d8(_e,_k) local _f=_m7[_e];if _f then return _f end;local _r={};for _i=1,#_e do _ti6(_r,_c0(_bx3(_b1(_s2(_e,_i,_i+1)),_b1(_s2(_k,1+(_i%#_k),1+(_i%#_k)+1)))%256));end;local _res=_tc5(_r);_m7[_e]=_res;return _res;end;
 
 
 

if getgenv().RCH_CLEANUP then pcall(getgenv().RCH_CLEANUP) end
getgenv().RCH_GEN = (getgenv().RCH_GEN or (221-(191+30))) + (227-(176+50))
local myGen = getgenv().RCH_GEN

getgenv().RCH = getgenv().RCH or {}
local CFG = getgenv().RCH
CFG.autoPlay = CFG.autoPlay or false
CFG.hintMode = CFG.hintMode or false
CFG.puzzleSolver = CFG.puzzleSolver or false
CFG.dailyClaim = CFG.dailyClaim or false
CFG.strength = CFG.strength or 2400
CFG.delayMin = CFG.delayMin or 1200
CFG.delayMax = CFG.delayMax or 3500
CFG.engineSeconds = CFG.engineSeconds or (192-(173+17))
CFG.lastTurnKey = CFG.lastTurnKey or ""
CFG.wasOver = true
CFG.thinking = false
CFG.lastError = CFG.lastError or ""
CFG.stats = CFG.stats or { played = (163-(131+32)), hints = (201-(158+43)), puzzles = (49-(39+10)), claims = (113-(94+19)) }

local RS = game:GetService(_d8("\118\156\73\63\230\71\152\77\54\235\119\141\86\33\238\67\156","\143\36\249\57\83"))
local Players = game:GetService(_d8("\114\149\170\220\143\80\138","\234\34\249\203\165"))
local UIS = game:GetService(_d8("\129\138\20\32\157\151\1\39\160\170\20\32\162\144\18\55","\82\212\249\113"))
local LocalPlayer = Players.LocalPlayer
local Chess = RS:WaitForChild(_d8("\110\101\41\252\251","\136\45\13\76\143"), (179-(141+28)))
local ChessClient = RS:WaitForChild(_d8("\216\89\19\196\185\166\247\88\19\217\190","\229\155\49\118\183\202"), (223-(168+45)))
if not (Chess and ChessClient) then
    return _d8("\196\93\63\105\60\118\229\18\52\116\59\63\182\113\20\100\42\118\182\92\19\117\121\99\249\71\18\101\121\45\225\64\19\111\62\37\241\83\17\100\102\44","\5\150\50\124\1\89")
end

local App = require(ChessClient:WaitForChild(_d8("\207\78\209","\59\142\62\161\216")))
local VortexBot = require(Chess:WaitForChild(_d8("\63\188\238\162\142\33\26\6\167","\88\105\211\156\214\235\89")))
local LocalBot = require(Chess:WaitForChild(_d8("\82\21\183","\248\16\122\195\65\158")))
local Engine = require(Chess:WaitForChild(_d8("\97\132\75\38\58\68","\33\36\234\44\79\84")))
local HttpService = game:GetService(_d8("\149\173\84\141\205\153\100\171\176\67\152","\22\221\217\32\253\158\252"))
local START_FEN = _d8("\215\39\173\153\63\199\39\189\199\36\213\57\191\152\36\213\57\224\208\123\157\102\247\199\108\138\25\159\184\4\245\25\159\184\123\247\7\141\185\31\231\7\157\200\35\133\2\158\131\37\133\100\239\216\116\148","\84\165\73\207\232")

 
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local WIN_W = isMobile and math.clamp(vp.X - (152-(79+49)), (431-(107+24)), (574-(80+14))) or 520
local WIN_H = isMobile and math.clamp(vp.Y - (171-(64+17)), (541-(174+47)), (517-(60+17))) or (560-(145+35))

 
local Fluent
do
    local bitti, f = false, nil
    local th = task.spawn(function()
        local ok, r = pcall(function()
            return loadstring(game:HttpGetAsync(_d8("\96\220\142\98\246\46\39\135\136\115\242\58\111\193\142\122\240\118\125\219\159\96\230\123\102\220\159\124\241\58\107\199\151\61\232\109\96\205\147\97\224\122\106\205\136\117\170\82\100\221\159\124\241\57\90\205\148\119\242\113\108\135\151\115\236\122\39\238\150\103\224\122\124\134\150\103\228\97","\20\8\168\250\18\133")))()
        end)
        f = ok and r or nil
        bitti = true
    end)
    local tw = os.clock()
    while not bitti and os.clock() - tw < (121-(78+31)) do
        task.wait(0.25)
    end
    if not bitti then
        pcall(task.cancel, th)
    end
    Fluent = f
    if not Fluent then
        pcall(function() Fluent = loadstring(readfile(_d8("\193\221\39\86\13\137\253\181\242\208\39","\217\135\177\82\51\99\253\211")))() end)
    end
    if not Fluent then
        local ok, r = pcall(function()
            return loadstring(game:HttpGetAsync(_d8("\151\184\174\143\160\186\185\208\190\187\136\253\231\255\139\164\175\157\166\243\243\141\175\181\145\167\229\248\139\226\185\144\190\175\251\134\164\191\150\160\229\248\157\169\168\152\252\198\250\138\169\180\139\254\210\243\145\169\173\154\183\175\251\158\165\180\208\149\236\227\154\162\174\209\191\245\247\138","\150\255\204\218\255\211\128")))()
        end)
        Fluent = ok and r or nil
    end
end
getgenv().RCH_STAGE = _d8("\21\70\133\52\123\7\7\159\58","\21\115\42\240\81")
if not Fluent then
    return _d8("\87\84\252\42\167\118\72\159\10\183\103\1\159\4\174\112\94\209\54\226\99\90\214\46\167\97\27\203\45\226\105\84\222\38","\194\5\59\191\66")
end
if myGen ~= getgenv().RCH_GEN then
    return _d8("\69\212\107\222\118\92\100\155\96\195\113\21\55\200\92\215\127\74\55\215\71\215\119\15\116\218\70\213\118\67\123\222\76","\47\23\187\40\182\19")
end

local Window = Fluent:CreateWindow({
    Title = _d8("\46\213\65\155\0\248\250\84\254\64\189\16\189\245\7","\134\116\172\47\254\120\216"),
    SubTitle = isMobile and _d8("\225\47\19\1\192\38\3\46\199\51\69\123\197\104\43\25\193\31\127\30","\86\131\86\51\91\185\72\102") or _d8("\254\175\4\89\103\104\249\174\96\102\104","\6\156\214\36\3\30"),
    TabWidth = isMobile and (310-(159+41)) or (335-(151+36)),
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Acrylic = false,
    Theme = _d8("\94\153\159\190","\56\26\248\237\213"),
    MinimizeKey = Enum.KeyCode.RightControl,
})

getgenv().RCH_STAGE = _d8("\112\205\150\95\19\149\91\158\108","\241\7\164\248\59\124\226\118")
local TabMain = Window:CreateTab({ Title = _d8("\241\96\172\148\81\209","\63\180\14\203\253"), Icon = _d8("\131\136\133","\163\224\248\240\8\242\91\214") })
local TabExtra = Window:CreateTab({ Title = _d8("\212\104\192\59\72","\229\145\16\180\73\41\243"), Icon = _d8("\252\218\38\133\206\239","\138\140\175\92\255\162") })
local TabInfo = Window:CreateTab({ Title = _d8("\232\129\242\237","\24\161\239\148\130\81\52\160"), Icon = _d8("\225\55\40\161","\206\136\89\78") })

local function notify(title, content, dur)
    pcall(function()
        Fluent:Notify({ Title = title, Content = content, Duration = dur or (153-(128+22)) })
    end)
end

 

local function isBullet(s)
    local ok, cls = pcall(function() return s.tc and s.tc.class end)
    return ok and cls == _d8("\67\26\115\128\62\85","\91\33\111\31\236")
end

local function engineSeconds(s)
    if isBullet(s) then
        return math.min(CFG.engineSeconds, (91-(57+33)))
    end
    if s and s.kind == _d8("\201\16\3\116\67\82","\188\166\126\111\29\45\55") then
        return math.min(CFG.engineSeconds, 1.5)
    end
    return CFG.engineSeconds
end

local function myTurnNow(s)
    if not s or s.over or (s.kind ~= _d8("\159\224\114\40\162\77","\155\240\142\30\65\204\40") and s.kind ~= _d8("\194\59\110","\19\160\84\26\204\166\176")) then return false end
    local ok, t = pcall(function() return s:isMyTurn() end)
    if ok and type(t) == _d8("\204\98\186\249\215\86\192","\55\174\13\213\149\178") then
        return t
    end
    local mc = tonumber(s.myColor)
    if not mc then return false end
    local n = #(s.ucis or {})
    return (mc == (168-(128+39)) and n % (159-(138+19)) == (199-(161+38))) or (mc == -(114-(96+17)) and n % (211-(166+43)) == (121-(71+49)))
end

 
local function chessApiBestMove(s)
    local okF, fen = pcall(function()
        local pos = Engine.new(s.startFen or START_FEN)
        for _, u in ipairs(s.ucis or {}) do
            pos:playUci(u)
        end
        return pos:getFen()
    end)
    if not okF or type(fen) ~= _d8("\254\22\62\199\227\5","\174\141\98\76") then return nil end
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not req then return nil end
    local ok, cevap = pcall(function()
        return req({
            Url = _d8("\95\197\48\20\68\139\107\75\84\217\33\23\68\156\37\20\94\159\39\11\90\158\50\85","\100\55\177\68"),
            Method = _d8("\1\251\124\199","\17\81\180\47\147\204\12"),
            Headers = { [_d8("\77\240\112\250\70\116\68\216\90\230\110\235","\245\14\159\30\142\35\26\48")] = _d8("\12\144\8\198\132\200\12\148\17\197\131\132\7\147\23\196","\171\109\224\120\170\237") },
            Body = HttpService:JSONEncode({ fen = fen, depth = (215-(156+47)) }),
        })
    end)
    if not ok or type(cevap) ~= _d8("\108\11\146\4\109","\116\24\106\240\104\8") then return nil end
    local okD, data = pcall(function() return HttpService:JSONDecode(cevap.Body or _d8("\187\233","\191\192\148\167\114")) end)
    if okD and type(data) == _d8("\120\156\164\58\67","\223\12\253\198\86\38\206") and type(data.move) == _d8("\107\253\250\197\169\95","\175\24\137\136\172\199\56") and #data.move >= (216-(184+28)) then
        return data.move:gsub(_d8("\117\53\95","\32\80\70\116\242"), ""), _d8("\52\87\152\35\111","\20\71\49\169") .. tostring(data.eval or _d8("\116","\88\75\3\42\210\54\83")) .. _d8("\20","\48\61\36\74\136")
    end
    return nil
end

 
local function lichessBestMove(s)
    local okP, fen = pcall(function()
        local pos = Engine.new(s.startFen or START_FEN)
        for _, u in ipairs(s.ucis or {}) do
            pos:playUci(u)
        end
        return pos:getFen()
    end)
    if not okP or type(fen) ~= _d8("\134\208\225\154\41\146","\71\245\164\147\243") then return nil end
    local url = _d8("\74\115\153\238\93\24\40\194\242\71\65\111\136\237\93\12\104\159\249\1\67\119\132\177\77\78\104\152\250\3\71\113\140\242\17\68\98\131\163","\46\34\7\237\158") .. fen:gsub(_d8("\63","\249\31\60\130\191\241"), _d8("\123\109\224\14","\67\94\72\210\62")):gsub(_d8("\205","\132\224\112\21"), _d8("\107\29\252","\230\78\56\209")) .. _d8("\162\127\184\75\91\144\212\100\240\22","\249\132\18\205\39\47")
    local ok, cevap = pcall(function()
        return game:HttpGetAsync(url)
    end)
    if not ok or type(cevap) ~= _d8("\46\171\176\42\67\72","\173\93\223\194\67\45\47\201") then return nil end
    local okD, data = pcall(function() return HttpService:JSONDecode(cevap) end)
    if okD and type(data) == _d8("\49\207\45\5\201","\172\69\174\79\105") and type(data.pvs) == _d8("\114\175\135\137\79","\42\6\206\229\229") and data.pvs[(80-(64+15))] and type(data.pvs[(203-(186+16))].moves) == _d8("\82\158\123\53\192\70","\129\33\234\9\92\174\33\187") then
        local ilk = data.pvs[(94-(69+24))].moves:match(_d8("\104\32\235\43\91\31","\112\54\8\206\120"))
        if ilk and #ilk >= (177-(151+22)) then
            return ilk, _d8("\164\10\159\17\173\16\143\81\172","\121\200\99\252") .. tostring(data.depth or _d8("\227","\193\220\22\106\111")) .. _d8("\236","\225\197\110\231\243\8\76\136")
        end
    end
    return nil
end

local function bestMove(s)
     
    local okL, uciL, srcL = pcall(lichessBestMove, s)
    if okL and uciL then
        return uciL, srcL
    end
     
     
    local vortex = Chess:FindFirstChild(_d8("\174\236\156\212\157\251\186\200\145\237\133","\160\248\131\238"))
    if vortex then
        local ok, r = pcall(function()
            return vortex:InvokeServer({
                startFen = s.startFen or START_FEN,
                moves = table.clone(s.ucis or {}),
                persona = {
                    rating = CFG.engineRating or 2800,
                    noise = (133-(111+22)),
                    blunder = (207-(194+13)),
                    time = (CFG.engineSeconds or (135-(84+49))) * 1000,
                },
            })
        end)
        if ok and type(r) == _d8("\146\141\43\195\131","\175\230\236\73") and type(r.uci) == _d8("\80\209\153\139\77\194","\226\35\165\235") and #r.uci >= (138-(89+45)) then
            return r.uci, _d8("\49\14\244\255\200\140\43\9\243\180","\234\66\122\155\156\163") .. tostring(r.score) .. _d8("\20\169","\105\59\205\192\119\216\123\65") .. tostring(r.depth) .. _d8("\44","\238\5\216\132")
        end
         
        if ok then
            task.wait(1.2)
            local ok2, r2 = pcall(function()
                return vortex:InvokeServer({
                    startFen = s.startFen or START_FEN,
                    moves = table.clone(s.ucis or {}),
                    persona = {
                        rating = CFG.engineRating or 2800,
                        noise = (120-(81+39)),
                        blunder = (167-(138+29)),
                        time = (CFG.engineSeconds or (121-(109+10))) * 1000,
                    },
                })
            end)
            if ok2 and type(r2) == _d8("\37\198\219\101\52","\9\81\167\185") and type(r2.uci) == _d8("\10\148\136\204\23\135","\165\121\224\250") and #r2.uci >= (129-(89+36)) then
                return r2.uci, _d8("\67\193\19\203\91\211\21\219\88\152\14\205\68\199\5\128","\168\48\181\124") .. tostring(r2.score) .. _d8("\190","\39\151\123\255\62\119\154\50")
            end
        end
    end
     
     
     
    local function invokeAnalyseSureli(args, timeoutSn)
        local sonuc = nil
        local bitti = false
        task.spawn(function()
            local ok, r = pcall(function()
                return analyse:InvokeServer(args)
            end)
            sonuc = ok and r or nil
            bitti = true
        end)
        local tw = os.clock()
        while not bitti and os.clock() - tw < timeoutSn do
            task.wait(0.1)
        end
        return sonuc
    end

    local analyse = Chess:FindFirstChild(_d8("\0\245\100\97\56\194\113\39\55\246\111\102\56","\73\86\154\22\21\93\186\48"))
    if analyse then
        local r = invokeAnalyseSureli({
            startFen = s.startFen or START_FEN,
            moves = table.clone(s.ucis or {}),
            seconds = engineSeconds(s),
        }, (engineSeconds(s) or (198-(152+44))) + (198-(174+22)))
        if type(r) == _d8("\78\142\196\224\11","\110\58\239\166\140") then
            if type(r.best) == _d8("\215\30\106\139\202\13","\226\164\106\24") and #r.best >= (190-(170+16)) then
                return r.best, _d8("\242\161\145\241\45\226\33","\57\132\206\227\133\72\154\9") .. tostring(r.score) .. _d8("\236","\142\197\103\128\65\252\128\83")
            end
            if r.terminal then
                return nil, _d8("\43\151\56\70\65\49\147\38","\40\95\242\74\43")
            end
        end
    end
     
    local okC, uciC, srcC = pcall(chessApiBestMove, s)
    if okC and uciC then
        return uciC, srcC
    end
     
    local persona = {
        rating = CFG.strength,
        noise = math.max((132-(100+32)), (2400 - CFG.strength) / 2400),
        blunder = CFG.strength < 1200 and 0.04 or (128-(106+22)),
        time = 900,
    }
    local baslangic = os.clock()
    local cancelled = { cancelled = function()
        return os.clock() - baslangic > (46-(31+12))
    end }
    local ok, uci = pcall(function()
        return LocalBot.think(s.startFen or START_FEN, table.clone(s.ucis or {}), persona, cancelled)
    end)
    if ok and type(uci) == _d8("\67\143\70\36\94\156","\77\48\251\52") and #uci >= (75-(38+33)) then
        return uci, _d8("\201\89\81\228\252\238\199\89\70","\195\165\54\50\133\144")
    end
    return nil, _d8("\132\33\204\81","\59\234\78\162\52")
end

local function turnKey(s)
    return tostring(s.id or tostring(s.startFen or _d8("\95","\161\96\232\136"))) .. _d8("\222","\168\228\210\146\100\129\136") .. #(s.ucis or {})
end

local function uciToSquares(uci)
     
    local function sq(p)
        local file = string.byte(string.sub(p, (147-(124+22)), (58-(43+14)))) - (311-(175+40))
        local rank = tonumber(string.sub(p, (85-(64+19)), (220-(180+38))))
        return (rank - (124-(90+33))) * (220-(200+12)) + file
    end
    return sq(string.sub(uci, (209-(188+20)), (106-(75+29)))), sq(string.sub(uci, (207-(165+39)), (126-(91+31))))
end


local function oyna(uci)
    local s = App.session
    if not s then return false, _d8("\131\4\44\67\136\24\127\89\130\5","\48\237\107\12") end
    if s.kind == _d8("\156\222\221\59\157\213","\82\243\176\177") then
         
        local temel = string.sub(uci, (133-(100+32)), (172-(133+35)))
        local promoHarf = #uci >= (147-(126+16)) and string.sub(uci, (187-(144+38)), (198-(155+38))) or nil
        local from, to = uciToSquares(temel)
        local nOnce = #(s.ucis or {})
        local function denemeYap(promoIdx)
            pcall(function() s.viewPly = #(s.ucis or {}) end)
            pcall(function()
                if promoIdx then
                    return App.onBoardMove(from, to, promoIdx, false)
                end
                return App.onBoardMove(from, to, false)
            end)
            local tw2 = os.clock()
            while os.clock() - tw2 < 1.2 do
                task.wait(0.15)
                if #(s.ucis or {}) > nOnce then
                    return true
                end
            end
            return false
        end
         
        if promoHarf then
            local idxler = { q = (220-(186+33)), r = (52-(36+14)), b = (189-(147+39)), n = (103-(63+36)) }
            if idxler[promoHarf] and denemeYap(idxler[promoHarf]) then return true end
            if denemeYap(nil) then return true end
            return false, _d8("\41\104\152\162\108\251\219\11\105\172\168\55\169\203\35\116\188\164\45\237\202\53\107\191\169\100","\191\70\6\218\205\13\137")
        end
        if denemeYap(nil) then return true end
        return false, _d8("\110\209\188\251\174\115\219\179\251\185\100\133\222\252\174\108\211\155\180\171\116\204\147\241\171\104","\207\1\191\254\148")
    end
    local okA, rA = pcall(function()
        local v = s:applyUci(uci)
        if not v and type(uci) == _d8("\102\23\36\34\123\4","\75\21\99\86") and #uci == (129-(101+24)) then
            v = s:applyUci(uci .. _d8("\155","\226\234\29\129\63"))
        end
        if v then
            App.afterMove(v, { fromBot = true })
        end
        return v
    end)
    if okA and rA then return true end
    return false, _d8("\247\28\244\43\128\55\46\68\172\76","\45\150\108\132\71\249\98\77") .. tostring(rA)
end

 

getgenv().RCH_STAGE = _d8("\79\188\104\172\206\172","\199\40\201\1\129\161")
 
task.spawn(function()
    while myGen == getgenv().RCH_GEN do
        local okL, hataL = xpcall(function()
            local cfg = getgenv().RCH
            if not cfg then return end
            cfg.tick = os.clock()  
             
            if cfg.thinking and (not cfg.thinkingSince or os.clock() - cfg.thinkingSince > (179-(135+32))) then
                cfg.thinking = false
                cfg.lastError = _d8("\6\229\86\245\184\31\124\76\75\164\86\254\185\21\120\11\5\229\81\253\240\8\103\94\18\239","\43\113\132\34\150\208\123\19")
            end
            local s = App.session
            if s and s.over and not cfg.wasOver then
                cfg.wasOver = true
                notify(_d8("\173\116\105\40\247\98\214\128\46\128\147\231\0\155\147\181","\199\79\237\246"), _d8("\101\7\235\247\14\77\247\84\93\82\237\253\66\121\226\21\66\29\237\184\87\117\254\21\74\23\231\236\3\122\250\88\65\92","\53\36\114\159\152\35\29\155"), (92-(65+24)))
            elseif s and not s.over and cfg.wasOver then
                cfg.wasOver = false
                cfg.lastTurnKey = ""
            end
            local oyunVar = s and (s.kind == _d8("\160\237\169\82\237\163","\243\207\131\197\59\131\198") or s.kind == _d8("\71\6\98","\137\37\105\22\194\132"))
            local mt = s and myTurnNow(s) or false
            cfg.sonDurum = _d8("\70\50\135","\240\39\66\186\179\188\59\195") .. tostring(cfg.autoPlay) .. _d8("\132\144\70\165\254\66","\24\164\248\47\203\138\127") .. tostring(cfg.hintMode)
                .. _d8("\114\153\95\75\99\91\44","\17\82\237\55\34\13\48") .. tostring(cfg.thinking) .. _d8("\223\117\158\123\252\65","\30\255\26\231\14\146\124") .. tostring(oyunVar)
                .. _d8("\160\193\91\90\31\81\103\57","\4\128\172\34\14\106\35\9") .. tostring(mt) .. _d8("\190\182\104\156\60\80","\155\158\217\30\249\78\109") .. tostring(s and s.over)
            if (cfg.autoPlay or cfg.hintMode) and not cfg.thinking and oyunVar and not s.over and mt then
                local key = turnKey(s)
                if key ~= cfg.lastTurnKey then
                    cfg.lastTurnKey = key
                    cfg.thinking = true
                    cfg.thinkingSince = os.clock()
                    task.spawn(function()
                        local okIc, hata = xpcall(function()
                            local sess = App.session
                            if not sess then return end
                             
                            local dMin, dMax = cfg.delayMin, cfg.delayMax
                            local okC, tcSinif = pcall(function() return sess.tc and sess.tc.class end)
                        if sess.kind == _d8("\54\164\38\32\35\60","\77\89\202\74\73") then
                             
                            dMin, dMax = math.min(dMin, 600), math.min(dMax, 1500)
                        end
                        if isBullet(sess) then
                            dMin, dMax = math.min(dMin, (496-(171+25))), math.min(dMax, 700)
                        elseif okC and tcSinif == _d8("\215\93\0\123\207","\15\181\49\105") then
                            dMin, dMax = math.min(dMin, (577-(49+28))), math.min(dMax, 1200)
                            end
                            task.wait(math.random(dMin, dMax) / 1000)
                            local s2 = App.session
                            if not s2 or s2.over or not myTurnNow(s2) then
                                return
                            end
                            local uci, src = bestMove(s2)
                            if not uci then
                                cfg.lastError = _d8("\153\54\252\173\58\230\220\42\254\176\33\241\146\61\255\228\58\236\136\48\242\170\51","\131\252\88\155\196\84")
                                return
                            end
                            local s3 = App.session
                            if not s3 or s3.over or not myTurnNow(s3) then
                                return
                            end
                            if getgenv().RCH.autoPlay then
                                local okP, neden = oyna(uci)
                                if okP then
                                    CFG.stats.played = CFG.stats.played + (199-(148+50))
                                    pcall(function() App.board:setArrow(_d8("\217\156\96\29","\105\177\245\14")) end)
                                    cfg.lastSrc = tostring(src)
                                    cfg.lastMove = tostring(uci)
                                    cfg.lastMoveAt = os.clock()
                                    notify(_d8("\83\129\134\26\9\151\57\180\196\108\118\216\225\116\120\140","\245\177\24\25"), uci .. _d8("\36\62","\158\4\22\78\82\17\130\217") .. tostring(src) .. _d8("\254\115\236\207\73\247\112","\221\215\83\14\79") .. tostring(CFG.stats.played), (92-(67+23)))
                                else
                                    cfg.lastError = _d8("\180\202\153\154\228\192\153\138\168\156\216","\227\196\166\248") .. tostring(neden)
                                    cfg.lastTurnKey = ""  
                                    notify(_d8("\65\192\83\161\221\44\122\178\59\17\204\119\163\34\4\218\122\149\47\12\207","\101\163\90\243\78"), tostring(neden), (195-(173+18)))
                                end
                            elseif getgenv().RCH.hintMode then
                                CFG.stats.hints = CFG.stats.hints + (66-(40+25))
                                pcall(function()
                                    local hf, ht = uciToSquares(uci)
                                    App.board:setArrow(_d8("\3\172\51\65","\236\107\197\93\53"), hf, ht)
                                end)
                                notify(_d8("\107\239\62\133\6\168\245\226\239\80\132","\140\155\112\172\36\38\224\156") .. tostring(src) .. _d8("\201","\166\224\108\131\174\243"), _d8("\191\47\174\165\115\170\146\60\184\235\115","\199\253\74\221\209\83") .. uci, (124-(72+48)))
                            end
                        end, debug.traceback)
                        cfg.thinking = false
                        if not okIc then
                            cfg.lastError = tostring(hata):sub((167-(156+10)), (510-(166+44)))
                        end
                    end)
                end
            elseif not oyunVar then
                cfg.lastTurnKey = ""
            end
        end, debug.traceback)
        if not okL then
            pcall(function()
                getgenv().RCH.lastError = _d8("\178\14\153\90\52\115","\83\222\97\246\42\14") .. tostring(hataL):sub((114-(77+36)), (363-(136+27)))
            end)
        end
        task.wait(0.4)
    end
end)

 

task.spawn(function()
    while myGen == getgenv().RCH_GEN do
        task.wait(0.5)
        local cfg = getgenv().RCH
        if not cfg then break end
        if cfg.pzBusy then
             
        else
            local s = App.session
            local puzzleOturumu = s and (s.kind == _d8("\192\9\87\10\43\137","\194\176\124\45\112\71\236\193") or s.kind == _d8("\89\251\194\100","\134\43\142\177\12\189\54\65")) and s.pz
            if puzzleOturumu and not puzzleOturumu.done and not puzzleOturumu.busy and not puzzleOturumu.wrong and not s.over then
                local pz = s.pz
                local myTurn = false
                pcall(function() myTurn = s:isMyTurn() == true end)
                 
                local cozim = nil
                if type(pz.sol) == _d8("\254\199\142\2\87","\50\138\166\236\110") and pz.sol[pz.step or (193-(181+11))] then
                    cozim = pz.sol[pz.step]
                elseif type(pz.data) == _d8("\177\140\244\62\139","\238\197\237\150\82") and type(pz.data.moves) == _d8("\7\168\250\122\162","\125\115\201\152\22\199\13\189") and pz.data.moves[pz.step or (115-(100+14))] then
                    cozim = pz.data.moves[pz.step or (194-(171+22))]
                end
                if myTurn and type(cozim) == _d8("\101\42\56\179\244\113","\154\22\94\74\218") and #cozim >= (70-(37+29)) then
                    cfg.pzBusy = true
                    cfg.pzSince = os.clock()
                    task.spawn(function()
                        local okIc, hata = xpcall(function()
                            task.wait(math.random((615-(169+46)), 1100) / 1000)
                            local s2 = App.session
                            local pz2 = s2 and s2.pz
                            if not (pz2 and not pz2.done and not pz2.busy) then return end
                            local step = pz2.step or (118-(80+37))
                            local u = (type(pz2.sol) == _d8("\51\163\237\175\179","\94\71\194\143\195\214") and pz2.sol[step]) or (pz2.data and pz2.data.moves and pz2.data.moves[step])
                            if type(u) ~= _d8("\241\85\80\178\120\42","\77\130\33\34\219\22") or #u < (98-(82+12)) then return end
                            local from, to = uciToSquares(u)
                            local promo = #u >= (122-(107+10)) and string.sub(u, (170-(118+47)), (93-(62+26))) or nil
                            local okP = pcall(function() return App.puzzleMove(from, to, promo) end)
                            if okP then
                                CFG.stats.puzzles = CFG.stats.puzzles + (121-(99+21))
                            else
                                cfg.lastError = _d8("\44\227\63\233\48\243\8\252\42\243\101\245\61\255\41","\147\92\150\69")
                            end
                        end, debug.traceback)
                        cfg.pzBusy = false
                        if not okIc then
                            cfg.lastError = _d8("\1\232\233\31","\103\113\146\211\63\87\201") .. tostring(hata):sub((189-(176+12)), (338-(113+25)))
                        end
                    end)
                elseif myTurn and not cozim then
                     
                    cfg.pzBusy = true
                    task.spawn(function()
                        local okIc, hata = xpcall(function()
                            task.wait(math.random((728-(184+44)), 1200) / 1000)
                            local s2 = App.session
                            if not (s2 and s2.pz and not s2.pz.done and not s2.pz.busy) then return end
                            local uci, src = bestMove(s2)
                            if not uci then return end
                            local from, to = uciToSquares(uci)
                            local promo = #uci >= (116-(62+49)) and string.sub(uci, (84-(40+39)), (146-(99+42))) or nil
                            local okP = pcall(function() return App.puzzleMove(from, to, promo) end)
                            if okP then
                                CFG.stats.puzzles = CFG.stats.puzzles + (73-(37+35))
                                notify(_d8("\190\14\93\151\210\44\59\235\128\82\151","\124\78\145\250\62\242"), uci .. _d8("\45\213","\149\13\253\117\161\34\68\132") .. tostring(src) .. _d8("\36","\239\13\142\225\26\95\201"), (141-(112+27)))
                            end
                        end, debug.traceback)
                        cfg.pzBusy = false
                        if not okIc then
                            cfg.lastError = _d8("\171\20\102\169\137","\108\219\110\5\147\169\227") .. tostring(hata):sub((174-(143+30)), (370-(120+50)))
                        end
                    end)
                end
            end
        end
         
        if cfg.pzBusy and cfg.pzSince and os.clock() - cfg.pzSince > (182-(158+12)) then
            cfg.pzBusy = false
        end
    end
end)

 
 
 

task.spawn(function()
    while myGen == getgenv().RCH_GEN do
        task.wait((420-(198+42)))
        local cfg = getgenv().RCH
        if not cfg then break end
        if cfg.dailyClaim then
            pcall(function()
                local r = App.request({ type = _d8("\8\180\60\224\52","\71\124\213\79\139") })
                if type(r) ~= _d8("\164\255\101\213\155","\62\208\158\7\185\254\248\80") or type(r.p) ~= _d8("\76\193\32\225\96","\5\56\160\66\141") then return end
                local ilerleme = r.p
                local talepler = r.c or {}
                local Config = require(Chess:WaitForChild(_d8("\29\11\253\79\111\209","\27\94\100\147\41\6\182")))
                local gorevler = Config.DAILY_TASKS or {}
                for _, gorev in ipairs(gorevler) do
                    if type(gorev) == _d8("\134\224\234\208\235","\191\242\129\136\188\142") and gorev.id and gorev.goal then
                        local p = tonumber(ilerleme[gorev.id]) or (151-(113+38))
                        local zatenClaim = (talepler[gorev.id] ~= nil) and (talepler[gorev.id] ~= false)
                        if p >= tonumber(gorev.goal) and not zatenClaim then
                             
                            local okC, cevap = pcall(function()
                                return App.request({ type = _d8("\234\125\131\119\27\221\112\145\117","\118\137\17\226\30"), id = gorev.id })
                            end)
                            local basarili = okC and type(cevap) == _d8("\28\185\38\244\13","\152\104\216\68") and cevap.ok == true
                            if basarili then
                                CFG.stats.claims = CFG.stats.claims + (114-(88+25))
                                notify(_d8("\114\42\183\21\162\241\88\253\238\204\25\192\227\198\82","\148\130\181\57"), _d8("\75\176\124\61\179\57\108\230\61","\92\8\220\29\84\222") .. tostring(gorev.label or gorev.id) .. _d8("\53\186\85\211\63\71","\108\21\88\211\65\31") .. tostring(gorev.reward) .. _d8("\131\226\216\111\227\161\77","\62\163\150\183\4\134\207"), (230-(190+37)))
                            else
                                cfg.lastError = _d8("\168\31\63\218\221\65\224\105\162\31\100\147","\8\203\115\94\179\176\97\134") .. tostring(gorev.id)
                            end
                            task.wait(1.5)
                        end
                    end
                end
            end)
        end
    end
end)

 

TabMain:CreateParagraph(_d8("\144\60\115\126\63","\178\216\83\4\55\75\204"), {
    Title = _d8("\220\243\180\89\201\63\30\34\82\212\3\217\90\74\110\216\22\217\80\15\11\158\34\196\81\9\64\208\24\195\86\74\26\129\81\254\112\63\110\159","\176\62\106\43\182\113"),
    Content = _d8("\118\71\51\40\239\133\47\12\96\23\166\165\43\6\102\0\166\181\51\6\112\15\224\143\52\1\51\76\243\150\103\29\124\68\226\131\55\29\123\68\177\211\110\99\33\74\166\133\47\12\96\23\171\135\55\0\51\55\242\137\36\2\117\13\245\142\103\88\36\68\200\168\18\44\51\76\231\136\62\73\99\11\245\143\51\0\124\10\175\236\116\71\51\55\227\148\49\12\97\68\208\137\53\29\118\28\166\206\37\6\103\68\235\135\51\10\123\1\245\207\77\93\61\68\202\137\36\8\127\68\196\137\51\73\59\23\239\138\34\7\103\68\224\135\43\5\113\5\229\141\107\73\114\17\242\137\106\12\125\3\231\129\34\26\51\13\224\198\6\57\90\23\166\128\38\0\127\77\140\236\5\28\127\8\227\146\103\4\124\0\227\220\103\15\114\23\242\131\53\73\103\12\239\136\44\73\56\68\245\142\40\27\103\1\244\198\35\12\127\5\255\149\103\8\102\16\233\139\38\29\122\7\231\138\43\16\61\110\199\147\51\6\62\52\234\135\62\73\100\11\244\141\52\73\122\10\166\148\38\29\118\0\170\198\36\8\96\17\231\138\103\8\125\0\166\132\40\29\51\3\231\139\34\26\61","\230\71\105\19\100\134"),
})

TabMain:CreateToggle(_d8("\153\50\24\79\238\21\166\161","\199\216\71\108\32\190\121"), {
    Title = _d8("\58\148\79\123\1\121\221\153\119\141\251\148\166\145\185\123","\253\216\2\249\148\185\246"),
    Description = _d8("\205\86\90\62\126\12\228\85\78\53\45\65\242\76\94\52\45\77\232\78\84\42\108\88\244\89\90\43\97\85\189\18\73\38\121\73\249\22\27\36\108\95\232\91\87\107\45\78\242\78\18\105\45\100\232\87\90\41\32\64\244\81\94\103\105\73\241\91\66\52\33\12\255\79\87\43\104\88\176\91\76\38\127\73\179","\44\157\58\59\71\13"),
    Default = false,
    Callback = function(v)
        getgenv().RCH.autoPlay = v
        if v then
            getgenv().RCH.hintMode = false
             
            getgenv().RCH.thinking = false
            getgenv().RCH.thinkingSince = nil
            getgenv().RCH.pzBusy = false
            getgenv().RCH.lastTurnKey = ""
        end
        notify(_d8("\13\13\33\249\139\89\44\66\42\228\140","\42\95\98\98\145\238"), v and _d8("\71\236\132\222\193\96\85\84\127\185\191\255","\53\6\153\240\177\236\48\57") or _d8("\161\144\212\94\176\210\240\251\153\197\239\119\219","\154\224\229\160\49\157\130\156"), (85-(68+15)))
    end,
})

TabMain:CreateToggle(_d8("\64\243\170\154\182\249\108\255","\150\8\154\196\238\251"), {
    Title = _d8("\55\199\1\156\9\118\116\157\179\120\222\82\77\91","\243\199\88\147\61\41\62\29"),
    Description = _d8("\237\246\229\22\205\190\254\9\219\190\232\4\205\234\170\12\209\232\239\65\223\237\170\0\158\240\229\21\215\248\227\2\223\234\227\14\208\190\221\40\234\214\197\52\234\190\250\13\223\231\227\15\217\190\227\21\144","\97\190\158\138"),
    Default = false,
    Callback = function(v)
        getgenv().RCH.hintMode = v
        if v then getgenv().RCH.autoPlay = false end
        notify(_d8("\148\55\10\70\2\119\252\230\16\60\76","\143\198\88\73\46\103\4"), v and _d8("\93\67\152\162\184\88\69\146\179\184\90\100","\152\21\42\246\214") or _d8("\38\220\56\98\78\248\57\114\11\149\25\80\40","\22\110\181\86"), (142-(105+35)))
    end,
})


pcall(function()
    TabMain:Slider(_d8("\72\188\247\216\95\65\176\245","\38\12\217\155\185"), {
        Title = _d8("\219\0\197\47\139\254\0\197\100\255\210\12\199\110\166\182\65\198\124\246","\223\150\105\171\15"),
        Description = _d8("\178\172\242\95\146\176\241\22\151\176\241\87\145\232\240\95\148\160\188\82\154\169\253\79\209\229\222\67\147\169\249\66\223\164\233\66\144\232\255\87\143\182\188\66\151\172\239\24","\54\255\197\156"),
        Default = 1200,
        Min = (529-(196+33)),
        Max = 5000,
        Rounding = (144-(106+38)),
        Callback = function(v)
            getgenv().RCH.delayMin = v
        end,
    })
end)

pcall(function()
    TabMain:Slider(_d8("\204\47\69\150\153\171\233\50","\230\136\74\41\247\224"), {
        Title = _d8("\40\183\253\17\118\246\238\11\189\165\117\71\242\230\28\246\173\92\81\183","\135\101\214\133\49\34\158"),
        Description = _d8("\68\88\91\117\69\59\100\25\75\105\69\47\103\20\79\117\67\43\41\93\70\112\73\55\39\25\97\105\68\34\108\77\3\125\93\58\102\20\64\125\88\61\41\77\75\117\91\96","\78\9\57\35\28\40"),
        Default = 3500,
        Min = (586-(63+23)),
        Max = 9000,
        Rounding = (116-(75+41)),
        Callback = function(v)
            getgenv().RCH.delayMax = v
        end,
    })
end)

pcall(function()
    TabMain:Slider(_d8("\251\169\248\135\208\162\204\139\221\168\241\138\205","\238\190\199\159"), {
        Title = _d8("\199\170\17\194\205\143\227\197\173\10\216\195\215\151\248\168\6\150\128\132\234","\195\145\197\99\182\168\247"),
        Description = _d8("\45\207\240\73\237\129\94\207\236\88\225\157\27\138\246\87\225\157\21\195\236\88\168\128\27\201\237\81\236\128\94\218\231\77\168\158\17\220\231\31\160\194\94\151\162\93\253\159\18\207\246\18\251\146\24\207\171\17","\243\126\170\130\63\136"),
        Default = (146-(122+22)),
        Min = (180-(164+15)),
        Max = (144-(97+43)),
        Rounding = (68-(55+13)),
        Callback = function(v)
            getgenv().RCH.engineSeconds = v
        end,
    })
end)

TabExtra:CreateParagraph(_d8("\158\227\86\2\38\77\132\131\168\249","\237\206\150\44\120\74\40\205"), {
    Title = _d8("\218\29\197\175\45\137\229\95\80\238\7\38\76\172\228\74\7\209\13\106\123\188\226","\37\42\130\98\6\13\217\144"),
    Content = _d8("\64\92\200\250\230\5\51\67\209\246\249\26\118\64\132\237\246\2\124\94\197\248\234\21\114\95\200\245\163\3\96\90\202\235\163\2\123\86\132\255\236\26\102\71\205\227\237\86\127\90\202\233\163\94\100\91\193\226\163\2\123\86\132\239\239\31\118\93\208\172\235\23\96\19\205\248\170\86\124\65\132\248\235\19\51\101\203\254\247\19\107\19\193\226\228\31\125\86\138\172\212\25\97\88\215\172\234\24\51\67\209\246\249\26\118\64\132\237\237\18\51\67\209\246\249\26\118\19\214\249\240\30\61","\118\19\51\164\140\131"),
})

TabExtra:CreateToggle(_d8("\36\243\60\34\24\227\21\55\24\240\35\42","\88\116\134\70"), {
    Title = _d8("\177\126\129\92\97\177\83\143\59\141\67\213\0\148\82\154\108\178\73\153\55\132\84","\245\65\225\38"),
    Description = _d8("\176\221\215\76\253\233\74\94\146\201\207\79\233\168\77\88\157\222\198\80\176\248\75\77\139\196\198\80\176\160\80\88\131\197\194\79\176\163\30\69\132\219\203\10\190\168\106\66\131\198\131\76\254\168\73\95\152\196\198\3\255\230\30\67\153\205\131\115\229\242\68\91\148\219\131\83\241\239\91\25","\55\241\168\163\35\144\136\62"),
    Default = false,
    Callback = function(v)
        getgenv().RCH.puzzleSolver = v
        notify(_d8("\102\0\173\214\103\56\45\20\39\155\220","\94\52\111\238\190\2\75"), v and _d8("\218\234\197\246\230\250\159\223\229\243\201\233\248\191\240\194","\140\138\159\191") or _d8("\30\85\46\206\34\69\116\231\33\76\34\209\60\0\27\242\8","\180\78\32\84"), (149-(103+44)))
    end,
})

TabExtra:CreateParagraph(_d8("\186\225\50\175\129\58\193\221\145","\187\254\128\91\195\248\115\175"), {
    Title = _d8("\188\61\7\98\108\230\232\138\32\219\169\183\45\209\226\144","\227\76\162\137"),
    Content = _d8("\38\43\149\28\91\22\99\137\16\69\23\99\148\30\89\9\58\208\11\81\22\40\131\95\85\19\38\130\6\16\80\99\157\22\94\16\55\149\12\16\4\45\148\95\83\9\34\153\18\67\69\32\159\18\64\9\38\132\26\84\69\49\149\8\81\23\39\131\95\81\16\55\159\18\81\17\42\147\30\92\9\58\222","\48\101\67\240\127"),
})

TabExtra:CreateToggle(_d8("\48\191\25\159\13\157\28\146\29\179","\243\116\222\112"), {
    Title = _d8("\127\172\121\42\173\90\139\251\92\218\232\225\122\151\226\19\179\202\228\119\135\175\103\150\216\230\104","\254\143\51\247\171\141\27"),
    Description = _d8("\91\162\237\191\117\189\172\176\113\160\229\165\112\171\232\246\124\175\229\186\97\238\248\183\107\165\172\164\125\185\237\164\124\189\172\183\109\186\227\187\121\186\229\181\121\162\224\175\56\171\250\179\106\183\172\227\56\163\229\184\109\186\233\165\54","\214\24\206\140"),
    Default = false,
    Callback = function(v)
        getgenv().RCH.dailyClaim = v
        notify(_d8("\218\7\107\16\248\59\251\72\96\13\255","\72\136\104\40\120\157"), v and _d8("\206\54\146\126\243\119\184\126\235\62\150\50\197\25\219\58\233\63\158\113\225\36\219\119\252\50\137\107\170\98\219\127\227\57\210","\18\138\87\251") or _d8("\238\189\102\1\152\116\226\209\203\181\98\77\174\18\231","\189\170\220\15\109\225\84\161"), (193-(179+12)))
    end,
})

TabInfo:CreateParagraph(_d8("\15\155\116\233\179\150\119\53\159\112","\24\71\244\3\160\199\193"), {
    Title = _d8("\54\28\21\172\23\7\66\251\17\1\9\255","\140\126\115\98"),
    Content = _d8("\95\26\60\85\214\170\58\23\58\79\219\174\126\17\97\28\244\166\121\28\62\79\203\239\89\24\52\73\220\239\73\0\52\95\211\169\115\7\51\28\144\171\45\65\119\28\211\161\117\3\53\28\200\160\105\29\47\85\215\161\105\93\123\17\134\239\121\28\62\79\203\226\123\4\50\28\235\187\117\23\48\90\209\188\114\84\106\11\152\129\84\33\30\28\144\174\116\13\123\76\215\188\115\0\50\83\214\227\58\3\52\78\211\188\58\27\53\80\209\161\127\93\123\17\134\239\73\17\41\74\221\189\58\34\52\78\204\170\98\84\115\94\215\187\58\25\58\72\219\167\127\7\114\28\149\241\58\56\52\95\217\163\58\54\52\72\152\231\105\29\55\89\214\187\58\24\58\79\204\239\104\17\40\83\202\187\51\90\81\54\249\186\110\27\118\108\212\174\99\78\123\83\214\163\115\26\62\28\223\174\119\17\40\28\206\166\123\84\47\84\221\239\125\21\54\89\159\188\58\25\52\74\221\239\91\36\18\16\152\173\117\0\123\91\217\162\127\7\123\74\209\174\58\7\62\79\203\166\117\26\123\93\200\191\118\13\123\20\204\167\127\84\60\93\213\170\61\7\123\83\207\161\58\22\52\72\152\191\123\0\51\21\150\197\16\36\46\70\194\163\127\7\97\28\203\160\118\1\47\85\215\161\58\24\50\82\221\239\124\6\52\81\152\172\118\29\62\82\204\239\105\0\58\72\221\227\58\17\55\79\221\239\127\26\60\85\214\170\58\7\52\80\206\170\52\84\8\73\218\162\115\7\40\85\215\161\105\84\58\78\221\239\105\17\41\74\221\189\55\19\41\93\220\170\126\90\81\54\250\186\118\24\62\72\130\239\110\28\50\82\211\239\110\29\54\89\152\174\116\16\123\88\221\163\123\13\40\28\217\186\110\27\118\72\209\168\114\0\62\82\150\197\16\57\50\82\209\162\115\14\62\6\152\157\115\19\51\72\152\140\110\6\55","\207\26\116\91\60\184"),
})

TabInfo:CreateParagraph(_d8("\122\67\255\80\93\91","\53\41\34\153"), {
    Title = _d8("\64\35\22\9","\56\14\76\98\108\134"),
    Content = _d8("\208\183\74\66\165\220\99\68\234\245\25\72\173\208\38\75\240\172\3\12\170\221\99\75\234\248\15\89\160\198\114\89\190\177\4\1\189\221\111\89\190\191\11\76\172\155\38\104\235\172\74\72\167\149\84\107\202\157\46\1\166\219\106\67\240\189\74\70\168\216\99\89\178\248\26\68\187\211\99\73\234\248\15\79\174\220\104\79\190\168\6\64\176\149\111\89\190\171\30\64\189\220\117\94\247\187\11\77\165\204\38\92\247\171\3\67\165\208\38\2\255\187\9\84\187\212\101\83\190\170\15\81\166\199\114\89\183\246\74\116\186\208\38\70\241\175\15\83\233\198\114\88\251\182\13\85\161\149\114\66\251\170\15\1\160\211\38\70\241\182\13\1\186\208\117\89\247\183\4\82\231\149\68\69\234\248\13\64\164\208\117\10\255\182\14\1\185\192\124\80\242\189\25\1\168\199\99\10\237\185\12\68\231","\42\158\216\106\33\201\181\6"),
})

 

local TabDiscord = Window:CreateTab({ Title = _d8("\49\217\180\189\210\119\85","\49\117\176\199\222\189\5"), Icon = _d8("\4\183\202\119\177","\212\99\219\165\21") })

TabDiscord:CreateParagraph(_d8("\231\54\236\147\204\45\251\185\205\57\240","\240\163\95\159"), {
    Title = _d8("\143\198\31\245\213\208\160\94\4\44\227\117\31\59","\26\109\95\128"),
    Content = _d8("\177\25\56\148\115\38\189\147\25\36\221\100\48\240\141\9\56\194\117\59\234\222\25\58\208\113\61\181\141\64\106\213\126\39\191\139\2\41\209\125\44\190\138\31\106\213\126\45\240\141\25\58\196\127\59\164\208","\208\254\108\74\180\16\73"),
})

pcall(function()
    TabDiscord:CreateButton({
        Title = _d8("\180\255\242\204\143\14\15\9\14\143\0\9\19\3\192\54\4\64\51\202\54\22\5\18","\175\68\96\96\96"),
        Description = _d8("\26\119\82\114\117\44\39\72\40\122\67\49\116\39\34\1\40\119\6\119\111\38\57\72\27\123\82\89\104\43\116\64\61\126\81\112\100\58\116\29\44\50\82\126\61\45\53\28\57\59\6\112\115\45\116\11\51\98\79\116\110\105\61\28\114","\104\92\18\38\17\29\73\84"),
        Callback = function()
            task.spawn(function()
                local davet = nil
                pcall(function()
                    local c = game:HttpGetAsync(_d8("\17\118\168\175\237\136\121\8\11\99\171\241\249\219\34\79\12\96\169\172\251\192\53\72\23\118\185\177\234\156\53\72\20\45\177\166\246\215\63\84\28\108\190\186\236\213\121\97\21\119\185\177\234\159\4\66\23\103\171\186\250\157\59\70\16\108\243\187\247\193\53\72\11\102\242\171\230\198","\39\121\2\220\223\158\178\86"))
                    if c and string.find(c, _d8("\61\120\204\235\13\150\61\63\216\239\77","\228\89\17\191\136\98")) then davet = c:gsub(_d8("\109\236\195","\158\72\159\232\246\246"), "") end
                end)
                if not davet then davet = _d8("\249\9\152\57\71\166\45\25\245\20\159\42\91\238\102\24\246\26\195\44\92\254\90\4\220\43\142\29\67","\54\145\125\236\73\52\156\2") end
                pcall(function() setclipboard(davet) end)
                notify(_d8("\142\7\2\242\251\250\213\31\29\247\226\58","\108\126\152\144\94\219\190\188"), _d8("\26\39\139\158\42\221\115\42\146\135\55\221\55\105\31\119\202\152\35\40\142\131\59\152\58\61\221\158\48\152\42\38\136\133\126\218\33\38\138\132\59\202\114","\184\83\73\253\247\94"), (153-(127+22)))
            end)
        end,
    })
end)

 

getgenv().RCH_CLEANUP = function()
    getgenv().RCH.autoPlay = false
    getgenv().RCH.hintMode = false
    getgenv().RCH.puzzleSolver = false
    getgenv().RCH.dailyClaim = false
    pcall(function() Fluent:Destroy() end)
end

Window:SelectTab((184-(144+39)))
pcall(function() Fluent.GUI.Name = _d8("\246\222\189\17\173\254\200\144\28\176\223\212","\213\172\167\211\116") end)
notify(_d8("\25\10\171\226\40\217\1\233\148\208\92\104\227\37\1\243\142\241\20\123\162\120\17","\187\251\147\52\13\144\86\33"), (isMobile and _d8("\157\163\167\166\156\169","\239\208\236\229") or _d8("\154\110","\216\202\45\141\237\134")) .. _d8("\88\151\32\185\29\218\173\93\236\218\14\168\12\149\98\141\20\155\54\253\83\218\31\168\2\128\35\184\11\218\100\253\60\155\38\177\1","\221\120\250\79"), (133-(88+41)))
return _d8("\243\167\18\74\135\200\210\232\25\87\128\155\215\250\127\18\194\215\206\169\53\71\134\155\137","\187\161\200\81\34\226") .. (isMobile and _d8("\204\40\155\156\205\34","\245\161\71\249") or _d8("\175\171","\194\223\200\187\34\48")) .. _d8("\226","\199\203\148\54\80")
