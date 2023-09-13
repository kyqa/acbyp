repeat wait() until game:IsLoaded()
print('Initialized')
if game.PlaceId == 8204899140 then
	local Players = game:GetService("Players")

	--local NewHash = ""
	--local CurrentHash = ""
	local UpdatedVersion = 212
	local WhitelistedSeq = {
		[1] = {
			[1] = 655, --// [number]
			[2] = 775, --// [number]
			[3] = 724, --// [number]
			[4] = 633, --// [number]
			[5] = 891 --// [number]
		}, --// table: 0x000000005324f5c9 [table]
		[2] = {
			[1] = 760, --// [number]
			[2] = 760, --// [number]
			[3] = 771, --// [number]
			[4] = 665, --// [number]
			[5] = 898 --// [number]
		}, --// table: 0x000000005e818c89 [table]
		[3] = {
			[1] = 660, --// [number]
			[2] = 759, --// [number]
			[3] = 751, --// [number]
			[4] = 863, --// [number]
			[5] = 771 --// [number]
		} --// table: 0x000000008053a989 [table]
	} --// table: 0x0000000043132109 [table]
	
	--[[local Booleans = {  --// Detection Booleans
		[1] = false; --// Metatable (Sequence) Indexing
		[2] = false; --// Checks for illegal images in coregui?
		[3] = false; --// Teleporting
		[4] = false; --// Humanoid Modifications (HipHeight, WalkSpeed, JumpPower, UseJumpPower)
		[5] = false; --// Changing Size (Catch, HumanoidRootPart)
		--// bools 6-19 don't neccesarilly trigger bans and are linked to other bools (1-5 & 20-22)
		[6] = true;
		[7] = true;
		[8] = true;
		[9] = true;
		[10] = true;
		[11] = true;
		[12] = true;
		[13] = true;
		[14] = true;
		[15] = true;
		[16] = true;
		[17] = true;
		[18] = true;
		[19] = true;
		--// end of links :)
		[20] = false; --// Football Modification
		[21] = false; --// Changing Gravity
		[22] = false; --// Seems to control if parts of the ac is disabled? (true = disable, false = enable)
	}]]
	
	local BooleanIndex = {
		[1] = 17;
		[2] = 19;
		[3] = 41;
		[4] = 44;
		[5] = 10;
		--// Links
		[6] = 28;
		[7] = 29;
		[8] = 30;
		[9] = 31;
		[10] = 32;
		[11] = 33;
		[12] = 34;
		[13] = 35;
		[14] = 36;
		[15] = 37;
		[16] = 38;
		[17] = 39;
		[18] = 9;
		[19] = 11;
		--// End of Links
		[20] = 40;
		[21] = 43;
		[22] = 18;
	}
	
	local BoolReasons = {
		[1] = "Metatable (Sequence) Indexing";
		[2] = "Illegal Image in CoreGui";
		[3] = "Teleporting";
		[4] = "Humanoid Modification";
		[5] = "Size Modification";
		--// Links
		[6] = "Link";
		[7] = "Link";
		[8] = "Link";
		[9] = "Link";
		[10] = "Link";
		[11] = "Link";
		[12] = "Link";
		[13] = "Link";
		[14] = "Link";
		[15] = "Link";
		[16] = "Link";
		[17] = "Link";
		[18] = "Link";
		[19] = "Link";
		--// End of Links
		[20] = "Football Moditification";
		[21] = "Gravity Modification";
		[22] = "AC Disabled";
	}
	
	local CurrentBools;
	local SequenceLinks = {}
	local MainFunction;
	
	local BlacklistNumber = Random.new():NextNumber(-9e5, 9e5)
	
	local _DEBUGGING = false
	local RemoteEvent;
	local ReadyForExecution = false
	local ProblemEncountered = false
	local BypassVerified = false
	
	if getgenv().BypassInitiated then
		return;
	end
	
	getgenv().BypassInitiated = true
	
	local function UpdateBools()
		local Upvalues = getupvalues(MainFunction)
	
		CurrentBools = {}
	
		for i, v in next, BooleanIndex do
			if Upvalues[v] ~= nil then
				CurrentBools[i] = Upvalues[v]
			elseif not ProblemEncountered then
				task.spawn(messagebox, "A problem has been encountered while trying to bypass. Please report this error message to the developers:\nTBP:BUF-UnK", "Problem Encountered", 1)
				game:Shutdown()
			end
		end
	end
	
	local function GetLinkedSequence(Sequence, Function)
		if not MainFunction then
			return;
		end
	
		local SeqHash = 1;
	
		for _, v in next, Sequence do
			SeqHash *= v
		end
	
		if Function == MainFunction then
			return "AC Fail-Safe" --// Main ac function is trying to ban us, it's a fail-safe triggered by (a) boolean(s) being true
		end
	
		if SequenceLinks[SeqHash] then
			return (BoolReasons[SequenceLinks[SeqHash]] or "Unknown") .. " (Cached)"
		end
	
		local DiffBool;
		local Upvalues = getupvalues(MainFunction)
	
		local NewBools = {}
	
		for i, v in next, BooleanIndex do
			NewBools[i] = Upvalues[v]
		end
	
		for i, v in next, NewBools do
			if v ~= CurrentBools[i] then
				DiffBool = i
			end
		end
	
		local LinkedSequence = BoolReasons[DiffBool] or "Unknown"
	
		if DiffBool then
			setupvalue(MainFunction, BooleanIndex[DiffBool], CurrentBools[DiffBool])
		end
	
		SequenceLinks[SeqHash] = DiffBool or 0/0;
		CurrentBools = NewBools
	
		return LinkedSequence
	end
	
	local function Debug(Method, ...)
		if _DEBUGGING then
			getgenv()[Method](...)
		end
	end
	
	local FormatTable = function()
		return;
	end
	
	if _DEBUGGING then
		FormatTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoTwistedHere/Roblox/main/FormatTable.lua"))() --// FormatTable :)
	end
	
	local function IsValidSequence(Sequence)
		for _, v in next, WhitelistedSeq do
			local Valid = 0
	
			for i, k in next, v do
				if Sequence[i] == k then
					Valid += 1
				end
			end
	
			if Valid == 5 then
				return true
			end
		end
	
		return false
	end
	
	local function SetMetatable(Meta)
		local Func = getrawmetatable(Meta).__call
		local FEnv = getrawmetatable(getfenv(Func)).__index
	
		setreadonly(FEnv.debug, false)
	
		FEnv.debug.info = function() --// SW is bitch for this
			return "You're a faggot of a LocalScript" --// Bypass caller check
		end
	
		setreadonly(FEnv.debug, true)
	
		local HookedAt = os.clock()
		local Logging;
		local LogCount = 0
		local CompletedCycles = 0
	
		getrawmetatable(Meta).__call = function(...)
			local Arguments = {...}
			local Table = table.remove(Arguments, 1) --// self
			local Caller = getinfo(2).func
	
			if not CurrentBools then
				local CallerInfo = getinfo(Caller)
	
				if CallerInfo.numparams == 3 and CallerInfo.nups > 40 and CallerInfo.is_vararg == 0 then
					MainFunction = Caller
					UpdateBools()
				end
			end
	
			if not IsValidSequence(Arguments) then
				if (os.clock() - HookedAt < 1 or #WhitelistedSeq == 0) and not Logging and CompletedCycles == 0 and not ProblemEncountered and not ReadyForExecution then --// Most likely the ac has updated
					Debug("warn", "[AUTO UPDATING BYPASS SEQUENCES] - STARTING")
	
					Logging = true
					WhitelistedSeq = {}
				end
	
				if not Logging then
					Debug("warn", "Blocked: ", FormatTable({
						["Suspected Ban Reason"] = GetLinkedSequence(Arguments, getinfo(2).func);
						["Sequence"] = Arguments;
					}))
	
					return BlacklistNumber
				else
					if Caller == MainFunction then
						Debug("warn", "Whitelisted", FormatTable(Arguments))
						table.insert(WhitelistedSeq, Arguments)
					else
						Debug("warn", "Unexpected function tried updating mt while whitelisting")
					end
				end
			elseif Logging then
				LogCount += 1
	
				if LogCount >= #WhitelistedSeq then --// This should only take a few cycles
					CompletedCycles += 1
	
					if CompletedCycles > 2 then
						Debug("warn", "[AUTO UPDATING BYPASS SEQUENCES] - COMPLETE")
	
						Logging = false
					end
				elseif CompletedCycles > 0 then
					CompletedCycles -= 1
				end
			end
	
			if not Logging then
				ReadyForExecution = true
			end
	
			--Debug("print", "not blocked", FormatTable(Arguments))
	
			return Func(...)
		end
	end
	
	repeat
		task.wait()
	until Players.LocalPlayer and Players.LocalPlayer.Character
	
	task.delay(8, function() --// If the bypass hasn't successfully executed by now, kick the player or shutdown the game
		if not ReadyForExecution and not ProblemEncountered then
			if not ProblemEncountered then
				task.spawn(messagebox, "A problem has been encountered while trying to bypass. Please report this error message to the developers:\nTBP:ExT-8", "Problem Encountered", 1)
				game:Shutdown()
			end
		end
	end)
	
	--[[local function GetGameHash(Function)
		local Source = getinfo(Function).source
		local Raw = ""
	
		for i, v in next, getreg() do
			if type(v) == "function" and getinfo(v).source == Source then
				local Info = getinfo(v)
				local Constants = getconstants(v)
				local FS = "#@C:"
	
				for i, v in next, Constants do
					if type(v) == "string" then
						FS ..= i.."-"..v.."~"
					end
				end
	
				FS ..= "@I:"..Info.nups.."~"..Info.name.."~"..Info.currentline.."~"..Info.numparams
	
				Raw ..= FS
			end
		end
	
		return Hash(Raw)
	end]]
	
	for _, v in next, getconnections(Players.LocalPlayer.Character.ChildAdded) do --// Loop through connections and grab the upper level character detections func
		if v.Function then
			local FInfo = getinfo(v.Function)
			
			if FInfo.nups == 9 then
				--// Party
	
				--[[NewHash = GetGameHash(v.Function)
	
				if NewHash ~= CurrentHash then
					Debug("warn", "Game has updated, updating bypass")
					WhitelistedSeq = {}
				end]]
	
				if game.PlaceVersion ~= UpdatedVersion then
					Debug("warn", "Game has updated, updating bypass")
					WhitelistedSeq = {}
				else
					Debug("warn", "Game has NOT updated")
				end
	
				RemoteEvent = getupvalue(v.Function, 8) --// Ban RE
				SetMetatable(getupvalue(v.Function, 9)) --// new_mt :>)
	
				Debug("warn", "Grabbed RemoteEvent & Metatable")
			end
		end
	end
	
	--// Hook FireServer & block blacklisted sequences from firing
	
	local OldHook; OldHook = hookfunction(RemoteEvent.fireServer, function(...) --// Hook FireServer (fireServer & FireServer direct to the same function)
		local Arguments = {...}
		local self = table.remove(Arguments, 1)
	
		if typeof(self) == "Instance" and self == RemoteEvent and type(Arguments[1]) == "string" and Arguments[1]:sub(1, 2) == "AC" then
			Debug("print", "FireServer request", FormatTable(Arguments))
	
			for _, v in next, Arguments do
				if (type(v) == "number" and v == BlacklistNumber) or (type(v) == "string" and v == "error") then
					Debug("warn", "BLACKLISTED SEQ TRIED TO RUN")
	
					return; --// Block blacklisted sequences from being sent
				end
			end
	
			Debug("print", "FireServer sent", FormatTable(Arguments))
		end
	
		return OldHook(...)
	end)
	
	local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", function(...)
		local Arguments = {...}
		local self = table.remove(Arguments, 1)
		local Method = getnamecallmethod()
	
		if (Method == "FireServer" or Method == "fireServer") and typeof(self) == "Instance" and self == RemoteEvent and type(Arguments[1]) == "string" and Arguments[1]:sub(1, 2) == "AC" then
			Debug("print", "FireServer request", FormatTable(Arguments))
	
			if not BypassVerified then
				if not Arguments[2] then
					Debug("warn", "Arguments[2] is nil, this is a problem")
					ProblemEncountered = true
					
					pcall(function()
						task.spawn(messagebox, "A problem has been encountered while trying to bypass. Please report this error message to the developers:\nTBP:BVF-AG2N", "Problem Encountered", 1)
						game:Shutdown()
					end)
				elseif type(Arguments[2]) == "table" and ReadyForExecution then
					BypassVerified = true
				end
			end
	
			for _, v in next, Arguments do
				if (type(v) == "number" and v == BlacklistNumber) or (type(v) == "string" and v == "error") then
					Debug("warn", "BLACKLISTED SEQ TRIED TO RUN")
	
					return; --// Block blacklisted sequences from being sent
				end
			end
	
			Debug("print", "FireServer sent", FormatTable(Arguments))
		end
	
		return OldNamecall(...)
	end)
	
	local OldDelay; OldDelay = hookfunction(delay, function(...) --// 'WhY uSe ElIpSeS iNsTeAd Of PaRaMs' - 1) stfu 2) to prevent scripts from intentionally causing an error (some errors can be caused by using defined params)
		local _, Function = ...
	
		if type(Function) == "function" and getinfo(Function).source:match("PlayerModule.LocalScript") then
			return; --// Block the function from being called
		end
	
		return OldDelay(...)
	end)
	
	repeat
		task.wait()
	until ReadyForExecution
	
	repeat
		task.wait()
	until BypassVerified
	
	Debug("warn", "[READY FOR EXECUTION]")
	
	if _DEBUGGING then
		Debug("warn", "Dumping sequences & current hash to clipboard")
		setclipboard(FormatTable({
			Sequences = WhitelistedSeq;
			--Hash = NewHash
			PlaceVersion = game.PlaceVersion;
		}))
	end

	getgenv().AC_BYPASS_DONE = true
end
