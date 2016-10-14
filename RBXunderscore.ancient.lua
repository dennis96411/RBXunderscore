--RBXunderscore by dennis96411
RBXUtility, RBXGUI, Events = LoadLibrary("RbxUtility"), LoadLibrary("RbxGui"), {}

Services = {
	Players = game:GetService("Players"),
	Teams = game:GetService("Teams"),
	Lighting = game:GetService("Lighting"),
	Sound = game:GetService("SoundService"),
	StarterPack = game:GetService("StarterPack"),
	StarterGUI = game:GetService("StarterGui"),
	Debris = game:GetService("Debris"),
	HTTP = game:GetService("HttpService"),
	--NetworkServer = game:GetService("NetworkServer"),
	Teleport = game:GetService("TeleportService"),
	Run = game:GetService("RunService"),
	ReplicatedStorage = game:GetService("ReplicatedStorage"), --
	Marketplace = game:GetService("MarketplaceService"), --
	CSGDictionary = game:GetService("CSGDictionaryService"), --
	--Joint = game:GetService("JointService"), --
	Friend = game:GetService("FriendService"), --
	Insert = game:GetService("InsertService"), --
	Chat = game:GetService("Chat"), --
	Test = game:GetService("TestService") --
}

Functions = {
	Instance = {
		Create = function(ClassName, Properties, Events)
			local Object = Instance.new(ClassName)
			if Properties then
				for Property, Value in next, Properties do
					if Property ~= "Parent" then
						Object[Property] = Value
					end
				end
			end
			if Events then
				for Event, Function in next, Events do
					Object[Event]:connect(Function)
				end
			end
			Object.Parent = Properties.Parent
			return Object
		end
	},
	
	Event = {
		Create = function(Event, Handler)
			local Signal = RBXUtility.CreateSignal()
			if not _(Events):GetNest(Event) then
				_(Events):CreateNest(Event, {Event = Signal, Connections = {}})
			end
			_(Handler):BindToEnvironment({Event = Signal}):RunAsThread()
			--coroutine.wrap(setfenv(Handler, Environment))()
		end,
		
		Attach = function(Event, Handler, Tag)
			local EventNest = _(Events):GetNest(Event)
			if EventNest then
				if Tag and EventNest.Connections[Tag] then Functions.Event.Detach(Event, Tag) end
				local Connection = EventNest.Event:connect(Handler)
				EventNest.Connections[Tag or (#EventNest.Connections + 1).__self] = Connection
				return Connection
			else
				error("[_.Event.Attach] The event " .. Event .. " does not exist!")
			end
		end,
		
		Detach = function(Event, Identifier)
			local EventNest = _(Events):GetNest(Event)
			if EventNest then
				for Tag, Connection in next, EventNest.Connections do
					if Tag == Identifier or Connection == Identifier then
						Connection:disconnect()
						EventNest.Connections[Tag] = nil
						return
					end
				end
			else
				error("[_.Event.Detach] The event " .. Event .. " does not exist!")
			end
		end,
		
		GetAllConnections = function(Event)
			local Connections = {}
			if Event and Events[Event] then
				for __, Connection in next, Functions.Table.GetNest(Events, Event).Connections do
					table.insert(Connections, Connection)
				end
			elseif not Event then
				for __, Event in next, Events do
					for __, Connection in next, Event.Connections do
						table.insert(Connections, Connection)
					end
				end
			end
			return #Connections > 0 and Connections or nil
		end
	},
	
	GUI = {
		CreateMessageDialog = function(Parent, Title, Message, Style, Buttons, Environment)
			local Environment, Dialog, FromOffset = Environment or getfenv(), Style and RBXGUI.CreateStyledMessageDialog(Title, Message, Style, Buttons) or RBXGUI.CreateMessageDialog(Title, Message, Buttons), 50
			local DefaultPosition, DefaultSize = Dialog.Position, Dialog.Size
			Environment.CloseDialog = function()
				Dialog:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(Dialog.Position.X.Scale + (Dialog.Size.X.Scale / 2), Dialog.Position.X.Offset + (Dialog.Size.X.Offset / 2), Dialog.Position.Y.Scale + (Dialog.Size.Y.Scale / 2), Dialog.Position.Y.Offset + (Dialog.Size.Y.Offset / 2)), "Out", "Quart", 0.25, true)
				repeat wait() until Dialog.AbsoluteSize == Vector2.new(0, 0)			
				Dialog:Destroy()
			end
			for __, Button in next, Buttons do
				setfenv(Button.Function, Environment)
			end
			Functions.GUI.ModifyZIndex(Dialog, 10, true)
			Dialog.Draggable = true
			Dialog.ClipsDescendants = true
			Dialog.Parent = Parent
			Dialog.Size = UDim2.new(0, 0, 0, 0); Dialog.Position = UDim2.new(0.5, 0, 0.5, 0)
			Dialog:TweenSizeAndPosition(DefaultSize, DefaultPosition, "Out", "Quart", 0.25, true)
			return Dialog
		end,
		
		SetCoreGUIEnabled = function(Components, Boolean)
			Boolean = _(Boolean):ToBoolean()
			if type(Components) == "table" then
				if Boolean ~= nil then
					for __, Component in next, Components do
						pcall(Services.StarterGUI, "SetCoreGuiEnabled", Component, Boolean)
					end
				else
					for Component, Boolean in next, Components do
						pcall(Services.StarterGUI, "SetCoreGuiEnabled", Component, Boolean)
					end
				end
			else
				pcall(Services.StarterGUI, "SetCoreGuiEnabled", Components, Boolean)
			end
		end,
		
		ModifyZIndex = function(Parent, Level, HardSet)
			local ZIndex = HardSet and Level or Parent.ZIndex + Level
			pcall(function() Parent.ZIndex = ZIndex end)
			for __, Object in next, _(Parent):GetAllChildren() do
				if Object.ZIndex then
					Object.ZIndex = HardSet and Object.ZIndex + ZIndex or ZIndex
				end
			end
		end
	},
	
	HTTP = {
		Get = function(URL, NoCache)
			return Services.HTTP:GetAsync(URL, NoCache)
		end,
		
		Post = function(URL, Data, Encode, ContentType)
			return Services.HTTP:PostAsync(URL, Encode and Services.HTTP:UrlEncode(Data) or Data, ContentType or (Encode and "ApplicationUrlEncoded" or "TextPlain"))
		end,
		
		JSON = {
			Encode = function(Data)
				return Services.HTTP:JSONEncode(Data)
			end,
			
			Decode = function(Data)
				return Services.HTTP:JSONDecode(Data)
			end
		}
	},
	
	Utilities = {
		GetUnwrappedObject = function(Object)
			if type(Object) == "userdata" and pcall(function() return Object.__self end) and type(Object.__type) ~= "nil" then
				return Object.__self
			else
				return Object
			end
		end,

		CanCheckType = function(Object)
			return (pcall(function() Object:IsType("") end))
		end,

		IsROBLOXObject = function(Object)
			return getmetatable(Object) == "The metatable is locked"
		end,
		
		Breathe = function(WaitProbability)
			if math.random() <= (WaitProbability or 0.1) then
				wait()
			end
		end,

		Log = function(Type, Section, Message)
			local Output = "[_" .. (Section and "." .. Section or "") .. "] " .. tostring(Message)
			if Type == "Log" then
				print(Output)
			elseif Type == "Warning" then
				warn(Output)
			elseif Type == "Error" then
				error(Output)
			end
		end,
		
		HandleError = function(Script, Successful, Returned, DoNotReturn)
			if Successful and not DoNotReturn then
				return Returned
			elseif Returned then
				Functions.Script.Error(Script, Returned:match(":(%d+:.+)"))
			end
		end
	}
}
Utilities = Functions.Utilities

ProxyMetamethods = {
	string = {
		MatchTest = function(String, Pattern, CaseInsensitive)
			String = Utilities.GetUnwrappedObject(String)
			return CaseInsensitive and not not String:lower():match(Pattern:lower()) or not not String:match(Pattern), (function() local Count = 0; for _ in (CaseInsensitive and String:lower() or String):gmatch(CaseInsensitive and Pattern:lower() or Pattern) do Count = Count + 1 end; return Count end)()
		end,
		
		Concatenate = function(String, Object)
			String = Utilities.GetUnwrappedObject(String); Object = Utilities.GetUnwrappedObject(Object)
			if type(Object) == "string" then
				return String .. Object
			elseif type(Object) == "number" or type(Object) == "boolean" then
				return String .. tostring(Object)
			elseif type(Object) == "table" then
				return String .. tostring(_(Object))
			else
				print("Concatenating string with", type(Object))
				return String .. tostring(Object)
			end
		end,
		
		ToString = function(String)
			return tostring(Utilities.GetUnwrappedObject(String))
		end,
		
		ToNumber = function(String)
			return tonumber(Utilities.GetUnwrappedObject(String))
		end,
		
		ToBoolean = function(String, Keywords, CaseSensitive)
			String = Utilities.GetUnwrappedObject(String)
			if not CaseSensitive then String = String:lower() end
			if type(Keywords) == "table" then
				if type(Keywords["true"]) == "table" or type(Keywords["false"]) == "table" then
					if Keywords["true"] then
						for __, Keyword in next, Keywords["true"] do
							if Keyword == String then
								return true
							end
						end
					end
					if Keywords["false"] then
						for __, Keyword in next, Keywords["false"] do
							if Keyword == String then
								return false
							end
						end
					end
					return nil
				else
					for Keyword, Boolean in next, Keywords do
						if String == Keyword then
							return Boolean
						end
					end
				end
			elseif String == "true" or String == "on" or String == "1" then
				return true
			elseif String == "false" or String == "off" or String == "0" then
				return false
			else
				return nil
			end
		end,
		
		GetLength = function(String)
			return #Utilities.GetUnwrappedObject(String)
		end,
		
		EvaluateAndReturn = function(String)
			return loadstring("return " .. Utilities.GetUnwrappedObject(String))()
		end,
		
		PrepareAsExpression = function(String)
			return ({Utilities.GetUnwrappedObject(String):gsub("%%", "%%%%"):gsub("%^", "%%^"):gsub("%$", "%%$"):gsub("%(", "%%("):gsub("%)", "%%)"):gsub("%.", "%%."):gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%*", "%%*"):gsub("%+", "%%+"):gsub("%-", "%%-"):gsub("%?", "%%?")})[1]
		end
	},
	
	number = {
		Round = function(Number, DecimalPlace)
			return math.floor(Utilities.GetUnwrappedObject(Number) * math.pow(10, DecimalPlace or 0) + 0.5) / math.pow(10, DecimalPlace or 0)
		end,
		
		Concatenate = function(Number, Object)
			Number = Utilities.GetUnwrappedObject(Number); Object = Utilities.GetUnwrappedObject(Object)
			if type(Object) == "number" or type(Object) == "string" then
				return tonumber(Number .. Object)
			elseif type(Object) == "boolean" then
				return tonumber(Number .. _(Object):ToNumber().__self)
			else
				print("Concatenating number with", type(Object))
				return Number .. tonumber(Object)
			end
		end,
		
		IsWithinTolerance = function(Number, NewNumber, Tolerance)
			Number, NewNumber = Utilities.GetUnwrappedObject(Number), Utilities.GetUnwrappedObject(NewNumber)
			return NewNumber >= Number - Tolerance and NewNumber <= Number + Tolerance
		end,
		
		ToString = function(Number)
			return tostring(Utilities.GetUnwrappedObject(Number))
		end,
		
		ToBoolean = function(Number)
			Number = Utilities.GetUnwrappedObject(Number)
			return Number == 1 and true or Number == 0 and false or nil
		end,
		
		GetLength = function(Number)
			return #tostring(Utilities.GetUnwrappedObject(Number))
		end
	},
	
	boolean = {
		ToString = function(Boolean)
			return tostring(Utilities.GetUnwrappedObject(Boolean))
		end,
		
		ToNumber = function(Boolean)
			return Utilities.GetUnwrappedObject(Boolean) == true and 1 or 0
		end
	},
	
	table = {
		GetAllChildren = function(Table, Type)
			local Objects = {}
			for __, Object in next, Utilities.GetUnwrappedObject(Table) do
				if type(Utilities.GetUnwrappedObject(Object)) == "table" and _(Object):GetSize().__self > 0 then
					for __, ChildObject in next, _(Object):GetAllChildren(Type).__self do
						table.insert(Objects, ChildObject)
					end
				elseif not Type or type(Object) == Type then
					table.insert(Objects, Object)
				end
			end
			return Objects
		end,
		
		GetNest = function(Table, Path)
			local LastLevel = Table
			for Level in Path:gmatch("%.-[^%.]+") do
				local Level = Level:gsub("^%.", "")
				if not pcall(function() return LastLevel[Level] end) then Utilities.Log("Error", "Metamethod.Table.GetNest", "Unable to index \"" .. Level .. "\" while getting nest.") end
				LastLevel = LastLevel[Level]
			end
			return LastLevel
		end,
		
		CreateNest = function(Table, Path, ReturnNest)
			local LastLevel = Table
			for Level in Path:gmatch("%.-[^%.]+") do
				local Level, NewLevel = (Level:gsub("^%.", ""))
				if type(LastLevel[Level]) ~= "table" then
					NewLevel = {}
					LastLevel[Level] = NewLevel
				end
				LastLevel = NewLevel or LastLevel[Level]
			end
			return ReturnNest and LastLevel or Table
		end,
		
		Match = function(Table, Type, Value, ExactMatch, CaseInsensitive)
			for Key, _Value in next, Utilities.GetUnwrappedObject(Table) do
				if Type == "Key" then
					if ExactMatch or type(Value) ~= "string" or type(Key) ~= "string" then
						if type(Key) == "table" and _(Key):Equal(Value) or Key == Value then
							return Key
						end
					else
						if CaseInsensitive then
							if Key:lower():match(Value:lower()) then
								return Key
							end
						elseif Key:match(Value) then
							return Key
						end
					end
				elseif Type == "Value" then
					if ExactMatch or type(Value) ~= "string" or type(_Value) ~= "string" then
						if type(_Value) == "table" and _(_Value):Equal(Value) or _Value == Value then
							return _Value
						end
					else
						if CaseInsensitive then
							if _Value:lower():match(Value:lower()) then
								return _Value
							end
						elseif _Value:match(Value) then
							return _Value
						end
					end
				end
			end
			return nil
		end,
		
		MatchPartner = function(Table, Type, Value, ExactMatch, CaseInsensitive)
			for Key, _Value in next, Utilities.GetUnwrappedObject(Table) do
				if Type == "Key" then
					if ExactMatch or type(Value) ~= "string" or type(_Value) ~= "string" then
						if type(_Value) == "table" and _(_Value):Equal(Value) or _Value == Value then
							return Key
						end
					else
						if CaseInsensitive then
							if _Value:lower():match(Value:lower()) then
								return Key
							end
						elseif _Value:match(Value) then
							return Key
						end
					end
				elseif Type == "Value" then
					if ExactMatch or type(Value) ~= "string" or type(Key) ~= "string" then
						if type(Key) == "table" and _(Key):Equal(Value) or Key == Value then
							return _Value
						end
					else
						if CaseInsensitive then
							if Key:lower():match(Value:lower()) then
								return _Value
							end
						elseif Key:match(Value) then
							return _Value
						end
					end
				end
			end
			return nil
		end,
		
		Clone = function(Table, ShallowClone)
			local Clone = {}
			for Key, Value in next, Utilities.GetUnwrappedObject(Table) do
				if type(Value) == "table" and not ShallowClone and Value ~= Table then
					Value = _(Value):Clone()
				end
				Clone[Key] = Value
			end
			print(getmetatable(Table))
			return not Utilities.IsROBLOXObject(Table) and setmetatable(Clone, getmetatable(Table)) or Clone
		end,
		
		Trim = function(Table, FromOrTo, To, DeepTrim)
			local Trimmed = {}
			for Index, Value in ipairs(Utilities.GetUnwrappedObject(Table)) do
				if type(Value) == "table" and DeepTrim then
					Value = _(Value):Trim(FromOrTo, To, true)
				end
				if not To then
					if Index <= FromOrTo then
						table.insert(Trimmed, Value)
					end
				elseif Index >= FromOrTo and Index <= To then
					table.insert(Trimmed, Value)
				end
			end
			return Trimmed
		end,
		
		Apply = function(Table, Function, DeepApply)
			for Key, Value in next, Utilities.GetUnwrappedObject(Table) do
				if type(Utilities.GetUnwrappedObject(Value)) == "table" and DeepApply then
					rawset(Table, Key, _(Value):Apply(Function, true))
				else
					rawset(Table, Key, Function(Value))
				end
				
			end
			return Table
		end,
		
		Filter = function(Table, Function, DeepFilter)
			for Key, Value in next, Utilities.GetUnwrappedObject(Table) do
				if type(Utilities.GetUnwrappedObject(Value)) == "table" and DeepFilter then
					rawset(Table, Key, _(Value):Filter(Function, true))
				elseif not Function(Value) == true then
					rawset(Table, Key, nil)
				end
			end
			return Table
		end,
		
		Flatten = function(Table, Overwrite)
			for Key, Value in next, Utilities.GetUnwrappedObject(Table) do
				Value = Utilities.GetUnwrappedObject(Value)
				if type(Value) == "table" then
					rawset(Table, Key, nil)
					for _Key, _Value in next, _(Value):Flatten(Overwrite).__self do
						if Table[_Key] ~= nil and not Overwrite then
							table.insert(Table, _Value)
						else
							rawset(Table, _Key, _Value)
						end
					end
				end
			end
			return Table
		end,
		
		Concatenate = function(Table, Object, Overwrite, OverwriteNumericIndexes)
			if _(Object):IsType("Table") then
				for Key, Value in next, Utilities.GetUnwrappedObject(Object) do
					if type(Key) == "number" and (not OverwriteNumericIndexes or Table.__overwritenumindex) then
						table.insert(Table, Value)
					elseif Table[Key] ~= nil and (Overwrite or Table.__overwrite) or Table[Key] == nil then
						Table[Key] = Value
					end
				end
			else
				table.insert(Table, Object)
			end
			return Table
		end,
		
		Equal = function(Table1, Table2, IgnoreNumericIndexes)
			if not _(Table2):IsType("Table") then Utilities.Log("Error", "Metatable.Table.Equal", "The object must be a table!") end
			Table1 = Utilities.GetUnwrappedObject(Table1); Table2 = Utilities.GetUnwrappedObject(Table2)
			if #Table1 ~= #Table2 then return false end
			local IndexedComparison = {{}, {}}
			for Key, Value in next, Table1 do
				if type(Key) == "number" and IgnoreNumericIndexes then
					table.insert(IndexedComparison[1], Value)
				elseif Table2[Key] ~= Value then
					return false
				end
			end
			for Key, Value in next, Table2 do
				if type(Key) == "number" and IgnoreNumericIndexes then
					table.insert(IndexedComparison[2], Value)
				elseif Table1[Key] ~= Value then
					return false
				end
			end
			if #IndexedComparison[1] ~= #IndexedComparison[2] then return false end
			while #IndexedComparison[1] > 0 do
				for Index, Value in next, IndexedComparison[2] do
					if Value == IndexedComparison[1][1] then
						table.remove(IndexedComparison[1], 1)
						table.remove(IndexedComparison[2], Index)
						break
					end
				end
			end
			return true
		end,
		
		ToKeyedChildrenTable = function(Table)
			local NewTable = {}
			for Index, Instance in next, Utilities.GetUnwrappedObject(Table) do
				NewTable[pcall(function() return Instance.Name end) and Instance.Name or Index] = Instance
			end
			return NewTable
		end,
		
		ToString = function(Table, Separator, Begin, End)
			local String = ""
			for Key, Value in next, Utilities.GetUnwrappedObject(Table) do
				--print("About to tostring", Key, "-", Value)
				if Key == End then
					break
				elseif Begin and Key == Begin or not Begin then
					Value = tostring(_(Value))
					String = String .. (#String > 0 and (Separator or Table.__sep or ", ") or "") .. (type(Key) == "number" and Value or tostring(_(Key)) .. " = " .. Value)
				end
			end
			return "Table[" .. tostring(Table):match("%w+$") .. "]{" .. String .. "}"
		end,
		
		GetSize = function(Table)
			local Length = 0
			for __ in next, Utilities.GetUnwrappedObject(Table) do
				Length = Length + 1
			end
			return Length
		end
	},
	
	["function"] = {
		BindToEnvironment = function(Function, Table)
			local Environment = getfenv(Function)
			for Key, Value in next, Table do
				Environment[Key] = Value
			end
			return Function
		end,
		
		RunWithEnvironment = function(Function, Environment, ...)
			return setfenv(Utilities.GetUnwrappedObject(Function), Environment or getfenv(Function))(...)
		end,
		
		RunAsThread = function(Function, ...) --Returns coroutine
			return _(Utilities.GetUnwrappedObject(Function)):ToThread():ResumeThread(...)
		end,
		
		ToThread = function(Function) --Returns coroutine
			return coroutine.create(Utilities.GetUnwrappedObject(Function))
		end,
		
		ToThreadedFunction = function(Function) --Returns function
			return coroutine.wrap(Utilities.GetUnwrappedObject(Function))
		end,
		
		ToString = function(Function)
			return "Function[" .. tostring(Utilities.GetUnwrappedObject(Function)):match("%w+$") .. "]"
		end
	},
	
	thread = {
		ResumeThread = function(Thread, ...)
			return coroutine.resume(Utilities.GetUnwrappedObject(Thread), ...) and Thread
		end,
		
		GetThreadStatus = function(Thread)
			return coroutine.status(Utilities.GetUnwrappedObject(Thread))
		end,
		
		IsRunningThread = function(Thread)
			return coroutine.running() == Utilities.GetUnwrappedObject(Thread)
		end,
		
		ToString = function(Thread)
			return "Thread[" .. tostring(Utilities.GetUnwrappedObject(Thread)):match("%w+$") .. "]"
		end
	},
	
	userdata = {
		GetAllChildren = function(Object, Properties, CaseInsensitive, PartialMatch, MatchAllProperties)
			local Objects = {}
			for __, Object in next, Utilities.GetUnwrappedObject(Object):GetChildren() do
				local MatchedProperties = {}
				if pcall(function() return Object:GetChildren() end) and #Object:GetChildren() > 0 then
					for __, Object in next, _(Object):GetAllChildren(Properties, CaseInsensitive, PartialMatch, MatchAllProperties).__self do
						table.insert(Objects, Object)
					end
				end
				if Properties then
					for Property, Value in next, Properties do
						if pcall(function() return Object[Property] end) then
							for __, Value in next, type(Value) == "table" and Value or {Value} do
								if PartialMatch and _(tostring(Object[Property])):MatchTest(Value, CaseInsensitive) or Object[Property] == Value then
									MatchedProperties[Property] = Value
									print(111, Objects)
									table.insert(Objects, not _(Objects):Match("Value", Object, true).__self and Object or nil)
									break
								end
							end
						end
					end
					if MatchAllProperties and _(MatchedProperties):GetSize().__self > 0 then
						local Properties = _(Properties):Clone()
						for Property, Value in next, MatchedProperties do
							local Match = type(Properties[Property]) == "table" and _(Properties[Property]):Match("Value", Value, true).__self or Properties[Property]
							Properties[Property] = not Match and Properties[Property] or Match ~= nil and nil
						end
						if _(Properties):GetSize().__self > 0 then
							table.remove(Objects, _(Objects):MatchPartner("Key", Object, true).__self)
						end
					end
				else
					table.insert(Objects, Object)
				end
			end
			return Objects
		end,
		
		RemoveAllChildren = function(Object, ...)
			for __, Object in next, _(Object):GetAllChildren(...) do
				Object:Destroy()
			end
		end,
		
		GetNest = function(Object, Path)
			local LastLevel = Object
			for Level in Path:gmatch("%.-[^%.]+") do
				local Level = Level:gsub("^%.", "")
				if not pcall(function() return LastLevel.FindFirstChild end) and LastLevel:FindFirstChild(Level) then Utilities.Log("Error", "Metamethod.Table.GetNest", "Unable to index \"" .. Level .. "\" while getting nest.") end
				LastLevel = LastLevel:FindFirstChild(Level)
			end
			return LastLevel
		end,
		
		CreateNest = function(Object, Path, Type, Content, ReturnNest)
			if not _(Object):IsType("Instance") then Utilities.Log("Error", "Userdata.CreateNest", "The object must be an instance!") end
			local LastLevel = Object
			for Level in Path:gmatch("%.-[^%.]+") do
				LastLevel = LastLevel:FindFirstChild((Level:gsub("^%.", ""))) or Instance.new(Type, LastLevel)
			end
			if type(Content) == "table" then
				for __, Instance in next, Content do
					Instance.Parent = LastLevel
				end
			elseif Content then
				Content.Parent = LastLevel
			end
			return ReturnNest and LastLevel or Object
		end,
		
		ToString = function(Object)
			local Object, String = _(Object), ""
			if Utilities.CanCheckType(Object) then
				if Object:IsType("Instance") then
					if pcall(function() return Object.Name end) then --Instance with indexable name
						String = Object.Name.__self .. (Object.Name ~= Object.ClassName and (" <" .. (#Object.ClassName > 0 and Object.ClassName.__self or "Unknown") .. ">") or "")
					else --Instance with unindexable name
						String = tostring(Object) .. " <Unknown>"
					end
				else
					String = tostring(Object.__self)
				end
			else
				String = tostring(Object.__self) .. " <Unknown>"
			end
			return (type(Object.__self) == "userdata" and (Utilities.CanCheckType(Object) and pcall(function() return Object.ClassName end) and Object:IsType("Service") and "Service" or Object:GetDataType().__self) or tostring(Object.__self):match("^%w+"):gsub("^(%w)", string.upper)) .. "[" .. String .. "]"
		end,
		
		GetSize = function(Object, IncludeChildren)
			Object = Utilities.GetUnwrappedObject(Object)
			if _(Object):IsType("Instance") then
				if IncludeChildren then
					local Size = 0
					for _ in next, _(Object):GetAllChildren() do
						Size = Size + 1
					end
					return Size
				else
					return #Object:GetChildren()
				end
			else
				return nil
			end
		end,
		
		GetDataType = function(Object)
			Object = Utilities.GetUnwrappedObject(Object)
			for DataType, Test in next, {
				Instance = function() return Object.IsA end,
				Vector2 = function() return Object + Vector2.new() end,
				Vector2int16 = function() return Object + Vector2int16.new() end,
				Vector3 = function() return Object + Vector3.new() end,
				Vector3int16 = function() return Object + Vector3int16.new() end,
				CFrame = function() return Object.p end,
				UDim = function() return Object.Scale end,
				UDim2 = function() return Object.X.Offset end,
				Color3 = function() return BrickColor.new(Object) end,
				ColorSequence = function() Instance.new("ParticleEmitter").Color = Object end,
				NumberSequence = function() Instance.new("ParticleEmitter").Transparency = Object end,
				BrickColor = function() return Object.Color end,
				Ray = function() return Object.ClosestPoint end,
				Region3 = function() if pcall(function() return Object.IsA end) then error() end; return Object.CFrame end,
				Region3int16 = function() if type(Object.Min) ~= "userdata" then error() end end,
				NumberRange = function() if type(Object.Min) ~= "number" then error() end end,
				Faces = function() return Object.Top end,
				Axes = function() return Object.X and Object.Top end,
				Enumeration = function() return Object.GetEnumItems end,
				Event = function() return Object.connect end,
				Connection = function() return Object.disconnect end,
				Proxy = function() if Utilities.IsROBLOXObject(Object) then error() end end
			} do
				if pcall(Test) then return DataType end
			end
			return "Unknown"
		end
	}
}
ProxySharedMetamethods = {
	Equal = function(Object, EqualWith)
		--print("equal invoked on", Object, "with", EqualWith)
		Object = Utilities.GetUnwrappedObject(Object)
		return ProxyMetamethods[type(Object)].Equal and ProxyMetamethods[type(Object)].Equal(Object, EqualWith) or Object == Utilities.GetUnwrappedObject(EqualWith)
	end,
	
	LessThan = function(Object, CompareWith)
		--print("less-than invoked on", Object, "with", CompareWith)
		Object = Utilities.GetUnwrappedObject(Object)
		return ProxyMetamethods[type(Object)].IsLessThan and ProxyMetamethods[type(Object)].IsLessThan(Object, CompareWith) or Object < Utilities.GetUnwrappedObject(CompareWith)
	end,
	
	LessThanOrEqualTo = function(Object, CompareWith)
		Object = Utilities.GetUnwrappedObject(Object)
		return ProxyMetamethods[type(Object)].IsLessThanOrEqualTo and ProxyMetamethods[type(Object)].IsLessThanOrEqualTo(Object, CompareWith) or Object <= Utilities.GetUnwrappedObject(CompareWith)
	end
}

_ = newproxy(true)
Metatable = getmetatable(_)
for Metamethod, Function in next, {
	__index = function(Self, Key)
		return Functions[Key] or nil
	end,
	__newindex = function() Utilities.Log("Error", nil, "You are unable to make changes to the framework.") end,
	__call = function(__, ...)
		local Proxies = {}
		for __, Object in next, {...} do
			local Object, Proxy = Utilities.GetUnwrappedObject(Object), newproxy(true)
			local ProxyMetatable = getmetatable(Proxy)
			for Metamethod, Function in next, {
				__index = function(__, Key)
					return Key == "__self" and Object
						or Key == "__type" and type(Object)
						or Key == "IsType" and function(Object, Type) return type(Object.__self) == "userdata" and (Type:lower() == "userdata" and true or (Object:GetDataType().__self == "Instance" and (Type:lower() == "service" and Object.__self == (#Object.__self.ClassName > 0 and game:FindService(Object.__self.ClassName)) or Object.__self:IsA(Type)) or Object:GetDataType().__self == Type)) or type(Object.__self) == "number" and (function(Number) local __, Decimal = math.modf(Number); return Type:lower() == "integer" and Decimal == 0 or Type:lower() == "float" and Decimal > 0 or nil end)(Object.__self) or type(Object.__self) == "string" and Type:lower():match("content[url]*") and pcall(function() game:GetService("ContentProvider"):PreloadAsync({Object.__self}) end) or type(Object.__self) == Type:lower() end
						or _(ProxyMetamethods[type(Object)][Key] or Functions[Key] or Object[Key])
				end,
				
				__newindex = function(__, Key, Value)
					if Key ~= "__self" and Key ~= "__type" and Key ~= "IsType" then
						Object[Key] = Value
					end
				end,
				
				__len = function()
					return ProxyMetamethods[type(Object)]["Get" .. ((type(Object) == "string" or type(Object) == "number") and "Length" or "Size")] and ProxyMetamethods[type(Object)]["Get" .. ((type(Object) == "string" or type(Object) == "number") and "Length" or "Size")](Object) or nil
				end,
				
				__tostring = function() --Must return a string to "print" function
					--print("tostring invoked on a", type(Object))
					return ProxyMetamethods[type(Object)].ToString and ProxyMetamethods[type(Object)].ToString(Object) or tostring(Object) or nil
				end,
				
				__concat = function(__, ConcatenateWith)
					--print("concat invoked on a", type(Object))
					return ProxyMetamethods[type(Object)].Concatenate and _(ProxyMetamethods[type(Object)].Concatenate(Object, ConcatenateWith)) or nil
				end,
				
				__call = function(__, ...)
					local Arguments = {...}
					for Key, Value in next, Arguments do
						Arguments[Key] = Utilities.GetUnwrappedObject(Value)
					end
					return _(Object(unpack(Arguments)))
				end,
				
				__eq = ProxySharedMetamethods.Equal,
				__lt = ProxySharedMetamethods.LessThan,
				__le = ProxySharedMetamethods.LessThanOrEqualTo,
				
				__add = function(__, AddWith)
					return _(ProxyMetamethods[type(Object)].Add and ProxyMetamethods[type(Object)].Add(Object, AddWith) or Object + Utilities.GetUnwrappedObject(AddWith))
				end,
				
				__sub = function(__, SubtractWith)
					return _(ProxyMetamethods[type(Object)].Subtract and ProxyMetamethods[type(Object)].Subtract(Object, SubtractWith) or Object - Utilities.GetUnwrappedObject(SubtractWith))
				end,
				
				__mul = function(__, MultiplyWith)
					return _(ProxyMetamethods[type(Object)].Multiply and ProxyMetamethods[type(Object)].Multiply(Object, MultiplyWith) or Object * Utilities.GetUnwrappedObject(MultiplyWith))
				end,
				
				__div = function(__, DivideWith)
					return _(ProxyMetamethods[type(Object)].Divide and ProxyMetamethods[type(Object)].Divide(Object, DivideWith) or Object / Utilities.GetUnwrappedObject(DivideWith))
				end,
				
				__mod = function(__, ModuloWith)
					return _(ProxyMetamethods[type(Object)].Modulo and ProxyMetamethods[type(Object)].Modulo(Object, ModuloWith) or math.fmod(Object, Utilities.GetUnwrappedObject(ModuloWith)))
				end,
				
				__pow = function(__, Exponent)
					return _(ProxyMetamethods[type(Object)].Power and ProxyMetamethods[type(Object)].Power(Object, Exponent) or math.pow(Object, Utilities.GetUnwrappedObject(Exponent)))
				end,
				
				__unm = function()
					return _(ProxyMetamethods[type(Object)].Negate and ProxyMetamethods[type(Object)].Negate(Object) or -Object)
				end,
				
				__metatable = function() Utilities.Log("Error", nil, "You are not allowed to make changes to the framework.") end
			} do rawset(ProxyMetatable, Metamethod, Function) end
			table.insert(Proxies, Proxy)
		end
		return unpack(Proxies)
	end,
	__metatable = function() Utilities.Log("Error", nil, "You are not allowed to make changes to the framework.") end
} do rawset(Metatable, Metamethod, Function) end
Functions.String, Functions.Table, Functions.Number = _(""), _({}), _(0)

--Type test
print("==========Userdata type detection test==========\n[True type] - [Detected type]")
for Type, Object in next, {
	Instance = Workspace,
	Vector2 = Vector2.new(),
	Vector2int16 = Vector2int16.new(),
	Vector3 = Vector3.new(),
	Vector3int16 = Vector3int16.new(),
	CFrame = CFrame.new(),
	UDim = UDim.new(),
	UDim2 = UDim2.new(),
	Color3 = Color3.new(),
	ColorSequence = ColorSequence.new(Color3.new()),
	NumberSequence = NumberSequence.new(0),
	BrickColor = BrickColor.new(),
	Ray = Ray.new(),
	Region3 = Region3.new(),
	Region3int16 = Region3int16.new(),
	NumberRange = NumberRange.new(0),
	Faces = Faces.new(),
	Axes = Axes.new(),
	Enumeration = Enum.Font,
	Event = game.Changed,
	Connection = game.Changed:connect(function() end),
	Proxy = newproxy()
} do
	print(Type, "-", _(Object):GetDataType())
end

return _
