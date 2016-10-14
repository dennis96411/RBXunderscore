--[[
	RBXunderscore Library/Object Wrapper by dennis96411 (Updated 10/13/2016 20:25 EST)
	Optimizations considered:
	* http://www.lua.org/gems/sample.pdf
	* https://stackoverflow.com/questions/154672/what-can-i-do-to-increase-the-performance-of-a-lua-program/#12865406
	* https://springrts.com/wiki/Lua_Performance
	* http://forums.civfanatics.com/showpost.php?p=11547731
]]

--Configurations
local Configurations = {
	AssertArgumentTypes = false, --Assert correct argument types; disable for less overhead but errors will be less verbose
	ContinueOnError = false, --Continue on non-fatal protected function call errors
	DirectlyModifyTables = false --Directly modify wrapped tables' original object
}

--Predeclare references
local _, Functions, InternalFunctions, Assert, Log, ProxyMethods

--Localize frequently-used global objects to avoid global environment table lookup
local
	--Global instances and objects
	script, game, Workspace, Enum,
	--ROBLOX userdata...
	Axes, BrickColor, CellId, CFrame, Color3, ColorSequence, ColorSequenceKeypoint, Faces, Instance, NumberRange, NumberSequence, NumberSequenceKeypoint, PhysicalProperties, Ray, Rect, Region3, Region3int16, UDim, UDim2, Vector2, Vector2int16, Vector3, Vector3int16,
	--... and their constructors
	NewAxes, NewBrickColor, NewCellId, NewCFrame, NewColor3, NewColorSequence, NewColorSequenceKeypoint, NewFaces, NewInstance, NewNumberRange, NewNumberSequence, NewNumberSequenceKeypoint, NewPhysicalProperties, NewRay, NewRect, NewRegion3, NewRegion3int16, NewUDim, NewUDim2, NewVector2, NewVector2int16, NewVector3, NewVector3int16,
	--Math functions
	math_abs, math_atan, math_atan2, math_ceil, math_floor, math_huge, math_log, math_log10, math_max, math_min, math_pi, math_random,
	--Table functions
	table_concat, table_insert, table_remove, table_sort,
	--Coroutine functions
	coroutine_resume, coroutine_running, coroutine_wrap, coroutine_yield,
	--Other functions
	assert, debug_traceback, delay, error, getfenv, getmetatable, ipairs, LoadLibrary, loadstring, newproxy, next, pairs, pcall, print, rawget, rawset, select, setfenv, setmetatable, spawn, string_dump, tick, tonumber, tostring, type, unpack, wait, warn, noop, --Empty function body
	NOPE --Replacement for error in protected calls; avoids global environment table lookup and function call
		=
	script, game, Workspace, Enum, Axes, BrickColor, CellId, CFrame, Color3, ColorSequence, ColorSequenceKeypoint, Faces, Instance, NumberRange, NumberSequence, NumberSequenceKeypoint, PhysicalProperties, Ray, Rect, Region3, Region3int16, UDim, UDim2, Vector2, Vector2int16, Vector3, Vector3int16, Axes.new, BrickColor.new, CellId.new, CFrame.new, Color3.new, ColorSequence.new, ColorSequenceKeypoint.new, Faces.new, Instance.new, NumberRange.new, NumberSequence.new, NumberSequenceKeypoint.new, PhysicalProperties.new,  Ray.new, Rect.new, Region3.new, Region3int16.new, UDim.new, UDim2.new, Vector2.new, Vector2int16.new, Vector3.new, Vector3int16.new, math.abs, math.atan, math.atan2, math.ceil, math.floor, math.huge, math.log, math.log10, math.max, math.min, math.pi, math.random, table.concat, table.insert, table.remove, table.sort, coroutine.resume, coroutine.running, coroutine.wrap, coroutine.yield, assert, debug.traceback, delay, error, getfenv, getmetatable, ipairs, LoadLibrary, loadstring, newproxy, next, pairs, pcall, print, rawget, rawset, select, setfenv, setmetatable, spawn, string.dump, tick, tonumber, tostring, type, unpack, wait, warn, function() end

--Helper functions for minimizing unnecessary closure generation during protected calls
local ProtectedCallHelpers = {
	Get = function(Object, Key) return Object[Key] end,
	Set = function(Object, Key, Value) Object[Key] = Value end,
	SetSelf = function(Object, Key) Object[Key] = Object[Key] end,
	Call = function(Object, Name, ...) Object[Name](...) end,
	CallMethod = function(Object, Name, ...) Object[Name](Object, ...) end
}

--Services and libraries (cached aliases of game.GetService and LoadLibrary)
local Services, Libraries = setmetatable({}, {
	__index = function(Self, Name)
		local Successful, Service = pcall(game.GetService, game, Name)
		if Successful then Self[Name] = Service; return Service end
		return nil
	end
}), setmetatable({}, {
	__index = function(Self, Name)
		local Library = LoadLibrary(Name)
		Self[Name] = Library; return Library
	end
})
for __, Instance in next, game:GetChildren() do --Cache services already under the data model
	pcall(function() return Services[tostring(Instance)] or Services[Instance.ClassName] end)
end

--Storage and environmental capabilities
local Storage, Capabilities = {
	Constant = {
		Instance = {
			AllClasses = {"Accessory", "Accoutrement", "AdService", "AdvancedDragger", "Animation", "AnimationController", "AnimationTrack", "Animator", "ArcHandles", "AssetService", "Attachment", "Backpack", "BackpackItem", "BadgeService", "BallSocketConstraint", "BasePart", "BasePlayerGui", "BaseScript", "BevelMesh", "BillboardGui", "BinaryStringValue", "BindableEvent", "BindableFunction", "BlockMesh", "BloomEffect", "BlurEffect", "BodyAngularVelocity", "BodyColors", "BodyForce", "BodyGyro", "BodyMover", "BodyPosition", "BodyThrust", "BodyVelocity", "BoolValue", "BoxHandleAdornment", "BrickColorValue", "Button", "ButtonBindingWidget", "CFrameValue", "CSGDictionaryService", "CacheableContentProvider", "Camera", "ChangeHistoryService", "CharacterAppearance", "CharacterMesh", "Chat", "ChatFilter", "ClickDetector", "ClientReplicator", "Clothing", "ClusterPacketCache", "CollectionService", "Color3Value", "ColorCorrectionEffect", "ConeHandleAdornment", "Configuration", "Constraint", "ContentFilter", "ContentProvider", "ContextActionService", "Controller", "ControllerService", "CookiesService", "CoreGui", "CoreScript", "CornerWedgePart", "CustomEvent", "CustomEventReceiver", "CylinderHandleAdornment", "CylinderMesh", "CylindricalConstraint", "DataModel", "DataModelMesh", "DataStorePages", "DataStoreService", "Debris", "DebugSettings", "DebuggerBreakpoint", "DebuggerManager", "DebuggerWatch", "Decal", "Dialog", "DialogChoice", "DoubleConstrainedValue", "Dragger", "DynamicRotate", "Explosion", "FaceInstance", "Feature", "FileMesh", "Fire", "Flag", "FlagStand", "FlagStandService", "FloorWire", "FlyweightService", "Folder", "ForceField", "FormFactorPart", "Frame", "FriendPages", "FriendService", "FunctionalTest", "GamePassService", "GameSettings", "GamepadService", "GenericSettings", "Geometry", "GlobalDataStore", "GlobalSettings", "Glue", "GroupService", "GuiBase", "GuiBase2d", "GuiBase3d", "GuiButton", "GuiItem", "GuiLabel", "GuiMain", "GuiObject", "GuiRoot", "GuiService", "GuidRegistryService", "HandleAdornment", "Handles", "HandlesBase", "HapticService", "Hat", "HingeConstraint", "Hint", "Hole", "Hopper", "HopperBin", "HttpRbxApiService", "HttpService", "Humanoid", "HumanoidController", "ImageButton", "ImageHandleAdornment", "ImageLabel", "InputObject", "InsertService", "Instance", "InstancePacketCache", "IntConstrainedValue", "IntValue", "JointInstance", "JointsService", "Keyframe", "KeyframeSequence", "KeyframeSequenceProvider", "LayerCollector", "Light", "Lighting", "LineHandleAdornment", "LocalScript", "LocalWorkspace", "LogService", "LoginService", "LuaSettings", "LuaSourceContainer", "LuaWebService", "ManualGlue", "ManualSurfaceJointInstance", "ManualWeld", "MarketplaceService", "MeshContentProvider", "MeshPart", "Message", "Model", "ModuleScript", "Motor", "Motor6D", "MotorFeature", "Mouse", "MoveToConstraint", "NegateOperation", "NetworkClient", "NetworkMarker", "NetworkPeer", "NetworkReplicator", "NetworkServer", "NetworkSettings", "NonReplicatedCSGDictionaryService", "NotificationService", "NumberValue", "ObjectValue", "OneQuarterClusterPacketCacheBase", "OrderedDataStore", "PVAdornment", "PVInstance", "Pages", "Pants", "ParallelRampPart", "Part", "PartAdornment", "PartOperation", "PartOperationAsset", "ParticleEmitter", "Path", "PathfindingService", "PersonalServerService", "PhysicsPacketCache", "PhysicsService", "PhysicsSettings", "Platform", "Player", "PlayerGui", "PlayerMouse", "PlayerScripts", "Players", "Plugin", "PluginManager", "PluginMouse", "PointLight", "PointsService", "Pose", "PostEffect", "PrismPart", "PrismaticConstraint", "ProfilingItem", "PyramidPart", "RayValue", "ReflectionMetadata", "ReflectionMetadataCallbacks", "ReflectionMetadataClass", "ReflectionMetadataClasses", "ReflectionMetadataEnum", "ReflectionMetadataEnumItem", "ReflectionMetadataEnums", "ReflectionMetadataEvents", "ReflectionMetadataFunctions", "ReflectionMetadataItem", "ReflectionMetadataMember", "ReflectionMetadataProperties", "ReflectionMetadataYieldFunctions", "RemoteEvent", "RemoteFunction", "RenderHooksService", "RenderSettings", "ReplicatedFirst", "ReplicatedStorage", "RightAngleRampPart", "RobloxReplicatedStorage", "RocketPropulsion", "RodConstraint", "RootInstance", "RopeConstraint", "Rotate", "RotateP", "RotateV", "RunService", "RunningAverageItemDouble", "RunningAverageItemInt", "RunningAverageTimeIntervalItem", "RuntimeScriptService", "Scale9Frame", "ScreenGui", "Script", "ScriptContext", "ScriptDebugger", "ScriptInformationProvider", "ScriptService", "ScrollingFrame", "Seat", "Selection", "SelectionBox", "SelectionLasso", "SelectionPartLasso", "SelectionPointLasso", "SelectionSphere", "ServerReplicator", "ServerScriptService", "ServerStorage", "ServiceProvider", "Shirt", "ShirtGraphic", "SkateboardController", "SkateboardPlatform", "Skin", "Sky", "SlidingBallConstraint", "Smoke", "Snap", "SocialService", "SolidModelContentProvider", "Sound", "SoundService", "Sparkles", "SpawnLocation", "SpawnerService", "SpecialMesh", "SphereHandleAdornment", "SpotLight", "SpringConstraint", "StandardPages", "StarterCharacterScripts", "StarterGear", "StarterGui", "StarterPack", "StarterPlayer", "StarterPlayerScripts", "Stats", "StatsItem", "Status", "StringValue", "SunRaysEffect", "SurfaceGui", "SurfaceLight", "SurfaceSelection", "TaskScheduler", "Team", "Teams", "TeleportService", "Terrain", "TerrainRegion", "TestService", "TextBox", "TextButton", "TextLabel", "TextService", "Texture", "TextureContentProvider", "TextureTrail", "TimerService", "Tool", "Toolbar", "TotalCountTimeIntervalItem", "TouchInputService", "TouchTransmitter", "TrussPart", "TweenService", "UnionOperation", "UserGameSettings", "UserInputService", "UserSettings", "Vector3Value", "VehicleController", "VehicleSeat", "VelocityMotor", "VirtualUser", "Visit", "WedgePart", "Weld", "Workspace"},
			AllProperties = {"AASamples", "AbsolutePosition", "AbsoluteSize", "AbsoluteWindowSize", "Acceleration", "AccelerometerEnabled", "AccountAge", "Active", "ActuatorType", "Adornee", "AllTutorialsDisabled", "AllowInsertFreeModels", "AllowSleep", "AllowTeamChangeOnTouch", "AllowThirdPartySales", "AltCdnFailureCount", "AltCdnSuccessCount", "AlwaysOnTop", "Ambient", "AmbientReverb", "Anchored", "Angle", "AngularSpeed", "AngularVelocity", "Animation", "AnimationId", "Antialiasing", "AppearanceDidLoad", "Archivable", "AreAnchorsShown", "AreArbitersThrottled", "AreAssembliesShown", "AreAttachmentsShown", "AreAwakePartsHighlighted", "AreBodyTypesShown", "AreConstraintsShown", "AreContactPointsShown", "AreHingesDetected", "AreJointCoordinatesShown", "AreMechanismsShown", "AreModelCoordsShown", "AreOwnersShown", "ArePartCoordsShown", "ArePhysicsRejectionsReported", "AreRegionsShown", "AreScriptStartsReported", "AreUnalignedPartsShown", "AreWorldCoordsShown", "Attachment0", "Attachment1", "AttachmentForward", "AttachmentPoint", "AttachmentPos", "AttachmentRight", "AttachmentUp", "AutoAssignable", "AutoButtonColor", "AutoColorCharacters", "AutoFRMLevel", "AutoJumpEnabled", "AutoRotate", "AutoRuns", "AutoSelectGuiEnabled", "AvailablePhysicalMemory", "Axes", "Axis", "AzimuthalAngle", "BackParamA", "BackParamB", "BackSurface", "BackSurfaceInput", "BackgroundColor", "BackgroundColor3", "BackgroundTransparency", "BaseAngle", "BaseTextureId", "BaseUrl", "BinType", "BlastPressure", "BlastRadius", "BlockMeshSize", "BodyPart", "BorderColor", "BorderColor3", "BorderSizePixel", "BottomImage", "BottomParamA", "BottomParamB", "BottomSurface", "BottomSurfaceInput", "BrickColor", "Brightness", "Browsable", "BubbleChat", "BubbleChatLifetime", "BubbleChatMaxBubbles", "C0", "C1", "CFrame", "CPU", "CameraMaxZoomDistance", "CameraMinZoomDistance", "CameraMode", "CameraOffset", "CameraSubject", "CameraType", "CanBeDropped", "CanCollide", "CanLoadCharacterAppearance", "CanSendPacketBufferLimit", "CanvasPosition", "CanvasSize", "CartoonFactor", "CdnFailureCount", "CdnResponceTime", "CdnSuccessCount", "CelestialBodiesShown", "Character", "CharacterAppearance", "CharacterAppearanceId", "CharacterAutoLoads", "ChatHistory", "ChatMode", "ChatScrollLength", "ChatVisible", "ClassName", "ClassicChat", "ClearTextOnFocus", "ClientPhysicsSendRate", "ClipsDescendants", "CollisionEnabled", "CollisionSoundEnabled", "CollisionSoundVolume", "Color", "Color3", "ColorShift_Bottom", "ColorShift_Top", "ComputerCameraMovementMode", "ComputerMovementMode", "Concurrency", "Condition", "ConstrainedValue", "Contrast", "ControlMode", "Controller", "ControllingHumanoid", "ConversationDistance", "CoordinateFrame", "CoreGuiNavigationEnabled", "CpuCount", "CpuSpeed", "CreatorId", "CreatorType", "CurrentAngle", "CurrentCamera", "CurrentDistance", "CurrentLength", "CurrentLine", "CurrentPosition", "CustomPhysicalProperties", "CustomizedTeleportUI", "CycleOffset", "D", "Damping", "DataComplexity", "DataComplexityLimit", "DataCost", "DataGCRate", "DataModel", "DataMtuAdjust", "DataReady", "DataSendPriority", "DataSendRate", "DebugDisableInterpolation", "DebuggingEnabled", "DefaultWaitTime", "Delta", "Deprecated", "Description", "DesiredAngle", "DestroyJointRadiusPercent", "DevCameraOcclusionMode", "DevComputerCameraMode", "DevComputerCameraMovementMode", "DevComputerMovementMode", "DevEnableMouseLock", "DevTouchCameraMode", "DevTouchCameraMovementMode", "DevTouchMovementMode", "Disabled", "DisplayDistanceType", "DistanceFactor", "DistributedGameTime", "DopplerScale", "Drag", "Draggable", "Duration", "EagerBulkExecution", "EasingDirection", "EasingStyle", "EditQualityLevel", "ElapsedTime", "Elasticity", "EmissionDirection", "EmptyCutoff", "EnableFRM", "EnableHeavyCompression", "EnableMouseLockOption", "Enabled", "ErrorCount", "ErrorReporting", "ExperimentalPhysicsEnabled", "ExperimentalTerrainLOD", "ExplorerImageIndex", "ExplorerOrder", "ExplosionType", "ExportMergeByMaterial", "Expression", "ExtentsOffset", "ExtraMemoryUsed", "F0", "F1", "F2", "F3", "Face", "FaceId", "Faces", "FieldOfView", "FilteringEnabled", "Focus", "FogColor", "FogEnd", "FogStart", "FollowUserId", "Font", "FontSize", "Force", "FormFactor", "FrameRateManager", "FreeLength", "FreeMemoryMBytes", "FreeMemoryPoolMBytes", "Friction", "From", "FrontParamA", "FrontParamB", "FrontSurface", "FrontSurfaceInput", "Fullscreen", "GamepadEnabled", "GcFrequency", "GcLimit", "GcPause", "GcStepMul", "GearGenreSetting", "Genre", "GeographicLatitude", "GfxCard", "GlobalShadows", "GoodbyeDialog", "Graphic", "GraphicsMode", "Gravity", "GridSize", "Grip", "GripForward", "GripPos", "GripRight", "GripUp", "Guest", "GuiNavigationEnabled", "GyroscopeEnabled", "HardwareMouse", "HasBuildTools", "HeadColor", "HeadLocked", "HeadScale", "HeadsUpDisplay", "Health", "HealthDisplayDistance", "Heat", "Height", "HipHeight", "Hit", "Hole", "HttpEnabled", "Humanoid", "Icon", "Image", "ImageColor3", "ImageRectOffset", "ImageRectSize", "ImageTransparency", "ImageUploadPromptBehavior", "InOut", "InUse", "InclinationAngle", "IncommingReplicationLag", "InitialPrompt", "Insertable", "InstanceCount", "Intensity", "Is30FpsThrottleEnabled", "IsAggregationShown", "IsBackend", "IsDebugging", "IsEnabled", "IsFinished", "IsFmodProfilingEnabled", "IsLoaded", "IsModalDialog", "IsPaused", "IsPersonalServer", "IsPhysicsEnvironmentalThrottled", "IsPlaying", "IsProfilingEnabled", "IsQueueErrorComputed", "IsReceiveAgeShown", "IsSFFlagsLoaded", "IsScriptStackTracingEnabled", "IsSleepAllowed", "IsSmooth", "IsSynchronizedWithPhysics", "IsThrottledByCongestionControl", "IsThrottledByOutgoingBandwidthLimit", "IsTreeShown", "IsWindows", "JobCount", "JobId", "Jump", "JumpPower", "KeyCode", "KeyboardEnabled", "LastCdnFailureTimeSpan", "LeftArmColor", "LeftLeg", "LeftLegColor", "LeftParamA", "LeftParamB", "LeftRight", "LeftSurface", "LeftSurfaceInput", "LegacyNamingScheme", "Length", "Lifetime", "LightEmission", "LimitsEnabled", "Line", "LineThickness", "LinkedSource", "LoadCharacterAppearance", "LocalPlayer", "LocalSaveEnabled", "LocalTransparencyModifier", "Location", "Locked", "LockedToPart", "Loop", "Looped", "LowerAngle", "LowerLimit", "LuaRamLimit", "MachineAddress", "ManualActivationOnly", "MaskWeight", "MasterVolume", "Material", "MaxActivationDistance", "MaxCollisionSounds", "MaxDataModelSendBuffer", "MaxDistance", "MaxExtents", "MaxForce", "MaxHealth", "MaxItems", "MaxLength", "MaxPlayers", "MaxPlayersInternal", "MaxSlopeAngle", "MaxSpeed", "MaxThrust", "MaxTorque", "MaxValue", "MaxVelocity", "MaximumSimulationRadius", "MembershipType", "MenuIsOpen", "MeshCacheSize", "MeshId", "MeshType", "MidImage", "MinDistance", "MinLength", "MinReportInterval", "MinValue", "Modal", "ModalEnabled", "MotorMaxAcceleration", "MotorMaxForce", "MotorMaxTorque", "MouseBehavior", "MouseDeltaSensitivity", "MouseEnabled", "MouseIconEnabled", "MouseSensitivity", "MouseSensitivityFirstPerson", "MouseSensitivityThirdPerson", "MoveDirection", "MultiLine", "Name", "NameDatabaseBytes", "NameDatabaseSize", "NameDisplayDistance", "NameOcclusion", "NetworkOwnerRate", "Neutral", "NextSelectionDown", "NextSelectionLeft", "NextSelectionRight", "NextSelectionUp", "NumPlayers", "NumRunningJobs", "NumSleepingJobs", "NumWaitingJobs", "NumberOfPlayers", "Occupant", "Offset", "Opacity", "Origin", "OsIs64Bit", "OsPlatform", "OsPlatformId", "OsVer", "OutdoorAmbient", "Outlines", "OverlayTextureId", "OverrideMouseIconBehavior", "P", "PageFaultsPerSecond", "PageFileBytes", "PantsTemplate", "ParallelPhysics", "Parent", "Part", "Part0", "Part1", "PerformanceStatsVisible", "PersonalServerRank", "PhysicsAnalyzerEnabled", "PhysicsEnvironmentalThrottle", "PhysicsMtuAdjust", "PhysicsReceive", "PhysicsSend", "PhysicsSendPriority", "PhysicsSendRate", "Pitch", "PixelShaderModel", "PlaceId", "PlaceVersion", "PlatformStand", "PlayOnRemove", "PlayerCount", "PlayerToHideFrom", "Playing", "Point", "Port", "Position", "PreferredClientPort", "PreferredParent", "PreferredPlayers", "PreferredPlayersInternal", "PrimaryPart", "PrintBits", "PrintEvents", "PrintFilters", "PrintInstances", "PrintPhysicsErrors", "PrintProperties", "PrintSplitMessage", "PrintStreamInstanceQuota", "PrintTouches", "Priority", "PriorityMethod", "PrivateBytes", "PrivateWorkingSetBytes", "ProcessCores", "ProcessorTime", "ProfilingWindow", "Purpose", "QualityLevel", "RAM", "Radius", "Range", "Rate", "ReceiveAge", "ReceiveRate", "Reflectance", "ReloadAssets", "RenderCSGTrianglesDebug", "RenderStreamedRegions", "ReportAbuseChatHistory", "ReportExtendedMachineConfiguration", "ReportSoundWarnings", "ReportStatURL", "ReporterType", "RequestQueueSize", "RequiresHandle", "ResetPlayerGuiOnSpawn", "ResizeIncrement", "ResizeableFaces", "Resolution", "RespawnLocation", "ResponseDialog", "Restitution", "RigType", "RightArmColor", "RightLeg", "RightLegColor", "RightParamA", "RightParamB", "RightSurface", "RightSurfaceInput", "RiseVelocity", "RobloxFailureCount", "RobloxLocked", "RobloxProductName", "RobloxRespoceTime", "RobloxSuccessCount", "RobloxVersion", "RoleSets", "RollOffMode", "RolloffScale", "RotSpeed", "RotVelocity", "Rotation", "RotationType", "SIMD", "Saturation", "SavedQualityLevel", "Scale", "ScaleEdgeSize", "ScaleType", "SchedulerDutyCycle", "SchedulerRate", "Score", "ScreenGuiEnabled", "Script", "ScriptsDisabled", "ScrollBarThickness", "ScrollingEnabled", "SeatPart", "SecondaryAxis", "SecondaryColor", "Selectable", "Selected", "SelectedCoreObject", "SelectedObject", "SelectionImageObject", "SendPacketBufferLimit", "ServoMaxForce", "ServoMaxTorque", "ShadowColor", "Shadows", "Shape", "Shiny", "ShirtTemplate", "ShowActiveAnimationAsset", "ShowBoundingBoxes", "ShowDecompositionGeometry", "ShowDevelopmentGui", "ShowInterpolationpath", "ShowPartMovementWayPoint", "Sides", "SimulateSecondsLag", "SimulationRadius", "Sit", "Size", "SizeConstraint", "SizeInCells", "SizeOffset", "SizeRelativeOffset", "SkinColor", "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SleepAdjustMethod", "SliceCenter", "SlicePrefix", "SoftwareSound", "SoundEnabled", "SoundId", "Source", "SparkleColor", "SpecificGravity", "Specular", "Speed", "Spread", "StabilizingDistance", "StarCount", "Status", "Steer", "StickyWheels", "Stiffness", "StreamingEnabled", "StudsBetweenTextures", "StudsOffset", "StudsPerTileU", "StudsPerTileV", "Style", "SurfaceColor", "SurfaceColor3", "SurfaceTransparency", "SystemProductName", "Target", "TargetAngle", "TargetFilter", "TargetOffset", "TargetPoint", "TargetPosition", "TargetRadius", "TargetSurface", "Team", "TeamColor", "Teleported", "TeleportedIn", "Terrain", "TestCount", "Text", "TextBounds", "TextColor", "TextColor3", "TextFits", "TextScaled", "TextStrokeColor3", "TextStrokeTransparency", "TextTransparency", "TextWrap", "TextWrapped", "TextXAlignment", "TextYAlignment", "Texture", "TextureCacheSize", "TextureID", "TextureId", "TextureSize", "Thickness", "ThreadAffinity", "ThreadPoolConfig", "ThreadPoolSize", "Threshold", "Throttle", "ThrottleAdjustTime", "ThrottledJobSleepTime", "ThrustD", "ThrustP", "TickCountPreciseOverride", "Ticket", "Time", "TimeLength", "TimeOfDay", "TimePosition", "Timeout", "TintColor", "To", "Tone", "ToolPunchThroughDistance", "ToolTip", "TopBottom", "TopImage", "TopParamA", "TopParamB", "TopSurface", "TopSurfaceInput", "Torque", "Torso", "TorsoColor", "TotalNumMovementWayPoint", "TotalPhysicalMemory", "TotalProcessorTime", "TouchCameraMovementMode", "TouchEnabled", "TouchMovementMode", "TouchSendRate", "TrackDataTypes", "TrackPhysicsDetails", "Transparency", "TriangleCount", "TurnD", "TurnP", "TurnSpeed", "UIMaximum", "UIMinimum", "UINumTicks", "UnitRay", "UpperAngle", "UpperLimit", "UseBasicMouseSensitivity", "UseInstancePacketCache", "UsePartColor", "UsePhysicsPacketCache", "UsedHideHudShortcut", "UserDialog", "UserHeadCFrame", "UserId", "UserInputState", "UserInputType", "VIPServerId", "VIPServerOwnerId", "VRDevice", "VREnabled", "VRRotationIntensity", "Value", "Velocity", "VelocityInheritance", "VelocitySpread", "Version", "VertexColor", "VertexShaderModel", "VideoCaptureEnabled", "VideoMemory", "VideoQuality", "VideoUploadPromptBehavior", "ViewSizeX", "ViewSizeY", "ViewportSize", "VirtualBytes", "Visible", "Volume", "WaitingForCharacterLogRate", "WaitingThreadsBudget", "WalkSpeed", "WalkToPart", "WalkToPoint", "WarnCount", "WaterColor", "WaterTransparency", "WaterWaveSize", "WaterWaveSpeed", "Weight", "WireRadius", "Workspace", "WorldAxis", "WorldPosition", "WorldRotation", "WorldSecondaryAxis", "X", "Y", "ZIndex", "ZOffset"},
			AllEvents = {"Activated", "AllowedGearTypeChanged", "AncestryChanged", "AnimationPlayed", "AxisChanged", "BadgeAwarded", "BoundActionAdded", "BoundActionChanged", "BoundActionRemoved", "BreakpointAdded", "BreakpointRemoved", "BrowserWindowClosed", "Button1Down", "Button1Up", "Button2Down", "Button2Up", "ButtonChanged", "CamelCaseViolation", "Changed", "CharacterAdded", "CharacterAppearanceLoaded", "CharacterRemoving", "Chatted", "ChildAdded", "ChildRemoved", "Click", "ClientLuaDialogRequested", "ClientPurchaseSuccess", "Climbing", "Close", "CloseLate", "ConnectionAccepted", "ConnectionFailed", "ConnectionRejected", "CoreGuiChangedSignal", "CustomStatusAdded", "CustomStatusRemoved", "DataBasicFiltered", "DataCustomFiltered", "Deactivated", "Deactivation", "DebuggerAdded", "DebuggerRemoved", "DescendantAdded", "DescendantRemoving", "Deselected", "DeviceAccelerationChanged", "DeviceGravityChanged", "DeviceRotationChanged", "DialogChoiceSelected", "DidLoop", "Died", "Disconnection", "DragBegin", "DragEnter", "DragStopped", "EncounteredBreak", "Ended", "Equipped", "Error", "ErrorMessageChanged", "EscapeKeyPressed", "Event", "EventConnected", "EventDisconnected", "FallingDown", "FinishedReplicating", "FirstPersonTransition", "FlagCaptured", "FocusLost", "Focused", "FreeFalling", "FriendRequestEvent", "FriendStatusChanged", "FullscreenChanged", "GameAnnounce", "GamepadConnected", "GamepadDisconnected", "GetActionButtonEvent", "GettingUp", "GraphicsQualityChangeRequest", "HealthChanged", "Heartbeat", "Hit", "Idle", "Idled", "IncommingConnection", "InputBegan", "InputChanged", "InputEnded", "InterpolationFinished", "ItemAdded", "ItemChanged", "ItemRemoved", "JumpRequest", "Jumping", "KeyDown", "KeyPressed", "KeyUp", "KeyframeReached", "LastInputTypeChanged", "LightingChanged", "Loaded", "LocalPlayerArrivedFromTeleport", "LocalSimulationTouched", "LocalToolEquipped", "LocalToolUnequipped", "LoginFailed", "LoginSucceeded", "MenuClosed", "MenuOpened", "MessageOut", "MouseButton1Click", "MouseButton1Down", "MouseButton1Up", "MouseButton2Click", "MouseButton2Down", "MouseButton2Up", "MouseClick", "MouseDrag", "MouseEnter", "MouseHoverEnter", "MouseHoverLeave", "MouseLeave", "MouseMoved", "MouseWheelBackward", "MouseWheelForward", "Move", "MoveStateChanged", "MoveToFinished", "NativePurchaseFinished", "OnClientEvent", "OnRedo", "OnServerEvent", "OnTeleport", "OnUndo", "OutfitChanged", "Paused", "PerformanceStatsVisibleChanged", "PhysicsAnalyzerIssuesFound", "PlatformStanding", "Played", "PlayerAdded", "PlayerAddedEarly", "PlayerChatted", "PlayerRemoving", "PlayerRemovingLate", "PointsAwarded", "PromptProductPurchaseFinished", "PromptProductPurchaseRequested", "PromptPurchaseFinished", "PromptPurchaseRequested", "Ragdoll", "ReachedTarget", "Received", "ReceiverConnected", "ReceiverDisconnected", "RemoveDefaultLoadingGuiSignal", "RenderStepped", "Resumed", "Resuming", "Running", "Seated", "Selected", "SelectionChanged", "SelectionGained", "SelectionLost", "ServerCollectConditionalResult", "ServerCollectResult", "ServerMessageOut", "ServerPurchaseVerification", "ServiceAdded", "ServiceRemoving", "ShowLeaveConfirmation", "SimulationRadiusChanged", "SourceValueChanged", "SpecialKeyPressed", "StateChanged", "StateEnabledChanged", "StatsReceived", "StatusAdded", "StatusRemoved", "Stepped", "Stopped", "StoppedTouching", "Strafing", "StudioModeChanged", "Swimming", "TextBoxFocusReleased", "TextBoxFocused", "ThirdPartyPurchaseFinished", "TicketProcessed", "TopbarTransparencyChangedSignal", "TouchEnded", "TouchLongPress", "TouchMoved", "TouchPan", "TouchPinch", "TouchRotate", "TouchStarted", "TouchSwipe", "TouchTap", "Touched", "UiMessageChanged", "Unequipped", "UserCFrameChanged", "VideoAdClosed", "VideoRecordingChangeRequest", "WatchAdded", "WatchRemoved", "WheelBackward", "WheelForward", "WindowFocusReleased", "WindowFocused"},
			AllFunctions = {"Abort", "Activate", "AddCenterDialog", "AddCoreScript", "AddCoreScriptLocal", "AddCustomStatus", "AddDebugger", "AddDummyJob", "AddItem", "AddKey", "AddKeyframe", "AddPose", "AddSelectionParent", "AddSelectionTuple", "AddSpecialKey", "AddStarterScript", "AddStat", "AddStatus", "AddSubPose", "AddWatch", "AdjustSpeed", "AdjustWeight", "ApplySpecificImpulse", "ApproveAssetId", "ApproveAssetVersionId", "AutowedgeCell", "AutowedgeCells", "AxisRotate", "BeginRecording", "BindAction", "BindActionToInputTypes", "BindActivate", "BindButton", "BindCoreAction", "BindToRenderStep", "BreakJoints", "Button1Down", "Button1Up", "Button2Down", "Button2Up", "CallFunction", "CanSetNetworkOwnership", "CancelAllNotification", "CancelNotification", "CaptureController", "CaptureFocus", "CaptureMetrics", "CellCenterToWorld", "CellCornerToWorld", "ChangeState", "Chat", "Check", "CheckSyntax", "Checkpoint", "Clear", "ClearAllChildren", "ClearCharacterAppearance", "ClearJoinAfterMoveJoints", "ClearMessage", "ClickButton1", "ClickButton2", "Clone", "CloseConnection", "ConfigureAsCloudEditServer", "ConfigureAsTeamTestServer", "ConvertToSmooth", "CopyRegion", "CountCells", "CreateButton", "CreateJoinAfterMoveJoints", "CreateLocalPlayer", "CreatePlugin", "CreateToolbar", "DeleteCookieValue", "Demote", "Destroy", "Disable", "DisableProcessPackets", "DisableQueue", "Disconnect", "DistanceFromCharacter", "Done", "Emit", "EnableAdorns", "EnableDebugging", "EnableProcessPackets", "EnableQueue", "EquipTool", "Error", "ExecuteScript", "ExperimentalSolverIsEnabled", "ExportPlace", "ExportSelection", "Fail", "Failed", "FillBall", "FillBlock", "FillRegion", "FindFirstChild", "FindFirstChildOfClass", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartsInRegion3", "FindPartsInRegion3WithIgnoreList", "FindService", "FinishShutdown", "Fire", "FireActionButtonFoundSignal", "FireAllClients", "FireClient", "FireServer", "GamepadSupports", "GenerateGUID", "Get", "GetAllBoundActionInfo", "GetAttachedReceivers", "GetAwardablePoints", "GetAxis", "GetBoundActionInfo", "GetBreakpoints", "GetBrickCount", "GetButton", "GetCanRedo", "GetCanUndo", "GetCell", "GetChildren", "GetClientCount", "GetClosestDialogToPosition", "GetCollection", "GetConnectedGamepads", "GetConnectedParts", "GetCookieValue", "GetCoreGuiEnabled", "GetCurrentLocalToolIcon", "GetCurrentPage", "GetCurrentValue", "GetDataStore", "GetDebugId", "GetDebuggers", "GetDeltaAve", "GetDeviceAcceleration", "GetDeviceGravity", "GetDeviceRotation", "GetErrorMessage", "GetExtentsSize", "GetFFlag", "GetFVariable", "GetFocusedTextBox", "GetFriendStatus", "GetFullName", "GetGPUDelay", "GetGameSessionID", "GetGamepadConnected", "GetGamepadState", "GetGlobalDataStore", "GetGlobals", "GetHash", "GetHeapStats", "GetJobIntervalPeakFraction", "GetJobTimePeakFraction", "GetJobsExtendedStats", "GetJobsInfo", "GetJoinMode", "GetKeyframeSequence", "GetKeyframeSequenceById", "GetKeyframes", "GetKeysPressed", "GetLastForce", "GetLastInputType", "GetListener", "GetLocalPlayerTeleportData", "GetLocals", "GetLogHistory", "GetMass", "GetMaxQualityLevel", "GetMessage", "GetMinutesAfterMidnight", "GetModelCFrame", "GetModelSize", "GetMoonDirection", "GetMoonPhase", "GetMotor", "GetMouse", "GetNavigationGamepads", "GetNetworkOwner", "GetNetworkOwnershipAuto", "GetNumAwakeParts", "GetOrderedDataStore", "GetPanSpeed", "GetPhysicsAnalyzerBreakOnIssue", "GetPhysicsAnalyzerIssue", "GetPhysicsThrottling", "GetPlatform", "GetPlayer", "GetPlayerByID", "GetPlayerById", "GetPlayerByUserId", "GetPlayerFromCharacter", "GetPlayers", "GetPlayingAnimationTracks", "GetPointCoordinates", "GetPoses", "GetPresentTime", "GetPrimaryPartCFrame", "GetRakStatsString", "GetRealPhysicsFPS", "GetRemoteBuildMode", "GetRenderAve", "GetRenderCFrame", "GetRenderConfMax", "GetRenderConfMin", "GetRenderStd", "GetRoll", "GetRootPart", "GetScriptStats", "GetSecondaryAxis", "GetService", "GetSetting", "GetShouldUseLuaChat", "GetStack", "GetState", "GetStateEnabled", "GetStatuses", "GetStudioUserId", "GetSubPoses", "GetSunDirection", "GetSupportedGamepadKeyCodes", "GetTeams", "GetTeleportSetting", "GetTextSize", "GetTiltSpeed", "GetTimeOfKeyframe", "GetTimes", "GetTimesForFrames", "GetTopbarTransparency", "GetTouchingParts", "GetTutorialState", "GetUiMessage", "GetUnder13", "GetUploadUrl", "GetUpvalues", "GetUseCoreScriptHealthBar", "GetUserCFrame", "GetValue", "GetValueString", "GetWatchValue", "GetWatches", "GetWaterCell", "HasAppearanceLoaded", "HasCustomStatus", "HasStatus", "HttpGet", "HttpPost", "ImportFbxAnimation", "ImportFbxRig", "InFullScreen", "InStudioMode", "Insert", "Interpolate", "IsA", "IsAncestorOf", "IsClient", "IsDefaultLoadingGuiRemoved", "IsDescendantOf", "IsFinishedReplicating", "IsFocused", "IsGearTypeAllowed", "IsGrounded", "IsKeyDown", "IsLoaded", "IsMotorSupported", "IsNavigationGamepad", "IsRegion3Empty", "IsRegion3EmptyWithIgnoreList", "IsRunMode", "IsRunning", "IsServer", "IsStudio", "IsTenFootInterface", "IsUserFeatureEnabled", "IsVibrationSupported", "JSONDecode", "JSONEncode", "JoinToOutsiders", "JumpCharacter", "Kick", "LegacyScriptMode", "Load", "LoadAnimation", "LoadBoolean", "LoadCharacterAppearance", "LoadData", "LoadGame", "LoadInstance", "LoadNumber", "LoadPlugins", "LoadString", "LoadWorld", "Logout", "MakeJoints", "Message", "MouseDown", "MouseMove", "MouseUp", "Move", "MoveCharacter", "MoveMouse", "MoveTo", "Negate", "OnUpdate", "OpenBrowserWindow", "OpenScript", "OpenWikiPage", "PGSIsEnabled", "PanUnits", "Pass", "Passed", "PasteRegion", "Pause", "Play", "PlayLocalSound", "PlayStockSound", "PlayerCanMakePurchases", "PlayerConnect", "Preload", "PreventTerrainChanges", "PrintScene", "Promote", "PromptLogin", "PromptNativePurchase", "PromptProductPurchase", "PromptPurchase", "PromptThirdPartyPurchase", "ReadVoxels", "RebalanceTeams", "RecenterUserHeadCFrame", "Redo", "RegisterActiveKeyframeSequence", "RegisterGetCore", "RegisterKeyframeSequence", "RegisterSetCore", "ReleaseFocus", "ReloadShaders", "Remove", "RemoveCenterDialog", "RemoveCharacter", "RemoveCustomStatus", "RemoveDefaultLoadingScreen", "RemoveKey", "RemoveKeyframe", "RemovePose", "RemoveSelectionGroup", "RemoveSpecialKey", "RemoveStat", "RemoveStatus", "RemoveSubPose", "Report", "ReportAbuse", "ReportAssetSale", "ReportInGoogleAnalytics", "ReportJobsStepWindow", "ReportMeasurement", "ReportRobuxUpsellStarted", "ReportTaskScheduler", "RequestCharacter", "RequestFriendship", "RequestServerOutput", "RequestServerStats", "Require", "Reset", "ResetCdnFailureCounts", "ResetOrientationToIdentity", "ResetWaypoints", "Resize", "ResizeWindow", "Resume", "RevokeFriendship", "Run", "Save", "SaveBoolean", "SaveData", "SaveInstance", "SaveNumber", "SaveSelectedToRoblox", "SaveStats", "SaveString", "ScheduleNotification", "ScreenPointToRay", "SendMarker", "Separate", "ServerSave", "Set", "SetAbuseReportUrl", "SetAccessKey", "SetAccountAge", "SetActive", "SetAdvancedResults", "SetAssetRevertUrl", "SetAssetUrl", "SetAssetVersionUrl", "SetAssetVersionsUrl", "SetAwardBadgeUrl", "SetAxis", "SetBaseCategoryUrl", "SetBaseSetsUrl", "SetBaseUrl", "SetBasicFilteringEnabled", "SetBestFriendUrl", "SetBlockingRemove", "SetBreakFriendUrl", "SetBreakpoint", "SetBuildUserPermissionsUrl", "SetCacheSize", "SetCameraPanMode", "SetCell", "SetCells", "SetChatFilterUrl", "SetChatStyle", "SetClickToWalkEnabled", "SetCollectScriptStats", "SetCollectionUrl", "SetCookieValue", "SetCore", "SetCoreGuiEnabled", "SetCreateFriendRequestUrl", "SetCreatorID", "SetCreatorId", "SetDeleteFriendRequestUrl", "SetDescription", "SetDesiredAngle", "SetEnabled", "SetErrorMessage", "SetFilterLimits", "SetFilterUrl", "SetFreeDecalUrl", "SetFreeModelUrl", "SetFriendUrl", "SetFriendsOnlineUrl", "SetGameSessionID", "SetGearSettings", "SetGenre", "SetGetFriendsUrl", "SetGlobal", "SetGlobalGuiInset", "SetGroupRankUrl", "SetGroupRoleUrl", "SetGroupUrl", "SetHasBadgeCooldown", "SetHasBadgeUrl", "SetIdentityOrientation", "SetImage", "SetIsBadgeDisabledUrl", "SetIsBadgeLegalUrl", "SetIsPlayerAuthenticationRequired", "SetJobsExtendedStatsWindow", "SetJoinAfterMoveInstance", "SetJoinAfterMoveTarget", "SetKeyDown", "SetKeyUp", "SetLegacyMaxItems", "SetListener", "SetLoadDataUrl", "SetLocal", "SetMakeFriendUrl", "SetMembershipType", "SetMenuIsOpen", "SetMessage", "SetMessageBrickCount", "SetMinutesAfterMidnight", "SetMotor", "SetNavigationGamepad", "SetNetworkOwner", "SetNetworkOwnershipAuto", "SetOutgoingKBPSLimit", "SetPackageContentsUrl", "SetPersonalServerGetRankUrl", "SetPersonalServerRoleSetsUrl", "SetPersonalServerSetRankUrl", "SetPhysicsAnalyzerBreakOnIssue", "SetPhysicsThrottleEnabled", "SetPing", "SetPlaceAccessUrl", "SetPlaceID", "SetPlaceId", "SetPlaceVersion", "SetPlayerHasPassUrl", "SetPosition", "SetPrimaryPartCFrame", "SetPropSyncExpiration", "SetRecordingDevice", "SetRemoteBuildMode", "SetReportUrl", "SetRoll", "SetSaveDataUrl", "SetScreenshotInfo", "SetSecondaryAxis", "SetServerSaveUrl", "SetSetting", "SetStateEnabled", "SetStuffUrl", "SetSuperSafeChat", "SetSysStatsUrl", "SetSysStatsUrlId", "SetTeleportSetting", "SetThreadPool", "SetThreadShare", "SetTimeout", "SetTitle", "SetTopbarTransparency", "SetTrustLevel", "SetTutorialState", "SetUiMessage", "SetUnder13", "SetUniverseId", "SetUploadUrl", "SetUpvalue", "SetUserCategoryUrl", "SetUserGuiRendering", "SetUserSetsUrl", "SetVIPServerId", "SetVIPServerOwnerId", "SetValue", "SetVerb", "SetVideoInfo", "SetWaterCell", "SetWaypoint", "ShowPermissibleJoints", "ShowStatsBasedOnInputString", "ShowVideoAd", "Shutdown", "SignalClientPurchaseSuccess", "SignalDialogChoiceSelected", "SignalPromptProductPurchaseFinished", "SignalPromptPurchaseFinished", "SignalServerLuaDialogClosed", "Start", "StartRecording", "StepIn", "StepOut", "StepOver", "Stop", "StopRecording", "TakeDamage", "TeamChat", "Teleport", "TeleportCancel", "TeleportToPlaceInstance", "TeleportToPrivateServer", "TeleportToSpawnByName", "TiltUnits", "ToggleFullscreen", "ToggleSelect", "ToggleTools", "TranslateBy", "TweenPosition", "TweenSize", "TweenSizeAndPosition", "TypeKey", "UnbindAction", "UnbindActivate", "UnbindAllActions", "UnbindButton", "UnbindCoreAction", "UnbindFromRenderStep", "Undo", "UnequipTools", "Union", "UnjoinFromOutsiders", "UrlEncode", "ViewportPointToRay", "WaitForChild", "Warn", "WhisperChat", "WorldToCell", "WorldToCellPreferEmpty", "WorldToCellPreferSolid", "WorldToScreenPoint", "WorldToViewportPoint", "WriteVoxels", "Zoom", "ZoomToExtents"},
			AllYieldFunctions = {"AdvanceToNextPageAsync", "AwardBadge", "AwardPoints", "BlockUser", "CheckOcclusionAsync", "ComputeRawPathAsync", "ComputeSmoothPathAsync", "CreatePlaceAsync", "CreatePlaceInPlayerInventoryAsync", "EndRecording", "FilterStringAsync", "FilterStringForBroadcast", "FilterStringForPlayerAsync", "GetAlliesAsync", "GetAnimations", "GetAssetVersions", "GetAsync", "GetBaseCategories", "GetBaseSets", "GetButton", "GetCharacterAppearanceAsync", "GetCollection", "GetCore", "GetCreatorAssetID", "GetDeveloperProductsAsync", "GetEnemiesAsync", "GetFreeDecals", "GetFreeModels", "GetFriendsAsync", "GetFriendsOnline", "GetGamePlacesAsync", "GetGamePointBalance", "GetGroupInfoAsync", "GetGroupsAsync", "GetLatestAssetVersionAsync", "GetNameFromUserIdAsync", "GetPlacePermissions", "GetPlayerPlaceInstanceAsync", "GetPointBalance", "GetProductInfo", "GetRankInGroup", "GetRecordingDevices", "GetRobuxBalance", "GetRoleInGroup", "GetRoleSets", "GetScheduledNotifications", "GetScreenResolution", "GetSortedAsync", "GetUserCategories", "GetUserIdFromNameAsync", "GetUserSets", "GetWebPersonalServerRank", "HttpGetAsync", "HttpPostAsync", "IncrementAsync", "Invoke", "InvokeClient", "InvokeServer", "IsBestFriendsWith", "IsDisabled", "IsFriendsWith", "IsInGroup", "IsLegal", "LoadAsset", "LoadAssetVersion", "LoadCharacter", "PerformPurchase", "PlayerHasPass", "PlayerOwnsAsset", "PostAsync", "PreloadAsync", "PromptForExistingAssetId", "ReserveServer", "RevertAsset", "Run", "SavePlace", "SavePlaceAsync", "SaveToRoblox", "SetAsync", "SetPlacePermissions", "SetWebPersonalServerRank", "UnblockUser", "UpdateAsync", "UserHasBadge", "WaitForDataReady"},
			AllCallbacks = {"ConfirmationCallback", "DeleteFilter", "ErrorCallback", "EventFilter", "NewFilter", "OnClientInvoke", "OnClose", "OnInvoke", "OnServerInvoke", "ProcessReceipt", "PropertyFilter", "RequestShutdown", "SendCoreUiNotification"}
		},
		
		--Empty immutable objects for accumulators
		EmptyAccumulativeObjects = {
			string = "",
			number = 0,
			boolean = false
		},
		
		--A map of built-in functions for name identification; could be used as address map for user functions
		LuaFunctionNameMap = setmetatable({
			--ROBLOX userdata constructors
			[NewAxes] = "Axes.new", [NewBrickColor] = "BrickColor.new", [BrickColor.New] = "BrickColor.New", [NewCFrame] = "CFrame.new", [NewColor3] = "Color3.new", [NewColorSequence] = "ColorSequence.new", [NewColorSequenceKeypoint] = "ColorSequenceKeypoint.new", [NewFaces] = "Faces.new", [NewInstance] = "Instance.new", [NewNumberRange] = "NumberRange.new", [NewNumberSequence] = "NumberSequence.new", [NewNumberSequenceKeypoint] = "NumberSequenceKeypoint.new", [NewPhysicalProperties] = "PhysicalProperties.new", [NewRay] = "Ray.new", [NewRect] = "Rect.new", [NewRegion3] = "Region3.new", [NewRegion3int16] = "Region3int16.new", [NewUDim] = "UDim.new", [NewUDim2] = "UDim2.new", [NewVector2] = "Vector2.new", [NewVector2int16] = "Vector2int16.new", [NewVector3] = "Vector3.new", [NewVector3int16] = "Vector3int16.new",
			--ROBLOX instance functions
			[game.ClearAllChildren] = "Instance.ClearAllChildren", [game.Clone] = "Instance.Clone", [game.clone] = "Instance.clone", [game.Destroy] = "Instance.Destroy", [game.destroy] = "Instance.destroy", [game.FindFirstChild] = "Instance.FindFirstChild", [game.findFirstChild] = "Instance.findFirstChild", [game.FindFirstChildOfClass] = "Instance.FindFirstChildOfClass", [game.GetChildren] = "Instance.GetChildren", [game.getChildren] = "Instance.getChildren", [game.GetFullName] = "Instance.GetFullName", [game.IsA] = "Instance.IsA", [game.isA] = "Instance.isA", [game.IsAncestorOf] = "Instance.IsAncestorOf", [game.IsDescendantOf] = "Instance.IsDescendantOf", [game.isDescendantOf] = "Instance.isDescendantOf", [game.Remove] = "Instance.Remove", [game.remove] = "Instance.remove", [game.WaitForChild] = "Instance.WaitForChild",
			--BrickColor functions
			[BrickColor.Black] = "BrickColor.Black", [BrickColor.Blue] = "BrickColor.Blue", [BrickColor.DarkGray] = "BrickColor.DarkGray", [BrickColor.Gray] = "BrickColor.Gray", [BrickColor.Green] = "BrickColor.Green", [BrickColor.palette] = "BrickColor.palette", [BrickColor.Random] = "BrickColor.Random", [BrickColor.random] = "BrickColor.random", [BrickColor.Red] = "BrickColor.Red", [BrickColor.White] = "BrickColor.White", [BrickColor.Yellow] = "BrickColor.Yellow",
			--CFrame functions
			[CFrame.Angles] = "CFrame.Angles", [CFrame.fromAxisAngle] = "CFrame.fromAxisAngle", [CFrame.fromEulerAnglesXYZ] = "CFrame.fromEulerAnglesXYZ",
			--Color3 functions
			[Color3.fromRGB] = "Color3.fromRGB", [Color3.fromHSV] = "Color3.fromHSV", [Color3.toHSV] = "Color3.toHSV",
			--Vector3 functions
			[Vector3.FromNormalId] = "Vector3.FromNormalId", [Vector3.FromAxis] = "Vector3.FromAxis",
			--String functions
			[string.byte] = "string.byte", [string.char] = "string.char", [string_dump] = "string.dump", [string.find] = "string.find", [string.format] = "string.format", [string.gfind] = "string.gfind", [string.gmatch] = "string.gmatch", [string.gsub] = "string.gsub", [string.len] = "string.len", [string.lower] = "string.lower", [string.match] = "string.match", [string.rep] = "string.rep", [string.reverse] = "string.reverse", [string.sub] = "string.sub", [string.upper] = "string.upper",
			--Math functions
			[math.abs] = "math.abs", [math.acos] = "math.acos", [math.asin] = "math.asin", [math.atan] = "math.atan", [math.atan2] = "math.atan2", [math.ceil] = "math.ceil", [math.cos] = "math.cos", [math.cosh] = "math.cosh", [math.deg] = "math.deg", [math.exp] = "math.exp", [math.floor] = "math.floor", [math.fmod] = "math.fmod", [math.frexp] = "math.frexp", [math.huge] = "math.huge", [math.ldexp] = "math.ldexp", [math.log] = "math.log", [math.log10] = "math.log10", [math.max] = "math.max", [math.min] = "math.min", [math.modf] = "math.modf", [math.noise] = "math.noise", [math.pow] = "math.pow", [math.rad] = "math.rad", [math.random] = "math.random", [math.randomseed] = "math.randomseed", [math.sin] = "math.sin", [math.sinh] = "math.sinh", [math.sqrt] = "math.sqrt", [math.tan] = "math.tan", [math.tanh] = "math.tanh",
			--Table functions
			[table.concat] = "table.concat", [table.foreach] = "table.foreach", [table.foreachi] = "table.foreachi", [table.getn] = "table.getn", [table.insert] = "table.insert", [table.maxn] = "table.maxn", [table.remove] = "table.remove", [table.setn] = "table.setn", [table.sort] = "table.sort",
			--Coroutine functions
			[coroutine.create] = "coroutine.create", [coroutine.resume] = "coroutine.resume", [coroutine.running] = "coroutine.running", [coroutine.status] = "coroutine.status", [coroutine.wrap] = "coroutine.wrap", [coroutine.yield] = "coroutine.yield",
			--Basic functions
			[assert] = "assert", [collectgarbage] = "collectgarbage", [debug.traceback] = "debug.traceback", [debug.profilebegin] = "debug.profilebegin", [debug.profileend] = "debug.profileend", [dofile] = "dofile", [error] = "error", [gcinfo] = "gcinfo", [getfenv] = "getfenv", [getmetatable] = "getmetatable", [ipairs] = "ipairs", [load] = "load", [loadfile] = "loadfile", [loadstring] = "loadstring", [newproxy] = "newproxy", [next] = "next", [os.difftime] = "os.difftime", [os.time] = "os.time", [pairs] = "pairs", [pcall] = "pcall", [print] = "print", [rawequal] = "rawequal", [rawget] = "rawget", [rawset] = "rawset", [select] = "select", [setfenv] = "setfenv", [setmetatable] = "setmetatable", [tonumber] = "tonumber", [tostring] = "tostring", [type] = "type", [unpack] = "unpack", [xpcall] = "xpcall",
			--ROBLOX-specific functions
			[Delay] = "Delay", [delay] = "Delay", [ElapsedTime] = "ElapsedTime", [elapsedTime] = "elapsedTime", [LoadLibrary] = "LoadLibrary", [PluginManager] = "PluginManager", [printidentity] = "printidentity", [require] = "require", [settings] = "settings", [Spawn] = "Spawn", [spawn] = "spawn", [Stats] = "stats", [stats] = "stats", [tick] = "tick", [time] = "time", [UserSettings] = "UserSettings", [Version] = "Version", [version] = "version", [Wait] = "Wait", [wait] = "wait", [warn] = "warn", [ypcall] = "ypcall"
		}, {
			__index = function(Self, Key)
				return type(Key) == "function" and rawset(Self, Key, tostring(Key):sub(-8))[Key] or nil
			end
		}),
		
		--Userdata-related helpers
		Userdata = {
			TypeTests = {
				Axes = setfenv(function(Object) Dummy.Axes = Object end, {Dummy = NewInstance("ArcHandles")}),
				BrickColor = setfenv(function(Object) Dummy.Value = Object end, {Dummy = NewInstance("BrickColorValue")}),
				CellId = function(Object) return Object.IsNil and Object.Location and Object.TerrainPart end,
				CFrame = setfenv(function(Object) Dummy.Value = Object end, {Dummy = NewInstance("CFrameValue")}),
				Color3 = function(Object) NewBrickColor(Object) end,
				ColorSequence = setfenv(function(Object) Dummy.Color = Object end, {Dummy = NewInstance("ParticleEmitter")}),
				ColorSequenceKeypoint = function(Object) if Object ~= NewColorSequenceKeypoint(Object.Time, Object.Value) then NOPE() end end,
				Connection = function(Object) local Helper = game.AncestryChanged:connect(noop); Object.disconnect(Helper); if Helper.connected then NOPE() else Helper:disconnect() end end,
				EnumerationRoot = function(Object) if Object ~= Enum then NOPE() end end,
				Enumeration = function(Object) if Object ~= Enum[tostring(Object)] then NOPE() end end,
				EnumerationItem = function(Object) if Object ~= Enum[tostring(Object):sub(6, -#Object.Name - 2)][Object.Name] then NOPE() end end,
				Event = setfenv(function(Object) Connector(Object, noop):disconnect() end, {Connector = game.AncestryChanged.connect}),
				Faces = setfenv(function(Object) Dummy.Faces = Object end, {Dummy = NewInstance("Handles")}),
				Instance = function(Object) if not pcall(game.IsA, Object, "Instance") and Object ~= game:FindService(pcall(ProtectedCallHelpers.Get, Object, "ClassName") and #Object.ClassName > 0 and Object.ClassName or tostring(Object)) then NOPE() end end, --Handles odd services such as CSGDictionaryService
				NumberRange = setfenv(function(Object) Dummy.Speed = Object end, {Dummy = NewInstance("ParticleEmitter")}),
				NumberSequence = setfenv(function(Object) Dummy.Transparency = Object end, {Dummy = NewInstance("ParticleEmitter")}),
				NumberSequenceKeypoint = function(Object) if select(2, pcall(NewNumberSequence, {Object})) == "NumberSequence ctor: expected 'NumberSequenceKeypoint' at index 1" then NOPE() end end,
				PhysicalProperties = setfenv(function(Object) Dummy.CustomPhysicalProperties = Object end, {Dummy = NewInstance("Part")}),
				Ray = setfenv(function(Object) Dummy.Value = Object end, {Dummy = NewInstance("RayValue")}),
				Rect = setfenv(function(Object) Dummy.SliceCenter = Object end, {Dummy = NewInstance("ImageLabel")}),
				Region3 = function(Object) Workspace:FindPartsInRegion3(Object, Workspace) end,
				Region3int16 = setfenv(function(Object) Terrain:CopyRegion(Object) end, {Terrain = Workspace.Terrain}),
				UDim = setfenv(function(Object) return Object + Dummy end, {Dummy = NewUDim()}),
				UDim2 = setfenv(function(Object) return Object + Dummy end, {Dummy = NewUDim2()}),
				Vector2 = setfenv(function(Object) return Object + Dummy end, {Dummy = NewVector2()}),
				Vector2int16 = setfenv(function(Object) return Object + Dummy end, {Dummy = NewVector2int16()}),
				Vector3 = setfenv(function(Object) return Object + Dummy end, {Dummy = NewVector3()}),
				Vector3int16 = setfenv(function(Object) return Object + Dummy end, {Dummy = NewVector3int16()})
			},
			
			Encoders = setmetatable({
				CellId = function(CellId) local Location = CellId.Location; return (CellId.IsNil and "true" or "false") .. "; " .. Location.X .. ", " .. Location.Y .. ", " .. Location.Z .. "; " .. tostring(CellId.TerrainPart) end,
				ColorSequence = function(ColorSequence)
					local String, StringSize, Keypoints = {}, 0, ColorSequence.Keypoints
					for Index = 1, #Keypoints do
						local Keypoint = Keypoints[Index]
						StringSize = StringSize + 1; String[StringSize] = Keypoint.Time .. ": [" .. tostring(Keypoint.Value) .. "; " .. tostring(Keypoint):match("([%d%.%d]+) $") .. "]; "
					end
					return table_concat(String):sub(1, -3)
				end,
				ColorSequenceKeypoint = function(ColorSequenceKeypoint) return ColorSequenceKeypoint.Time .. "; " .. tostring(ColorSequenceKeypoint.Value) .. "; " .. tostring(ColorSequenceKeypoint):match("([%d%.%d]+) $") end,
				Connection = function(Connection) return Connection.connected and "Active" or "Inactive" end,
				EnumerationItem = function(EnumerationItem) return tostring(EnumerationItem):sub(6) end,
				Event = function(Event) return tostring(Event):sub(8) end,
				Instance = function(Instance)
					if pcall(ProtectedCallHelpers.Get, Instance, "Name") then
						local Name, ClassName = Instance.Name, Instance.ClassName
						return Name .. (Name ~= ClassName and " <" .. ClassName .. ">" or "")
					end
					return tostring(Instance) .. " <Unknown>"
				end,
				NumberRange = function(NumberRange) return NumberRange.Min .. ", " .. NumberRange.Max end,
				NumberSequence = function(NumberSequence)
					local String, StringSize, Keypoints = {}, 0, NumberSequence.Keypoints
					for Index = 1, #Keypoints do
						local Keypoint = Keypoints[Index]
						StringSize = StringSize + 1; String[StringSize] = Keypoint.Time .. ": [" .. Keypoint.Value .. ", " .. Keypoint.Envelope .. "]; "
					end
					return table_concat(String):sub(1, -3)
				end,
				NumberSequenceKeypoint = function(NumberSequenceKeypoints) return NumberSequenceKeypoints.Time .. ", " .. NumberSequenceKeypoints.Value .. ", " .. NumberSequenceKeypoints.Envelope end,
				Ray = function(Ray) return tostring(Ray.Origin) .. "; " .. tostring(Ray.Direction) end,
				UDim2 = function(UDim2) return UDim2.X.Scale .. ", " .. UDim2.X.Offset .. "; " .. UDim2.Y.Scale .. ", " .. UDim2.Y.Offset end,
				Fallback = function(Userdata) local UserdataString = tostring(Userdata); return UserdataString:find("^%w+: %w+$") and "0x" .. UserdataString:sub(-8) or Userdata ~= Enum and UserdataString or "" end
			}, {__index = function(Self) return Self.Fallback end}),
			
			Decoders = setmetatable({
				Axes = function(String)
					local Decoded = ProxyMethods.string.Split(String, ", ")
					for Index = 1, #Decoded do Decoded[Index] = Enum.Axis[Decoded[Index]] end
					return NewAxes(unpack(Decoded))
				end,
				BrickColor = function(String) return NewBrickColor(String) end,
				CFrame = function(String) return NewCFrame(unpack(ProxyMethods.string.Split(String, ", "))) end,
				Color3 = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewColor3(Decoded[1], Decoded[2], Decoded[3]) end,
				ColorSequence = function(String)
					local Decoded, DecodedSize, StringSplit = {}, 0, ProxyMethods.string.Split
					for Keypoint in String:gmatch("%b[]") do
						local Color3 = StringSplit(Keypoint:sub(2, -5), ", ")
						DecodedSize = DecodedSize + 1; Decoded[DecodedSize] = NewColor3(Color3[1], Color3[2], Color3[3])
					end
					return NewColorSequence(unpack(Decoded))
				end,
				Enumeration = function(String) return Enum[String] end,
				EnumerationItem = function(String) return ProxyMethods.table.GetNest(Enum, String) end,
				Faces = function(String)
					local Decoded = ProxyMethods.string.Split(String, ", ")
					for Index = 1, #Decoded do Decoded[Index] = Enum.NormalId[Decoded[Index]] end
					return NewFaces(unpack(Decoded))
				end,
				NumberRange = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewNumberRange(Decoded[1], Decoded[2]) end,
				NumberSequence = function(String)
					local Keypoints, KeypointsSize, StringSplit = {}, 0, ProxyMethods.string.Split
					for Keypoint in String:gmatch("%d+[%.%d+]*: %b[]") do
						KeypointsSize = KeypointsSize + 1; Keypoints[KeypointsSize] = NewNumberSequenceKeypoint(Keypoint:match("(%d+[%.%d+]*).-(%d+[%.%d+]*).-(%d+[%.%d+]*)"))
					end
					return NewColorSequence(unpack(Keypoints))
				end,
				PhysicalProperties = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewPhysicalProperties(Decoded[1], Decoded[2], Decoded[3], Decoded[4], Decoded[5]) end,
				Ray = function(String)
					local Decoded = ProxyMethods.string.Split(String:gsub(";", ","), ", ")
					return NewRay(NewVector3(Decoded[1], Decoded[2], Decoded[3]), NewVector3(Decoded[4], Decoded[5], Decoded[6]))
				end,
				Rect = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewRect(Decoded[1], Decoded[2], Decoded[3]) end,
				Region3 = function(String)
					local Decoded = ProxyMethods.string.Split(String:gsub(";", ","), ", ")
					local Position, Size = NewCFrame(unpack(Decoded, 1, 12)), NewVector3(Decoded[13], Decoded[14], Decoded[15])
					return NewRegion3(Position - Size * 0.5, Position + Size * 0.5)
				end,
				Region3int16 = function(String)
					local Decoded = ProxyMethods.string.Split(String:gsub(";", ","), ", ")
					return NewRegion3int16(NewVector3int16(Decoded[1], Decoded[2], Decoded[3]), NewVector3int16(Decoded[4], Decoded[5], Decoded[6]))
				end,
				UDim = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewUDim(Decoded[1], Decoded[2]) end,
				UDim2 = function(String) local Decoded = ProxyMethods.string.Split(String:gsub(";", ","), ", "); return NewUDim2(Decoded[1], Decoded[2], Decoded[3], Decoded[4]) end,
				Vector2 = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewVector2(Decoded[1], Decoded[2]) end,
				Vector2int16 = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewVector2int16(Decoded[1], Decoded[2]) end,
				Vector3 = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewVector3(Decoded[1], Decoded[2], Decoded[3]) end,
				Vector3int16 = function(String) local Decoded = ProxyMethods.string.Split(String, ", "); return NewVector3int16(Decoded[1], Decoded[2], Decoded[3]) end,
				Fallback = function(String) warn("No method of unserializing \"" .. String .. "\"") end
			}, {__index = function(Self) return Self.Fallback end}),
			
			DummyObjects = {
				Instances = setmetatable({}, {
					__index = function(Self, ClassName)
						local Successful, Instance = pcall(NewInstance, ClassName)
						if Successful then Self[ClassName] = Instance; return Instance end; return nil
					end
				}),
				Axes = NewAxes(),
				BrickColor = NewBrickColor(),
				CellId = NewCellId(),
				CFrame = NewCFrame(),
				Color3 = NewColor3(),
				ColorSequence = NewColorSequence(NewColor3()),
				ColorSequenceKeypoint = NewColorSequenceKeypoint(0, NewColor3()),
				Faces = NewFaces(),
				NumberRange = NewNumberRange(0),
				NumberSequence = NewNumberSequence(0),
				NumberSequenceKeypoint = NewNumberSequenceKeypoint(0, 0),
				PhysicalProperties = NewPhysicalProperties(0, 0, 0),
				Ray = NewRay(),
				Rect = NewRect(),
				Region3 = NewRegion3(),
				Region3int16 = NewRegion3int16(),
				UDim = NewUDim(),
				UDim2 = NewUDim2(),
				Vector2 = NewVector2(),
				Vector2int16 = NewVector2int16(),
				Vector3 = NewVector3(),
				Vector3int16 = NewVector3int16()
			}
		},
		
		Math = {
			Infinity = math_huge,
			NaN = math_abs(0 / 0)
		}
	},
	Persistent = {Instance = {PropertyWritabilityMap = {}}},
	Temporary = {}
}, setmetatable({}, {__index = {
	CanUseLoadstring = pcall(loadstring, ""),
	CanAccessScriptSource = pcall(ProtectedCallHelpers.Get, script, "Source"),
	IsFilteringEnabled = Workspace.FilteringEnabled
}})

--Functions
Functions = {
	Create = {
		Instance = function(ClassName, Properties, Events)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Functions.Create.Instance", ClassName, "string", Properties, "nil, table", Events, "nil, table") end
			local Instance, Parent = NewInstance(ClassName)
			if Properties then
				Parent = Properties.Parent; Properties.Parent = nil
				for Property, Value in next, Properties do
					Instance[Property] = Value
				end
				Instance.Parent = Parent
			end
			if Events then
				for Event, Handler in next, Events do
					Instance[Event]:connect(Handler)
				end
			end
			return Instance
		end,
		
		Proxy = function(Metatable)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Functions.Create.Proxy", Metatable, "table") end
			local Proxy = newproxy(true); local CurrentMetatable = getmetatable(Proxy)
			for Name, Metamethod in next, Metatable do
				CurrentMetatable[Name] = Metamethod
			end
			return Proxy
		end
	},
	
	--[[Event = {
		Create = function(Event, Handler)
			Assert("Functions.Event.Create", not ProxyMethods.table.GetNest(Storage.Temporary.Events, Event), "The event \"" .. Event .. "\" already exists!")
			if type(Handler) == "function" then
				local Signal = Libraries.RbxUtility.CreateSignal()
				ProxyMethods.table.CreateNest(Storage.Temporary.Events, Event, {Signal = Signal, Connections = {}})
				ProxyMethods["function"].RunAsThread(ProxyMethods["function"].BindToEnvironment(Handler, {Signal = Signal}))
			elseif type(Handler) == "userdata" and ProxyMethods.userdata.GetUserdataType(Handler) == "Connection" then
				--ProxyMethods.table.CreateNest(Storage.Temporary.Events, Event, {Signal = Handler, Connections = {}})
			end
			return true
		end,
		
		Remove = function(Event) --Fix this; NestParentTable == nil
			local EventNest = ProxyMethods.table.GetNest(Storage.Temporary.Events, Event); local NestParentTable = ProxyMethods.table.GetOriginChildTable(Storage.Temporary.Events, EventNest)
			--print(_(Storage.Temporary.Events):GetOriginChildTable(EventNest))
			Assert("Functions.Event.Remove", EventNest, "The event \"" .. Event .. "\" does not exist!")
			for __, Connection in next, EventNest.Connections do
				Connection:__disconnect()
			end
			NestParentTable[ProxyMethods.table.IndexOf(NestParentTable, EventNest)] = nil
			return true
		end,
		
		Attach = function(Event, Handler, Tag)
			local EventNest = ProxyMethods.table.GetNest(Storage.Temporary.Events, Event)
			Assert("Functions.Event.Attach", EventNest, "The event \"" .. Event .. "\" does not exist!", not Tag or not EventNest.Connections[Tag], "The event \"" .. Event .. "\" already has an attachment with the tag \"" .. tostring(Tag) .. "\"! Please detach it first.")
			local Connection = EventNest.Signal:connect(Handler)
			local Proxy = Functions.Create.Proxy({
				__index = function(Self, Key) return (Key == "disconnect" or Key == "Detach") and Functions.Event.Detach or Key == "__disconnect" and Connection.disconnect or nil end,
				__metatable = "The metatable is locked"
			})
			EventNest.Connections[Tag or #EventNest.Connections + 1] = Proxy
			return Proxy
		end,
		
		Detach = function(...)
			local Arguments = {...}
			local EventConnectionsNest = type(Arguments[1]) == "string" and ProxyMethods.table.GetNest(Storage.Temporary.Events, Arguments[1] .. ".Connections") or ProxyMethods.table.GetOriginChildTable(Storage.Temporary.Events, Arguments[1])
			Assert("Functions.Event.Detach", EventConnectionsNest, "The event" .. (type(Arguments[1]) == "string" and " \"" .. Arguments[1] .. "\"" or "") .. " does not exist!")
			for Tag, Connection in next, EventConnectionsNest do
				if Connection == Arguments[1] or Tag == Arguments[2] then
					Connection:__disconnect()
					EventConnectionsNest[Tag] = nil
					return true
				end
			end
			return false
		end,
		
		GetConnections = function(Event)
			Assert.ExpectArgument("Functions.Event.GetConnections", Event)
			local EventNest, Connections, ConnectionsSize = ProxyMethods.table.GetNest(Storage.Temporary.Events, Event), {}, 0
			Assert("Functions.Event.GetConnections", EventNest, "The event \"" .. Event .. "\" does not exist!")
			for __, Connection in next, EventNest.Connections do
				ConnectionsSize = ConnectionsSize + 1; Connections[ConnectionsSize] = Connection
			end
			return Connections
		end
	},]]
	
	GUI = {
		CreateMessageDialog = function(Parent, Title, Message, Style, Buttons) --Styles: Notify, Confirm, Error
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Functions.GUI.CreateMessageDialog", Parent, "nil, Instance", Title, "string", Message, "string", Style, "string", Buttons, "table") end
			local Parent, Dialog, FromOffset = Parent and (Parent:IsA("GuiBase") and Parent or Functions.Create.Instance("ScreenGui", {Name = "_MessageDialog", Parent = Parent})) or nil, Style and Libraries.RbxGui.CreateStyledMessageDialog(Title, Message, Style, Buttons) or Libraries.RbxGui.CreateMessageDialog(Title, Message, Buttons), 50
			local DefaultPosition, DefaultSize = Dialog.Position, Dialog.Size
			ProxyMethods.userdata.Instance.SetProperties(Dialog, {
				Parent = Parent,
				Draggable = true,
				ClipsDescendants = true,
				Size = NewUDim2(0, 0, 0, 0),
				Position = NewUDim2(0.5, 0, 0.5, 0)
			})
			for Index = 1, #Buttons do
				getfenv(Buttons[Index].Function).Dialog = setmetatable({
					Close = coroutine_wrap(function()
						Dialog:TweenSizeAndPosition(NewUDim2(0, 0, 0, 0), NewUDim2(Dialog.Position.X.Scale + (Dialog.Size.X.Scale * 0.5), Dialog.Position.X.Offset + (Dialog.Size.X.Offset * 0.5), Dialog.Position.Y.Scale + (Dialog.Size.Y.Scale * 0.5), Dialog.Position.Y.Offset + (Dialog.Size.Y.Offset * 0.5)), "Out", "Quart", 0.25, true)
						repeat wait() until Dialog.AbsoluteSize.X == 0 and Dialog.AbsoluteSize.Y == 0
						(Dialog.Parent.Name == "RBXunderscore_MessageDialog" and Dialog.Parent or Dialog):Destroy()
					end)
				}, {
					__newindex = noop,
					__metatable = "The metatable is locked"
				})
			end
			Functions.GUI.ModifyZIndex(Dialog, 10, true)
			Dialog:TweenSizeAndPosition(DefaultSize, DefaultPosition, "Out", "Quart", 0.25, true)
			return Dialog
		end,
		
		ModifyZIndex = function(Parent, Level, HardSet)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Functions.GUI.ModifyZIndex", Parent, "instance", Level, "integer", HardSet, "nil, boolean") end
			local Children, ZIndex = ProxyMethods.userdata.Instance.GetAllChildren(Parent), HardSet and Level or Parent.ZIndex + Level
			pcall(ProtectedCallHelpers.Set, Parent, "ZIndex", ZIndex)
			for Index = 1, #Children do
				local Child = Children[Index]
				if Child:IsA("GuiObject") then
					Child.ZIndex = HardSet and Child.ZIndex + ZIndex or ZIndex
				end
			end
		end
	},
	
	HTTPRequest = {
		New = function(URL, Options)
			--Methods: Send, Abort
			--Properties: URL, RequestType, Data, DataType (POST), EncodeData (POST), CompressData (POST), Cache (GET), Response, Status, Timeout
			--Events: OnSuccess, OnFailure, OnStatusChange, OnTimeOut
			--Statuses: 
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("HTTPRequest.New", URL, "string", Options, "nil, table") end
			local Properties, Events, Statuses, Internal = {
				URL = Services.HttpService:UrlEncode(URL),
				RequestType = Options.RequestType and Options.RequestType:upper() or "GET",
				Data = type(Options.Data) == "table" and Services.HttpService:JSONEncode(Options.Data) or Options.Data,
				DataType = Options.DataType,
				Encode = Options.Encode,
				Compress = Options.Compress,
				Cache = Options.Cache,
				Timeout = Options.Timeout or 5,
				Status = "uninitialized",
				StatusCode = 0
			}, {
				OnSuccess = Options.OnSuccess,
				OnFailure = Options.OnFailure,
				OnStatusChange = Options.OnStatusChange,
				OnTimeout = Options.OnTimeout
			}, {Time = {}}, {}
			return InternalFunctions.NewProxy({
				__index = setmetatable({
					Properties = Properties,
					Events = Events
				}, {
					__index = {
						Send = coroutine_wrap(function()
							local StartTime, Timer, Response = tick()
							Timer = Services.RunService.Stepped:connect(function()
								local Time = tick();
								
							end)
							if Properties.RequestType == "GET" then
								Response = Services.HttpService:GetAsync(Properties.URL, not Properties.Cache);
							elseif Properties.RequestType == "POST" then
								Response = Services.HttpService:PostAsync(Properties.URL, Properties.Data, Properties.DataType, Properties.Compress)
							else
								
							end
							Timer:disconnect()
							if not Internal.Aborted then
								--Got response
								Properties.Response = Response
								Properties.Completed = true
							end
						end),
						
						Abort = function()
							Internal.Aborted = true
							Properties.Status = "aborted"
							Properties.StatusCode = -1
						end
					}
				}),
				
				__newindex = function()
					
				end,
				
				__len = function()
					
				end,
				
				__metatable = "The metatable is locked"
			})
		end,
		
		Get = function(URL, NoCache)
			return Services.HttpService:GetAsync(URL, NoCache)
		end,
		
		GetAsync = function(URL, NoCache, Callback)
			
		end,
		
		Post = function(URL, Data, ContentType, CompressData)
			return Services.HttpService:PostAsync(URL, type(Data) ~= "string" and Services.HttpService:JSONEncode(Data) or Data, ContentType, CompressData)
		end,
		
		PostAsync = function(URL, Data, ContentType, CompressData, Callback)
			
		end,
		
		SetDefaultOptions = function(Options)
			
		end
	},
	
	Utilities = {
		NormalizeIndexRange = function(MaximumPosition, Begin, End)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Functions.Utilities.NormalizeIndexRange", MaximumPosition, "integer", Begin, "nil, integer", End, "nil, integer") end
			MaximumPosition, Begin = type(MaximumPosition) == "number" and MaximumPosition or #MaximumPosition, Begin or 1
			if Begin > MaximumPosition or End and (End < -MaximumPosition or End == 0) then return 0, 0 end
			return math_max(Begin < 0 and MaximumPosition + Begin + 1 or Begin, 1), End and math_min(math_max(End < 0 and (End == Begin and math_max(Begin < 0 and MaximumPosition + Begin + 1 or Begin, 1) or MaximumPosition + End + 1) or (Begin < 0 and MaximumPosition + Begin + End or (End < Begin and Begin or End)), 1), MaximumPosition) or MaximumPosition
		end
	}
}

--Functions used by the library internally
InternalFunctions = {
	GetUnwrappedObject = function(Object)
		return InternalFunctions.IsWrappedObject(Object) and Object.__self or Object
	end,
	
	GetUnwrappedObjects = function(...)
		local Objects, ArgumentCount, IsWrappedObject = {...}, select("#", ...), InternalFunctions.IsWrappedObject
		for Index = 1, ArgumentCount do
			local Object = Objects[Index]
			if IsWrappedObject(Object) then
				Objects[Index] = Object.__self
			end
		end
		return unpack(Objects, 1, ArgumentCount)
	end,
	
	GetProxyMethod = function(Object, Method)
		local Type = type(Object)
		if Type == "userdata" then
			local UserdataProxyMethods = ProxyMethods.userdata
			local Methods, SubType = UserdataProxyMethods[UserdataProxyMethods.GetUserdataType(Object)], pcall(ProtectedCallHelpers.Get, Object, "ClassName") and Object.ClassName or tostring(Object)
			return Methods and (Methods[SubType] and Methods[SubType][Method] or Methods[Method]) or UserdataProxyMethods[Method]
		else
			return ProxyMethods[Type][Method]
		end
	end,
	
	GetConditionalProtectedCaller = function(Section, Function, Error)
		return function(...) Assert(Section, pcall(Function, ...) or Configurations.ContinueOnError, Error) end
	end,
	
	IsType = function(Object, _Type)
		if InternalFunctions.IsWrappedObject(Object) then Object = Object.__self end; local Type = type(Object)
		if type(_Type) ~= "string" then return Type == type(_Type) end
		--print(Object, Type, _Type)
		local _LowerType = _Type:lower()
		if Type == _LowerType or _LowerType == "object" and Type ~= "nil" or _LowerType == "anything" then
			return true
		elseif _LowerType == "numeric" then
			return type(tonumber(Object)) == "number"
		elseif Type == "userdata" then
			local UserdataType, UserdataString = ProxyMethods.userdata.GetUserdataType(Object), tostring(Object)
			return UserdataType == "Instance" and (_LowerType == "service" and Object == game:FindService(pcall(ProtectedCallHelpers.Get, Object, "ClassName") and #Object.ClassName > 0 and Object.ClassName or pcall(game.FindService, game, UserdataString) and UserdataString or "nil") or Object:IsA(_Type)) or _LowerType == UserdataType:lower()
		elseif Type == "number" then
			local IsInteger = Object % 1 == 0
			return _LowerType == "integer" and IsInteger or (_LowerType == "float" or _LowerType == "double") and not IsInteger or (_LowerType == "content" or _LowerType == "contentid" or _LowerType == "asset" or _LowerType == "assetid") and ProxyMethods.number.IsContentID(Object)
		elseif Type == "string" then
			return (_LowerType == "content" or _LowerType == "contenturl" or _LowerType == "asset" or _LowerType == "asseturl") and ProxyMethods.string.IsContentURL(Object)
		elseif Type == "function" then
			return (_LowerType == "luafunction" or _LowerType == "builtinfunction") and ProxyMethods["function"].IsLuaFunction(Object)
		elseif Type == "thread" then
			return _LowerType == "coroutine"
		end
		return false
	end,
	
	IsWrappedObject = setfenv(function(Object)
		return type(Object) == "userdata" and pcall(Check, Object)
	end, {Check = function(Object) return Object.__self and Object.__type end}),
	
	Identity = function(...) return ... end,
	
	ReturnTruthiness = function(...)
		local ArgumentCount = select("#", ...)
		if ArgumentCount > 1 then
			local Arguments = {...}
			for Index = 1, ArgumentCount do
				Arguments[Index] = not not Arguments[Index]
			end
			return unpack(Arguments, 1, ArgumentCount)
		else
			return not not ...
		end
	end
}

--Functions used for assertion
Assert = setmetatable({
	ExpectArgument = function(Section, ...)
		local Arguments = {...}
		for Index = 1, select("#", ...) do
			if Arguments[Index] == nil then
				Log.Error(Section, "Argument #" .. Index .. " expected (got nil)", 1)
			end
		end
	end,
	
	ExpectArgumentType = function(Section, ...) --ActualType (object), ExpectedType (string list separated by comma)...
		local Arguments, IsType = {...}, InternalFunctions.IsType
		for Index = 1, select("#", ...), 2 do
			local Argument, ArgumentIndex = Arguments[Index], (Index + 1) * 0.5 - ((Index + 1) * 0.5) % 1
			local ActualType, ExpectedType, IsWrongType = type(Argument), Arguments[Index + 1], true
			if ExpectedType:find(",") then
				for ExpectedType in ExpectedType:gmatch("%w+") do
					if ActualType == ExpectedType or IsType(Argument, ExpectedType) then
						IsWrongType = false; break
					end
				end
			elseif ActualType == ExpectedType or IsType(Argument, ExpectedType) then
				IsWrongType = false
			end
			if IsWrongType then
				Log.Error(Section, "Wrong type for argument #" .. ArgumentIndex .. " (" .. ExpectedType:gsub("(.*),", "%1 or") .. " expected, got " .. ActualType .. ")", 1)
			end
		end
	end,
	
	ExpectEveryArgumentType = function(Section, TypeExpected, ...)
		local Arguments, ProcessedArguments, ProcessedArgumentsSize = {...}, {}, 0
		for Index = 1, select("#", ...) do
			ProcessedArguments[ProcessedArgumentsSize + 1] = Arguments[Index]
			ProcessedArguments[ProcessedArgumentsSize + 2] = TypeExpected
			ProcessedArgumentsSize = ProcessedArgumentsSize + 2
		end
		Assert.ExpectArgumentType(Section, unpack(ProcessedArguments, 1, ProcessedArgumentsSize))
	end
}, {
	__call = function(Self, Section, ...) --Generic assertion
		local Arguments = {...}
		for Index = 1, select("#", ...), 2 do
			if not Arguments[Index] then
				Log.Error(Section, Arguments[Index + 1], 1)
			end
		end
	end
})

--Functions used for logging
Log = setmetatable({
	Warn = function(Section, Message)
		warn("[_" .. (Section and "." .. Section or "") .. "] " .. Message)
	end,
	
	Error = function(Section, Message, StackLevel)
		error("[_" .. (Section and "." .. Section or "") .. "] " .. Message, 2 + (StackLevel or 0))
	end
}, {
	__call = function(__, Section, Message)
		Services.TestService:Message("[_" .. (Section and "." .. Section or "") .. "] " .. Message)
	end
})

--Proxy methods
ProxyMethods = setmetatable({
	string = {
		CamelCase = function(String, Template) --Use "x" or "X" to indicate words; example: x_X, XX, x-__-X
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.CamelCase", String, "string", Template, "nil, string") end
			local StringCapitalize = ProxyMethods.string.Capitalize
			local Words, Separator = ProxyMethods.string.GetWords(String, StringCapitalize)
			if Template then
				local LowerFirstWord, LowerOtherWords = Template:sub(1, 1):lower() == Template:sub(1, 1), Template:sub(-1):lower() == Template:sub(-1)
				Words[1] = LowerFirstWord and Words[1]:lower() or StringCapitalize(Words[1])
				for Index = 2, #Words do
					Words[Index] = LowerOtherWords and Words[Index]:lower() or StringCapitalize(Words[Index])
				end
				Separator = Template:match("%W+")
			end
			return table_concat(Words, Separator)
		end,
		
		CharacterAt = function(String, Index)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.CharacterAt", String, "string", Index, "nil, integer") end
			return String:sub(Index, Index)
		end,
		
		Contains = function(String, Pattern)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.Contains", String, "string", Pattern, "string, number") end
			if Pattern == "" then return nil else Pattern = tostring(Pattern) end
			local MatchFound = not not (CaseInsensitive and String:lower() or String):match(CaseInsensitive and Pattern:lower() or Pattern)
			if MatchFound then
				local MatchCount = 0
				for __ in (CaseInsensitive and String:lower() or String):gmatch(CaseInsensitive and Pattern:lower() or Pattern) do
					MatchCount = MatchCount + 1
				end
				return true, MatchCount
			else
				return false
			end
		end,
		
		EndsWith = function(String, Substring, MaximumIndex, CaseInsensitive)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.EndsWith", String, "string", Substring, "string, number", MaximumIndex, "nil, integer", CaseInsensitive, "nil, boolean") end
			Substring = tostring(Substring)
			local StringLength, SubstringLength = #String, #Substring
			if SubstringLength > StringLength then return false end
			return (CaseInsensitive and String:lower() or String):sub((MaximumIndex or StringLength) - SubstringLength + 1, MaximumIndex or StringLength) == (CaseInsensitive and Substring:lower() or Substring)
		end,
		
		EscapeRegularExpression = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.EscapeRegularExpression", String, "string") end
			return (String:gsub("([%p%s])", "%%%1"))
		end,
		
		Execute = function(String, ...)
			Assert("Methods.String.Execute", Capabilities.CanUseLoadstring, "loadstring is not available in local scripts!")
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.Execute", String, "string") end
			return loadstring(String)(...)
		end,
		
		GetNumbers = function(String, Processor)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.GetNumbers", String, "string", Processor, "nil, function") end
			return ProxyMethods.string.MatchAllByPattern(String, "%d+[%.%d+]*", Processor)
		end,
		
		GetWords = function(String, Processor)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.GetWords", String, "string", Processor, "nil, function") end
			return ProxyMethods.string.MatchAllByPattern(String, "%w+", Processor)
		end,
		
		IndexOf = function(String, Pattern, MinimumIndex)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.IndexOf", String, "string", Pattern, "string, number", MinimumIndex, "nil, integer") end
			return (String:find(tostring(Pattern), MinimumIndex and MinimumIndex < 1 and 1 or MinimumIndex))
		end,
		
		InvertCase = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.InvertCase", String, "string") end
			local Characters, CharactersSize = {}, 0
			for Index = 1, #String do
				local Character = String:sub(Index, Index)
				CharactersSize = CharactersSize + 1; Characters[CharactersSize] = Character:lower() == Character and Character:upper() or Character:lower()
			end
			return table_concat(Characters)
		end,
		
		IsBlank = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.IsBlank", String, "string") end
			return not String:find("%S")
		end,
		
		IsContentURL = setfenv(function(String, Timeout)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.IsContentURL", String, "string", Timeout, "nil, number") end
			String = type(tonumber(String)) == "number" and "rbxassetid://" .. String or String:lower()
			local ContentProvider, Timeout, IsInvalid, Connection = Services.ContentProvider, tick() + (String:sub(1, 9) == "rbxasset:" and 0.02 or Timeout or 5)
			Connection = MessageOutEvent:connect(function(Message, Type)
				if Type == Enum.MessageType.MessageError and Message == "ContentProvider:Preload() failed for " .. String:gsub("^rbxhttp:/", "http://www.roblox.com") then
					IsInvalid = true; Connection:disconnect()
				end
			end)
			pcall(ContentProvider.Preload, ContentProvider, String)
			repeat wait()--[[; print("[" .. String .. "] Queue size:", ContentProvider.RequestQueueSize, "| Invalid:", IsInvalid, "| Timed out:", tick() > Timeout)]] until ContentProvider.RequestQueueSize == 0 or IsInvalid or tick() > Timeout
			return not IsInvalid
		end, {MessageOutEvent = Services.LogService.MessageOut}),
		
		LastIndexOf = function(String, Pattern, MaximumIndex)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.LastIndexOf", String, "string", Pattern, "string, number", MaximumIndex, "nil, integer") end
			Pattern = tostring(Pattern)
			local Found = String:reverse():find(Pattern:reverse(), #String - (MaximumIndex and (MaximumIndex > #String and #String or MaximumIndex) - #Pattern or #String))
			return Found and #String - #Pattern - Found + 2 or nil
		end,
		
		LoadString = function(String)
			Assert("Methods.String.LoadString", Capabilities.CanUseLoadstring, "loadstring is not available in local scripts!")
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.LoadString", String, "string") end
			return loadstring(String)
		end,
		
		MatchAllByPattern = function(String, Pattern, Processor)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.MatchAllByPattern", String, "string", Pattern, "string, number", Processor, "nil, function") end
			local Strings, StringsSize = {}, 0
			for String in String:gmatch(Pattern) do
				StringsSize = StringsSize + 1; Strings[StringsSize] = String
			end
			if Processor then
				for Index = 1, #Strings do
					Strings[Index] = Processor(Strings[Index])
				end
			end
			return Strings
		end,
		
		Pad = function(String, Padding, Side)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.Pad", String, "string", Padding, "string, number", Side, "nil, string") end
			return not Side and Padding .. String .. Padding or Side == "Left" and Padding .. String or Side == "Right" and String .. Padding or String
		end,
		
		ParseBinary = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ParseBinary", String, "string") end
			return tonumber(String:match("0?b?([01]+)"), 2)
		end,
		
		ParseDouble = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ParseDouble", String, "string") end
			return tonumber(String:match("%d+%.?%d*"))
		end,
		
		ParseHex = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ParseHex", String, "string") end
			return tonumber(String:match("0?x?(%x+)"), 16)
		end,
		
		ParseInteger = function(String)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ParseInteger", String, "string") end
			return tonumber(String:match("%d+"))
		end,
		
		Split = function(String, Delimiter) --Fix
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.Split", String, "string", Delimiter, "nil, string, number") end
			local Delimiter, Pieces, PiecesSize = ProxyMethods.string.EscapeRegularExpression(Delimiter and tostring(Delimiter) or ""), {}, 0
			for Piece in String:gmatch(Delimiter == "" and "." or "[^" .. Delimiter .. "]-[^" .. Delimiter .. "]+") do
				PiecesSize = PiecesSize + 1; Pieces[PiecesSize] = Piece:gsub("^" .. Delimiter, "")
			end
			return #Pieces > 0 and Pieces or nil
		end,
		
		StartsWith = function(String, Substring, MinimumIndex, CaseInsensitive)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.StartsWith", String, "string", Substring, "string, number", MinimumIndex, "nil, integer", CaseInsensitive, "nil, boolean") end
			Substring = tostring(Substring)
			return (CaseInsensitive and String:lower() or String):sub(MinimumIndex or 1, (MinimumIndex or 0) + #Substring) == (CaseInsensitive and Substring:lower() or Substring)
		end,
		
		ToBoolean = function(String, Keywords)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ToBoolean", String, "string", Keywords, "nil, table") end
			Keywords = Keywords or {[true] = {"true", "on", "yes", "1"}, [false] = {"false", "off", "no", "0"}}
			if type(Keywords[true]) == "table" or type(Keywords[false]) == "table" then
				if Keywords[true] then
					local Keywords = Keywords[true]
					for Index = 1, #Keywords do
						if Keywords[Index] == String then
							return true
						end
					end
				end
				if Keywords[false] then
					local Keywords = Keywords[false]
					for Index = 1, #Keywords do
						if Keywords[Index] == String then
							return false
						end
					end
				end
			else
				for Keyword, Boolean in next, Keywords do
					if String == Keyword then
						return Boolean
					end
				end
			end
			return nil
		end,
		
		ToLowerCase = function(String, Begin, End)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ToLowercase", String, "string", Begin, "nil, integer", End, "nil, integer") end
			Begin, End = Functions.Utilities.NormalizeIndexRange(#String, Begin, End)
			return String:sub(1, Begin - 1) .. String:sub(Begin, End):lower() .. String:sub(End + 1, #String)
		end,
		
		ToNumber = tonumber,
		
		ToUpperCase = function(String, Begin, End)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.ToUppercase", String, "string", Begin, "nil, integer", End, "nil, integer") end
			Begin, End = Functions.Utilities.NormalizeIndexRange(#String, Begin, End)
			return String:sub(1, Begin - 1) .. String:sub(Begin, End):upper() .. String:sub(End + 1, #String)
		end,
		
		Trim = function(String, Side)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.String.Trim", String, "string", Side, "nil, string") end
			return String:match("^" .. ((not Side or Side == "Left") and "%s*" or "") .. "(.-)" .. ((not Side or Side == "Right") and "%s*" or "") .. "$")
		end,
		
		Unserialize = function(...) return ProxyMethods.userdata.Instance.Unserialize(...) end,
		
		--Metamethods
		Add = function(String, AddWith)
			Assert("Methods.String.Add", type(AddWith) ~= "number" or ProxyMethods.number.IsInteger(AddWith), "The number added with must be an integer!")
			return type(AddWith) == "number" and (AddWith == 0 and String or not ProxyMethods.number.IsPositive(AddWith) and ProxyMethods.string.Subtract(String, -AddWith)) or ProxyMethods.string.Concatenate(String, AddWith)
		end,
		
		Subtract = function(String, SubtractWith)
			Assert("Methods.String.Subtract", type(SubtractWith) == "string" or type(SubtractWith) == "number" and ProxyMethods.number.IsInteger(SubtractWith) and (SubtractWith == 0 or ProxyMethods.number.IsPositive(SubtractWith)), "The string must be subtracted with a string or a positive integer!")
			return type(SubtractWith) == "number" and (SubtractWith == 0 and String or String:sub(Functions.Utilities.NormalizeIndexRange(#String, 1, #String - SubtractWith))) or (String:gsub(SubtractWith, ""))
		end,
		
		Multiply = string.rep,
		
		Negate = string.reverse,
		
		Concatenate = function(String, Object)
			if type(Object) == "string" then
				return String .. Object
			elseif type(Object) == "table" then
				return String .. tostring(_(Object))
			else
				return String .. tostring(Object)
			end
		end,
		
		GetLength = function(String) return #String end,
		
		ToString = tostring
	},
	
	number = setmetatable({
		--Miscellaneous functions
		Absolute = math_abs,
		
		Ceiling = math_ceil,
		
		Clamp = function(Number, LowerLimit, UpperLimit)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.Clamp", LowerLimit, "number", UpperLimit, "nil, number") end
			if not UpperLimit then LowerLimit, UpperLimit = 1, LowerLimit end
			if Number < LowerLimit then return LowerLimit end
			if Number > UpperLimit then return UpperLimit end
			return Number
		end,
		
		Floor = math_floor,
		
		FractionalPart = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.FractionalPart", Number, "number") end
			return Number >= 0 and Number % 1 or Number % -1
		end,
		
		FromCharacterCode = string.char,
		
		IntegralPart = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IntegralPart", Number, "number") end
			return Number - (Number > 0 and Number % 1 or Number % -1)
		end,
		
		Log = function(Number, Base)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.Log", Number, "number") end
			return Base and math_log(Number) / math_log(Base) or math_log10(Number)
		end,
		
		Log10 = math_log10,
		
		LogE = math_log,
		
		RandomSeed = math.randomseed,
		
		Root = function(Number, Root)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.Root", Number, "number", Root, "number") end
			return Number ^ (1 / Root)
		end,
		
		Round = function(Number, Precision)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.Round", Number, "number", Precision, "nil, integer") end
			local Shift = 10 ^ (Precision or 0)
			return math_floor(Number * Shift + 0.5) / Shift
		end,
		
		Sign = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.Sign", Number, "number") end
			return Number > 0 and 1 or Number < 0 and -1 or 0
		end,
		
		TimeElapsed = function(TickTime) --Returns tick() - number; use by doing _(tick()):TimeElapsed()
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.TimeElapsed", TickTime, "number") end
			return tick() - TickTime
		end,
		
		--Trigonometric functions
		ArcCosine = math.acos,
		
		ArcSine = math.asin,
		
		ArcTangent = function(Number, Adjacent)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.ArcTangent", Number, "number", Adjacent, "nil, number") end
			return Adjacent and math_atan2(Number, Adjacent) or math_atan(Number)
		end,
		
		Cosine = math.cos,
		
		Sine = math.sin,
		
		HyperbolicArcCosine = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.HyperbolicArcCosine", Number, "number") end
			return math_log(Number + (Number * Number - 1) ^ 0.5)
		end,
		
		HyperbolicArcSine = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.HyperbolicArcSine", Number, "number") end
			return Number == -math_huge and Number or math_log(Number + (Number * Number + 1) ^ 0.5)
		end,
		
		HyperbolicArcTangent = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.HyperbolicArcTangent", Number, "number") end
			return math_log((1 + Number) / (1 - Number)) * 0.5
		end,
		
		HyperbolicCosine = math.cosh,
		
		HyperbolicSine = math.sinh,
		
		HyperbolicTangent = math.tanh,
		
		Tangent = math.tan,
		
		--Type-check functions
		IsContentID = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsContentID", Number, "integer") end
			return ProxyMethods.string.IsContentURL("rbxassetid://" .. Number)
		end,
		
		IsEven = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsEven", Number, "number") end
			return Number % 2 == 0
		end,
		
		IsFinite = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsFinite", Number, "number") end
			local String = tostring(math_abs(Number))
			return String ~= "1.#QNAN" and String ~= "1.#INF"
		end,
		
		IsInteger = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsInteger", Number, "number") end
			return Number % 1 == 0
		end,
		
		IsNaN = function(Number)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsNaN", Number, "number") end
			return Number ~= Number
		end,
		
		IsStringEqual = function(Number, OtherNumber)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsStringEqual", Number, "number", OtherNumber, "number, string") end
			return tostring(Number) == (type(OtherNumber) == "string" and OtherNumber or tostring(OtherNumber))
		end,
		
		IsWithinRange = function(Number, Minimum, Maximum)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsWithinRange", Number, "number", Minimum, "number", Maximum, "number") end
			return Number >= Minimum and Number <= Maximum
		end,
		
		IsWithinTolerance = function(Number, BaseLine, Tolerance)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Number.IsWithinTolerance", Number, "number", BaseLine, "number", Tolerance, "number") end
			return BaseLine >= Number - Tolerance and BaseLine <= Number + Tolerance
		end,
		
		--Conversion functions
		ToBoolean = function(Number)
			return Number ~= 0
		end,
		
		ToDegrees = math.deg,
		
		ToRadians = math.rad,
		
		--Metamethods
		Concatenate = function(Number, Object)
			local Type = type(Object)
			if Type == "number" or Type == "string" then
				return tonumber(Number .. Object)
			elseif Type == "boolean" then
				return tonumber(Number .. ProxyMethods.boolean.ToNumber(Object))
			else
				return Number .. tonumber(Object)
			end
		end,
		
		GetLength = function(Number) return #tostring(Number) end,
		
		ToString = tostring
	}, {__index = math}),
	
	boolean = {
		ToNumber = function(Boolean)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Boolean.ToNumber", Boolean, "boolean") end
			return Boolean and 1 or 0
		end,
		
		--Metamethods
		Add = function(Boolean, Object)
			if type(Object) == "boolean" then
				return Boolean or Object --Logical OR (+)
			else
				return Boolean + Object
			end
		end,
		
		Multiply = function(Boolean, Object)
			if type(Object) == "boolean" then
				return Boolean and Object --Logical AND (*)
			else
				return Boolean * Object
			end
		end,
		
		Negate = function(Boolean)
			return not Boolean --Logical NOT (-)
		end,
		
		Power = function(Boolean, Object)
			if type(Object) == "boolean" then
				return Boolean ~= Object --Logical XOR (^)
			else
				return Boolean ^ Object
			end
		end,
		
		ToString = tostring
	},
	
	table = setmetatable({
		--Non-mutative methods
		Chunk = function(Table, ChunkSize)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Chunk", Table, "table", ChunkSize, "integer") end
			local NewTable, NewTableSize, TableIndex = {}, 0, 1
			while TableIndex <= #Table do
				local CurrentChunk = {}
				for ChunkIndex = 1, ChunkSize do
					CurrentChunk[ChunkIndex] = Table[TableIndex]; TableIndex = TableIndex + 1
				end
				NewTableSize = NewTableSize + 1; NewTable[NewTableSize] = CurrentChunk
			end
			return NewTable
		end,
		
		Clone = function(Table, ShallowClone)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Clone", Table, "table", ShallowClone, "nil, boolean") end
			local NewTable, Metatable, TableClone = {}, getmetatable(Table), ProxyMethods.table.Clone
			for Key, Value in next, Table do
				if type(Value) == "table" and not ShallowClone and Value ~= Table then
					Value = TableClone(Value)
				end
				NewTable[Key] = Value
			end
			return type(Metatable) == "table" and setmetatable(NewTable, TableClone(Metatable)) or NewTable
		end,
		
		DisableRewriting = function(Table, DeepApply, WarnRewriteAttempts)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.DisableRewriting", Table, "table", DeepApply, "nil, boolean", WarnRewriteAttempts, "nil, boolean") end
			local GetUnwrappedObject, TableDisableRewriting = InternalFunctions.GetUnwrappedObject, ProxyMethods.table.DisableRewriting
			local Iterator = function(Key1, Key2) return next(Table, GetUnwrappedObject(Key1 or Key2)) end
			if DeepApply then
				ProxyMethods.table.Map(Table, function(Object)
					return type(Object) == "table" and TableDisableRewriting(Object, true, WarnRewriteAttempts) or Object
				end)
			end
			return setmetatable({}, {
				__index = function(__, Key)
					return Key == "__iter" and Iterator or Key == "__size" and #Table or Table[Key]
				end,
				__newindex = function(__, Key, Value)
					if Table[Key] == nil then
						Table[Key] = type(Value) == "table" and DeepApply and TableDisableRewriting(Value, true) or Value
					elseif WarnRewriteAttempts then
						warn("An attempt to rewrite to a write-once only table has been ignored. (Table: 0x" .. tostring(Table):sub(-8) .. " | Key: " .. tostring(Key) .. " | Value: " .. tostring(Value) .. ")")
					end
				end,
				__metatable = "Rewriting to this table has been disabled."
			})
		end,
		
		DisableWriting = function(Table, DeepApply, WarnWriteAttempts)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.DisableWriting", Table, "table", DeepApply, "nil, boolean", WarnWriteAttempts, "nil, boolean") end
			local GetUnwrappedObject = InternalFunctions.GetUnwrappedObject
			local Iterator = function(Key1, Key2) return next(Table, GetUnwrappedObject(Key1 or Key2)) end
			if DeepApply then
				ProxyMethods.table.Map(Table, function(Object)
					return type(Object) == "table" and ProxyMethods.table.DisableWriting(Object, true, WarnWriteAttempts) or Object
				end)
			end
			return setmetatable({}, {
				__index = function(__, Key)
					return Key == "__iter" and Iterator or Key == "__size" and #Table or Table[Key]
				end,
				__newindex = function(__, Key, Value)
					if WarnWriteAttempts then
						warn("An attempt to write to a read-only table has been ignored. (Table: 0x" .. tostring(Table):sub(-8) .. " | Key: " .. tostring(Key) .. " | Value: " .. tostring(Value) .. ")")
					end
				end,
				__metatable = "Writing to this table has been disabled."
			})
		end,
		
		Every = function(Table, Callback)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Every", Table, "table", Callback, "nil, function") end
			Callback = Callback or InternalFunctions.Identity
			for Key, Value in next, Table do
				if not Callback(Value, Key) then
					return false
				end
			end
			return true
		end,
		
		Find = function(Table, Callback, DeepFind)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Find", Table, "table", Callback, "function", DeepFind, "nil, boolean") end
			local Found, FoundSize, TableFind = {}, 0, ProxyMethods.table.Find
			for Key, Value in next, Table do
				if type(Value) == "table" and DeepFind then
					local ChildFound = TableFind(Value, Callback, true)
					if ChildFound then
						FoundSize = FoundSize + 1; Found[FoundSize] = {Table = Value, Key = ChildFound.Key, Value = ChildFound.Value}
					end
				elseif Callback(Value, Key) then
					FoundSize = FoundSize + 1; Found[FoundSize] = {Table = Table, Key = Key, Value = Value}
				end
			end
			return #Found > 0 and Found or nil
		end,
		
		ForEach = function(Table, Callback, DeepApply)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.ForEach", Callback, "function", DeepApply, "nil, boolean") end
			for Key, Value in next, Table do
				if type(Value) == "table" and DeepApply then
					ProxyMethods.table.ForEach(Value, Callback, true)
				else
					Callback(Value, Key, Table)
				end
			end
			return Table
		end,
		
		GetAllChildren = function(Table, Type, DeepGet)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetAllChildren", Table, "table", Type, "anything", DeepGet, "nil, boolean") end
			local Objects, ObjectsSize = {}, 0
			local TableGetSize, TableGetAllChildren, IsType = ProxyMethods.table.GetSize, ProxyMethods.table.GetAllChildren, InternalFunctions.IsType
			for __, Object in next, Table do
				if type(Object) == "table" and DeepGet and TableGetSize(Object) > 0 then
					if not Type or Type:lower() == "table" then
						ObjectsSize = ObjectsSize + 1; Objects[ObjectsSize] = Object
					end
					for __, ChildObject in next, TableGetAllChildren(Object, Type, true) do
						ObjectsSize = ObjectsSize + 1; Objects[ObjectsSize] = ChildObject
					end
				elseif type(Type) == "table" then
					for __, Type in next, Type do
						if IsType(Object, Type) then
							ObjectsSize = ObjectsSize + 1; Objects[ObjectsSize] = Object
						end
					end
				elseif not Type or IsType(Object, Type) then
					ObjectsSize = ObjectsSize + 1; Objects[ObjectsSize] = Object
				end
			end
			return Objects
		end,
		
		GetArray = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetArray", Table, "table") end
			local ArrayPart = {}
			for Index, Value in ipairs(Table) do ArrayPart[Index] = Value end
			return ArrayPart
		end,
		
		GetArraySize = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetArraySize", Table, "table") end
			return #Table
		end,
		
		GetChildPath = function(Table, Object)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetChildPath", Table, "table") end
			local Path, PathSize = {}, 0
			for Key, Value in next, Table do
				PathSize = PathSize + 1; Path[PathSize] = Key
				if Value == Object then
					break
				elseif type(Value) == "table" then
					local Nest = ProxyMethods.table.GetChildPath(Value, Object)
					if ProxyMethods.table.GetNest(Value, Nest or "") == Object then
						ProxyMethods.table.Concatenate(Path, ProxyMethods.string.Split(Nest, "."))
						break
					end
				end
				Path[PathSize] = nil
				PathSize = PathSize - 1
			end
			return ProxyMethods.table.GetNest(Table, table_concat(Path, ".") or "") == Object and table_concat(Path, ".") or nil
		end,
		
		GetHash = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetHash", Table, "table") end
			local HashPart, ArrayIndices = {}, {}
			for Index in ipairs(Table) do ArrayIndices[Index] = true end
			for Key, Value in next, Table do
				if not ArrayIndices[Key] then HashPart[Key] = Value end
			end
			return HashPart
		end,
		
		GetHashSize = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetHashSize", Table, "table") end
			local TableSize = 0
			for __ in next, Table do TableSize = TableSize + 1 end
			return TableSize - #Table
		end,
		
		GetKeys = function(Table, NumericKeysOnly)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetKeys", Table, "table", NumericKeysOnly, "nil, boolean") end
			local Keys, KeysSize = {}, 0
			for Key, Value in next, Table do
				if not NumericKeysOnly or type(Key) == "number" then
					KeysSize = KeysSize + 1; Keys[KeysSize] = Key
				end
			end
			return Keys
		end,
		
		GetNest = function(Table, Path)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetNest", Table, "table", Path, "string") end
			local LastLevel = Table
			for Level in Path:gmatch("%.-[^%.]+") do
				local Level = Level:gsub("^%.", "")
				--if not pcall(ProtectedCallHelpers.Get, LastLevel, Level) then return nil end
				if LastLevel[Level] ~= nil then
					LastLevel = LastLevel[Level]
				elseif type(tonumber(Level)) == "number" and LastLevel[tonumber(Level)] ~= nil then
					LastLevel = LastLevel[tonumber(Level)]
				end
			end
			return LastLevel ~= Table and LastLevel or nil
		end,
		
		GetOriginChildTable = function(Table, Object)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetOriginChildTale", Table, "table") end
			for __, ChildTable in next, ProxyMethods.table.GetAllChildren(Table, "Table", true) do
				for __, Value in next, ChildTable do
					if Value == Object then return ChildTable end
				end
			end
			return nil
		end,
		
		GetValues = function(Table, NumericKeysOnly)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.GetValues", Table, "table", NumericKeysOnly, "nil, boolean") end
			local Values, ValuesSize = {}, 0
			for Key, Value in next, Table do
				if not NumericKeysOnly or type(Key) == "number" then
					ValuesSize = ValuesSize + 1; Values[ValuesSize] = Value
				end
			end
			return Values
		end,
		
		HasArray = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.HasArray", Table, "table") end
			return #Table > 0
		end,
		
		HasHash = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.HasHash", Table, "table") end
			local TotalSize = 0
			for __ in next, Table do TotalSize = TotalSize + 1 end
			return TotalSize > 0 and TotalSize > #Table
		end,
		
		IndexOf = function(Table, Object, MinimumIndex)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.IndexOf", Table, "table", Object, "anything", MinimumIndex, "nil, integer") end
			if MinimumIndex then
				local Keys, Values, MinimumIndex, PassedMinimumIndex = ProxyMethods.table.GetKeys(Table), ProxyMethods.table.GetValues(Table), type(MinimumIndex) == "number" and MinimumIndex < 1 and 1 or MinimumIndex
				for Index, Value in next, Values do
					if not PassedMinimumIndex and Keys[Index] == MinimumIndex then PassedMinimumIndex = true end
					if Value == Object and PassedMinimumIndex then
						return Keys[Index]
					end
				end
				return nil
			else
				return ProxyMethods.table.MatchPartner(Table, "Key", Object)
			end
		end,
		
		Intersect = function(Table, OtherTable)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Intersect", Table, "table", OtherTable, "table") end
			local Intersection = {}
			for Key, Value in next, Table do
				if OtherTable[Key] == Value then Intersection[Key] = Value end
			end
			return Intersection
		end,
		
		Join = function(Table, Delimiter, UseRBXunderscoreToString)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Join", Table, "table", Delimiter, "nil, string, number", UseRBXunderscoreToString, "nil, boolean") end
			local String, StringSize, Delimiter = {}, 0, (Delimiter or "") .. ""
			for __, Value in next, Table do
				StringSize = StringSize + 1; String[StringSize] = tostring(UseRBXunderscoreToString and _(Value) or Value) .. Delimiter
			end
			return (table_concat(String):gsub(ProxyMethods.string.EscapeRegularExpression(Delimiter) .. "$", ""))
		end,
		
		LastIndexOf = function(Table, Object, MaximumIndex)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.LastIndexOf", Table, "table", Object, "anything", MaximumIndex, "nil, integer") end
			MaximumIndex = MaximumIndex and MaximumIndex < #Table and MaximumIndex or #Table
			local Keys, Values, PassedMaximumIndex = ProxyMethods.table.Reverse(ProxyMethods.table.GetKeys(Table)), ProxyMethods.table.Reverse(ProxyMethods.table.GetValues(Table))
			for Index, Value in next, Values do
				if MaximumIndex then
					if not PassedMaximumIndex and Keys[Index] == MaximumIndex then PassedMaximumIndex = true end
					if Value == Object and PassedMaximumIndex then
						return Keys[Index]
					end
				elseif not MaximumIndex and Value == Object then
					return Keys[Index]
				end
			end
			return nil
		end,
		
		Match = function(Table, Type, Object, CaseInsensitive, PartialMatch)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Match", Table, "table", Type, "string", Object, "object", CaseInsensitive, "nil, boolean", PartialMatch, "nil, boolean") end
			local TableEquals = ProxyMethods.table.Equals
			for Key, Value in next, Table do
				if Type == "Key" then
					if not PartialMatch or type(Object) ~= "string" or type(Key) ~= "string" then
						if type(Key) == "table" and TableEquals(Key, Object) or Key == Object then
							return Key
						end
					else
						if CaseInsensitive then
							if Key:lower():find(Object:lower()) then
								return Key
							end
						elseif Key:find(Object) then
							return Key
						end
					end
				elseif Type == "Value" then
					if not PartialMatch or type(Object) ~= "string" or type(Value) ~= "string" then
						if type(Value) == "table" and TableEquals(Value, Object) or Value == Object then
							return Value
						end
					else
						if CaseInsensitive then
							if Value:lower():find(Object:lower()) then
								return Value
							end
						elseif Value:find(Object) then
							return Value
						end
					end
				end
			end
			return nil
		end,
		
		MatchPartner = function(Table, Type, Object, CaseInsensitive, PartialMatch)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.MatchPartner", Table, "table", Type, "string", Object, "object", CaseInsensitive, "nil, boolean", PartialMatch, "nil, boolean") end
			local TableEquals = ProxyMethods.table.Equals
			for Key, Value in next, Table do
				if Type == "Key" then
					if not PartialMatch or type(Object) ~= "string" or type(Value) ~= "string" then
						if type(Value) == "table" and TableEquals(Value, Object) or Value == Object then
							return Key
						end
					else
						if CaseInsensitive then
							if Value:lower():find(Object:lower()) then
								return Key
							end
						elseif Value:find(Object) then
							return Key
						end
					end
				elseif Type == "Value" then
					if not PartialMatch or type(Object) ~= "string" or type(Key) ~= "string" then
						if type(Key) == "table" and TableEquals(Key, Object) or Key == Object then
							return Value
						end
					else
						if CaseInsensitive then
							if Key:lower():find(Object:lower()) then
								return Value
							end
						elseif Key:find(Object) then
							return Value
						end
					end
				end
			end
			return nil
		end,
		
		Reduce = function(Table, Callback, InitialValue)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Reduce", Table, "table", Callback, "function") end
			local AccumulatedValue = InitialValue or Storage.Constant.EmptyAccumulativeObjects[type(Table[1])]
			for Index, Value in ipairs(Table) do
				AccumulatedValue = Callback(AccumulatedValue, Value, Index)
			end
			return AccumulatedValue
		end,
		
		ReduceRight = function(Table, Callback, InitialValue)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.ReduceRight", Table, "table", Callback, "function") end
			local AccumulatedValue = InitialValue or Storage.Constant.EmptyAccumulativeObjects[type(Table[#Table])]
			for Index, Value in ipairs(ProxyMethods.table.Reverse(Table)) do
				AccumulatedValue = Callback(AccumulatedValue, Value, #Table - Index + 1)
			end
			return AccumulatedValue
		end,
		
		Repeat = function(Table, Amount)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Repeat", Table, "table", Amount, "nil, integer") end
			local Repeated, RepeatedSize = {}, 0
			for Index = 1, Amount or 2 do
				for Index = 1, #Table do
					RepeatedSize = RepeatedSize + 1; Repeated[RepeatedSize] = Table[Index]
				end
			end
			return Repeated
		end,
		
		Slice = function(Table, ...) --Rewrite as standalone
			return ProxyMethods.table.Splice(ProxyMethods.table.Clone(Table), ...)
		end,
		
		Some = function(Table, Callback)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Some", Table, "table", Callback, "nil, function") end
			Callback = Callback or InternalFunctions.Identity
			for Key, Value in next, Table do
				if Callback(Value, Key) then return true end
			end
			return false
		end,
		
		ToKeyedChildrenTable = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.ToKeyedChildrenTable", Table, "table") end
			local NewTable, NewTableSize = {}, 0
			for Index, Instance in next, Table do
				if pcall(ProtectedCallHelpers.Get, Instance, "Name") then
					NewTable[Instance.Name] = Instance
				else
					NewTableSize = NewTableSize + 1; NewTable[NewTableSize] = Instance
				end
			end
			return NewTable
		end,
		
		TraverseAllChildTables = function(Table) --for ChildTable, Pair = {Key = a, Value = b} in TraverseAllChildTables(Table) do
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.TraverseAllChildTables", Table, "table") end
			local AllTables, TableIndexOf = ProxyMethods.table.GetAllChildren(Table, "Table", true), ProxyMethods.table.IndexOf
			return function(ChildTable, Pair)
				ChildTable, Pair = ChildTable or Table, Pair or {}
				print("We are given:", ChildTable, Pair.Key, Pair.Value)
				if next(ChildTable, Pair.Key) == nil then
					ChildTable = select(2, next(AllTables, TableIndexOf(AllTables, ChildTable)))
					if ChildTable then
						Pair.Key, Pair.Value = next(ChildTable)
					else
						--Pair.Key, Pair.Value = nil, nil
						return nil
					end
				else
					Pair.Key, Pair.Value = next(ChildTable, Pair.Key)
				end
				print("Returning:", ChildTable, Pair.Key, Pair.Value)
				return ChildTable, Pair
			end
		end,
		
		Union = function(Table, OtherTable)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Union", Table, "table", OtherTable, "table") end
			local Union = ProxyMethods.table.Clone(Table, true)
			for Key, Value in next, OtherTable do
				if Union[Key] == nil then Union[Key] = Value end
			end
			return Union
		end,
		
		Unpack = function(Table, ArrayBegin, ArrayEnd) --Include unpack(table, ...) functionalities
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Unpack", Table, "table") end
			local Objects, ObjectsSize = {}, 0
			for __, Value in next, Table do
				ObjectsSize = ObjectsSize + 1; Objects[ObjectsSize] = Value
			end
			return unpack(Objects, 1, ObjectsSize)
		end,
		
		UnpackArray = unpack, --Herp derp
		
		UnpackHash = function(Table) --I dunno why you'd think this would be a good idea
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.UnpackHash", Table, "table") end
			local Objects, ObjectsSize, ArrayIndices = {}, 0, {}
			for Index in ipairs(Table) do ArrayIndices[Index] = true end
			for Key, Value in next, Table do
				if not ArrayIndices[Key] then
					ObjectsSize = ObjectsSize + 1; Objects[ObjectsSize] = Value
				end
			end
			return unpack(Objects, 1, ObjectsSize)
		end,
		
		--Mutative methods
		Clear = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Clear", Table, "table") end
			local Check = math_random(); Table[1] = Check
			if Table[1] == Check then
				for Key in next, Table do
					Table[Key] = nil
				end
			else --Change was intercepted by a metamethod
				for Key in next, Table do
					rawset(Table, Key, nil)
				end
			end
			Table._ = 1; Table._ = nil --Attempt to force garbage collection
			return Table
		end,
		
		ClearArray = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.ClearArray", Table, "table") end
			local Check = math_random(); Table[1] = Check
			if Table[1] == Check then
				for Index = 1, #Table do Table[Index] = nil end
			else --Change was intercepted by a metamethod
				for Index = 1, #Table do rawset(Table, Index, nil) end
			end
			return Table
		end,
		
		ClearHash = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.ClearHash", Table, "table") end
			local Check = math_random(); Table[next(Table)] = Check
			if Table[next(Table)] == Check then
				for Index = 1, #Table do Table[Index] = nil end
			else --Change was intercepted by a metamethod
				for Index = 1, #Table do rawset(Table, Index, nil) end
			end
			return Table
		end,
		
		CopyWithin = function(Table, Target, Begin, End)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.CopyWithin", Table, "table", Target, "integer", Begin, "nil, integer", End, "nil, integer") end
			if Target > #Table then return Table end
			Target, Begin, End = Target < 0 and #Table + Target or Target, Functions.Utilities.NormalizeIndexRange(#Table, Begin, End)
			for Index = Begin, End do
				Table[Target + Index - Begin] = Table[Index]
			end
			return Table
		end,
		
		CreateNest = function(Table, Path, Content, ReturnNest)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.CreateNest", Table, "table", Path, "string", Content, "anything", ReturnNest, "nil, boolean") end
			local LastLevel = Table
			for Level in Path:gmatch("%.-[^%.]+") do
				local Level, NewLevel = (Level:gsub("^%.", ""))
				if type(LastLevel[Level]) ~= "table" then
					NewLevel = {}
					LastLevel[Level] = NewLevel
				end
				LastLevel = NewLevel or LastLevel[Level]
			end
			if type(Content) == "table" then
				for Key, Value in next, Content do
					LastLevel[Key] = Value
				end
			elseif Content then
				LastLevel[#LastLevel + 1] = Content
			end
			return ReturnNest and LastLevel or Table
		end,
		
		Extend = function(Table, OtherTable, NoOverwrite)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Extend", Table, "table", OtherTable, "table", NoOverwrite, "nil, boolean") end
			for Key, Value in next, OtherTable do
				if not NoOverwrite or Table[Key] == nil then Table[Key] = OtherTable[Key] end
			end
			return Table
		end,
		
		Fill = function(Table, Object, Begin, End) --Fix this
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Fill", Table, "table", Object, "anything", Begin, "nil, integer", End, "nil, integer") end
			if Begin then
				Begin, End = Functions.Utilities.NormalizeIndexRange(#Table, Begin, End)
				for Key in ipairs(Table) do
					if Key >= Begin and Key <= End then
						rawset(Table, Key, Object)
					end
				end
			else
				for Key in next, Table do
					rawset(Table, Key, Object)
				end
			end
			return Table
		end,
		
		Filter = function(Table, Callback, DeepFilter)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Filter", Table, "table", Callback, "nil, function", DeepFilter, "nil, boolean") end
			Callback = Callback or InternalFunctions.Identity
			for Key, Value in next, Table do
				if type(Value) == "table" and DeepFilter then
					rawset(Table, Key, ProxyMethods.table.Filter(Value, Callback, true))
				elseif not Callback(Value, Key) then
					rawset(Table, Key, nil)
				end
			end
			return Table
		end,
		
		Flatten = function(Table, DeepFlatten, Overwrite) --Currently buggy
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Flatten", Table, "table", DeepFlatten, "nil, boolean", Overwrite, "nil, boolean") end
			for Key, Value in next, Table do
				if type(Value) == "table" then
					for Key, Value in next, ProxyMethods.table.Flatten(Value, Overwrite) do
						if Table[Key] ~= nil and not Overwrite then
							Table[#Table + 1] = Value
						else
							rawset(Table, Key, Value)
						end
					end
					rawset(Table, Key, nil)
				end
			end
			return Table
		end,
		
		Insert = function(Table, ...)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Insert", Table, "table") end
			table_insert(Table, ...)
			return Table
		end,
		
		LockMetatable = function(Table, Message)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.LockMetatable", Table, "table", Message, "nil, string") end
			return ProxyMethods.table.SetMetatable(Table, {__metatable = Message or "The metatable is locked"}, true)
		end,
		
		Map = function(Table, Callback, DeepMap)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Map", Table, "table", Callback, "function", DeepMap, "nil, boolean") end
			for Key, Value in next, Table do
				if type(Value) == "table" and DeepMap then
					rawset(Table, Key, ProxyMethods.table.Map(Value, Callback, true))
				else
					rawset(Table, Key, Callback(Value, Key))
				end
			end
			return Table
		end,
		
		Pop = table_remove,
		
		Push = function(Table, ...)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Push", Table, "table") end
			local Arguments, TableSize = {...}, #Table
			for Index = 1, select("#", ...) do
				TableSize = TableSize + 1; Table[TableSize] = Arguments[Index]
			end
			return Table
		end,
		
		Remove = function(Table, Key)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Remove", Table, "table") end
			table_remove(Table, type(Key) == "number" and Key or Key and ProxyMethods.table.IndexOf(Table, Key) or nil)
			return Table
		end,
		
		RemoveAll = function(Table, Object)
		
		end,
		
		RemoveIndexGaps = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.RemoveIndexGaps", Table, "table") end
			local MaxIndex, LastUsedIndex = 1, 0
			for Key in next, Table do
				if type(Key) == "number" and Key > 0 then
					if Key > MaxIndex then MaxIndex = Key end
					LastUsedIndex = LastUsedIndex + 1
					Table[LastUsedIndex] = Table[Key]
				end
			end
			for Index = LastUsedIndex + 1, MaxIndex do
				Table[Index] = nil
			end
			return Table
		end,
		
		Reverse = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Reverse", Table, "table") end
			local Values = ProxyMethods.table.GetValues(Table, true)
			for Index in ipairs(Table) do
				Table[Index] = Values[#Values - Index + 1]
			end
			return Table
		end,
		
		SetMetatable = function(Table, Metatable, ApplyMode)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.SetMetatable", Table, "table", Metatable, "table", ApplyMode, "nil, boolean") end
			local CurrentMetatable = getmetatable(Table)
			Assert("Methods.Table.SetMetatable", CurrentMetatable == nil or type(CurrentMetatable) == "table", "The table's metatable is unmodifiable!")
			return setmetatable(Table, ApplyMode and ProxyMethods.table.Concatenate(Metatable, CurrentMetatable) or (type(Metatable) == "table" and Metatable or {__metatable = Metatable}))
		end,
		
		Shift = function(Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Shift", Table, "table") end
			return table_remove(Table, 1)
		end,
		
		Sort = function(Table, Callback)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Sort", Table, "table", Callback, "nil, function") end
			table_sort(Table, Callback)
			return Table
		end,
		
		Splice = function(Table, Begin, End)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Splice", Table, "table", Begin, "integer", End, "nil, integer") end
			local RemovedChildren, RemovedChildrenSize, IndicesToRemove, IndicesToRemoveSize, EntriesRemoved, Begin, End = {}, 0, {}, 0, 0, Functions.Utilities.NormalizeIndexRange(#Table, Begin, End)
			for Index in ipairs(Table) do
				if Index < Begin or Index > End then
					IndicesToRemoveSize = IndicesToRemoveSize + 1; IndicesToRemove[IndicesToRemoveSize] = Index
				end
			end
			for __, Index in next, IndicesToRemove do
				RemovedChildrenSize = RemovedChildrenSize + 1
				RemovedChildren[RemovedChildrenSize] = table_remove(Table, Index - EntriesRemoved)
				EntriesRemoved = EntriesRemoved + 1
			end
			return RemovedChildren
		end,
		
		Unshift = function(Table, ...)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.Unshift", Table, "table") end
			local Arguments = {...}
			for Index = 1, #Arguments do
				table_insert(Table, Index, Arguments[Index])
			end
			return Table
		end,
		
		--Metamethods
		Add = function(...)
			return ProxyMethods.table.Concatenate(...)
		end,
		
		Subtract = function(Table, SubtractWith)
			return ProxyMethods.table.Slice(Table, 1, -SubtractWith - 1)
		end,
		
		Multiply = function(...)
			return ProxyMethods.table.Repeat(...)
		end,
		
		Negate = function(Table)
			return ProxyMethods.table.Reverse(ProxyMethods.table.Clone(Table, true))
		end,
		
		Concatenate = function(Table, Object, Overwrite, OverwriteNumericIndices)
			Table = ProxyMethods.table.Clone(Table, true)
			if type(Object) == "table" then
				local TableSize = #Table
				for Key, Value in next, Object do
					if type(Key) == "number" and not OverwriteNumericIndices then
						TableSize = TableSize + 1; Table[TableSize] = Value
					elseif Table[Key] == nil or Overwrite then
						Table[Key] = Value
					end
				end
			else
				Table[#Table + 1] = Object
			end
			return Table
		end,
		
		Equals = function(Table, OtherTable, IgnoreNumericIndices)
			if type(OtherTable) ~= "table" or ProxyMethods.table.GetSize(Table) ~= ProxyMethods.table.GetSize(OtherTable) then return false end
			local IndexedComparison = {{}, {}}
			for Key, Value in next, Table do
				if type(Key) == "number" and IgnoreNumericIndices then
					local IndexedTable = IndexedComparison[1]
					IndexedTable[#IndexedTable + 1] = Value
				elseif OtherTable[Key] ~= Value then
					return false
				end
			end
			for Key, Value in next, OtherTable do
				if type(Key) == "number" and IgnoreNumericIndices then
					local IndexedTable = IndexedComparison[2]
					IndexedTable[#IndexedTable + 1] = Value
				elseif Table[Key] ~= Value then
					return false
				end
			end
			if #IndexedComparison[1] ~= #IndexedComparison[2] then return false end
			while #IndexedComparison[1] > 0 do
				for Index, Value in next, IndexedComparison[2] do
					if Value == IndexedComparison[1][1] then
						table_remove(IndexedComparison[1], 1)
						table_remove(IndexedComparison[2], Index)
						break
					end
				end
			end
			return true
		end,
		
		GetSize = function(Table)
			local Size = 0
			for __ in next, Table do Size = Size + 1 end
			return Size
		end,
		
		ToString = function(Table, Separator, Begin, End)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Table.ToString", Table, "table", Separator, "nil, string, number", Begin, "nil, integer", End, "nil, integer") end
			local String, StringSize = {}, 0
			for Key, Value in next, Table do
				if Key == End then
					break
				elseif not Begin or Key == Begin then
					Value = tostring(_(Value))
					StringSize = StringSize + 1; String[StringSize] = (type(Key) == "number" and Value or tostring(_(Key)) .. " = " .. Value) .. (Separator or ", ")
				end
			end
			return (Separator and "" or "Table[0x" .. tostring(Table):sub(-8) .. "]{") .. table_concat(String):gsub((Separator or ", ") .. "$", "") .. (Separator and "" or "}")
		end
	}, {__index = table}),
	
	["function"] = {
		BindToEnvironment = function(Function, Table)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.BindToEnvironment", Function, "function", Table, "table") end
			local Environment = getfenv(Function)
			for Key, Value in next, Table do Environment[Key] = Value end
			return Function
		end,
		
		Chain = function(...)
			if Configurations.AssertArgumentTypes then Assert.ExpectEveryArgumentType("Methods.Function.Chain", "function", ...) end
			local Arguments = {...}
			return function(...)
				local Returned, ReturnedSize = {}, 0
				for __, Function in next, Arguments do
					ReturnedSize = ReturnedSize + 1; Returned[ReturnedSize] = {Function(...)}
				end
				return unpack(Returned, 1, ReturnedSize)
			end
		end,
		
		Delay = function(Function, Timeout)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.Delay", Function, "function", Timeout, "nil, number") end
			return delay(Timeout or 0, Function)
		end,
		
		Dump = string_dump,
		
		GetDelayedCaller = function(Function, Timeout)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.GetDelayedCaller", Function, "function", Timeout, "nil, number") end
			return function(...)
				local Arguments, ArgumentCount = {...}, select("#", ...)
				return delay(Timeout or 0, function() return Function(unpack(Arguments, 1, ArgumentCount)) end)
			end
		end,
		
		GetProtectedCaller = function(Function)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.GetProtectedCaller", Function, "function") end
			return function(...) return pcall(Function, ...) end
		end,
		
		IsLuaFunction = function(Function)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.IsLuaFunction", Function, "function") end
			return select(2, pcall(string_dump, Function)) == "unable to dump given function"
		end,
		
		ProtectedCall = function(Function, ...)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.ProtectedCall", Function, "function") end
			return pcall(Function, ...)
		end,
		
		RunAsThread = function(Function, ...) --Returns coroutine
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.RunAsThread", Function, "function") end
			return ProxyMethods.thread.ResumeThread(ProxyMethods["function"].ToThread(Function), ...)
		end,
		
		RunWithEnvironment = function(Function, Environment, ...)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.RunWithEnvironment", Function, "function", Environment, "nil, table") end
			return setfenv(Function, Environment or {})(...)
		end,
		
		Spawn = spawn,
		
		ToThread = coroutine.create, --Returns coroutine
		
		ToThreadedFunction = coroutine_wrap, --Returns function
		
		--Metamethods
		ToString = setfenv(function(Function)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Function.ToString", Function, "function") end
			return (ProxyMethods["function"].IsLuaFunction(Function) and "LuaFunction[" .. NameMap[Function] or "Function[0x" .. tostring(Function):sub(-8)) .. "]" .. ProxyMethods.table.ToString(getfenv(Function)):sub(18)
		end, {NameMap = Storage.Constant.LuaFunctionNameMap})
	},
	
	thread = {
		ResumeThread = function(Thread, ...)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Thread.ResumeThread", Thread, "thread") end
			return coroutine_resume(Thread, ...) and Thread
		end,
		
		GetThreadStatus = coroutine.status,
		
		IsRunningThread = function(Thread)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Thread.IsRunningThread", Thread, "thread") end
			return coroutine_running() == Thread
		end,
		
		--Metamethods
		ToString = function(Thread)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Thread.ToString", Thread, "thread") end
			return "Thread[0x" .. tostring(Thread):sub(-8) .. "]"
		end
	},
	
	userdata = {
		Instance = {
			Sound = {
				Play = function(Sound, Asset)
					if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.Sound.Play", Sound, "Sound", Asset, "nil, asset") end
					if Asset then Sound.SoundId = Asset end
					Sound:Play()
				end,
				
				PlayAfter = function(Sound, Assets)
					if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.Sound.PlayAfter", Sound, "Sound", Assets, "asset, table") end
					local Connection; Connection = Sound.Ended:connect(type(Assets) == "table" and function()
						Assert("Methods.Userdata.Instance.Sound.PlayAfter", ProxyMethods.table.Every(Assets, ProxyMethods.string.IsContentURL), "At least one of the asset URLs is invalid.")
						Sound.SoundId = table_remove(Assets)
						Sound:Play()
						if #Assets == 0 then Connection:disconnect() end
					end or function()
						Assert("Methods.Userdata.Instance.Sound.PlayAfter", InternalFunctions.IsType(Assets, "asset"), "The asset URL \"" .. Assets .. "\" is invalid.")
						Sound.SoundId = type(Assets) == "number" and "rbxassetid://" .. Assets or Assets
						Sound:Play(); Connection:disconnect()
					end)
				end,
				
				Preload = function(Sound, WaitForLoad)
					if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.Sound.Preload", Sound, "Sound", WaitForLoad, "nil, boolean") end
					Services.ContentProvider[WaitForLoad and "PreloadAsync" or "Preload"](Services.ContentProvider, WaitForLoad and {Sound.SoundId} or Sound.SoundId)
					return Sound
				end
			},
			
			Clone = function(Instance, ForceClone)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.Clone", Instance, "instance", ForceClone, "nil, boolean") end
				if ForceClone then
					Instance.Archivable = true
					for __, Instance in next, ProxyMethods.userdata.Instance.GetAllChildren(Instance) do
						Instance.Archivable = true
					end
				end
				return Instance:Clone()
			end,
			
			CreateNest = function(Instance, Path, ClassName, Content, ReturnNest)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.CreateNest", Instance, "instance", Path, "string", ClassName, "string", Content, "anything", ReturnNest, "nil, boolean") end
				local LastLevel, CreateInstance = Instance, Instance.Create
				for Level in Path:gmatch("%.-[^%.]+") do
					Level = Level:gsub("^%.", "")
					LastLevel = LastLevel:FindFirstChild(Level) or CreateInstance(ClassName, {Name = Level, Parent = LastLevel})
				end
				if type(Content) == "table" then
					for __, Instance in next, Content do
						Instance.Parent = LastLevel
					end
				elseif Content then
					Content.Parent = LastLevel
				end
				return ReturnNest and LastLevel or Instance
			end,
			
			GetAllChildren = function(Instance, Properties, CaseInsensitive, PartialMatch, MatchAllProperties)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.GetAllChildren", Instance, "instance", Properties, "nil, table", CaseInsensitive, "nil, boolean", PartialMatch, "nil, boolean", MatchAllProperties, "nil, boolean") end
				local Instances, InstancesSize, Children, InstanceGetAllChildren, StringContains, TableMatch, TableGetSize, TableClone, TableIndexOf, GetProperty = {}, 0, Instance:GetChildren(), ProxyMethods.userdata.Instance.GetAllChildren, ProxyMethods.string.Contains, ProxyMethods.table.Match, ProxyMethods.table.GetSize, ProxyMethods.table.Clone, ProxyMethods.table.IndexOf, ProtectedCallHelpers.Get
				for Index = 1, #Children do
					local Instance = Children[Index]
					if pcall(Instance.GetChildren, Instance) and #Instance:GetChildren() > 0 then
						for __, Instance in next, InstanceGetAllChildren(Instance, Properties, CaseInsensitive, PartialMatch, MatchAllProperties) do
							InstancesSize = InstancesSize + 1; Instances[InstancesSize] = Instance
						end
					end
					if Properties then
						local MatchedProperties = {}
						for Property, Value in next, Properties do
							if pcall(GetProperty, Instance, Property) then
								for __, Value in next, type(Value) == "table" and Value or {Value} do
									if PartialMatch and StringContains(tostring(Instance[Property]), Value, CaseInsensitive) or Instance[Property] == Value then
										MatchedProperties[Property] = Value
										if not TableMatch(Instances, "Value", Instance) then
											InstancesSize = InstancesSize + 1; Instances[InstancesSize] = Instance
										end
										break
									end
								end
							end
						end
						if MatchAllProperties and TableGetSize(MatchedProperties) > 0 then
							local Properties = TableClone(Properties)
							for Property, Value in next, MatchedProperties do
								local Match = type(Properties[Property]) == "table" and TableMatch(Properties[Property], "Value", Value) or Properties[Property]
								Properties[Property] = not Match and Properties[Property] or Match ~= nil and nil
							end
							if TableGetSize(Properties) > 0 then
								table_remove(Instances, TableIndexOf(Instances, Instance))
							end
						end
					else
						InstancesSize = InstancesSize + 1; Instances[InstancesSize] = Instance
					end
				end
				return Instances
			end,
			
			GetAllMembers = function(Instance, Type, NoCache)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.GetAllMembers", Instance, "instance", Type, "string") end
				local Entries, EntriesSize, TypeMembers = {}, 0, Storage.Constant.Instance["All" .. Type]
				if TypeMembers then
					local ClassName, PersistentInstanceStorage, InstanceHasProperty = Instance.ClassName, Storage.Persistent.Instance, ProxyMethods.userdata.Instance.HasProperty
					local Cache = PersistentInstanceStorage[ClassName]
					if not Cache then
						Cache = {}; PersistentInstanceStorage[ClassName] = Cache
					elseif not NoCache and Cache[Type] then
						--print("Cache of", Type, "for", ClassName, "found!")
						return Cache[Type]
					end
					if Type == "Classes" then
						for Index = 1, TypeMembers.__size do --#TypeMembers
							local Name = TypeMembers[Index]
							if Instance:IsA(Name) then
								EntriesSize = EntriesSize + 1; Entries[EntriesSize] = Name
							end
						end
					elseif Type == "Properties" then
						for Index = 1, TypeMembers.__size do --#TypeMembers
							local Name = TypeMembers[Index]
							if InstanceHasProperty(Instance, Name) then
								EntriesSize = EntriesSize + 1; Entries[EntriesSize] = Name
							end
						end
					else
						local GetMember = ProtectedCallHelpers.Get
						for Index = 1, TypeMembers.__size do --#TypeMembers
							local Name = TypeMembers[Index]
							if pcall(GetMember, Instance, Name) then
								EntriesSize = EntriesSize + 1; Entries[EntriesSize] = Name
							end
						end
					end
					Cache[Type] = Entries
				end
				return Entries
			end,
			
			GetNest = function(Instance, Path)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.GetNest", Instance, "instance", Path, "string") end
				local LastLevel = Instance
				for Level in Path:gmatch("%.-[^%.]+") do
					local Level = Level:gsub("^%.", "")
					if not LastLevel:FindFirstChild(Level) then return nil end
					LastLevel = LastLevel:FindFirstChild(Level)
				end
				return LastLevel
			end,
			
			HasProperty = function(Instance, Property)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.HasProperty", Instance, "instance", Property, "string") end
				return select(2, pcall(ProtectedCallHelpers.SetSelf, Instance, Property)) ~= Property .. " is not a valid member of " .. Instance.ClassName
			end,
			
			IsCreatable = function(Instance)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.IsCreatable", Instance, "instance") end
				return (pcall(NewInstance, Instance.ClassName))
			end,
			
			IsPropertyReadOnly = setfenv(function(Instance, Property, NoCache)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.IsPropertyReadOnly", Instance, "instance", Property, "string") end
				Assert("Methods.Userdata.Instance.IsPropertyReadOnly", ProxyMethods.userdata.Instance.HasProperty(Instance, Property), "\"" .. Property .. "\" is not a valid property of class \"" .. Instance.ClassName .. "\"!")
				local Cache = PersistentInstanceStorage.PropertyWritabilityMap[Instance.ClassName]
				if not Cache then
					Cache = {}; PersistentInstanceStorage.PropertyWritabilityMap[Instance.ClassName] = Cache
				elseif not NoCache and Cache[Property] ~= nil then
					--print("Cache found!")
					return not Cache[Property]
				end
				if pcall(ProtectedCallHelpers.Get, Instance, Property) then
					local IsWritable = Property == "Parent" or pcall(ProtectedCallHelpers.SetSelf, Instance, Property) or pcall(ProtectedCallHelpers.Set, DummyInstances[Instance.ClassName] or Instance, Property, Instance[Property])
					Cache[Property] = IsWritable; return not IsWritable
				end
				return nil
			end, {PersistentInstanceStorage = Storage.Persistent.Instance, DummyInstances = Storage.Constant.Userdata.DummyObjects.Instances}),
			
			RemoveAllChildren = setfenv(function(...)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.RemoveAllChildren", ({...})[1], "instance") end
				ProxyMethods.table.ForEach(ProxyMethods.userdata.Instance.GetAllChildren(...), ProtectedDestroy)
			end, {ProtectedDestroy = function(Instance) pcall(game.Destroy, Instance) end}),
			
			Serialize = setfenv(function(Instance, IncludeChildren, ReturnAsTable, Root)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.Serialize", Instance, "instance", IncludeChildren, "nil, boolean", ReturnAsTable, "nil, boolean", Root, "nil, instance") end
				Assert("Methods.Userdata.Instance.Serialize", pcall(NewInstance, Instance.ClassName), "The instance \"" .. Instance.Name .. "\" of class \"" .. Instance.ClassName .. "\" is not creatable!")
				Instance.Archivable = true; Instance = Instance:Clone(); if Instance.ClassName == "Model" then Instance:MakeJoints() end --Clone root before serialization to avoid unwanted modifications on original objects
				local Children = IncludeChildren and Instance:GetChildren() or nil; if not Root then Root = Instance end
				local Properties, Output = ProxyMethods.userdata.Instance.GetAllMembers(Instance, "Properties"), {ClassName = Instance.ClassName, __children = Children} --ClassName won't be serialized because it is read-only, so we have to put it in manually
				local Processor, IsInstancePropertyReadOnly, Warn, Helpers = Processor, ProxyMethods.userdata.Instance.IsPropertyReadOnly, Log.Warn, {
					TableIndexOf = ProxyMethods.table.IndexOf,
					UserdataToString = ProxyMethods.userdata.ToString
				}
				for Index = 1, #Properties do
					local MemberName = Properties[Index]
					if IsInstancePropertyReadOnly(Instance, MemberName, true) == false then
						local Successful, Error = pcall(Processor, Output, Instance, MemberName, Root, IncludeChildren and Children, Helpers)
						if not Successful then
							Warn("Methods.Userdata.Instance.Serialize", "Unable to serialize property \"" .. MemberName .. "\" for instance \"" .. Instance.Name .. "\" of class \"" .. Instance.ClassName .. "\": " .. Error)
						end
					end
				end
				if IncludeChildren and #Children > 0 then
					local SerializeInstance = ProxyMethods.userdata.Instance.Serialize
					for Index = 1, #Children do
						local Child = Children[Index]
						if pcall(NewInstance, Child.ClassName) then
							Children[Index] = SerializeInstance(Child, true, true, Root)
						end
					end
				else
					Output.__children = nil
				end
				if ReturnAsTable then
					return Output
				else
					local Successful, Encoded = pcall(Services.HttpService.JSONEncode, Services.HttpService, Output)
					if Successful then
						return Encoded
					else
						Warn("Methods.Userdata.Instance.Serialize", "HttpService.JSONEncode has failed to encode the serialized data. Using RbxUtility.EncodeJSON instead.")
						return Libraries.RbxUtility.EncodeJSON(Output)
					end
				end
				--return ReturnAsTable and Output or Libraries.RbxUtility.EncodeJSON(Output)--Services.HttpService:JSONEncode(Output)
			end, {
				Processor = setfenv(function(Output, Instance, MemberName, Root, Children, Helpers)
					local Member = Instance[MemberName]; local MemberType = type(Member)
					if MemberType == "userdata" then
						if pcall(InstanceTypeTest, Member) then
							local MemberParent = Member.Parent
							if MemberParent == Instance and Children then
								Output[MemberName] = "__children$$" .. Helpers.TableIndexOf(Children, Member)
							else
								--print("Serializing", MemberName, "|", Member:GetFullName():sub(MemberParent == Root and #Root.Name + 2 or #Member.Name + 3), "|", MemberParent)
								Output[MemberName] = "__return$$" .. (MemberParent == Root and "!" or "") .. (MemberParent and Member:GetFullName():sub(MemberParent == Root and #Root.Name + 2 or #Member.Name + 3) or "")
							end
						else
							local UserdataString = Helpers.UserdataToString(Member)
							local OpeningBracketIndex = UserdataString:find("%[")
							Output[MemberName] = UserdataString:sub(1, OpeningBracketIndex - 1) .. "$$" .. UserdataString:sub(OpeningBracketIndex + 1, -2)
						end
					else
						Output[MemberName] = Member
					end
				end, {InstanceTypeTest = Storage.Constant.Userdata.TypeTests.Instance})
			}),
			
			SetProperties = function(Instance, Properties)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.SetProperties", Instance, "instance", Properties, "table") end
				local SetProperty, IsInstancePropertyReadOnly = ProtectedCallHelpers.Set, ProxyMethods.userdata.Instance.IsPropertyReadOnly
				for Property, Value in next, Properties do
					pcall(SetProperty, Instance, Property, Value)
				end
				return Instance
			end,
			
			Unserialize = setfenv(function(Input, Parent, Links, IsDescendant) --Grouped with instance methods for ease of remembering
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.Unserialize", Input, "string, table", Parent, "nil, Instance", Links, "nil, table", IsDescendant, "nil, boolean") end
				local Decoded = type(Input) == "string" and --[[Libraries.RbxUtility.DecodeJSON(Input)]]Services.HttpService:JSONDecode(Input) or Input
				local ClassName = Decoded.ClassName; Decoded.ClassName = nil
				local Instance, Children = NewInstance(ClassName), Decoded.__children
				local Processor, Warn, Helpers = Processor, Log.Warn
				if not IsDescendant then Links = {} end
				if Children then
					local UnserializeInstance = ProxyMethods.userdata.Instance.Unserialize
					for Index = 1, #Children do
						Children[Index] = UnserializeInstance(Children[Index], Instance, Links, true)
					end
					Decoded.__children = nil
				end
				for MemberName, Member in next, Decoded do
					local Successful, Error = pcall(Processor, Instance, Member, MemberName, Children, Links)
					if not Successful then
						Warn("Methods.Userdata.Instance.Unserialize", "Unable to set property \"" .. MemberName .. "\" for instance \"" .. Decoded.Name .. "\" of class \"" .. ClassName .. "\": " .. Error)
					end
				end
				if not IsDescendant then
					local Successful, Error = pcall(LinksProcessor, Instance, Links)
					if not Successful then
						Warn("Methods.Userdata.Instance.Unserialize", "An error has occurred while linking properties for instance \"" .. Decoded.Name .. "\" of class \"" .. ClassName .. "\": " .. Error)
					end
				end
				Instance.Parent = Parent; pcall(ProtectedCallHelpers.CallMethod, Instance, "MakeJoints")
				return Instance
			end, {
				Processor = setfenv(function(Instance, Member, MemberName, Children, Links)
					if type(Member) == "string" and Member:find("%$%$") then
						local SeparatorIndex = Member:find("%$%$"); local MemberIndex = SeparatorIndex + 2
						if Member:sub(1, SeparatorIndex - 1) == "__children" then
							Instance[MemberName] = Children[tonumber(Member:sub(MemberIndex))]
						elseif Member:sub(1, SeparatorIndex - 1) == "__return" then
							local LinksSize = #Links
							Links[LinksSize + 1] = Instance; Links[LinksSize + 2] = MemberName; Links[LinksSize + 3] = Member:sub(MemberIndex)
						else
							Instance[MemberName] = UserdataConstantStorage.Decoders[Member:sub(1, SeparatorIndex - 1)](Member:sub(MemberIndex))
						end
					else
						Instance[MemberName] = Member
					end
				end, {UserdataConstantStorage = Storage.Constant.Userdata}),
				
				LinksProcessor = function(Instance, Links) --"!" = root, "!a" == root.a, "" = parent
					local TableGetNest = ProxyMethods.table.GetNest
					for Index = 1, #Links, 3 do
						--print(_(Links[Index], Links[Index + 1], Links[Index + 2], #Links[Index + 2]))
						local Link = Links[Index + 2]
						Links[Index][Links[Index + 1]] = Link == "!" and Instance or Link == "" and Links[Index].Parent or Link:sub(1, 1) == "!" and TableGetNest(Instance, Link:sub(2)) or TableGetNest(Instance, Link)
					end
				end
			}),
			
			WaitForChild = setfenv(function(Instance, Name, IncludeDescendants)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.WaitForChild", Instance, "instance", Name, "string", IncludeDescendants, "nil, boolean") end
				if IncludeDescendants then
					local Found = Instance:FindFirstChild(Name, true); if Found then return Found end
					local Connections, ConnectionsSize = {}, 1; local ConnectCallback = function()
						ConnectionsSize = ConnectionsSize + 1; Connections[ConnectionsSize] = Instance.Changed:connect(function(Property) if Property == "Name" and Instance.Name == Name then Found = Instance end end)
					end
					Connections[1] = Instance.DescendantAdded:connect(function(Instance)
						if pcall(ProtectedCallHelpers.Get, Instance, "Name") and Instance.Name == Name then
							Found = Instance
						else
							ConnectCallback()
						end
					end)
					for __, Instance in next, ProxyMethods.userdata.Instance.GetAllChildren(Instance) do
						pcall(ConnectCallback)
					end
					repeat wait() until Found
					ProxyMethods.table.ForEach(Connections, DisconnectConnection)
					return Found
				else
					return Instance:WaitForChild(Name)
				end
			end, {DisconnectConnection = function(Connection) Connection:disconnect() end}),
			
			--Metamethods
			GetSize = function(Instance, IncludeChildren)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Instance.GetSize", Instance, "instance", IncludeChildren, "nil, boolean") end
				return IncludeChildren and #ProxyMethods.userdata.Instance.GetAllChildren(Instance) or #Instance:GetChildren()
			end
		},
		
		Proxy = {
			Clone = function(Proxy)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Proxy.Clone", Proxy, "proxy") end
				local Metatable = getmetatable(Proxy)
				Assert("Methods.Userdata.Proxy.Clone", type(Metatable) == "table", "The proxy's metatable is a " .. type(Metatable) .. ". It must be a table!")
				local NewProxy = newproxy(true); local NewMetatable = getmetatable(NewProxy)
				for Key, Value in next, Metatable do
					NewMetatable[Key] = Value
				end
				return NewProxy
			end,
			
			SetMetatable = function(Proxy, Metatable)
				if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.Proxy.SetMetatable", Proxy, "proxy", Metatable, "table") end
				local CurrentMetatable = getmetatable(Proxy)
				Assert("Methods.Userdata.Proxy.SetMetatable", type(CurrentMetatable) == "table", "The proxy's metatable is a " .. type(CurrentMetatable) .. ". It must be a table!")
				for Key, Value in next, Metatable do
					CurrentMetatable[Key] = Value
				end
				return Proxy
			end
		},
		
		GetNest = function(...) return ProxyMethods.table.GetNest(...) end,
		
		GetUserdataType = setfenv(function(Userdata)
			if Configurations.AssertArgumentTypes then Assert.ExpectArgumentType("Methods.Userdata.GetUserdataType", Userdata, "userdata") end
			for UserdataType, Test in next, UserdataTypeTests do
				if pcall(Test, Userdata) then return UserdataType end
			end
			return "Proxy" --Assume all unknown userdata to be proxies created using newproxy
		end, {UserdataTypeTests = Storage.Constant.Userdata.TypeTests}),
		
		IsROBLOXUserdata = function(Userdata)
			return getmetatable(Userdata) == "The metatable is locked" and not InternalFunctions.IsWrappedObject(Object)
		end,
		
		--Metamethods
		ToString = setfenv(function(Userdata)
			local UserdataString, UserdataType = tostring(Userdata), ProxyMethods.userdata.GetUserdataType(Userdata)
			local OutputString = UserdataEncoders[UserdataType](Userdata)
			return (UserdataType == "Instance" and Userdata == game:FindService(pcall(ProtectedCallHelpers.Get, Userdata, "ClassName") and #Userdata.ClassName > 0 and Userdata.ClassName or pcall(game.FindService, game, UserdataString) and UserdataString or "nil") and "Service" or UserdataType) .. (#OutputString > 0 and "[" .. OutputString .. "]" or "")
		end, {UserdataEncoders = Storage.Constant.Userdata.Encoders})
	}
}, {__index = function(Self, Key) return type(Key) == "string" and rawget(Self, Key:lower()) or nil end})
setmetatable(Functions, {__index = ProxyMethods})

--Shared metamethods for proxies; required for proper invocation of comparison metamethods (see http://www.lua.org/pil/13.2.html)
local ProxySharedMetamethods = {
	__eq = function(First, Second)
		First, Second = InternalFunctions.GetUnwrappedObjects(First, Second)
		local Metamethod = InternalFunctions.GetProxyMethod(First, "Equals")
		if Metamethod then return Metamethod(First, Second) end; return First == Second
	end,
	__lt = function(First, Second)
		First, Second = InternalFunctions.GetUnwrappedObjects(First, Second)
		local Metamethod = InternalFunctions.GetProxyMethod(First, "IsLessThan")
		if Metamethod then return Metamethod(First, Second) end; return First < Second
	end,
	__le = function(First, Second)
		First, Second = InternalFunctions.GetUnwrappedObjects(First, Second)
		local Metamethod = InternalFunctions.GetProxyMethod(First, "IsLessThanOrEqualTo")
		if Metamethod then return Metamethod(First, Second) end; return First <= Second
	end,
	__metatable = "The metatable is locked"
}

--Initialize storage
Storage.Constant.DefaultConfigurations = ProxyMethods.table.Clone(Configurations) --Store default configurations
Storage.Constant = ProxyMethods.table.DisableWriting(Storage.Constant, true) --Disable writing to constant storage
Storage.Persistent = ProxyMethods.table.DisableRewriting(Storage.Persistent, true, true) --Disable rewriting to persistent storage
Storage = ProxyMethods.table.DisableWriting(Storage) --Disable writing to storage root

--Disable writing to exposed library components
Functions, ProxyMethods, Services, Libraries, Capabilities = unpack(ProxyMethods.table.Map({Functions, ProxyMethods, Services, Libraries, Capabilities}, function(Table) return ProxyMethods.table.DisableWriting(Table, true) end))

--Set the library/object wrapper entry point
_ = Functions.Create.Proxy({
	__call = setfenv(function(__, ...)
		local Arguments, ArgumentCount, Proxies = {...}, select("#", ...), {}
		local GetUnwrappedObjects, GetProxyMethod, IsType = InternalFunctions.GetUnwrappedObjects, InternalFunctions.GetProxyMethod, InternalFunctions.IsType
		for Index = 1, ArgumentCount do
			local Object = Arguments[Index]
			if Object == nil or InternalFunctions.IsWrappedObject(Object) then
				Proxies[Index] = Object
			else
				local Object, ObjectString, Type, Methods = type(Object) == "table" and not Configurations.DirectlyModifyTables and ProxyMethods.table.Clone(Object, true) or Object, tostring(Object), type(Object), setmetatable({}, {
					__index = function(Self, Key)
						local Method = GetProxyMethod(Object, Key)
						Self[Key] = Method; return Method
					end
				})
				Proxies[Index] = Functions.Create.Proxy(ProxyMethods.table.Extend({
					__index = function(__, Key)
						return Key == "__self" and Object
							or Key == "__type" and Type
							or Key == "__addr" and (Type == "table" or Type == "function" or Type == "thread") and "0x" .. ObjectString:sub(-8)
							or Key == "IsType" and IsType
							or _(
								Methods[Key]
								or (Type ~= "string" and Type ~= "table" and Type ~= "userdata") and Log.Error("Proxy <" .. Type .. ">", "Attempting to index " .. type(Key) .. " \"" .. tostring(Key) .. "\"")
								or Object[Key]
							)
					end,
					__newindex = function(__, Key, Value) Object[Key] = Value end,
					__call = function(__, ...) return _(Object(GetUnwrappedObjects(...))) end,
					__len = function()
						local Metamethod = Methods["Get" .. ((Type == "string" or Type == "number") and "Length" or "Size")]
						if Metamethod then return _(Metamethod(Object)) end; return _(#Object)
					end,
					__tostring = function()
						local Metamethod = Methods.ToString
						if Metamethod then return Metamethod(Object) end; return tostring(Object)
					end,
					__concat = function(First, Second)
						local Metamethod, First, Second = Methods.Concatenate, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First .. Second)
					end,
					__add = function(First, Second)
						local Metamethod, First, Second = Methods.Add, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First + Second)
					end,
					__sub = function(First, Second)
						local Metamethod, First, Second = Methods.Subtract, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First - Second)
					end,
					__mul = function(First, Second)
						local Metamethod, First, Second = Methods.Multiply, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First * Second)
					end,
					__div = function(First, Second)
						local Metamethod, First, Second = Methods.Divide, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First / Second)
					end,
					__mod = function(First, Second)
						local Metamethod, First, Second = Methods.Modulus, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First % Second)
					end,
					__pow = function(First, Second)
						local Metamethod, First, Second = Methods.Power, GetUnwrappedObjects(First, Second)
						if Metamethod then return _(Metamethod(First, Second)) end; return _(First ^ Second)
					end,
					__unm = function()
						local Metamethod = Methods.Negate
						if Metamethod then return _(Metamethod(Object)) end; return _(-Object)
					end,
				}, ProxySharedMetamethods))
			end
		end
		return unpack(Proxies, 1, ArgumentCount)
	end, {
		
	}),
	__index = setmetatable({
		Functions = Functions,
		Services = Services,
		Libraries = Libraries,
		Storage = Storage,
		Capabilities = Capabilities,
		Configurations = setmetatable({}, {
			__index = setmetatable({
				Reset = function(Key)
					Assert.ExpectArgumentType("Configurations.Reset", Key, "nil, string")
					if Key then
						Configurations[Key] = Storage.Constant.DefaultConfigurations[Key]
					else
						Configurations = ProxyMethods.table.Clone(Storage.Constant.DefaultConfigurations)
						Log.Warn("Configurations.Reset", "Configurations have been reset to their default values.")
					end
				end
			}, {
				__index = function(__, Key)
					Assert.ExpectArgumentType("Configurations.Get", Key, "string")
					return Configurations[Key]
				end
			}),
			__newindex = function(__, Key, Value)
				Assert.ExpectArgumentType("Configurations.Set", Key, "string")
				Configurations[Key] = Value
			end,
			__metatable = "The metatable is locked"
		})
	}, {__index = ProxyMethods}),
	__newindex = function() Log.Error(nil, "You are not allowed to make changes to the library during runtime.") end,
	__tostring = function() return "RBXunderscore Library/Object Wrapper" end,
	__len = function() return "internal-dev" end,
	__metatable = "The metatable is locked"
})

return _
