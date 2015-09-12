--RBXunderscore by dennis96411
Services, Libraries = setmetatable({}, {__index = function(Self, Name) return rawget(Self, Name) or pcall(game.GetService, game, Name) and rawget(rawset(Self, Name, game:GetService(Name)), Name) end}), setmetatable({}, {__index = function(Self, Name) return rawget(Self, Name) or rawget(rawset(Self, Name, LoadLibrary(Name)), Name) end}); for _, Instance in next, game:GetChildren() do pcall(function() return Services[Instance.ClassName] end) end
Resources, Capabilities, Events = {
	Instance = {
		AllClasses = {"Accoutrement", "AdService", "AdvancedDragger", "Animation", "AnimationController", "AnimationTrack", "AnimationTrackState", "Animator", "ArcHandles", "AssetService", "Backpack", "BackpackItem", "BadgeService", "BasePart", "BasePlayerGui", "BaseScript", "BevelMesh", "BillboardGui", "BinaryStringValue", "BindableEvent", "BindableFunction", "BlockMesh", "BodyAngularVelocity", "BodyColors", "BodyForce", "BodyGyro", "BodyMover", "BodyPosition", "BodyThrust", "BodyVelocity", "BoolValue", "BoxHandleAdornment", "BrickColorValue", "Button", "ButtonBindingWidget", "CFrameValue", "CSGDictionaryService", "CacheableContentProvider", "Camera", "ChangeHistoryService", "CharacterAppearance", "CharacterMesh", "Chat", "ChatFilter", "ClickDetector", "ClientReplicator", "Clothing", "ClusterPacketCache", "CollectionService", "Color3Value", "ConeHandleAdornment", "Configuration", "ContentFilter", "ContentProvider", "ContextActionService", "Controller", "ControllerService", "CookiesService", "CoreGui", "CoreScript", "CornerWedgePart", "CustomEvent", "CustomEventReceiver", "CylinderHandleAdornment", "CylinderMesh", "DataModel", "DataModelMesh", "DataStorePages", "DataStoreService", "Debris", "DebugSettings", "DebuggerBreakpoint", "DebuggerManager", "DebuggerWatch", "Decal", "Dialog", "DialogChoice", "DoubleConstrainedValue", "Dragger", "DynamicRotate", "Explosion", "FWService", "FaceInstance", "Feature", "FileMesh", "Fire", "Flag", "FlagStand", "FlagStandService", "FloorWire", "FlyweightService", "Folder", "ForceField", "FormFactorPart", "Frame", "FriendPages", "FriendService", "FunctionalTest", "GamePassService", "GameSettings", "GamepadService", "GenericSettings", "Geometry", "GlobalDataStore", "GlobalSettings", "Glue", "GroupService", "GuiBase", "GuiBase2d", "GuiBase3d", "GuiButton", "GuiItem", "GuiLabel", "GuiMain", "GuiObject", "GuiRoot", "GuiService", "GuidRegistryService", "HandleAdornment", "Handles", "HandlesBase", "Hat", "Hint", "Hole", "Hopper", "HopperBin", "HttpRbxApiService", "HttpService", "Humanoid", "HumanoidController", "ImageButton", "ImageHandleAdornment", "ImageLabel", "InputObject", "InsertService", "Instance", "InstancePacketCache", "IntConstrainedValue", "IntValue", "JointInstance", "JointsService", "Keyframe", "KeyframeSequence", "KeyframeSequenceProvider", "LayerCollector", "Light", "Lighting", "LineHandleAdornment", "LocalBackpack", "LocalScript", "LocalWorkspace", "LogService", "LoginService", "LuaSettings", "LuaSourceContainer", "LuaWebService", "ManualGlue", "ManualSurfaceJointInstance", "ManualWeld", "MarketplaceService", "MeshContentProvider", "Message", "Model", "ModuleScript", "Motor", "Motor6D", "MotorFeature", "Mouse", "NegateOperation", "NetworkClient", "NetworkMarker", "NetworkPeer", "NetworkReplicator", "NetworkServer", "NetworkSettings", "NonReplicatedCSGDictionaryService", "NotificationService", "NumberValue", "ObjectValue", "OneQuarterClusterPacketCacheBase", "OrderedDataStore", "PVAdornment", "PVInstance", "Pages", "Pants", "ParallelRampPart", "Part", "PartAdornment", "PartOperation", "PartOperationAsset", "ParticleEmitter", "Path", "PathfindingService", "PersonalServerService", "PhysicsPacketCache", "PhysicsService", "PhysicsSettings", "Platform", "Player", "PlayerGui", "PlayerHUD", "PlayerMouse", "PlayerScripts", "Players", "Plugin", "PluginManager", "PluginMouse", "PointLight", "PointsService", "Pose", "PrismPart", "ProfilingItem", "PyramidPart", "RayValue", "ReflectionMetadata", "ReflectionMetadataCallbacks", "ReflectionMetadataClass", "ReflectionMetadataClasses", "ReflectionMetadataEnum", "ReflectionMetadataEnumItem", "ReflectionMetadataEnums", "ReflectionMetadataEvents", "ReflectionMetadataFunctions", "ReflectionMetadataItem", "ReflectionMetadataMember", "ReflectionMetadataProperties", "ReflectionMetadataYieldFunctions", "RemoteEvent", "RemoteFunction", "RenderHooksService", "RenderSettings", "ReplicatedFirst", "ReplicatedStorage", "RightAngleRampPart", "RobloxReplicatedStorage", "RocketPropulsion", "RootInstance", "Rotate", "RotateP", "RotateV", "RunService", "RunningAverageItemDouble", "RunningAverageItemInt", "RunningAverageTimeIntervalItem", "RuntimeScriptService", "Scale9Frame", "ScreenGui", "Script", "ScriptContext", "ScriptDebugger", "ScriptInformationProvider", "ScriptService", "ScrollingFrame", "Seat", "Selection", "SelectionBox", "SelectionLasso", "SelectionPartLasso", "SelectionPointLasso", "SelectionSphere", "ServerReplicator", "ServerScriptService", "ServerStorage", "ServiceProvider", "Shirt", "ShirtGraphic", "SkateboardController", "SkateboardPlatform", "Skin", "Sky", "Smoke", "Snap", "SocialService", "SolidModelContentProvider", "Sound", "SoundService", "Sparkles", "SpatialQueryCache", "SpawnLocation", "SpawnerService", "SpecialMesh", "SphereHandleAdornment", "SpotLight", "StandardPages", "StarterGear", "StarterGui", "StarterPack", "StarterPlayer", "StarterPlayerScripts", "Stats", "StatsItem", "Status", "StringValue", "StudioTool", "SurfaceGui", "SurfaceLight", "SurfaceSelection", "TaskScheduler", "Team", "Teams", "TeleportService", "Terrain", "TerrainRegion", "TestService", "TextBox", "TextButton", "TextLabel", "TextService", "Texture", "TextureContentProvider", "TextureTrail", "TimerService", "Tool", "Toolbar", "TotalCountTimeIntervalItem", "TouchInputService", "TouchTransmitter", "TrussPart", "TweenService", "UnionOperation", "UserGameSettings", "UserInputService", "UserSettings", "Vector3Value", "VehicleController", "VehicleSeat", "VelocityMotor", "VirtualUser", "Visit", "WedgePart", "Weld", "Workspace"},
		AllProperties = {"AASamples", "AbsolutePosition", "AbsoluteSize", "AbsoluteWindowSize", "Acceleration", "AccelerometerEnabled", "AccountAge", "Active", "Adornee", "AllTutorialsDisabled", "AllowSleep", "AllowTeamChangeOnTouch", "AltCdnFailureCount", "AltCdnSuccessCount", "AlwaysOnTop", "Ambient", "AmbientReverb", "Anchored", "Angle", "Animation", "AnimationId", "Antialiasing", "AppearanceDidLoad", "Archivable", "AreAnchorsShown", "AreArbitersThrottled", "AreAssembliesShown", "AreAwakePartsHighlighted", "AreBodyTypesShown", "AreContactPointsShown", "AreHingesDetected", "AreJointCoordinatesShown", "AreMechanismsShown", "AreModelCoordsShown", "AreOwnersShown", "ArePartCoordsShown", "ArePhysicsRejectionsReported", "AreRegionsShown", "AreScriptStartsReported", "AreUnalignedPartsShown", "AreWorldCoordsShown", "AttachmentForward", "AttachmentPoint", "AttachmentPos", "AttachmentRight", "AttachmentUp", "AutoAssignable", "AutoButtonColor", "AutoColorCharacters", "AutoFRMLevel", "AutoJumpEnabled", "AutoRotate", "AutoRuns", "AutoSelectGuiEnabled", "AvailablePhysicalMemory", "Axes", "BackParamA", "BackParamB", "BackSurface", "BackSurfaceInput", "BackgroundColor", "BackgroundColor3", "BackgroundTransparency", "BaseAngle", "BaseTextureId", "BaseUrl", "BinType", "BlastPressure", "BlastRadius", "BlockMeshSize", "BodyPart", "BorderColor", "BorderColor3", "BorderSizePixel", "BottomImage", "BottomParamA", "BottomParamB", "BottomSurface", "BottomSurfaceInput", "BrickColor", "Brightness", "Browsable", "BubbleChat", "BubbleChatLifetime", "BubbleChatMaxBubbles", "C0", "C1", "CFrame", "CPU", "CameraMaxZoomDistance", "CameraMinZoomDistance", "CameraMode", "CameraOffset", "CameraSubject", "CameraType", "CanBeDropped", "CanCollide", "CanLoadCharacterAppearance", "CanSendPacketBufferLimit", "CanvasPosition", "CanvasSize", "CartoonFactor", "CdnFailureCount", "CdnResponceTime", "CdnSuccessCount", "CelestialBodiesShown", "Character", "CharacterAppearance", "CharacterAutoLoads", "ChatHistory", "ChatMode", "ChatScrollLength", "ClassName", "ClassicChat", "ClearTextOnFocus", "ClientPhysicsSendRate", "ClipsDescendants", "CollisionEnabled", "CollisionSoundEnabled", "CollisionSoundVolume", "Color", "Color3", "ColorShift_Bottom", "ColorShift_Top", "ComputerCameraMovementMode", "ComputerMovementMode", "Concurrency", "Condition", "ConstrainedValue", "ControlMode", "Controller", "ControllingHumanoid", "ConversationDistance", "CoordinateFrame", "CpuCount", "CpuSpeed", "CreatorId", "CreatorType", "CurrentAngle", "CurrentCamera", "CurrentLine", "CustomizedTeleportUI", "CycleOffset", "D", "DataComplexity", "DataComplexityLimit", "DataCost", "DataGCRate", "DataModel", "DataMtuAdjust", "DataReady", "DataSendPriority", "DataSendRate", "DebugDisableInterpolation", "DebuggingEnabled", "DefaultWaitTime", "Delta", "Deprecated", "Description", "DesiredAngle", "DestroyJointRadiusPercent", "DevCameraOcclusionMode", "DevComputerCameraMode", "DevComputerCameraMovementMode", "DevComputerMovementMode", "DevEnableMouseLock", "DevTouchCameraMode", "DevTouchCameraMovementMode", "DevTouchMovementMode", "Disabled", "DisplayDistanceType", "DistanceFactor", "DistributedGameTime", "DopplerScale", "Draggable", "Duration", "EagerBulkExecution", "EditQualityLevel", "ElapsedTime", "Elasticity", "EmptyCutoff", "EnableFRM", "EnableHeavyCompression", "EnableMouseLockOption", "Enabled", "EnforceInstanceCountLimit", "ErrorCount", "ErrorReporting", "ExperimentalPhysicsEnabled", "ExplorerImageIndex", "ExplorerOrder", "ExplosionType", "ExportMergeByMaterial", "Expression", "ExtentsOffset", "ExtraMemoryUsed", "F0", "F1", "F2", "F3", "Face", "FaceId", "Faces", "FieldOfView", "FilteringEnabled", "Focus", "FogColor", "FogEnd", "FogStart", "FollowUserId", "Font", "FontSize", "FormFactor", "FrameRateManager", "FreeMemoryMBytes", "FreeMemoryPoolMBytes", "Friction", "From", "FrontParamA", "FrontParamB", "FrontSurface", "FrontSurfaceInput", "Fullscreen", "GamepadEnabled", "GarbageCollectionFrequency", "GarbageCollectionLimit", "GcFrequency", "GcLimit", "GcPause", "GcStepMul", "GearGenreSetting", "Genre", "GeographicLatitude", "GfxCard", "GlobalShadows", "GoodbyeDialog", "Graphic", "GraphicsMode", "GridSize", "Grip", "GripForward", "GripPos", "GripRight", "GripUp", "Guest", "GuiNavigationEnabled", "GyroscopeEnabled", "HardwareMouse", "HasBuildTools", "HeadColor", "HeadsUpDisplay", "Health", "HealthDisplayDistance", "Heat", "Height", "Hit", "Hole", "HttpEnabled", "Humanoid", "Icon", "Image", "ImageColor3", "ImageRectOffset", "ImageRectSize", "ImageTransparency", "ImageUploadPromptBehavior", "InCameraGesture", "InOut", "InUse", "IncommingReplicationLag", "InitialPrompt", "Insertable", "InstanceCount", "InstanceCountLimit", "Is30FpsThrottleEnabled", "IsAggregationShown", "IsBackend", "IsDebugging", "IsEnabled", "IsFinished", "IsFmodProfilingEnabled", "IsModalDialog", "IsPaused", "IsPersonalServer", "IsPhysicsEnvironmentalThrottled", "IsPlaying", "IsProfilingEnabled", "IsQueueErrorComputed", "IsReceiveAgeShown", "IsScriptStackTracingEnabled", "IsSleepAllowed", "IsSmooth", "IsSynchronizedWithPhysics", "IsThrottledByCongestionControl", "IsThrottledByOutgoingBandwidthLimit", "IsTreeShown", "IsWindows", "JobCount", "JobId", "Jump", "KeyCode", "KeyboardEnabled", "LastCdnFailureTimeSpan", "LeftArmColor", "LeftLeg", "LeftLegColor", "LeftParamA", "LeftParamB", "LeftRight", "LeftSurface", "LeftSurfaceInput", "LegacyNamingScheme", "Length", "Lifetime", "LightEmission", "Line", "LineThickness", "LinkedSource", "LocalPlayer", "LocalSaveEnabled", "LocalTransparencyModifier", "Locked", "Loop", "Looped", "LuaRamLimit", "MachineAddress", "ManualActivationOnly", "MaskWeight", "MasterVolume", "Material", "MaxActivationDistance", "MaxCollisionSounds", "MaxDataModelSendBuffer", "MaxExtents", "MaxHealth", "MaxItems", "MaxPlayers", "MaxSpeed", "MaxThrust", "MaxTorque", "MaxValue", "MaxVelocity", "MaximumSimulationRadius", "MembershipType", "MeshCacheSize", "MeshId", "MeshType", "MidImage", "MinReportInterval", "MinValue", "Modal", "ModalEnabled", "MouseBehavior", "MouseEnabled", "MouseIconEnabled", "MouseSensitivity", "MoveDirection", "MultiLine", "Name", "NameDatabaseBytes", "NameDatabaseSize", "NameDisplayDistance", "NameOcclusion", "NetworkOwnerRate", "Neutral", "NextSelectionDown", "NextSelectionLeft", "NextSelectionRight", "NextSelectionUp", "NumPlayers", "NumRunningJobs", "NumSleepingJobs", "NumWaitingJobs", "NumberOfPlayers", "Occupant", "Offset", "Opacity", "Origin", "OsIs64Bit", "OsPlatform", "OsPlatformId", "OsVer", "OutdoorAmbient", "Outlines", "OverlayTextureId", "OverrideMouseIconEnabled", "P", "PageFaultsPerSecond", "PageFileBytes", "PantsTemplate", "ParallelPhysics", "Parent", "Part", "Part0", "Part1", "PersonalServerRank", "PhysicsEnvironmentalThrottle", "PhysicsMtuAdjust", "PhysicsReceive", "PhysicsSend", "PhysicsSendPriority", "PhysicsSendRate", "Pitch", "PixelShaderModel", "PlaceId", "PlaceVersion", "PlatformStand", "PlayOnRemove", "PlayerCount", "PlayerToHideFrom", "Point", "Port", "Position", "PreferredClientPort", "PreferredParent", "PrimaryPart", "PrintBits", "PrintEvents", "PrintFilters", "PrintInstances", "PrintPhysicsErrors", "PrintProperties", "PrintSplitMessage", "PrintStreamInstanceQuota", "PrintTouches", "Priority", "PriorityMethod", "PrivateBytes", "PrivateWorkingSetBytes", "ProcessCores", "ProcessorTime", "ProfilingWindow", "Purpose", "QualityLevel", "RAM", "Radius", "Range", "Rate", "ReceiveAge", "ReceiveRate", "Reflectance", "ReloadAssets", "RenderStreamedRegions", "ReportAbuseChatHistory", "ReportExtendedMachineConfiguration", "ReportSoundWarnings", "ReportStatURL", "ReporterType", "RequestQueueSize", "ResetPlayerGuiOnSpawn", "ResizeIncrement", "ResizeableFaces", "Resolution", "RespawnLocation", "ResponseDialog", "RightArmColor", "RightLeg", "RightLegColor", "RightParamA", "RightParamB", "RightSurface", "RightSurfaceInput", "RiseVelocity", "RobloxFailureCount", "RobloxLocked", "RobloxProductName", "RobloxRespoceTime", "RobloxSuccessCount", "RobloxVersion", "RoleSets", "RolloffScale", "RotSpeed", "RotVelocity", "Rotation", "RotationType", "SIMD", "SavedQualityLevel", "Scale", "ScaleEdgeSize", "SchedulerDutyCycle", "SchedulerRate", "Score", "Script", "ScriptsDisabled", "ScrollBarThickness", "ScrollingEnabled", "SeatPart", "SecondaryColor", "Selectable", "Selected", "SelectedCoreObject", "SelectedObject", "SelectionImageObject", "SendPacketBufferLimit", "ShadowColor", "Shadows", "Shape", "Shiny", "ShirtTemplate", "ShowActiveAnimationAsset", "ShowBoundingBoxes", "ShowDecompositionGeometry", "ShowDevelopmentGui", "ShowInterpolationpath", "ShowLegacyPlayerList", "ShowPartMovementWayPoint", "Sides", "SimulateSecondsLag", "SimulationRadius", "Sit", "Size", "SizeConstraint", "SizeInCells", "SizeOffset", "SizeRelativeOffset", "SkinColor", "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SleepAdjustMethod", "SlicePrefix", "SoftwareSound", "SoundEnabled", "SoundId", "Source", "SparkleColor", "SpecificGravity", "Specular", "Speed", "StarCount", "Status", "Steer", "StickyWheels", "StreamingEnabled", "StudsBetweenTextures", "StudsOffset", "StudsPerTileU", "StudsPerTileV", "Style", "SurfaceColor", "SurfaceColor3", "SurfaceTransparency", "SystemProductName", "Target", "TargetFilter", "TargetOffset", "TargetPoint", "TargetRadius", "TargetSurface", "TeamColor", "Teleported", "Terrain", "TestCount", "Text", "TextBounds", "TextColor", "TextColor3", "TextFits", "TextScaled", "TextStrokeColor3", "TextStrokeTransparency", "TextTransparency", "TextWrap", "TextWrapped", "TextXAlignment", "TextYAlignment", "Texture", "TextureCacheSize", "TextureId", "TextureSize", "Thickness", "ThreadAffinity", "ThreadPoolConfig", "ThreadPoolSize", "Throttle", "ThrottleAdjustTime", "ThrottledJobSleepTime", "ThrustD", "ThrustP", "TickCountPreciseOverride", "Ticket", "Time", "TimeLength", "TimeOfDay", "TimePosition", "Timeout", "To", "Tone", "ToolPunchThroughDistance", "ToolTip", "TopBottom", "TopImage", "TopParamA", "TopParamB", "TopSurface", "TopSurfaceInput", "Torque", "Torso", "TorsoColor", "TotalNumMovementWayPoint", "TotalPhysicalMemory", "TotalProcessorTime", "TouchCameraMovementMode", "TouchEnabled", "TouchMovementMode", "TouchSendRate", "TrackDataTypes", "TrackPhysicsDetails", "Transparency", "TurnD", "TurnP", "TurnSpeed", "UnitRay", "UseInstancePacketCache", "UseLuaChat", "UsePartColor", "UsePhysicsPacketCache", "UserDialog", "UserInputState", "UserInputType", "VIPServerId", "Value", "Velocity", "VelocitySpread", "Version", "VertexColor", "VertexShaderModel", "VideoCaptureEnabled", "VideoMemory", "VideoQuality", "VideoUploadPromptBehavior", "ViewSizeX", "ViewSizeY", "ViewportSize", "VirtualBytes", "Visible", "Volume", "WaitingForCharacterLogRate", "WaitingThreadsBudget", "WalkSpeed", "WalkToPart", "WalkToPoint", "WarnCount", "Weight", "WireRadius", "Workspace", "X", "Y", "ZIndex", "ZOffset"},
		AllEvents = {"Activated", "AllowedGearTypeChanged", "AncestryChanged", "AnimationPlayed", "AxisChanged", "BadgeAwarded", "BoundActionAdded", "BoundActionChanged", "BoundActionRemoved", "BreakpointAdded", "BreakpointRemoved", "BrowserWindowClosed", "Button1Down", "Button1Up", "Button2Down", "Button2Up", "ButtonChanged", "CamelCaseViolation", "Changed", "CharacterAdded", "CharacterRemoving", "Chatted", "ChildAdded", "ChildRemoved", "Click", "ClientLuaDialogRequested", "ClientPurchaseSuccess", "Climbing", "Close", "CloseLate", "ConnectionAccepted", "ConnectionFailed", "ConnectionRejected", "CoreGuiChangedSignal", "CustomStatusAdded", "CustomStatusRemoved", "DataBasicFiltered", "DataCustomFiltered", "Deactivated", "Deactivation", "DebuggerAdded", "DebuggerRemoved", "DescendantAdded", "DescendantRemoving", "Deselected", "DeviceAccelerationChanged", "DeviceGravityChanged", "DeviceRotationChanged", "DialogChoiceSelected", "DidLoop", "Died", "Disconnection", "DragBegin", "DragEnter", "DragStopped", "EncounteredBreak", "Ended", "Equipped", "Error", "ErrorMessageChanged", "EscapeKeyPressed", "Event", "EventConnected", "EventDisconnected", "FallingDown", "FinishedReplicating", "FirstPersonTransition", "FlagCaptured", "FocusLost", "Focused", "FreeFalling", "FriendRequestEvent", "FriendStatusChanged", "FullscreenChanged", "GameAnnounce", "GamepadConnected", "GamepadDisconnected", "GetActionButtonEvent", "GettingUp", "GraphicsQualityChangeRequest", "HealthChanged", "Heartbeat", "Hit", "Idle", "Idled", "IncommingConnection", "InputBegan", "InputChanged", "InputEnded", "InterpolationFinished", "ItemAdded", "ItemChanged", "ItemRemoved", "JumpRequest", "Jumping", "KeyDown", "KeyPressed", "KeyUp", "KeyframeReached", "LightingChanged", "Loaded", "LocalPlayerArrivedFromTeleport", "LocalSimulationTouched", "LocalToolEquipped", "LocalToolUnequipped", "LoginFailed", "LoginSucceeded", "MessageOut", "MouseButton1Click", "MouseButton1Down", "MouseButton1Up", "MouseButton2Click", "MouseButton2Down", "MouseButton2Up", "MouseClick", "MouseDrag", "MouseEnter", "MouseHoverEnter", "MouseHoverLeave", "MouseLeave", "MouseMoved", "MouseWheelBackward", "MouseWheelForward", "Move", "MoveStateChanged", "MoveToFinished", "NativePurchaseFinished", "OnClientEvent", "OnRedo", "OnServerEvent", "OnTeleport", "OnUndo", "OutfitChanged", "Paused", "PlatformStanding", "Played", "PlayerAdded", "PlayerAddedEarly", "PlayerChatted", "PlayerRemoving", "PlayerRemovingLate", "PointsAwarded", "ProcessedEvent", "PromptProductPurchaseFinished", "PromptProductPurchaseRequested", "PromptPurchaseFinished", "PromptPurchaseRequested", "Ragdoll", "ReachedTarget", "Received", "ReceiverConnected", "ReceiverDisconnected", "RemoveDefaultLoadingGuiSignal", "RenderStepped", "Resuming", "Running", "Seated", "Selected", "SelectionChanged", "ServerCollectConditionalResult", "ServerCollectResult", "ServerMessageOut", "ServerPurchaseVerification", "ServiceAdded", "ServiceRemoving", "ShowLeaveConfirmation", "SimulationRadiusChanged", "SourceValueChanged", "SpecialKeyPressed", "StateChanged", "StatsReceived", "StatusAdded", "StatusRemoved", "Stepped", "Stopped", "StoppedTouching", "Strafing", "StudioModeChanged", "Swimming", "TextBoxFocusReleased", "TextBoxFocused", "ThirdPartyPurchaseFinished", "TicketProcessed", "TopbarTransparencyChangedSignal", "TouchEnded", "TouchLongPress", "TouchMoved", "TouchPan", "TouchPinch", "TouchRotate", "TouchStarted", "TouchSwipe", "TouchTap", "Touched", "UiMessageChanged", "Unequipped", "VideoAdClosed", "VideoRecordingChangeRequest", "WatchAdded", "WatchRemoved", "WheelBackward", "WheelForward", "WindowFocusReleased", "WindowFocused"},
		AllFunctions = {"Abort", "Activate", "AddCenterDialog", "AddCoreScript", "AddCoreScriptLocal", "AddCustomStatus", "AddDebugger", "AddDummyJob", "AddItem", "AddKey", "AddKeyframe", "AddLeaderboardKey", "AddPose", "AddSelectionParent", "AddSelectionTuple", "AddSpecialKey", "AddStarterScript", "AddStat", "AddStatus", "AddSubPose", "AddWatch", "AdjustSpeed", "AdjustWeight", "ApplySpecificImpulse", "ApproveAssetId", "ApproveAssetVersionId", "AutowedgeCell", "AutowedgeCells", "AxisRotate", "BindAction", "BindActionToInputTypes", "BindActivate", "BindButton", "BindCoreAction", "BindToRenderStep", "BreakJoints", "Button1Down", "Button1Up", "Button2Down", "Button2Up", "CallFunction", "CancelAllNotification", "CancelNotification", "CaptureController", "CaptureFocus", "CaptureMetrics", "CellCenterToWorld", "CellCornerToWorld", "ChangeState", "Chat", "Check", "CheckSyntax", "Checkpoint", "Clear", "ClearAllChildren", "ClearCharacterAppearance", "ClearContent", "ClearJoinAfterMoveJoints", "ClearMessage", "ClickButton1", "ClickButton2", "Clone", "CloseConnection", "ConvertToSmooth", "CopyRegion", "CountCells", "CreateButton", "CreateJoinAfterMoveJoints", "CreateLocalPlayer", "CreatePlugin", "CreateToolbar", "DeleteCookieValue", "Demote", "Destroy", "Disable", "DisableProcessPackets", "DisableQueue", "Disconnect", "DistanceFromCharacter", "DoCommand", "Done", "EnableAdorns", "EnableDebugging", "EnableProcessPackets", "EnableQueue", "EquipTool", "Error", "ExecuteScript", "ExperimentalSolverIsEnabled", "ExportPlace", "ExportSelection", "Fail", "Failed", "FillBall", "FillBlock", "FillRegion", "FindFirstChild", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartsInRegion3", "FindPartsInRegion3WithIgnoreList", "FindService", "FinishShutdown", "Fire", "FireActionButtonFoundSignal", "FireAllClients", "FireClient", "FireServer", "GamepadSupports", "GenerateGUID", "Get", "GetAllBoundActionInfo", "GetAttachedReceivers", "GetAwardablePoints", "GetBoundActionInfo", "GetBreakpoints", "GetBrickCount", "GetButton", "GetCanRedo", "GetCanUndo", "GetCell", "GetChildren", "GetClientCount", "GetClosestDialogToPosition", "GetCollection", "GetCommandNames", "GetConnectedParts", "GetConnectorCount", "GetCookieValue", "GetCoreGuiEnabled", "GetCurrentLocalToolIcon", "GetCurrentPage", "GetCurrentValue", "GetDataStore", "GetDebugId", "GetDebuggers", "GetDeltaAve", "GetDeviceAcceleration", "GetDeviceGravity", "GetDeviceRotation", "GetErrorMessage", "GetExtentsSize", "GetFFlag", "GetFVariable", "GetFVariables", "GetFriendStatus", "GetFullName", "GetGPUDelay", "GetGameSessionID", "GetGamepadConnected", "GetGamepadState", "GetGlobalDataStore", "GetGlobals", "GetHash", "GetHeapStats", "GetInstanceCount", "GetJobIntervalPeakFraction", "GetJobTimePeakFraction", "GetJobsExtendedStats", "GetJobsInfo", "GetJoinMode", "GetKeyframeSequence", "GetKeyframeSequenceById", "GetKeyframes", "GetKeysPressed", "GetLastForce", "GetLocals", "GetLogHistory", "GetMass", "GetMaxQualityLevel", "GetMessage", "GetMinutesAfterMidnight", "GetModelCFrame", "GetModelSize", "GetMoonDirection", "GetMoonPhase", "GetMouse", "GetNetworkOwner", "GetNetworkOwnershipAuto", "GetNumAwakeParts", "GetObjects", "GetOldSchoolBackpack", "GetOrderedDataStore", "GetPanSpeed", "GetPhysicsThrottling", "GetPlatform", "GetPlayer", "GetPlayerByID", "GetPlayerByUserId", "GetPlayerFromCharacter", "GetPlayers", "GetPlayingAnimationTracks", "GetPointCoordinates", "GetPoses", "GetPresentTime", "GetPrimaryPartCFrame", "GetRakStatsString", "GetRealPhysicsFPS", "GetRemoteBuildMode", "GetRenderAve", "GetRenderCFrame", "GetRenderConfMax", "GetRenderConfMin", "GetRenderStd", "GetRoll", "GetRootPart", "GetScriptStats", "GetService", "GetSetting", "GetStack", "GetState", "GetStateEnabled", "GetStatuses", "GetStudioUserId", "GetSubPoses", "GetSunDirection", "GetSupportedGamepadKeyCodes", "GetTeams", "GetTiltSpeed", "GetTimeOfKeyframe", "GetTimes", "GetTimesForFrames", "GetTopbarTransparency", "GetTouchingParts", "GetTutorialState", "GetUiMessage", "GetUnder13", "GetUploadUrl", "GetUpvalues", "GetUseCoreScriptHealthBar", "GetValue", "GetValueString", "GetVoxelCount", "GetWatchValue", "GetWatches", "GetWaterCell", "HasCustomStatus", "HasStatus", "HttpGet", "HttpPost", "InFullScreen", "InStudioMode", "Insert", "Interpolate", "IsA", "IsAncestorOf", "IsCommandChecked", "IsCommandEnabled", "IsDefaultLoadingGuiRemoved", "IsDescendantOf", "IsFinishedReplicating", "IsGearTypeAllowed", "IsGrounded", "IsKeyDown", "IsLoaded", "IsLuaTouchControls", "IsRegion3Empty", "IsRegion3EmptyWithIgnoreList", "IsRunning", "IsStudioTouchEmulationEnabled", "IsUserFeatureEnabled", "JSONDecode", "JSONEncode", "JoinToOutsiders", "JumpCharacter", "Kick", "LegacyScriptMode", "Load", "LoadAnimation", "LoadBoolean", "LoadCharacter", "LoadCharacterAppearance", "LoadData", "LoadGame", "LoadInstance", "LoadNumber", "LoadPlugins", "LoadString", "LoadWorld", "Logout", "MakeJoints", "Message", "MouseDown", "MouseMove", "MouseUp", "Move", "MoveCharacter", "MoveMouse", "MoveTo", "Negate", "OnUpdate", "OpenBrowserWindow", "OpenScript", "PanUnits", "Pass", "Passed", "PasteRegion", "Pause", "Play", "PlayStockSound", "PlayerConnect", "Preload", "PreventTerrainChanges", "PrintScene", "Promote", "PromptLogin", "PromptNativePurchase", "PromptProductPurchase", "PromptPurchase", "PromptThirdPartyPurchase", "ReadVoxels", "RebalanceTeams", "Redo", "RegisterActiveKeyframeSequence", "RegisterKeyframeSequence", "ReleaseFocus", "ReloadShaders", "Remove", "RemoveCenterDialog", "RemoveCharacter", "RemoveCustomStatus", "RemoveDefaultLoadingScreen", "RemoveKey", "RemoveKeyframe", "RemovePose", "RemoveSelectionGroup", "RemoveSpecialKey", "RemoveStat", "RemoveStatus", "RemoveSubPose", "Report", "ReportAbuse", "ReportInGoogleAnalytics", "ReportJobsStepWindow", "ReportMeasurement", "ReportTaskScheduler", "RequestCharacter", "RequestFriendship", "RequestServerOutput", "RequestServerStats", "Require", "Reset", "ResetCdnFailureCounts", "ResetOrientationToIdentity", "ResetWaypoints", "Resize", "ResizeWindow", "Resume", "RevokeFriendship", "RotateCamera", "Run", "Save", "SaveBoolean", "SaveData", "SaveInstance", "SaveLeaderboardData", "SaveNumber", "SaveSelectedToRoblox", "SaveStats", "SaveString", "ScheduleNotification", "ScreenPointToRay", "SendMarker", "Separate", "ServerSave", "Set", "SetAbuseReportUrl", "SetAccessKey", "SetAccountAge", "SetActive", "SetAdvancedResults", "SetAssetRevertUrl", "SetAssetUrl", "SetAssetVersionUrl", "SetAssetVersionsUrl", "SetAwardBadgeUrl", "SetBaseCategoryUrl", "SetBaseSetsUrl", "SetBaseUrl", "SetBasicFilteringEnabled", "SetBestFriendUrl", "SetBlockingRemove", "SetBreakFriendUrl", "SetBreakpoint", "SetBuildUserPermissionsUrl", "SetCacheSize", "SetCameraPanMode", "SetCell", "SetCells", "SetChatFilterUrl", "SetChatStyle", "SetClickToWalkEnabled", "SetCollectScriptStats", "SetCollectionUrl", "SetCookieValue", "SetCoreGuiEnabled", "SetCreateFriendRequestUrl", "SetCreatorID", "SetCreatorId", "SetDeleteFriendRequestUrl", "SetDescription", "SetDesiredAngle", "SetEnabled", "SetErrorMessage", "SetFilterLimits", "SetFilterUrl", "SetFreeDecalUrl", "SetFreeModelUrl", "SetFriendUrl", "SetFriendsOnlineUrl", "SetGameSessionID", "SetGearSettings", "SetGenre", "SetGetFriendsUrl", "SetGlobal", "SetGlobalGuiInset", "SetGroupRankUrl", "SetGroupRoleUrl", "SetGroupUrl", "SetHasBadgeCooldown", "SetHasBadgeUrl", "SetIdentityOrientation", "SetImage", "SetIsBadgeDisabledUrl", "SetIsBadgeLegalUrl", "SetIsPlayerAuthenticationRequired", "SetJobsExtendedStatsWindow", "SetJoinAfterMoveInstance", "SetJoinAfterMoveTarget", "SetKeyDown", "SetKeyUp", "SetLegacyMaxItems", "SetLoadDataUrl", "SetLocal", "SetMakeFriendUrl", "SetMembershipType", "SetMessage", "SetMessageBrickCount", "SetMinutesAfterMidnight", "SetNetworkOwner", "SetNetworkOwnershipAuto", "SetOldSchoolBackpack", "SetOutgoingKBPSLimit", "SetPackageContentsUrl", "SetPersonalServerGetRankUrl", "SetPersonalServerRoleSetsUrl", "SetPersonalServerSetRankUrl", "SetPhysicsThrottleEnabled", "SetPing", "SetPlaceAccessUrl", "SetPlaceID", "SetPlaceId", "SetPlaceVersion", "SetPlayerHasPassUrl", "SetPosition", "SetPrimaryPartCFrame", "SetPropSyncExpiration", "SetRemoteBuildMode", "SetReportUrl", "SetRoll", "SetSaveDataUrl", "SetSaveLeaderboardDataUrl", "SetScreenshotInfo", "SetServerSaveUrl", "SetSetting", "SetStateEnabled", "SetStuffUrl", "SetSuperSafeChat", "SetSysStatsUrl", "SetSysStatsUrlId", "SetThreadPool", "SetThreadShare", "SetTimeout", "SetTitle", "SetTopbarTransparency", "SetTrustLevel", "SetTutorialState", "SetUiMessage", "SetUnder13", "SetUniverseId", "SetUploadUrl", "SetUpvalue", "SetUserCategoryUrl", "SetUserSetsUrl", "SetVIPServerId", "SetValue", "SetVerb", "SetVideoInfo", "SetWaterCell", "SetWaypoint", "ShowPermissibleJoints", "ShowVideoAd", "Shutdown", "SignalClientPurchaseSuccess", "SignalDialogChoiceSelected", "SignalPromptProductPurchaseFinished", "SignalPromptPurchaseFinished", "SignalServerLuaDialogClosed", "Start", "StartRecording", "StepIn", "StepOut", "StepOver", "Stop", "StopRecording", "TakeDamage", "TeamChat", "Teleport", "TeleportCancel", "TeleportImpl", "TeleportToPlaceInstance", "TeleportToSpawnByName", "TiltUnits", "ToggleFullscreen", "ToggleSelect", "ToggleTools", "TranslateBy", "TweenPosition", "TweenSize", "TweenSizeAndPosition", "TypeKey", "UnbindAction", "UnbindActivate", "UnbindAllActions", "UnbindButton", "UnbindCoreAction", "UnbindFromRenderStep", "Undo", "UnequipTools", "Union", "UnjoinFromOutsiders", "UrlEncode", "ViewportPointToRay", "Warn", "WhisperChat", "WorldToCell", "WorldToCellPreferEmpty", "WorldToCellPreferSolid", "WorldToScreenPoint", "WorldToViewportPoint", "WriteVoxels", "Zoom", "ZoomCamera", "ZoomToExtents"},
		AllYieldFunctions = {"AdvanceToNextPageAsync", "AwardBadge", "AwardPoints", "BlockUser", "CheckOcclusionAsync", "ComputeRawPathAsync", "ComputeSmoothPathAsync", "CreatePlaceAsync", "CreatePlaceInPlayerInventoryAsync", "FilterStringForPlayerAsync", "GetAlliesAsync", "GetAnimations", "GetAssetVersions", "GetAsync", "GetBaseCategories", "GetBaseSets", "GetButton", "GetCollection", "GetCreatorAssetID", "GetDeveloperProductsAsync", "GetEnemiesAsync", "GetFreeDecals", "GetFreeModels", "GetFriendsAsync", "GetFriendsOnline", "GetGamePlacesAsync", "GetGamePointBalance", "GetGroupInfoAsync", "GetNameFromUserIdAsync", "GetPlacePermissions", "GetPlayerPlaceInstanceAsync", "GetPointBalance", "GetProductInfo", "GetRankInGroup", "GetRoleInGroup", "GetRoleSets", "GetScheduledNotifications", "GetScreenResolution", "GetSortedAsync", "GetUserCategories", "GetUserIdFromNameAsync", "GetUserSets", "GetWebPersonalServerRank", "HttpGetAsync", "HttpPostAsync", "IncrementAsync", "Invoke", "InvokeClient", "InvokeServer", "IsBestFriendsWith", "IsDisabled", "IsFriendsWith", "IsInGroup", "IsLegal", "LoadAsset", "LoadAssetVersion", "PlayerHasPass", "PlayerOwnsAsset", "PostAsync", "PreloadAsync", "RevertAsset", "Run", "SavePlace", "SavePlaceAsync", "SaveToRoblox", "SetAsync", "SetPlacePermissions", "SetWebPersonalServerRank", "UnblockUser", "UpdateAsync", "UserHasBadge", "WaitForChild", "WaitForDataReady"},
		AllCallbacks = {"ConfirmationCallback", "DeleteFilter", "ErrorCallback", "EventFilter", "NewFilter", "OnClientInvoke", "OnClose", "OnInvoke", "OnServerInvoke", "ProcessReceipt", "PropertyFilter", "RequestShutdown"}
	}
}, {
	CanUseLoadstring = pcall(loadstring, "")
}, {}

Functions = setmetatable({
	Instance = {
		Create = function(ClassName, Properties, Events, ReturnUnwrapped)
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
			return ReturnUnwrapped and Object or _(Object)
		end,
		
		SetCustomMethod = function(Type, Name, Method)
			Type = Utilities.GetUnwrappedObjects(type(Type) == "string" and Type or _(Type):IsType("Instance") and Type.ClassName or nil)
			Utilities.Assert("Instance.CreateMethod", Type, "Argument 1 must be an instance or a string!"); Utilities.Assert("Instance.CreateMethod", type(Name) == "string", "Argument 2 must be a string!"); Utilities.Assert("Instance.CreateMethod", type(Method) == "function", "Argument 3 must be a function!")
			if type(ProxyMethods.userdata.Instance[Type]) ~= "table" then ProxyMethods.userdata.Instance[Type] = {} end
			ProxyMethods.userdata.Instance[Type][Name] = Method
		end,
	},
	
	Event = {
		Create = function(Event, Handler)
			local Signal = Libraries.RbxUtility.CreateSignal()
			if not _(Events):GetNest(Event).__self then
				_(Events):CreateNest(Event, {Event = Signal, Connections = {}})
			end
			_(Handler):BindToEnvironment({Event = Signal}):RunAsThread()
		end,
		
		Attach = function(Event, Handler, Tag)
			local EventNest = _(Events):GetNest(Event).__self
			Utilities.Assert("Event.Attach", EventNest, "The event \"" .. Event .. "\" does not exist!")
			Utilities.Assert("Event.Attach", not Tag or not EventNest.Connections[Tag], "The event \"" .. Event .. "\" already has an attachment with the tag \"" .. tostring(Tag) .. "\"! Please detach it first.")
			local Connection = EventNest.Event:connect(Handler)
			EventNest.Connections[Tag or #EventNest.Connections + 1] = Connection
			return setmetatable({Connection}, {
				__index = function(Self, Key)
					return (Key == "disconnect" or Key == "Detach") and _.Event.Detach or Key == "__disconnect" and rawget(Self, 1).disconnect or nil
				end,
				__newindex = function() end,
				__metatable = "The metatable is locked"
			})
		end,
		
		Detach = function(...)
			local Arguments = {...}
			local EventConnectionsNest = (Arguments[1].disconnect and _(Events):GetOriginChildTable(Arguments[1]) or _(Events):GetNest(Arguments[1] .. ".Connections")).__self
			if type(Arguments[1]) == "string" then
				Utilities.Assert("Event.Detach", EventConnectionsNest, "The event \"" .. Arguments[1] .. "\" does not exist!")
			end
			for Tag, Connection in next, EventConnectionsNest do
				if Connection == Arguments[1] or Tag == Arguments[2] then
					Connection:__disconnect()
					EventConnectionsNest[Tag] = nil
					return nil
				end
			end
		end,
		
		GetAllConnections = function(Event)
			local Connections = {}
			if Event then
				local EventNest = _(Events):GetNest(Event).__self
				if EventNest then
					for __, Connection in next, EventNest.Connections do
						table.insert(Connections, Connection)
					end
				end
			else
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
			local Dialog, FromOffset = Style and Libraries.RbxGui.CreateStyledMessageDialog(Title, Message, Style, Buttons) or Libraries.RbxGui.CreateMessageDialog(Title, Message, Buttons), 50
			local DefaultPosition, DefaultSize = Dialog.Position, Dialog.Size
			for __, Button in next, Buttons do
				_(Button.Function):BindToEnvironment({CloseDialog = function()
					Dialog:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(Dialog.Position.X.Scale + (Dialog.Size.X.Scale / 2), Dialog.Position.X.Offset + (Dialog.Size.X.Offset / 2), Dialog.Position.Y.Scale + (Dialog.Size.Y.Scale / 2), Dialog.Position.Y.Offset + (Dialog.Size.Y.Offset / 2)), "Out", "Quart", 0.25, true)
					repeat wait() until Dialog.AbsoluteSize == Vector2.new(0, 0)			
					Dialog:Destroy()
				end})
			end
			Functions.GUI.ModifyZIndex(Dialog, 10, true)
			_(Dialog):SetProperties({
				Parent = Parent,
				Draggable = true,
				ClipsDescendants = true,
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
			Dialog:TweenSizeAndPosition(DefaultSize, DefaultPosition, "Out", "Quart", 0.25, true)
			return Dialog
		end,
		
		SetCoreGUIEnabled = function(Components, Boolean)
			Boolean = _(Boolean):ToBoolean()
			if type(Components) == "table" then
				if Boolean ~= nil then
					for __, Component in next, Components do
						pcall(Services.StarterGui, "SetCoreGuiEnabled", Component, Boolean)
					end
				else
					for Component, Boolean in next, Components do
						pcall(Services.StarterGui, "SetCoreGuiEnabled", Component, Boolean)
					end
				end
			else
				pcall(Services.StarterGui, "SetCoreGuiEnabled", Components, Boolean)
			end
		end,
		
		ModifyZIndex = function(Parent, Level, HardSet)
			local ZIndex = HardSet and Level or Parent.ZIndex + Level
			pcall(function() Parent.ZIndex = ZIndex end)
			for __, Object in next, _(Parent):GetAllChildren().__self do
				if pcall(function() return Object.ZIndex end) then
					Object.ZIndex = HardSet and Object.ZIndex + ZIndex or ZIndex
				end
			end
		end
	},
	
	HTTP = {
		Get = function(URL, NoCache)
			return Services.HttpService:GetAsync(URL, NoCache)
		end,
		
		Post = function(URL, Data, Encode, ContentType)
			return Services.HttpService:PostAsync(URL, Encode and Services.HttpService:UrlEncode(Data) or Data, ContentType or (Encode and "ApplicationUrlEncoded" or "TextPlain"))
		end
	},
	
	Utilities = {
		GetUnwrappedObjects = function(...)
			local Objects = {...}
			for Index, Object in next, Objects do
				if type(Object) == "userdata" and pcall(function() return Object.__self end) and type(Object.__type) ~= "nil" then
					Object = Object.__self; Objects[Index] = Object
				end
				if type(Object) == "table" then
					for Key, _Object in next, Object do
						rawset(Object, Key, Utilities.GetUnwrappedObjects(_Object))
					end
				end
			end
			return unpack(Objects)
		end,
		
		GetSpecificProxyMethod = function(Object, Method)
			return type(Object) == "userdata" and ProxyMethods.userdata[ProxyMethods.userdata.GetDataType(Object)] and (ProxyMethods.userdata[ProxyMethods.userdata.GetDataType(Object)][pcall(function() return Object.ClassName end) and Object.ClassName or tostring(Object)] and ProxyMethods.userdata[ProxyMethods.userdata.GetDataType(Object)][pcall(function() return Object.ClassName end) and Object.ClassName or tostring(Object)][Method] or ProxyMethods.userdata[ProxyMethods.userdata.GetDataType(Object)][Method]) or ProxyMethods[type(Object)][Method]
		end,
		
		GetRelativeRange = function(MaximumPosition, Begin, End)
			MaximumPosition = type(MaximumPosition) == "number" and MaximumPosition or #Utilities.GetUnwrappedObjects(MaximumPosition)
			Begin, End = Begin or 1, End or MaximumPosition
			return Begin < 0 and math.max(MaximumPosition + Begin + 1, 0) or math.min(Begin, MaximumPosition), End < 0 and math.max(MaximumPosition + End, 0) or math.min(End, MaximumPosition)
		end,
		
		TraverseAllChildTables = function(Table)
			local AllTables, ChildTable, Key, Value = _(Table):GetAllChildren("Table", true).__self, Table
			return function()
				print("We are given:", ChildTable, Key, Value)
				if next(ChildTable, Key) == nil then
					ChildTable = select(2, next(AllTables, ChildTable ~= Table and _(AllTables):IndexOf(ChildTable).__self or nil))
					-- Key, Value = next(ChildTable)
				-- else
					-- Key, Value = next(ChildTable, Key)
				end
				return ChildTable, next(ChildTable, Key)
			end
		end,
		
		CanCheckType = function(Object)
			return (pcall(function() _(Object):IsType("") end))
		end,

		IsROBLOXUserdata = function(Object)
			return getmetatable(Object) == "The metatable is locked"
		end,
		
		LockMetatable = function(Table)
			getmetatable(Utilities.GetUnwrappedObjects(Table)).__metatable = "The metatable is locked"
			return Table
		end,
		
		Breathe = function(WaitProbability)
			return math.random() < (WaitProbability or 0.05) and wait() or nil
		end,

		Log = function(Type, Section, Message)
			getfenv()[Type == "Log" and "print" or Type == "Warning" and "warn" or Type == "Error" and "error"]("[_" .. (Section and "." .. Section or "") .. "] " .. tostring(Message))
		end,
		
		Assert = function(Section, Test, Message)
			if type(Test) == "table" and not _(Test):Every(function(__, Returned) return Returned end).__self or type(Test) ~= "table" and not Utilities.GetUnwrappedObjects(Test) then
				Utilities.Log("Error", Section, Message)
			end
		end,
		
		HandlePcall = function(Script, Successful, Returned)
			if Successful then
				return Returned
			elseif Returned then
				Utilities.Log("Error", "Utilities.HandlePcall", Returned:match(":(%d+:.+)"))
			end
		end
	}
}, {
	__index = function(Self, Key)
		return rawget(Self, Key) or ProxyMethods[Key:lower()]
	end
})
Utilities = Functions.Utilities

ProxyMethods = {
	string = {
		MatchTest = function(String, Pattern, CaseInsensitive)
			if Pattern == "" then return nil end
			local String, MatchFound = Utilities.GetUnwrappedObjects(String), not not (CaseInsensitive and String:lower() or String):match(CaseInsensitive and Pattern:lower() or Pattern)
			if MatchFound then
				return true, (function() local Count = 0; for __ in (CaseInsensitive and String:lower() or String):gmatch(CaseInsensitive and Pattern:lower() or Pattern) do Count = Count + 1 end; return Count end)()
			else
				return false
			end
		end,
		
		Split = function(String, Delimiter)
			local Delimiter, Pieces = _(Delimiter or ""):PrepareAsRegularExpression().__self, {}
			for Piece in Delimiter ~= "" and String:gmatch("[" .. Delimiter .. "]-[^" .. Delimiter .. "]+") or String:gmatch(".") do
				table.insert(Pieces, (Piece:gsub("^" .. Delimiter, "")))
			end
			return #Pieces > 0 and Pieces or nil
		end,
		
		Trim = function(String, Side)
			return Utilities.GetUnwrappedObjects(String):match("^" .. ((not Side or Side == "Left") and " *" or "") .. "(.-)" .. ((not Side or Side == "Right") and " *" or "") .. "$")
		end,
		
		Concatenate = function(String, Object)
			String, Object = Utilities.GetUnwrappedObjects(String, Object)
			if type(Object) == "string" then
				return String .. Object
			elseif type(Object) == "number" or type(Object) == "boolean" then
				return String .. tostring(Object)
			elseif type(Object) == "table" then
				return String .. tostring(_(Object))
			else
				return String .. tostring(Object)
			end
		end,
		
		IndexOf = function(String, Pattern, MinimumIndex)
			return (Utilities.GetUnwrappedObjects(String):find(Pattern, MinimumIndex))
		end,
		
		LastIndexOf = function(String, Pattern, MaximumIndex)
			String = Utilities.GetUnwrappedObjects(String)
			return String:find(Pattern) and (#String - String:reverse():find(Pattern:reverse(), #String - (MaximumIndex and MaximumIndex - #Pattern or #String)) - #Pattern + 2) or nil
		end,
		
		Pluralize = function(String)
			String = Utilities.GetUnwrappedObjects(String)
			return String:sub(-1) == "s" and String .. "es" or String:sub(-2) == "ey" and String:sub(1, #String - 2) .. "ies" or String:sub(-1) == "y" and String:sub(1, #String - 1) .. "ies" or String .. "s"
		end,
		
		Unserialize = function(String, Parent)
			local Decoded = Services.HttpService:JSONDecode(Utilities.GetUnwrappedObjects(String))
			local Instance = Instance.new(Decoded.ClassName)
			if Decoded.__children then
				for Index, Child in next, Decoded.__children do
					Decoded.__children[Index] = select(2, pcall(_.String.Unserialize, Services.HttpService:JSONEncode(Child), Instance))
				end
			end
			for MemberName, Member in next, Decoded do
				local Successful, Error = pcall(function()
					if type(Member) == "string" and (Member:match("^__children") or Member:match("^__return")) then
						Instance[MemberName] = Member:match("^__children") and Decoded.__children[tonumber(Member:match("%[(.+)%]"))] or _(game):GetNest(Member:match("%[(.+)%]")).__self
					elseif MemberName ~= "ClassName" and MemberName ~= "Parent" and MemberName ~= "__children" then
						if type(Member) == "string" and Member:match("^__%$") then
							local Member, MemberType = Member:match("%[(.+)%]$"), Member:match("%w+")
							if MemberType:match("Vector") or MemberType == "CFrame" or MemberType == "UDim" or MemberType == "Color3" or MemberType == "BrickColor" or MemberType == "NumberRange" then
								Member = getfenv()[MemberType].new(unpack(_(Member):Split(", ").__self))
							elseif MemberType == "UDim2" then
								local Arguments = {}
								for Number in Member:gmatch("%d+[%.%d+]*") do
									table.insert(Arguments, Number)
								end
								Member = UDim2.new(unpack(Arguments))
							elseif MemberType == "Region3" then
								local Position, Size = unpack(_(Member):Split("; ").__self); Position, Size = CFrame.new(unpack(_(Position):Split(", ").__self)), Vector3.new(Size)
								Member = Region3.new(Position - Size / 2, Position + Size / 2)
							elseif MemberType == "Region3int16" then
								local Vectors = _(Member):Split("; "):Map(function(__, Vector) return _(Vector):Split(", ").__self end).__self
								Member = Region3int16.new(Vector3int16.new(unpack(Vectors[1])), Vector3int16.new(unpack(Vectors[2])))
							elseif MemberType == "Ray" then
								local Vectors = {{}, {}}
								for Number in Member:gmatch("%d+[%.%d+]*") do
									table.insert(#Vectors[1] < 3 and Vectors[1] or Vectors[2], Number)
								end
								Member = Ray.new(Vector3.new(unpack(Vectors[1])), Vector3.new(unpack(Vectors[2])))
							elseif MemberType:match("Sequence") then
								local Arguments = {}
								for __, Argument in next, _(Member):Split(";").__self do
									table.insert(Arguments, MemberType == "NumberSequence" and NumberSequenceKeypoint.new(Argument:match("%d+[%.%d+]*"), Argument:match("%[(%d+[%.%d+]*)")) or Color3.new(unpack(_(Argument:match("(.+) | %d+[%.%d+]*")):Split(", ").__self)))
								end
								Member = getfenv()[MemberType].new(MemberType == "NumberSequence" and Arguments or unpack(Arguments))
							elseif MemberType:match("Enumeration") then
								Member = _(Enum):GetNest(Member).__self
							elseif MemberType == "Axes" or MemberType == "Faces" then
								local Faces = {}
								for __, Face in next, _(Member):Split(", ").__self do
									table.insert(Faces, Enum.NormalId[Face])
								end
								Member = getfenv()[MemberType].new(unpack(Faces))
							end
							Instance[MemberName] = Member
						else
							Instance[MemberName] = Member
						end
					end
				end)
				if not Successful then
					Utilities.Log("Warning", "Methods.string.Unserialize", "Unable to unserialize property \"" .. MemberName .. "\": " .. Error)
				end
			end
			if Parent then
				Instance.Parent = Parent
			end
			return Instance
		end,
		
		ToLowerCase = function(String, FromOrTo, To)
			String = Utilities.GetUnwrappedObjects(String)
			if To then
				return (FromOrTo > 1 and String:sub(1, FromOrTo - 1) or "") .. String:sub(FromOrTo, To):lower() .. (To < #String and String:sub(To + 1, #String) or "")
			elseif FromOrTo then
				return String:sub(1, FromOrTo):lower() .. String:sub(FromOrTo + 1, #String)
			else
				return String:lower()
			end
		end,
		
		ToUpperCase = function(String, FromOrTo, To)
			String = Utilities.GetUnwrappedObjects(String)
			if To then
				return (FromOrTo > 1 and String:sub(1, FromOrTo - 1) or "") .. String:sub(FromOrTo, To):upper() .. (To < #String and String:sub(To + 1, #String) or "")
			elseif FromOrTo then
				return String:sub(1, FromOrTo):upper() .. String:sub(FromOrTo + 1, #String)
			else
				return String:upper()
			end
		end,
		
		ToString = function(String)
			return tostring(Utilities.GetUnwrappedObjects(String))
		end,
		
		ToNumber = function(String)
			return tonumber(Utilities.GetUnwrappedObjects(String))
		end,
		
		ToBoolean = function(String, Keywords)
			String, Keywords = Utilities.GetUnwrappedObjects(String), Keywords or {[true] = {"true", "on", "1"}, [false] = {"false", "off", "0"}}
			if type(Keywords[true]) == "table" or type(Keywords[false]) == "table" then
				if Keywords[true] then
					for __, Keyword in next, Keywords[true] do
						if Keyword == String then
							return true
						end
					end
				end
				if Keywords[false] then
					for __, Keyword in next, Keywords[false] do
						if Keyword == String then
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
		
		GetLength = function(String)
			return #Utilities.GetUnwrappedObjects(String)
		end,
		
		LoadAndReturn = function(String)
			Utilities.Assert("Methods.string.LoadAndReturn", Capabilities.CanUseLoadstring, "loadstring is not available in local scripts!")
			return loadstring("return " .. Utilities.GetUnwrappedObjects(String))()
		end,
		
		PrepareAsRegularExpression = function(String)
			return (Utilities.GetUnwrappedObjects(String):gsub("([%p%s])", "%%%1"))
		end
	},
	
	number = {
		Round = function(Number, DecimalPlace)
			return math.floor(Utilities.GetUnwrappedObjects(Number) * math.pow(10, DecimalPlace or 0) + 0.5) / math.pow(10, DecimalPlace or 0)
		end,
		
		LogBase = function(Number, Base)
			return math.log(Utilities.GetUnwrappedObjects(Number)) / math.log(Base)
		end,
		
		ShiftBits = function(Number, Direction, ShiftBy)
			return Direction == "Left" and (Number * math.pow(2, ShiftBy)) or Direction == "Right" and math.floor(Number / math.pow(2, ShiftBy)) or nil
		end,
		
		Concatenate = function(Number, Object)
			Number, Object = Utilities.GetUnwrappedObjects(Number, Object)
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
			Number, NewNumber = Utilities.GetUnwrappedObjects(Number, NewNumber)
			return NewNumber >= Number - Tolerance and NewNumber <= Number + Tolerance
		end,
		
		ToString = function(Number)
			return tostring(Utilities.GetUnwrappedObjects(Number))
		end,
		
		ToBoolean = function(Number)
			Number = Utilities.GetUnwrappedObjects(Number)
			return Number == 1 and true or Number == 0 and false or nil
		end,
		
		GetLength = function(Number)
			return #tostring(Utilities.GetUnwrappedObjects(Number))
		end
	},
	
	boolean = {
		Negate = function(Boolean)
			return not Utilities.GetUnwrappedObjects(Boolean)
		end,
		
		ToString = function(Boolean)
			return tostring(Utilities.GetUnwrappedObjects(Boolean))
		end,
		
		ToNumber = function(Boolean)
			return Utilities.GetUnwrappedObjects(Boolean) and 1 or 0
		end
	},
	
	table = {
		GetAllChildren = function(Table, Type, DeepGet)
			local Objects = {}
			for __, Object in next, Utilities.GetUnwrappedObjects(Table) do
				if type(Object) == "table" and DeepGet and _(Object):GetSize().__self > 0 then
					if not Type or Type:lower() == "table" then table.insert(Objects, Object) end
					for __, ChildObject in next, _(Object):GetAllChildren(Type, true).__self do
						table.insert(Objects, ChildObject)
					end
				elseif type(Type) == "table" then
					for __, Type in next, Type do
						if _(Object):IsType(Type) then
							table.insert(Objects, Object)
						end
					end
				elseif not Type or _(Object):IsType(Type) then
					table.insert(Objects, Object)
				end
			end
			return Objects
		end,
		
		GetOriginChildTable = function(Table, Object)
			for __, ChildTable in next, _(Table):GetAllChildren("Table", true).__self do
				for __, Value in next, ChildTable do
					if Value == Object then return ChildTable end
				end
			end
			return nil
		end,
		
		GetNest = function(Table, Path)
			local LastLevel = Table
			for Level in Path:gmatch("%.-[^%.]+") do
				local Level = Level:gsub("^%.", "")
				if not pcall(function() return LastLevel[Level] end) then return nil end
				LastLevel = LastLevel[Level]
			end
			return LastLevel
		end,
		
		CreateNest = function(Table, Path, Content, ReturnNest)
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
				table.insert(LastLevel, Content)
			end
			return ReturnNest and LastLevel or Table
		end,
		
		GetIndexed = function(Table, Type, NumericIndexesOnly)
			local Entries, Index = {}, 0
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				Index = Index + 1
				if not NumericIndexesOnly then
					Entries[Index] = Type == "Keys" and Key or Type == "Values" and Value or nil
				elseif type(Key) == "number" then
					if Type == "Keys" then
						Entries[Index] = Key
					elseif Type == "Values" then
						Entries[Index] = Value
					end
				end
			end
			return #Entries > 0 and Entries or nil
		end,
		
		ContainsNonNumericIndex = function(Table)
			return #Utilities.GetUnwrappedObjects(Table) ~= _(Table):GetSize().__self
		end,
		
		IndexOf = function(Table, Object, MinimumIndex)
			if MinimumIndex then
				local Keys, Values, PassedMinimumIndex = _(Table):GetIndexed("Keys").__self, _(Table):GetIndexed("Values").__self
				for Index, Value in next, Values do
					if not PassedMinimumIndex and Keys[Index] == MinimumIndex then PassedMinimumIndex = true end
					if Value == Object and PassedMinimumIndex then
						return Keys[Index]
					end
				end
				return nil
			else
				return _(Table):MatchPartner("Key", Object).__self
			end
		end,
		
		LastIndexOf = function(Table, Object, MaximumIndex)
			local Keys, Values, PassedMaximumIndex = _(Table):GetIndexed("Keys"):Reverse().__self, _(Table):GetIndexed("Values"):Reverse().__self
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
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if Type == "Key" then
					if not PartialMatch or type(Object) ~= "string" or type(Key) ~= "string" then
						if type(Key) == "table" and _(Key):Equals(Object) or Key == Object then
							return Key
						end
					else
						if CaseInsensitive then
							if Key:lower():match(Object:lower()) then
								return Key
							end
						elseif Key:match(Object) then
							return Key
						end
					end
				elseif Type == "Value" then
					if not PartialMatch or type(Object) ~= "string" or type(Value) ~= "string" then
						if type(Value) == "table" and _(Value):Equals(Object) or Value == Object then
							return Value
						end
					else
						if CaseInsensitive then
							if Value:lower():match(Object:lower()) then
								return Value
							end
						elseif Value:match(Object) then
							return Value
						end
					end
				end
			end
			return nil
		end,
		
		MatchPartner = function(Table, Type, Object, CaseInsensitive, PartialMatch)
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if Type == "Key" then
					if not PartialMatch or type(Object) ~= "string" or type(Value) ~= "string" then
						if type(Value) == "table" and _(Value):Equals(Object) or Value == Object then
							return Key
						end
					else
						if CaseInsensitive then
							if Value:lower():match(Object:lower()) then
								return Key
							end
						elseif Value:match(Object) then
							return Key
						end
					end
				elseif Type == "Value" then
					if not PartialMatch or type(Object) ~= "string" or type(Key) ~= "string" then
						if type(Key) == "table" and _(Key):Equals(Object) or Key == Object then
							return Value
						end
					else
						if CaseInsensitive then
							if Key:lower():match(Object:lower()) then
								return Value
							end
						elseif Key:match(Object) then
							return Value
						end
					end
				end
			end
			return nil
		end,
		
		Clone = function(Table, DeepClone)
			local Clone = {}
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if type(Value) == "table" and Value ~= Table and DeepClone then
					Value = _(Value):Clone()
				end
				Clone[Key] = Value
			end
			return not Utilities.IsROBLOXUserdata(Table) and setmetatable(Clone, getmetatable(Table)) or Clone
		end,
		
		Fill = function(Table, Object, FromOrTo, To)
			Utilities.Assert("Methods.table.Fill", {not FromOrTo or type(FromOrTo) == "number" and math.floor(FromOrTo) == FromOrTo, not To or type(To) == "number" and math.floor(To) == To}, "Arguments 2 and 3 (if passed) must be integers!")
			Table = Utilities.GetUnwrappedObjects(Table)
			if FromOrTo then
				FromOrTo, To = Utilities.GetRelativeRange(Table, FromOrTo, To)
				for Key in ipairs(Table) do
					if Key >= FromOrTo and Key <= To then
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
		
		Insert = function(Table, ...)
			Table = Utilities.GetUnwrappedObjects(Table)
			table.insert(Table, ...)
			return Table
		end,
		
		Remove = function(Table, Index)
			Table = Utilities.GetUnwrappedObjects(Table)
			table.remove(Table, Index)
			return Table
		end,
		
		Push = function(Table, ...)
			Table = Utilities.GetUnwrappedObjects(Table)
			for __, Object in next, {...} do
				Table[#Table + 1] = Object
			end
			return Table
		end,
		
		Pop = function(Table)
			return table.remove(Utilities.GetUnwrappedObjects(Table))
		end,
		
		Shift = function(Table)
			return table.remove(Utilities.GetUnwrappedObjects(Table), 1)
		end,
		
		Unshift = function(Table, ...)
			Table = Utilities.GetUnwrappedObjects(Table)
			for __, Argument in next, _({...}):Reverse().__self do
				table.insert(Table, 1, Argument)
			end
			return Table
		end,
		
		Slice = function(Table, ...)
			return _(Table):Clone():Splice(...).__self
		end,
		
		Splice = function(Table, FromOrTo, To)
			Utilities.Assert("Methods.table.Splice", {not FromOrTo or type(FromOrTo) == "number" and math.floor(FromOrTo) == FromOrTo, not To or type(To) == "number" and math.floor(To) == To}, "Arguments 1 and 2 (if passed) must be integers!")
			local Table, IndexesToRemove, EntriesRemoved, FromOrTo, To = Utilities.GetUnwrappedObjects(Table), {}, 0, Utilities.GetRelativeRange(Table, FromOrTo, To)
			for Index in ipairs(Table) do
				if Index < FromOrTo or Index > To then
					table.insert(IndexesToRemove, Index)
				end
			end
			for __, Index in next, IndexesToRemove do
				table.remove(Table, Index - EntriesRemoved)
				EntriesRemoved = EntriesRemoved + 1
			end
			return Table
		end,
		
		Each = function(Table, Callback, DeepApply)
			Utilities.Assert("Methods.table.Each", _(Callback):IsType("Function"), "Argument 1 must be a function!")
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if type(Value) == "table" and DeepApply then
					_(Value):Each(Callback, true)
				else
					Callback(Key, Value)
				end
			end
			return Table
		end,
		
		Map = function(Table, Callback, DeepMap)
			Utilities.Assert("Methods.table.Map", _(Callback):IsType("Function"), "Argument 1 must be a function!")
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if type(Value) == "table" and DeepMap then
					rawset(Table, Key, _(Value):Each(Callback, true).__self)
				else
					rawset(Table, Key, Callback(Key, Value))
				end
			end
			return Table
		end,
		
		Every = function(Table, Callback)
			Utilities.Assert("Methods.table.Every", _(Callback):IsType("Function"), "Argument 1 must be a function!")
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if not Callback(Key, Value) then
					return false
				end
			end
			return true
		end,
		
		Some = function(Table, Callback)
			Utilities.Assert("Methods.table.Some", _(Callback):IsType("Function"), "Argument 1 must be a function!")
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if Callback(Key, Value) then
					return true
				end
			end
			return false
		end,

		Filter = function(Table, Callback, DeepFilter)
			Utilities.Assert("Methods.table.Filter", _(Callback):IsType("Function"), "Argument 1 must be a function!")
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if type(Value) == "table" and DeepFilter then
					rawset(Table, Key, _(Value):Filter(Callback, true))
				elseif not Callback(Key, Value) == true then
					rawset(Table, Key, nil)
				end
			end
			return Table
		end,
		
		Flatten = function(Table, Overwrite)
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				--Value = Utilities.GetUnwrappedObjects(Value)
				if type(Value) == "table" then
					for Key, Value in next, _(Value):Flatten(Overwrite).__self do
						if Table[Key] ~= nil and not Overwrite then
							table.insert(Table, Value)
						else
							rawset(Table, Key, Value)
						end
					end
					rawset(Table, Key, nil)
				end
			end
			return Table
		end,
		
		Sort = function(Table, Callback)
			Table = Utilities.GetUnwrappedObjects(Table)
			table.sort(Table, Callback)
			return Table
		end,
		
		Reverse = function(Table) --Only reverses numeric indexed values
			local Values = _(Table):GetIndexed("Values", true).__self
			for Key in next, Utilities.GetUnwrappedObjects(Table) do
				if type(Key) == "number" then
					Table[Key] = Values[#Values - Key + 1]
				end
			end
			return Table
		end,
		
		Join = function(Table, Delimiter, UseRBXunderscoreToString)
			local String, Delimiter = "", Delimiter or ""
			for __, Value in next, Utilities.GetUnwrappedObjects(Table) do
				String = String .. (UseRBXunderscoreToString and _(Value):ToString().__self or tostring(Value)) .. Delimiter
			end
			return (String:gsub(_(Delimiter):PrepareAsRegularExpression().__self .. "$", ""))
		end,
		
		Concatenate = function(Table, Object, Overwrite, OverwriteNumericIndexes)
			if _(Object):IsType("Table") then
				for Key, Value in next, Utilities.GetUnwrappedObjects(Object) do
					if type(Key) == "number" and not (OverwriteNumericIndexes or Table.__overwritenumindex) then
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
		
		Equals = function(Table, OtherTable, IgnoreNumericIndexes)
			Utilities.Assert("Methods.table.Equals", _(OtherTable):IsType("Table"), "Argument 1 must be a table!")
			Table, OtherTable = Utilities.GetUnwrappedObjects(Table, OtherTable)
			local IndexedComparison = {{}, {}}
			for Key, Value in next, Table do
				if type(Key) == "number" and IgnoreNumericIndexes then
					table.insert(IndexedComparison[1], Value)
				elseif OtherTable[Key] ~= Value then
					return false
				end
			end
			for Key, Value in next, OtherTable do
				if type(Key) == "number" and IgnoreNumericIndexes then
					table.insert(IndexedComparison[2], Value)
				elseif Table[Key] ~= Value then
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
			for Index, Instance in next, Utilities.GetUnwrappedObjects(Table) do
				if pcall(function() return Instance.Name end) then
					NewTable[Instance.Name] = Instance
				else
					table.insert(NewTable, Instance)
				end
			end
			return NewTable
		end,
		
		ToString = function(Table, Separator, Begin, End)
			local String = ""
			for Key, Value in next, Utilities.GetUnwrappedObjects(Table) do
				if Key == End then
					break
				elseif Key ~= "__sep" and (not Begin or Key == Begin) then
					Value = tostring(_(Value))
					String = String .. (type(Key) == "number" and Value or tostring(_(Key)) .. " = " .. Value) .. (Separator or Table.__sep or ", ")
				end
			end
			return (Separator and "" or "Table[" .. tostring(Table):match("%w+$") .. "]{") .. String:gsub((Separator or Table.__sep or ", ") .. "$", "") .. (Separator and "" or "}")
		end,
		
		GetSize = function(Table)
			local Size = 0
			for __ in next, Utilities.GetUnwrappedObjects(Table) do
				Size = Size + 1
			end
			return Size
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
			return setfenv(Utilities.GetUnwrappedObjects(Function), Environment or getfenv(Function))(...)
		end,
		
		Call = function(Function, Self, ...)
			return _(Function):BindToEnvironment({self = Self})(...)
		end,
		
		Apply = function(Function, Self, Arguments)
			Utilities.Assert("Methods.function.Apply", not Arguments or type(Arguments) == "table", "Argument 2 must be nil or a table!")
			return _(Function):BindToEnvironment({self = Self})(Arguments and unpack(Arguments) or nil)
		end,
		
		RunAsThread = function(Function, ...) --Returns coroutine
			return _(Utilities.GetUnwrappedObjects(Function)):ToThread():ResumeThread(...)
		end,
		
		ToThread = function(Function) --Returns coroutine
			return coroutine.create(Utilities.GetUnwrappedObjects(Function))
		end,
		
		ToThreadedFunction = function(Function) --Returns function
			return coroutine.wrap(Utilities.GetUnwrappedObjects(Function))
		end,
		
		ToString = function(Function)
			return "Function[" .. tostring(Utilities.GetUnwrappedObjects(Function)):match("%w+$") .. "]"
		end
	},
	
	thread = {
		ResumeThread = function(Thread, ...)
			return coroutine.resume(Utilities.GetUnwrappedObjects(Thread), ...) and Thread
		end,
		
		GetThreadStatus = function(Thread)
			return coroutine.status(Utilities.GetUnwrappedObjects(Thread))
		end,
		
		IsRunningThread = function(Thread)
			return coroutine.running() == Utilities.GetUnwrappedObjects(Thread)
		end,
		
		ToString = function(Thread)
			return "Thread[" .. tostring(Utilities.GetUnwrappedObjects(Thread)):match("%w+$") .. "]"
		end
	},
	
	userdata = {
		Instance = setmetatable({
			Part = {
				Test = function()
					return "ayy"
				end
			},
			
			Sound = {
				PlayAfter = function(Sound, Assets)
					Sound = Utilities.GetUnwrappedObjects(Sound)
					local Connection; Connection = Sound.Ended:connect(function()
						if type(Assets) == "table" then
							local Asset = table.remove(Assets)
							Utilities.Assert("Methods.userdata.Instance.Sound.PlayAfter", _(Asset):IsType("Content"), "The asset URI \"" .. Asset .. "\" is invalid.")
							Sound.SoundId = Asset
							Sound:Play()
							if #Assets == 0 then Connection:disconnect() end
						else
							Utilities.Assert("Methods.userdata.Instance.Sound.PlayAfter", _(Assets):IsType("Content"), "The asset URI \"" .. Assets .. "\" is invalid.")
							Sound.SoundId = Assets
							Sound:Play(); Connection:disconnect()
						end
					end)
				end
			},
			
			GetAllChildren = function(Instance, Properties, CaseInsensitive, PartialMatch, MatchAllProperties)
				local Instances = {}
				for __, Instance in next, Utilities.GetUnwrappedObjects(Instance):GetChildren() do
					local MatchedProperties = {}
					if pcall(function() return Instance:GetChildren() end) and #Instance:GetChildren() > 0 then
						for __, Instance in next, _(Instance):GetAllChildren(Properties, CaseInsensitive, PartialMatch, MatchAllProperties).__self do
							table.insert(Instances, Instance)
						end
					end
					if Properties then
						for Property, Value in next, Properties do
							if pcall(function() return Instance[Property] end) then
								for __, Value in next, type(Value) == "table" and Value or {Value} do
									if PartialMatch and _(tostring(Instance[Property])):MatchTest(Value, CaseInsensitive).__self or Instance[Property] == Value then
										MatchedProperties[Property] = Value
										table.insert(Instances, not _(Instances):Match("Value", Instance).__self and Instance or nil)
										break
									end
								end
							end
						end
						if MatchAllProperties and _(MatchedProperties):GetSize().__self > 0 then
							local Properties = _(Properties):Clone()
							for Property, Value in next, MatchedProperties do
								local Match = type(Properties[Property]) == "table" and _(Properties[Property]):Match("Value", Value).__self or Properties[Property]
								Properties[Property] = not Match and Properties[Property] or Match ~= nil and nil
							end
							if _(Properties):GetSize().__self > 0 then
								table.remove(Instances, _(Instances):IndexOf(Instance).__self)
							end
						end
					else
						table.insert(Instances, Instance)
					end
				end
				return Instances
			end,
			
			RemoveAllChildren = function(Instance, ...)
				for __, Instance in next, _(Instance):GetAllChildren(...).__self do
					Instance:Destroy()
				end
			end,
			
			GetAllMembers = function(Instance, Type)
				if type(Type) == "table" then
					local Entries = _({})
					for __, Type in next, Type do
						Type = Resources.Instance["All" .. Type]
						if Type then Entries:Concatenate(_(Type):Clone():Filter(function(__, Name) return pcall(function() return Instance[Name] end) and Instance[Name] ~= Instance:FindFirstChild(Name) end)) end
					end
					return Entries:Sort().__self
				elseif Type then
					return _(Resources.Instance["All" .. Type]):Clone():Filter(function(__, Name) return pcall(function() return Instance[Name] end) and Instance[Name] ~= Instance:FindFirstChild(Name) end).__self
				else
					return _(Resources.Instance):Clone():Flatten():Filter(function(__, Name) return pcall(function() return Instance[Name] and Instance[Name] ~= Instance:FindFirstChild(Name) end) end):Sort().__self
				end
			end,
			
			GetAllClasses = function(Instance)
				local Instance, Classes = Utilities.GetUnwrappedObjects(Instance), {}
				for __, Class in next, Resources.Instance.AllClasses do
					table.insert(Classes, Instance:IsA(Class) and Class or nil)
				end
				return Classes
			end,
			
			GetNest = function(Instance, Path)
				local LastLevel = Instance
				for Level in Path:gmatch("%.-[^%.]+") do
					local Level = Level:gsub("^%.", "")
					if not LastLevel:FindFirstChild(Level) then return nil end
					LastLevel = LastLevel:FindFirstChild(Level)
				end
				return LastLevel
			end,
			
			CreateNest = function(Instance, Path, Type, Content, ReturnNest)
				local LastLevel = Instance
				for Level in Path:gmatch("%.-[^%.]+") do
					Level = (Level:gsub("^%.", ""))
					LastLevel = LastLevel:FindFirstChild(Level) or (function(Instance) Instance.Name = Level; return Instance end)(Instance.new(Type, LastLevel))
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
			
			SetProperties = function(Instance, Properties)
				Instance = Utilities.GetUnwrappedObjects(Instance)
				for Property, Value in next, Properties do
					Instance[Property] = Value
				end
				return Instance
			end,
			
			SetCustomMethod = function(...)
				_.Instance.SetCustomMethod(...)
			end,
			
			Serialize = function(Instance, IncludeChildren, ExcludedProperties, ReturnAsTable)
				Utilities.Assert("Methods.userdata.Instance.Serialize", not ExcludedProperties or type(ExcludedProperties) == "table" and _(ExcludedProperties):Every(function(__, Property) return type(Property) == "string" end).__self, "Argument 2 must be a table that contains only strings!")
				Instance = Utilities.GetUnwrappedObjects(Instance)
				local Children, Output = Instance:GetChildren(), {__children = {}}
				for __, Member in next, _(Instance):GetAllMembers("Properties").__self do
					if (not ExcludedProperties or not ExcludedProperties[Member]) and Member ~= "Parent" then
						local Successful, Error = pcall(function()
							local MemberType = type(Instance[Member])
							if MemberType == "string" or MemberType == "boolean" or MemberType == "table" then
								Output[Member] = Instance[Member]
							elseif MemberType == "number" then
								Output[Member] = _(Instance[Member]):Round(8).__self
							elseif MemberType == "userdata" then
								local _Member = _(Instance[Member])
								if _Member:IsType("Instance") then
									if _Member:IsDescendantOf(Instance).__self and IncludeChildren then
										table.insert(Output.__children, _Member:Serialize(true, ExcludedProperties, true).__self)
										Output[Member] = "__children[" .. #Output.__children .. "]"
									else
										Output[Member] = "__return[" .. Instance[Member]:GetFullName() .. "]"
									end
								else
									Output[Member] = "__$" .. tostring(_Member)
								end
							elseif MemberType ~= "nil" then
								Utilities.Log("Warning", "Methods.userdata.Instance.Serialize", "Unable to serialize property \"" .. Member .. "\" because it's a " .. MemberType .. "!")
							end
						end)
						if not Successful then
							Utilities.Log("Warning", "Methods.userdata.Instance.Serialize", "Unable to serialize property \"" .. Member .. "\": " .. Error)
						end
					end
				end
				if IncludeChildren and #Children > 0 then
					for __, Child in next, Children do
						table.insert(Output.__children, _(Child):Serialize(IncludeChildren, ExcludedProperties, true).__self)
					end
				elseif #Output.__children == 0 then
					Output.__children = nil
				end
				return ReturnAsTable and Output or Services.HttpService:JSONEncode(Output)
			end,
			
			GetSize = function(Instance, IncludeChildren)
				Instance = Utilities.GetUnwrappedObjects(Instance)
				if IncludeChildren then
					local Size = 0
					for __ in next, _(Instance):GetAllChildren() do
						Size = Size + 1
					end
					return Size
				else
					return #Instance:GetChildren()
				end
			end
		}, {
			__index = function(Self, Key)
				local Object = rawget(Self, Key)
				if type(Object) == "table" and getmetatable(Object) ~= "The metatable is locked" then
					Self[Key] = nil; Self[Key] = Object --Invoke __newindex
				end
				return rawget(Self, Key)
			end,
			
			__newindex = function(Self, Key, Value)
				if type(rawget(Self, Key)) ~= "function" then
					rawset(Self, Key, type(Value) == "table" and setmetatable({Internal = Value, Custom = {}}, {
						__index = function(Self, Name)
							if Name:sub(1, 1) == "_" then
								return rawget(Self, "Internal")[Name:sub(2)]
							else
								return rawget(Self, "Custom")[Name] or rawget(Self, "Internal")[Name]
							end
						end,
						__newindex = function(Self, Name, Method)
							rawget(Self, "Custom")[Name] = Method
						end,
						__metatable = "The metatable is locked"
					}) or Value)
				end
			end,
		}),
		
		--Miscellaneous userdata methods
		GetNest = function(Object, Path) --Attempt to get nest as if object is a table
			return _.Table.GetNest(Object, Path)
		end,
		
		ToString = function(Object)
			local Object, String = _(Object), ""
			if Utilities.CanCheckType(Object) then
				local Object, Type = Utilities.GetUnwrappedObjects(Object), Object:GetDataType().__self
				if Type == "Instance" then
					String = pcall(function() return Object.Name end) and (Object.Name .. (Object.Name ~= Object.ClassName and (" <" .. (#Object.ClassName > 0 and Object.ClassName or "Unknown") .. ">") or "")) or (tostring(Object) .. " <Unknown>")
				elseif Type == "Event" then
					String = tostring(Object):gsub("^Signal ", "")
				elseif Type == "NumberSequence" then
					for __, Keypoint in next, Object.Keypoints do
						String = String .. Keypoint.Time .. ": [" .. Keypoint.Value .. " | " .. Keypoint.Envelope .. "]; "
					end
					String = String:gsub("; $", "")
				elseif Type == "ColorSequence" then
					for __, Keypoint in next, Object.Keypoints do
						String = String .. Keypoint.Time .. ": [" .. tostring(Keypoint.Value) .. " | " .. tostring(Keypoint):match("(%d+[%.%d+]*) $") .. "]; "
					end
					String = String:gsub("; $", "")
				elseif Type == "NumberRange" then
					String = Object.Min .. ", " .. Object.Max
				elseif Type == "Axes" or Type == "Faces" then
					String = not (Object.Left or Object.Right or Object.Top or Object.Bottom or Object.Front or Object.Back) and "None" or ((Object.Left and "Left, " or "") .. (Object.Right and "Right, " or "") .. (Object.Top and "Top, " or "") .. (Object.Bottom and "Bottom, " or "") .. (Object.Front and "Front, " or "") .. (Object.Back and "Back" or "")):gsub(", $", "")
				elseif Type == "EnumerationItem" then
					String = tostring(Object):gsub("^Enum.", "")
				elseif tostring(Object):match("^%w+: %w+$") then
					String = tostring(Object):match("%w+$")
				elseif Type ~= "Connection" then
					String = tostring(Object)
				end
			else
				String = tostring(Object.__self) .. " <Unknown>"
			end
			return (type(Object.__self) == "userdata" and (Utilities.CanCheckType(Object) and pcall(function() return Object.ClassName end) and Object:IsType("Service") and "Service" or Object:GetDataType().__self) or tostring(Object.__self):match("^%w+"):gsub("^(%w)", string.upper)) .. "[" .. String .. "]"
		end,
		
		GetDataType = function(Object)
			Object = Utilities.GetUnwrappedObjects(Object)
			for DataType, Test in next, {
				Instance = function() return Object.IsA end,
				Vector2 = function() return Object + Vector2.new() end,
				Vector2int16 = function() return Object + Vector2int16.new() end,
				Vector3 = function() return Object + Vector3.new() end,
				Vector3int16 = function() return Object + Vector3int16.new() end,
				CFrame = function() if pcall(function() return Object.IsA end) then error() end; return Object.p end,
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
				EnumerationItem = function() if pcall(function() return Object.IsA end) then error() end; return Object.Name and Object.Value end,
				Event = function() return Object.connect end,
				Connection = function() return Object.disconnect end,
				Proxy = function() if Utilities.IsROBLOXUserdata(Object) then error() end end
			} do
				if pcall(Test) then return DataType end
			end
			return "Unknown"
		end
	},
	
	["nil"] = {
		Test = function()
			return "Nice nil you've got there!"
		end
	}
}
ProxySharedMetamethods = {
	Equals = function(Object, EqualsTo)
		local Object, Metamethod = Utilities.GetUnwrappedObjects(Object), Utilities.GetSpecificProxyMethod(Object, "Equals")
		return _(Metamethod and Metamethod(Object, EqualsTo) or Object == Utilities.GetUnwrappedObjects(EqualsTo))
	end,
	
	IsLessThan = function(Object, CompareWith)
		local Object, Metamethod = Utilities.GetUnwrappedObjects(Object), Utilities.GetSpecificProxyMethod(Object, "IsLessThan")
		return _(Metamethod and Metamethod(Object, CompareWith) or Object < Utilities.GetUnwrappedObjects(CompareWith))
	end,
	
	IsLessThanOrEqualTo = function(Object, CompareWith)
		local Object, Metamethod = Utilities.GetUnwrappedObjects(Object), Utilities.GetSpecificProxyMethod(Object, "IsLessThanOrEqualTo")
		return _(Metamethod and Metamethod(Object, CompareWith) or Object <= Utilities.GetUnwrappedObjects(CompareWith))
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
		for __, Object in next, select("#", ...) == #{...} and {...} or (function(...) local Arguments = {...}; for Index = 1, select("#", ...) do Arguments[Index] = Arguments[Index] ~= nil and Arguments[Index] or "__nil" end; return Arguments end)(...) do
			if type(Object) == "userdata" and pcall(function() return Object.__self end) and type(Object.__type) ~= "nil" then --Already wrapped
				table.insert(Proxies, Object)
			else
				local Object, Proxy = (function() if Object == "__nil" then return nil else return Object end end)(), newproxy(true)
				local ProxyMetatable = getmetatable(Proxy)
				for Metamethod, Function in next, {
					__index = function(__, Key)
						if Key == "__self" then
							return Object
						elseif Key == "__type" then
							return type(Object)
						elseif Key == "IsType" then
							return function(Object, Type)
								local _Object = Object.__self
								if type(_Object) == "userdata" then
									return Type:lower() == "userdata" and true or (Object:GetDataType().__self == "Instance" and (Type:lower() == "service" and _Object == (#_Object.ClassName > 0 and game:FindService(_Object.ClassName)) or _Object:IsA(Type)) or Object:GetDataType().__self == Type)
								elseif type(_Object) == "number" then
									local Type, __, Decimal = Type:lower(), math.modf(_Object)
									return Type == "integer" and Decimal == 0 or Type == "float" and Decimal > 0
								elseif type(_Object) == "string" then
									_Object = _Object:lower()
									return (Type:lower() == "content" or Type:lower() == "asset") and pcall(function() Services.ContentProvider:PreloadAsync({_Object}) end) or nil
								else
									return type(_Object) == Type:lower()
								end
								--return type(_Object) == "userdata" and (Type:lower() == "userdata" and true or (Object:GetDataType().__self == "Instance" and (Type:lower() == "service" and _Object == (#_Object.ClassName > 0 and game:FindService(_Object.ClassName)) or _Object:IsA(Type)) or Object:GetDataType().__self == Type)) or type(_Object) == "number" and (function(Number) local __, Decimal = math.modf(Number); return Type:lower() == "integer" and Decimal == 0 or Type:lower() == "float" and Decimal > 0 or nil end)(_Object) or type(_Object) == "string" and Type:lower():match("^content") and pcall(function() Services.ContentProvider:PreloadAsync({_Object}) end) or type(_Object) == Type:lower()
							end
						elseif Key == "Unwrap" then
							return Utilities.GetUnwrappedObjects
						else
							return _(Utilities.GetSpecificProxyMethod(Object, Key) or Object[Key])
						end
					end,
					
					__newindex = function(__, Key, Value)
						Object[Key] = Value
					end,
					
					__len = function()
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Get" .. ((type(Object) == "string" or type(Object) == "number") and "Length" or "Size"))
						return _(Metamethod and Metamethod(Object) or #Object)
					end,
					
					__tostring = function() --Must return a string to "print" function
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "ToString")
						return Metamethod and Metamethod(Object) or tostring(Object)
					end,
					
					__concat = function(__, ConcatenateWith)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Concatenate")
						return _(Metamethod and Metamethod(Object, ConcatenateWith) or Object .. ConcatenateWith)
					end,
					
					__call = function(__, ...)
						local Arguments = {...}
						for Key, Value in next, Arguments do
							Arguments[Key] = Utilities.GetUnwrappedObjects(Value)
						end
						return _(Object(unpack(Arguments)))
					end,
					
					__eq = ProxySharedMetamethods.Equals,
					__lt = ProxySharedMetamethods.IsLessThan,
					__le = ProxySharedMetamethods.IsLessThanOrEqualTo,
					
					__add = function(__, AddWith)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Add")
						return _(Metamethod and Metamethod(Object, AddWith) or Object + Utilities.GetUnwrappedObjects(AddWith))
					end,
					
					__sub = function(__, SubtractWith)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Subtract")
						return _(Metamethod and Metamethod(Object, SubtractWith) or Object - Utilities.GetUnwrappedObjects(SubtractWith))
					end,
					
					__mul = function(__, MultiplyWith)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Multiply")
						return _(Metamethod and Metamethod(Object, MultiplyWith) or Object * Utilities.GetUnwrappedObjects(MultiplyWith))
					end,
					
					__div = function(__, DivideWith)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Divide")
						return _(Metamethod and Metamethod(Object, DivideWith) or Object / Utilities.GetUnwrappedObjects(DivideWith))
					end,
					
					__mod = function(__, ModuloWith)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Modulo")
						return _(Metamethod and Metamethod(Object, ModuloWith) or math.fmod(Object, Utilities.GetUnwrappedObjects(ModuloWith)))
					end,
					
					__pow = function(__, Exponent)
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Power")
						return _(Metamethod and Metamethod(Object, Exponent) or math.pow(Object, Utilities.GetUnwrappedObjects(Exponent)))
					end,
					
					__unm = function()
						local Metamethod = Utilities.GetSpecificProxyMethod(Object, "Negate")
						return _(Metamethod and Metamethod(Object) or -Object)
					end,
					
					__metatable = function() Utilities.Log("Error", nil, "You are not allowed to make changes to the framework.") end
				} do rawset(ProxyMetatable, Metamethod, Function) end
				table.insert(Proxies, Proxy)
			end
		end
		return unpack(Proxies)
	end,
	__metatable = function() Utilities.Log("Error", nil, "You are not allowed to make changes to the framework.") end
} do rawset(Metatable, Metamethod, Function) end


--Userdata type detection/tostring test
print("==========Userdata type detection/tostring test==========\n[Type] - [RBXunderscore tostring'd]")
for Type, Object in next, {
	Instance = Workspace.Terrain,
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
	EnumerationItem = Enum.Font.Legacy,
	Event = game.Changed,
	Connection = game.Changed:connect(function() end),
	Proxy = newproxy()
} do
	print(Type, "-", _(Object))
end
print("=========================")

--Get all children within an instance (arguments: properties, case-insensitive, partial match, match every property [only one in each subarray])
--_(Workspace):GetAllChildren({
--	Name = {"fun", "ent", "bill", "ca"}, --Table of properties [match only one]
--	ClassName = "bind" --Single property
--}, true, true, true):Each(function(_, Instance) print("GetAllChildren instance:", Instance:GetFullName(), "-", Instance.ClassName) end)

--Event creation, binding, unbinding
-- _.Event.Create("ayy", function() while true do Event:fire("I'm still working!", wait(0.5)) end end)
-- Attachment = _.Event.Attach("ayy", function(Message) print(tick(), Message) end, "lmao")
-- print("Event attached:", _(Functions.Event.GetAllConnections("ayy")))
-- wait(3)
-- _.Event.Detach(Attachment or unpack({"ayy", "lmao"})) --Detach using the attachment or tag
-- print("Event detached:", Functions.Event.GetAllConnections())

--for ChildTable, Key, Value in Utilities.TraverseAllChildTables(Resources) do
--	print("Table:", ChildTable, "| Key:", Key, "| Value:", Value)
--end

print("Every property of Workspace:", _(Workspace):GetAllMembers("Properties"))
print("Every class of a Part:", _(Workspace.BasePlate):GetAllClasses())
print(_("0: [0, 0, 0 | 0]; 1: [0, 0, 0 | 0]"):Split(";"))
game.SoundService.Sound:Play(); _(game.SoundService.Sound):PlayAfter(136242893)
--print(_(Workspace:WaitForChild("Player1")):Serialize(true):Unserialize(game))
