-- ROCHESS HUB v2.0 | Auto-Play + Puzzle Solver + Daily Claim | by ZynexDev
-- Mobile + PC responsive | Engine: server Vortex (VortexAnalyse) -> local Bot
-- Session: ChessClient.App module table | Moves: playMove(online) / applyUci+afterMove(bot) / puzzleMove(puzzle)

if getgenv().RCH_CLEANUP then pcall(getgenv().RCH_CLEANUP) end
getgenv().RCH_GEN = (getgenv().RCH_GEN or 0) + 1
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
CFG.engineSeconds = CFG.engineSeconds or 2
CFG.lastTurnKey = CFG.lastTurnKey or ""
CFG.wasOver = true
CFG.thinking = false
CFG.lastError = CFG.lastError or ""
CFG.stats = CFG.stats or { played = 0, hints = 0, puzzles = 0, claims = 0 }

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Chess = RS:WaitForChild("Chess", 10)
local ChessClient = RS:WaitForChild("ChessClient", 10)
if not (Chess and ChessClient) then
    return "RoChess Hub: Chess not found (wrong game?)"
end

local App = require(ChessClient:WaitForChild("App"))
local VortexBot = require(Chess:WaitForChild("VortexBot"))
local LocalBot = require(Chess:WaitForChild("Bot"))
local Engine = require(Chess:WaitForChild("Engine"))
local HttpService = game:GetService("HttpService")
local START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

-- MOBILE / PC ----------------------------------------------------------------
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local WIN_W = isMobile and math.clamp(vp.X - 24, 300, 480) or 520
local WIN_H = isMobile and math.clamp(vp.Y - 90, 320, 440) or 380

-- Fluent: GitHub (12s budget) -> local fallback -> GitHub retry
local Fluent
do
    local bitti, f = false, nil
    local th = task.spawn(function()
        local ok, r = pcall(function()
            return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/myheisenberg/Fluent-Renewed/main/Fluent.luau"))()
        end)
        f = ok and r or nil
        bitti = true
    end)
    local tw = os.clock()
    while not bitti and os.clock() - tw < 12 do
        task.wait(0.25)
    end
    if not bitti then
        pcall(task.cancel, th)
    end
    Fluent = f
    if not Fluent then
        pcall(function() Fluent = loadstring(readfile("Fluent.luau"))() end)
    end
    if not Fluent then
        local ok, r = pcall(function()
            return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/myheisenberg/Fluent-Renewed/main/Fluent.luau"))()
        end)
        Fluent = ok and r or nil
    end
end
getgenv().RCH_STAGE = "fluent-ok"
if not Fluent then
    return "RoChess Hub: Fluent failed to load"
end
if myGen ~= getgenv().RCH_GEN then
    return "RoChess Hub: stale load cancelled"
end

local Window = Fluent:CreateWindow({
    Title = "Zynex | RoChess",
    SubTitle = isMobile and "by ZynexDev | MOBILE" or "by ZynexDev",
    TabWidth = isMobile and 110 or 148,
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl,
})

getgenv().RCH_STAGE = "window-ok"
local TabMain = Window:CreateTab({ Title = "Engine", Icon = "cpu" })
local TabExtra = Window:CreateTab({ Title = "Extra", Icon = "puzzle" })
local TabInfo = Window:CreateTab({ Title = "Info", Icon = "info" })

local function notify(title, content, dur)
    pcall(function()
        Fluent:Notify({ Title = title, Content = content, Duration = dur or 3 })
    end)
end

-- ENGINE ---------------------------------------------------------------------

local function isBullet(s)
    local ok, cls = pcall(function() return s.tc and s.tc.class end)
    return ok and cls == "bullet"
end

local function engineSeconds(s)
    if isBullet(s) then
        return math.min(CFG.engineSeconds, 1)
    end
    if s and s.kind == "online" then
        return math.min(CFG.engineSeconds, 1.5)
    end
    return CFG.engineSeconds
end

local function myTurnNow(s)
    if not s or s.over or (s.kind ~= "online" and s.kind ~= "bot") then return false end
    local ok, t = pcall(function() return s:isMyTurn() end)
    if ok and type(t) == "boolean" then
        return t
    end
    local mc = tonumber(s.myColor)
    if not mc then return false end
    local n = #(s.ucis or {})
    return (mc == 1 and n % 2 == 0) or (mc == -1 and n % 2 == 1)
end

-- KATMAN CHESS-API: ucretsiz Stockfish 17 NNUE (her pozisyon, kimliksiz)
local function chessApiBestMove(s)
    local okF, fen = pcall(function()
        local pos = Engine.new(s.startFen or START_FEN)
        for _, u in ipairs(s.ucis or {}) do
            pos:playUci(u)
        end
        return pos:getFen()
    end)
    if not okF or type(fen) ~= "string" then return nil end
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if not req then return nil end
    local ok, cevap = pcall(function()
        return req({
            Url = "https://chess-api.com/v1",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ fen = fen, depth = 12 }),
        })
    end)
    if not ok or type(cevap) ~= "table" then return nil end
    local okD, data = pcall(function() return HttpService:JSONDecode(cevap.Body or "{}") end)
    if okD and type(data) == "table" and type(data.move) == "string" and #data.move >= 4 then
        return data.move:gsub("%s+", ""), "sf17(" .. tostring(data.eval or "?") .. ")"
    end
    return nil
end

-- KATMAN LICHESS: bulut Stockfish (derin analiz, internet uzerinden)
local function lichessBestMove(s)
    local okP, fen = pcall(function()
        local pos = Engine.new(s.startFen or START_FEN)
        for _, u in ipairs(s.ucis or {}) do
            pos:playUci(u)
        end
        return pos:getFen()
    end)
    if not okP or type(fen) ~= "string" then return nil end
    local url = "https://lichess.org/api/cloud-eval?fen=" .. fen:gsub(" ", "%%20"):gsub("-", "%%-") .. "&multiPv=1"
    local ok, cevap = pcall(function()
        return game:HttpGetAsync(url)
    end)
    if not ok or type(cevap) ~= "string" then return nil end
    local okD, data = pcall(function() return HttpService:JSONDecode(cevap) end)
    if okD and type(data) == "table" and type(data.pvs) == "table" and data.pvs[1] and type(data.pvs[1].moves) == "string" then
        local ilk = data.pvs[1].moves:match("^(%S+)")
        if ilk and #ilk >= 4 then
            return ilk, "lichess(d" .. tostring(data.depth or "?") .. ")"
        end
    end
    return nil
end

local function bestMove(s)
    -- KATMAN -1: LICHESS BULUT STOCKFISH (depth 75'e kadar — en guclu katman)
    local okL, uciL, srcL = pcall(lichessBestMove, s)
    if okL and uciL then
        return uciL, srcL
    end
    -- KATMAN 0: SUNUCU STOCKFISH (VortexThink) — hamle r.uci alaninda, HER context'te calisiyor
    -- (onceki "nil" sanigimiz: r.best'a bakiyorduk, hamle r.uci'deymis!)
    local vortex = Chess:FindFirstChild("VortexThink")
    if vortex then
        local ok, r = pcall(function()
            return vortex:InvokeServer({
                startFen = s.startFen or START_FEN,
                moves = table.clone(s.ucis or {}),
                persona = {
                    rating = CFG.engineRating or 2800,
                    noise = 0,
                    blunder = 0,
                    time = (CFG.engineSeconds or 2) * 1000,
                },
            })
        end)
        if ok and type(r) == "table" and type(r.uci) == "string" and #r.uci >= 4 then
            return r.uci, "stockfish(" .. tostring(r.score) .. "/d" .. tostring(r.depth) .. ")"
        end
        -- SIKLIK SINIRI: nil gelirse 1.2 sn bekleyip BIR KEZ daha dene
        if ok then
            task.wait(1.2)
            local ok2, r2 = pcall(function()
                return vortex:InvokeServer({
                    startFen = s.startFen or START_FEN,
                    moves = table.clone(s.ucis or {}),
                    persona = {
                        rating = CFG.engineRating or 2800,
                        noise = 0,
                        blunder = 0,
                        time = (CFG.engineSeconds or 2) * 1000,
                    },
                })
            end)
            if ok2 and type(r2) == "table" and type(r2.uci) == "string" and #r2.uci >= 4 then
                return r2.uci, "stockfish-retry(" .. tostring(r2.score) .. ")"
            end
        end
    end
    -- KATMAN 1: sunucu Vortex motoru (2800+)
    -- InvokeServer asla blocksuz kullanilmaz: sunucu cevap vermeyince thread SONSUZ
    -- bekler (oyunun kendi invokeWithTimeout gibi). Sureli sarmalayici:
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

    local analyse = Chess:FindFirstChild("VortexAnalyse")
    if analyse then
        local r = invokeAnalyseSureli({
            startFen = s.startFen or START_FEN,
            moves = table.clone(s.ucis or {}),
            seconds = engineSeconds(s),
        }, (engineSeconds(s) or 2) + 2)
        if type(r) == "table" then
            if type(r.best) == "string" and #r.best >= 4 then
                return r.best, "vortex(" .. tostring(r.score) .. ")"
            end
            if r.terminal then
                return nil, "terminal"
            end
        end
    end
    -- KATMAN 1.5: CHESS-API STOCKFISH 17 (online dahil her pozisyon)
    local okC, uciC, srcC = pcall(chessApiBestMove, s)
    if okC and uciC then
        return uciC, srcC
    end
    -- KATMAN 2: local Bot
    local persona = {
        rating = CFG.strength,
        noise = math.max(0, (2400 - CFG.strength) / 2400),
        blunder = CFG.strength < 1200 and 0.04 or 0,
        time = 900,
    }
    local baslangic = os.clock()
    local cancelled = { cancelled = function()
        return os.clock() - baslangic > 3
    end }
    local ok, uci = pcall(function()
        return LocalBot.think(s.startFen or START_FEN, table.clone(s.ucis or {}), persona, cancelled)
    end)
    if ok and type(uci) == "string" and #uci >= 4 then
        return uci, "local-bot"
    end
    return nil, "none"
end

local function turnKey(s)
    return tostring(s.id or tostring(s.startFen or "?")) .. ":" .. #(s.ucis or {})
end

local function uciToSquares(uci)
    -- session:findMove formati: (rank-1)*8 + file  (canli testle dogrulandi)
    local function sq(p)
        local file = string.byte(string.sub(p, 1, 1)) - 96
        local rank = tonumber(string.sub(p, 2, 2))
        return (rank - 1) * 8 + file
    end
    return sq(string.sub(uci, 1, 2)), sq(string.sub(uci, 3, 4))
end


local function oyna(uci)
    local s = App.session
    if not s then return false, "no session" end
    if s.kind == "online" then
        -- KULLANICI TIKLAMA YOLU + terfi destegi + dogrulama
        local temel = string.sub(uci, 1, 4)
        local promoHarf = #uci >= 5 and string.sub(uci, 5, 5) or nil
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
        -- terfi: harfin indeksi once, sonra varsayilan; normal: tek deneme
        if promoHarf then
            local idxler = { q = 1, r = 2, b = 3, n = 4 }
            if idxler[promoHarf] and denemeYap(idxler[promoHarf]) then return true end
            if denemeYap(nil) then return true end
            return false, "onBoardMove: terfi dusmedi"
        end
        if denemeYap(nil) then return true end
        return false, "onBoardMove: hamle dusmedi"
    end
    local okA, rA = pcall(function()
        local v = s:applyUci(uci)
        if not v and type(uci) == "string" and #uci == 4 then
            v = s:applyUci(uci .. "q")
        end
        if v then
            App.afterMove(v, { fromBot = true })
        end
        return v
    end)
    if okA and rA then return true end
    return false, "applyUci: " .. tostring(rA)
end

-- AUTO-PLAY LOOP (online + bot games) ----------------------------------------

getgenv().RCH_STAGE = "gui-ok"
-- SUPERVIZORLU DONGU: her tik xpcall ile korumali — hata olursa loglanir, dongu ASLA olmez
task.spawn(function()
    while myGen == getgenv().RCH_GEN do
        local okL, hataL = xpcall(function()
            local cfg = getgenv().RCH
            if not cfg then return end
            cfg.tick = os.clock() -- kalp atisi: dongu canli mi?
            -- watchdog: thinking takilirse (since yoksa DAHIL) kendini cozer
            if cfg.thinking and (not cfg.thinkingSince or os.clock() - cfg.thinkingSince > 12) then
                cfg.thinking = false
                cfg.lastError = "watchdog: think task stuck"
            end
            local s = App.session
            if s and s.over and not cfg.wasOver then
                cfg.wasOver = true
                notify("♟️ Game Over", "Auto-Play ready for the next game.", 3)
            elseif s and not s.over and cfg.wasOver then
                cfg.wasOver = false
                cfg.lastTurnKey = ""
            end
            local oyunVar = s and (s.kind == "online" or s.kind == "bot")
            local mt = s and myTurnNow(s) or false
            cfg.sonDurum = "ap=" .. tostring(cfg.autoPlay) .. " hint=" .. tostring(cfg.hintMode)
                .. " think=" .. tostring(cfg.thinking) .. " oyun=" .. tostring(oyunVar)
                .. " myTurn=" .. tostring(mt) .. " over=" .. tostring(s and s.over)
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
                            -- bullet: hizli dusun
                            local dMin, dMax = cfg.delayMin, cfg.delayMax
                            local okC, tcSinif = pcall(function() return sess.tc and sess.tc.class end)
                        if sess.kind == "online" then
                            -- online: hizli oyna (kullanici yarisi almasin)
                            dMin, dMax = math.min(dMin, 600), math.min(dMax, 1500)
                        end
                        if isBullet(sess) then
                            dMin, dMax = math.min(dMin, 300), math.min(dMax, 700)
                        elseif okC and tcSinif == "blitz" then
                            dMin, dMax = math.min(dMin, 500), math.min(dMax, 1200)
                            end
                            task.wait(math.random(dMin, dMax) / 1000)
                            local s2 = App.session
                            if not s2 or s2.over or not myTurnNow(s2) then
                                return
                            end
                            local uci, src = bestMove(s2)
                            if not uci then
                                cfg.lastError = "engine returned nothing"
                                return
                            end
                            local s3 = App.session
                            if not s3 or s3.over or not myTurnNow(s3) then
                                return
                            end
                            if getgenv().RCH.autoPlay then
                                local okP, neden = oyna(uci)
                                if okP then
                                    CFG.stats.played = CFG.stats.played + 1
                                    pcall(function() App.board:setArrow("hint") end)
                                    cfg.lastSrc = tostring(src)
                                    cfg.lastMove = tostring(uci)
                                    cfg.lastMoveAt = os.clock()
                                    notify("♟️ Auto-Play", uci .. " (" .. tostring(src) .. ") — #" .. tostring(CFG.stats.played), 2)
                                else
                                    cfg.lastError = "play fail: " .. tostring(neden)
                                    cfg.lastTurnKey = "" -- kilidi ac: dongu tekrar denesin
                                    notify("⚠️ Auto-Play fail", tostring(neden), 4)
                                end
                            elseif getgenv().RCH.hintMode then
                                CFG.stats.hints = CFG.stats.hints + 1
                                pcall(function()
                                    local hf, ht = uciToSquares(uci)
                                    App.board:setArrow("hint", hf, ht)
                                end)
                                notify("💡 Hint (" .. tostring(src) .. ")", "Best move: " .. uci, 4)
                            end
                        end, debug.traceback)
                        cfg.thinking = false
                        if not okIc then
                            cfg.lastError = tostring(hata):sub(1, 300)
                        end
                    end)
                end
            elseif not oyunVar then
                cfg.lastTurnKey = ""
            end
        end, debug.traceback)
        if not okL then
            pcall(function()
                getgenv().RCH.lastError = "loop: " .. tostring(hataL):sub(1, 200)
            end)
        end
        task.wait(0.4)
    end
end)

-- PUZZLE AUTO-SOLVER ---------------------------------------------------------

task.spawn(function()
    while myGen == getgenv().RCH_GEN do
        task.wait(0.5)
        local cfg = getgenv().RCH
        if not cfg then break end
        if cfg.pzBusy then
            -- bekleniyor
        else
            local s = App.session
            local puzzleOturumu = s and (s.kind == "puzzle" or s.kind == "rush") and s.pz
            if puzzleOturumu and not puzzleOturumu.done and not puzzleOturumu.busy and not puzzleOturumu.wrong and not s.over then
                local pz = s.pz
                local myTurn = false
                pcall(function() myTurn = s:isMyTurn() == true end)
                -- cozum satiri: pz.sol veya pz.data.moves
                local cozim = nil
                if type(pz.sol) == "table" and pz.sol[pz.step or 1] then
                    cozim = pz.sol[pz.step]
                elseif type(pz.data) == "table" and type(pz.data.moves) == "table" and pz.data.moves[pz.step or 1] then
                    cozim = pz.data.moves[pz.step or 1]
                end
                if myTurn and type(cozim) == "string" and #cozim >= 4 then
                    cfg.pzBusy = true
                    cfg.pzSince = os.clock()
                    task.spawn(function()
                        local okIc, hata = xpcall(function()
                            task.wait(math.random(400, 1100) / 1000)
                            local s2 = App.session
                            local pz2 = s2 and s2.pz
                            if not (pz2 and not pz2.done and not pz2.busy) then return end
                            local step = pz2.step or 1
                            local u = (type(pz2.sol) == "table" and pz2.sol[step]) or (pz2.data and pz2.data.moves and pz2.data.moves[step])
                            if type(u) ~= "string" or #u < 4 then return end
                            local from, to = uciToSquares(u)
                            local promo = #u >= 5 and string.sub(u, 5, 5) or nil
                            local okP = pcall(function() return App.puzzleMove(from, to, promo) end)
                            if okP then
                                CFG.stats.puzzles = CFG.stats.puzzles + 1
                            else
                                cfg.lastError = "puzzleMove fail"
                            end
                        end, debug.traceback)
                        cfg.pzBusy = false
                        if not okIc then
                            cfg.lastError = "pz: " .. tostring(hata):sub(1, 200)
                        end
                    end)
                elseif myTurn and not cozim then
                    -- cozum satiri client'ta yok: motorla coz
                    cfg.pzBusy = true
                    task.spawn(function()
                        local okIc, hata = xpcall(function()
                            task.wait(math.random(500, 1200) / 1000)
                            local s2 = App.session
                            if not (s2 and s2.pz and not s2.pz.done and not s2.pz.busy) then return end
                            local uci, src = bestMove(s2)
                            if not uci then return end
                            local from, to = uciToSquares(uci)
                            local promo = #uci >= 5 and string.sub(uci, 5, 5) or nil
                            local okP = pcall(function() return App.puzzleMove(from, to, promo) end)
                            if okP then
                                CFG.stats.puzzles = CFG.stats.puzzles + 1
                                notify("🧩 Puzzle", uci .. " (" .. tostring(src) .. ")", 2)
                            end
                        end, debug.traceback)
                        cfg.pzBusy = false
                        if not okIc then
                            cfg.lastError = "pzc: " .. tostring(hata):sub(1, 200)
                        end
                    end)
                end
            end
        end
        -- pz watchdog
        if cfg.pzBusy and cfg.pzSince and os.clock() - cfg.pzSince > 12 then
            cfg.pzBusy = false
        end
    end
end)

-- DAILY TASK CLAIMER ---------------------------------------------------------
-- Cevap sekli (canli olculdu): {tokens=number, p={capture=25,play=4,win=2}, c={claimed...}, resetAt=number}
-- Hedefler Config.DAILY_TASKS'te (id + goal). p[id] >= goal ve c[id] yoksa -> claimTask.

task.spawn(function()
    while myGen == getgenv().RCH_GEN do
        task.wait(180)
        local cfg = getgenv().RCH
        if not cfg then break end
        if cfg.dailyClaim then
            pcall(function()
                local r = App.request({ type = "tasks" })
                if type(r) ~= "table" or type(r.p) ~= "table" then return end
                local ilerleme = r.p
                local talepler = r.c or {}
                local Config = require(Chess:WaitForChild("Config"))
                local gorevler = Config.DAILY_TASKS or {}
                for _, gorev in ipairs(gorevler) do
                    if type(gorev) == "table" and gorev.id and gorev.goal then
                        local p = tonumber(ilerleme[gorev.id]) or 0
                        local zatenClaim = (talepler[gorev.id] ~= nil) and (talepler[gorev.id] ~= false)
                        if p >= tonumber(gorev.goal) and not zatenClaim then
                            -- oyunun kendi yolu: REQUEST + ok kontrolu (FireServer islemiyor!)
                            local okC, cevap = pcall(function()
                                return App.request({ type = "claimTask", id = gorev.id })
                            end)
                            local basarili = okC and type(cevap) == "table" and cevap.ok == true
                            if basarili then
                                CFG.stats.claims = CFG.stats.claims + 1
                                notify("🎁 Daily Task", "Claimed: " .. tostring(gorev.label or gorev.id) .. " → +" .. tostring(gorev.reward) .. " tokens", 3)
                            else
                                cfg.lastError = "claim fail: " .. tostring(gorev.id)
                            end
                            task.wait(1.5)
                        end
                    end
                end
            end)
        end
    end
end)

-- GUI -----------------------------------------------------------------------

TabMain:CreateParagraph("HowIt", {
    Title = "♟️ Hybrid Engine (Stockfish 17 NNUE)",
    Content = "1. Lichess Cloud Stockfish (up to depth 75)\n2. chess-api Stockfish 17 NNUE (any position)\n3. Server Vortex (bot matches)\n4. Local Bot (silent fallback, auto-engages if APIs fail)\n\nBullet mode: faster think + shorter delays automatically.\nAuto-Play works in rated, casual and bot games.",
})

TabMain:CreateToggle("AutoPlay", {
    Title = "▶️ Auto-Play",
    Description = "Plays your moves automatically (rated, casual, bot). Human-like delays, bullet-aware.",
    Default = false,
    Callback = function(v)
        getgenv().RCH.autoPlay = v
        if v then
            getgenv().RCH.hintMode = false
            -- taze baslangic: takili kilirleri temizle
            getgenv().RCH.thinking = false
            getgenv().RCH.thinkingSince = nil
            getgenv().RCH.pzBusy = false
            getgenv().RCH.lastTurnKey = ""
        end
        notify("RoChess Hub", v and "Auto-Play ON" or "Auto-Play OFF", 2)
    end,
})

TabMain:CreateToggle("HintMode", {
    Title = "💡 Hint Mode",
    Description = "Shows the best move as a notification WITHOUT playing it.",
    Default = false,
    Callback = function(v)
        getgenv().RCH.hintMode = v
        if v then getgenv().RCH.autoPlay = false end
        notify("RoChess Hub", v and "Hint Mode ON" or "Hint Mode OFF", 2)
    end,
})


pcall(function()
    TabMain:Slider("DelayMin", {
        Title = "Min Think Delay (ms)",
        Description = "Minimum human-like delay. Bullet auto-caps this.",
        Default = 1200,
        Min = 300,
        Max = 5000,
        Rounding = 0,
        Callback = function(v)
            getgenv().RCH.delayMin = v
        end,
    })
end)

pcall(function()
    TabMain:Slider("DelayMax", {
        Title = "Max Think Delay (ms)",
        Description = "Maximum human-like delay. Bullet auto-caps this.",
        Default = 3500,
        Min = 500,
        Max = 9000,
        Rounding = 0,
        Callback = function(v)
            getgenv().RCH.delayMax = v
        end,
    })
end)

pcall(function()
    TabMain:Slider("EngineSeconds", {
        Title = "Vortex Think Time (s)",
        Description = "Server engine thinking seconds per move (1 = bullet-safe).",
        Default = 2,
        Min = 1,
        Max = 4,
        Rounding = 0,
        Callback = function(v)
            getgenv().RCH.engineSeconds = v
        end,
    })
end)

TabExtra:CreateParagraph("PuzzleInfo", {
    Title = "🧩 Puzzle Auto-Solver",
    Content = "Solves puzzles automatically using the solution line (when the client has it) or the Vortex engine. Works in puzzles and puzzle rush.",
})

TabExtra:CreateToggle("PuzzleSolver", {
    Title = "🧩 Puzzle Auto-Solver",
    Description = "Automatically solves puzzles (normal + rush). Turn on while on the Puzzles page.",
    Default = false,
    Callback = function(v)
        getgenv().RCH.puzzleSolver = v
        notify("RoChess Hub", v and "Puzzle Solver ON" or "Puzzle Solver OFF", 2)
    end,
})

TabExtra:CreateParagraph("DailyInfo", {
    Title = "🎁 Daily Tasks",
    Content = "Checks your daily tasks every 5 minutes and claims completed rewards automatically.",
})

TabExtra:CreateToggle("DailyClaim", {
    Title = "🎁 Auto-Claim Daily Tasks",
    Description = "Claims finished daily task rewards automatically every 5 minutes.",
    Default = false,
    Callback = function(v)
        getgenv().RCH.dailyClaim = v
        notify("RoChess Hub", v and "Daily Claim ON (checks every 5 min)" or "Daily Claim OFF", 2)
    end,
})

TabInfo:CreateParagraph("HowItWorks", {
    Title = "How it works",
    Content = "Engine cascade: Lichess Cloud Stockfish (d75, known positions) -> chess-api Stockfish 17 NNUE (any position, works online) -> Server Vortex (bot matches) -> Local Bot (silent last resort).\n\nAuto-Play: online games via the game's move API, bot games via session apply (the game's own bot path).\n\nPuzzles: solution line from client state, else engine solve. Submissions are server-graded.\n\nBullet: think time and delays auto-tighten.\n\nMinimize: Right Ctrl",
})

TabInfo:CreateParagraph("Safety", {
    Title = "Note",
    Content = "No client-side anti-cheat exists in this game. But in RATED online games, perfect engine play is statistically visible (accuracy reports). Use lower strength there if long sessions. Bot games and puzzles are safe.",
})

-- DISCORD TAB (en altta) -----------------------------------------------------

local TabDiscord = Window:CreateTab({ Title = "Discord", Icon = "globe" })

TabDiscord:CreateParagraph("DiscordInfo", {
    Title = "♟️ Discord",
    Content = "Our community server: updates, announcements and support.",
})

pcall(function()
    TabDiscord:CreateButton({
        Title = "💬 Join Discord Server",
        Description = "Fetches the invite from GitHub (always up to date) and copies it.",
        Callback = function()
            task.spawn(function()
                local davet = nil
                pcall(function()
                    local c = game:HttpGetAsync("https://raw.githubusercontent.com/myheisenberg/Fluent-Renewed/main/discord.txt")
                    if c and string.find(c, "discord.gg/") then davet = c:gsub("%s+", "") end
                end)
                if not davet then davet = "https://discord.gg/ehbX2MVbTw" end
                pcall(function() setclipboard(davet) end)
                notify("💬 Discord", "Invite copied — paste it in your browser!", 4)
            end)
        end,
    })
end)

-- MAC SONU WEBHOOK ----------------------------------------------------------

getgenv().RCH_CLEANUP = function()
    getgenv().RCH.autoPlay = false
    getgenv().RCH.hintMode = false
    getgenv().RCH.puzzleSolver = false
    getgenv().RCH.dailyClaim = false
    pcall(function() Fluent:Destroy() end)
end

Window:SelectTab(1)
pcall(function() Fluent.GUI.Name = "ZynexRoChess" end)
notify("♟️ RoChess Hub v2.0", (isMobile and "MOBILE" or "PC") .. " mode — Auto-Play + Puzzles + Daily", 4)
return "RoChess Hub v2.0 loaded (" .. (isMobile and "mobile" or "pc") .. ")"
