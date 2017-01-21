ChatSanitizer = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1", "FuBarPlugin-2.0")
ChatSanitizer.cachedRatings = {}
ChatSanitizer.blockHistory = {}
ChatSanitizer.numBlocked = 0

local Tablet = AceLibrary("Tablet-2.0")

ChatSanitizer.name = "FuBar_ChatSanitizer"
ChatSanitizer.version = "1.0." .. string.sub("$Revision: 1200 $", 12, -3)
ChatSanitizer.hasIcon = "Interface\\Icons\\Ability_Seal"
ChatSanitizer.defaultPosition = 'LEFT'
ChatSanitizer.defaultMinimapPosition = 180
ChatSanitizer.canHideText = false
ChatSanitizer.hasNoColor = true
ChatSanitizer.cannotDetachTooltip = true

-- Stolen from SpamMeNot
ChatSanitizer.words = {	
	["5uneed"] = 50,
	["gold4guild"] = 50,
	["mm4ss"] = 50,
	["peons"] = 50,
	["peonz"] = 50,
	["fcwow"] = 50,
	["4hire"] = 30,
	["p4hire"] = 50,
	["g4pwowitems"] = 50,
	["ourgamecenter"] = 50,
	["mmo4store"] = 50,
	["fzf"] = 50,
	["happy"] = 40,
	["worker"] = 25,
	["wow%-europe%.cn"] = 80,
	["epicinn"] = 50,
	["working"] = 20,
	["delivery"] = 30,
	["deliveries"] = 30,
	["manfarm"] = 20,
	["power"] = 25,	
	["level"] = 25,
	["lvl"] = 20,
	["mmo"] = 15,
	["pwr"] = 20,
	["store"] = 20,
	["gold"] = 30,
	["coin"] = 30,
	["get%s*gold"] = 10,
	["currency"] = 30,
	["account"] = 30,
	["%d+g"] = 10,
	["all%scustomer"] = 10,
	["profession"] = 30,
	["buy"] = 20,
	["purchase"] = 20,
	["sell"] = 20,
	["payment"] = 20,
	["dollar"] = 30,
	["pound"] = 30,
	["euro"] = 30,
	["€"] = 30,
	["%d+%s*eur"] = 30,
	["%d+%s*pound"] = 30,
	["%d+%s*usd"] = 30,
	["%d+%s*gbp"] = 30,
	["$$"] = 30,
	["$%d+"] = 30,
	["£"] = 30,
	["offer"] = 15,
	["free"] = 15,
	["order"] = 15,
	["fast"] = 15,
	["cheap"] = 15,
	["price"] = 10,
	["low"] = 10,
	["courtious"] = 15,
	["safe"] = 15,
	["special"] = 15,
	["service"] = 30,
	["p&l"] = 50,
	["days"] = 10,
	["discount"] = 20,
	["code"] = 10,
	["www"] = 25,
	["3vv"] = 25,
	["wvvw"] = 25,
	["%.com"] = 25,
	["%,com"] = 25,
	[" com"] = 10,
	["dot%s*com"] = 25,
	["dot%s*cn"] = 75,
	["%.cn"] = 75,
	["%,cn"] = 75,
	["banned"] = 15,
	["hi"] = 5,
	["web"] = 20,
	["site"] = 20,
	["welcome%s*to"] = 30,
	["wellcome%s*to"] = 15,
	["wellcome"] = 15,
	["we"] = 5,
	["best"] = 15,
	["choice"] = 15,
	["mount"] = 15,
	["promotion"] = 15,
	["wow%-toolbox"] = 50,
	["hack"] = 40,
	["undetectable"] = 20,
	["download"] = 30,
	["health"] = 10,
	["mana"] = 10,
	["solo"] = 10,
	["instance"] = 10,
	["elite"] = 10,
	["mob"] = 5,
	["%?"] = 5,
	["guarantee"] = 15,
	[">>"] = 12,
	["<<"] = 12,
	["=="] = 10,
	["server"] = 10,
	["65%s*%-%s*70"] = 15,
	["60%s*%-%s*70"] = 15,
	["1%s*%-%s*60"] = 15,
	["24%s*/*%s*7"] = 15,
	["level%s*%d+%s*account"] = 40,
	["stat%s*changer"] = 50,
	["live%s*chat"] = 30,
	["dude,%syou%ssuck,%sstop%sbeing%sa%sn00b."] = 100,
	["sell.*account"] = 50,
	["%d%s*customers"] = 15,
	["bonus"] = 10,
	["with%s*in%s*%d"] = 10,
	["e%-shop"] = 50,
	["c{circle}m"] = 25,
	["c@m"] = 25,
	["buyeugold"] = 50,
	["byeugold"] = 50,
	["goldcat"] = 50,
	["m%s*4"] = 15,
	["pvpbank"] = 50,
	["g4wow"] = 50,
	["okogames"] = 50,
	["mmotank"] = 50,
	["elysiumnwow"] = 50,
	["mmogo"] = 50,
	["mmook"] = 50,
}

function ChatSanitizer:ChatFrame_OnEvent()
	local msg
	if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_BATTLEGROUND" or event == "CHAT_MSG_BATTLEGROUND_LEADER" or event == "CHAT_MSG_EMOTE" then
		msg = arg1
		arg1 = self:Filter(arg1)
	end
	if arg1 ~= "" then
		if type(self.hooks["ChatFrame_OnEvent"]) == "function" then
			self.hooks["ChatFrame_OnEvent"](event)
		else
			return self.hooks["ChatFrame_MessageEventHandler"](event)
		end
	else
		self:Archive(msg, arg2)
	end
end

function ChatSanitizer:WIM_FilterResult(msg)
	local filtered = ChatSanitizer:Filter(msg)
	if filtered ~= "" then
		return self.hooks.WIM_FilterResult(msg)
	else
		return 1
	end
end

function ChatSanitizer:OnReceiveWhisper()
	arg1 = ChatSanitizer:Filter(arg1)
	if arg1 ~= "" then
		self.hooks[WhisperFu]["OnReceiveWhisper"](WhisperFu)
	end
end

function ChatSanitizer:OnInitialize()
	if ChatFrame_MessageEventHandler ~= nil and type(ChatFrame_MessageEventHandler) == "function" then
		self:Hook("ChatFrame_MessageEventHandler", "ChatFrame_OnEvent", true)
	else
		self:Hook("ChatFrame_OnEvent", true)
	end
	if WhisperFu then
		self:Hook(WhisperFu, "OnReceiveWhisper")
	end
	if WIM_FilterResult then
		self:Hook("WIM_FilterResult")
	end
end

function ChatSanitizer:Filter(text)
	local count = self:RateMessage(text)
	if count >= 100 then
		return ""
	else
		return text
	end
end

function ChatSanitizer:Archive(text, sender)
	ChatSanitizer.numBlocked = ChatSanitizer.numBlocked + 1
	if getn(self.blockHistory) == 10 then
		tremove(self.blockHistory,1)
	end
	tinsert(self.blockHistory,{[1] = sender, [2] = text})
	self:SetText("Blocked Spam: "..ChatSanitizer.numBlocked)
	self:UpdateTooltip()
end

-- The main spam rating formula.  Takes a string and returns a rating.  >= 100 is considered
-- to be spam.
function ChatSanitizer:RateMessage(s)

	-- Strip out wow hyperlinks and colors
	s = self:RemoveHyperLinks(s)
	s = string.lower(s)

	if self.cachedRatings[s] then
		if self.cachedRatings[s][self.words] then
			return self.cachedRatings[s][self.words]
		end
	end

	local spacestrip = "[^1234567890abcdefghijklmnopqrstuvwxyzrÄÂÊÁËÈÍÎÏÌÓÔÒÚÛÙı]+"
	local sCompact = string.gsub(s, spacestrip, "")

	local weight1 = self:SpacedWordCheck(s)
	local weight2 = self:SubstringCheck(s)
	local weight3 = self:SubstringCheck(sCompact)

	local weight = weight1
	if weight2 > weight then
		weight = weight2
	end

	if weight3 > weight then
		weight = weight3
	end

	if not self.cachedRatings[s] then
		self.cachedRatings[s] = {}
	end

	self.cachedRatings[s][self.words] = weight
	return weight
end

function ChatSanitizer:RemoveHyperLinks(text)
	text = string.gsub(text, "|H.-|h(.-)|h", "%1")
	text = string.gsub(text, "|c%w%w%w%w%w%w%w%w(.-)|r", "%1")
	return text
end

-- Regular spaced word check.
function ChatSanitizer:SpacedWordCheck(s)
	local weight = 0
	local wordsChecked = {}
	
	-- Check individual words
	weight = weight + self:TestWords(wordsChecked, s)

	-- Remove double spacing and replace odd characters used for spaces with real ones
	-- and check again
	local spacestrip = "[^1234567890abcdefghijklmnopqrstuvwxyzrÄÂÊÁËÈÍÎÏÌÓÔÒÚÛÙı]+"
	s = string.gsub(s, spacestrip, " ")
	weight = weight + self:TestWords(wordsChecked, s)
	
	-- Change numbers commonly used as letters to their letter and check again
	s = self:NumbersToLetters(s)
	weight = weight + self:TestWords(wordsChecked, s)
	
	-- and vice-versa
	s = self:LettersToNumbers(s)
	weight = weight + self:TestWords(wordsChecked, s)

	return weight
end

-- Simply search for word matches anywhere in the text
function ChatSanitizer:SubstringCheck(s)
	local word = ""
	local value = 0
	local weight = 0
	
	local wordsFound = {}

	weight = self:TestSubstringWords(wordsFound, s)

	-- Revert numerics
	s = self:NumbersToLetters(s)
	weight = weight + self:TestSubstringWords(wordsFound, s)

	-- and backwards
	s = self:LettersToNumbers(s)
	weight = weight + self:TestSubstringWords(wordsFound, s)
	
	return weight
end

-- Searches for substring matches for words in the word list
-- Will not check for words listed in wordsFound
function ChatSanitizer:TestSubstringWords(wordsFound, s)
	local word = ""
	local value = 0
	local weight = 0
	
	for word, value in pairs(self.words) do
		if not wordsFound[word] then
			local _,_,w = string.find(s, "("..word..")")
			if (w) then
				weight = weight + value
				wordsFound[word] = 1
			end
		end
	end
	return weight
end

-- Tests individual words and returns a summed spam rating.  Words
-- listed in wordsChecked are not checked again
function ChatSanitizer:TestWords(wordsChecked, s)
	local w = ""
	local weight = 0
	-- Check individual words
	for w in string.gfind(s, "%w+") do
		if (not wordsChecked[w]) then
			if (self.words[w]) then
				weight = weight + self.words[w]
			end
			wordsChecked[w] = 1;
		end
	end	
	return weight;
end

function ChatSanitizer:NumbersToLetters(s)
	s = string.gsub(s, "0" , "o")
	s = string.gsub(s, "1" , "l")
	s = string.gsub(s, "3" , "e")
	s = string.gsub(s, "4" , "a")
	s = string.gsub(s, "5" , "s")
	return s
end

function ChatSanitizer:LettersToNumbers(s)
	s = string.gsub(s, "o" , "0")
	s = string.gsub(s, "l" , "1")
	s = string.gsub(s, "e" , "3")
	s = string.gsub(s, "a" , "4")
	s = string.gsub(s, "s" , "5")
	return s
end

function ChatSanitizer:OnTooltipUpdate()
	local cat = Tablet:AddCategory('text', "Blocked Messages:",'columns', 1)
	for k,v in ipairs(self.blockHistory) do
		cat:AddLine('text', v[1]..": "..v[2],
							'textwrap', true,
							'textR', 1,
							'textG', 1,
							'textB', 1)
	end
end

function ChatSanitizer:OnClick()
	while getn(self.blockHistory) > 0
		do tremove(self.blockHistory)
	end
	ChatSanitizer.numBlocked = 0
	self:SetText("ChatSanitizer")
	self:UpdateTooltip()
end