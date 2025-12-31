-- ================= SERVICES ================= -> ;)
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ================= VARS =================
local jump = false
local rodando = false
local apenas_jump = false


-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "ContadorGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25, 0.6)
frame.Position = UDim2.fromScale(0.375, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- ================= TOP BAR =================
local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.fromScale(1, 0.15)
topBar.BackgroundTransparency = 1
topBar.Active = true

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.fromScale(0.8, 1)
title.BackgroundTransparency = 1
title.Text = "JJs AUTOMÁTICO!"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local minimizeBtn = Instance.new("TextButton", topBar)
minimizeBtn.Size = UDim2.fromScale(0.2, 1)
minimizeBtn.Position = UDim2.fromScale(0.8, 0)
minimizeBtn.Text = "–"
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true

-- ================= CONTENT =================
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -topBar.AbsoluteSize.Y - 80)
content.Position = UDim2.fromScale(0, 0.15)
content.BackgroundTransparency = 1

local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0, 14)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= INPUT =================
local input = Instance.new("TextBox", content)
input.Size = UDim2.fromScale(0.85, 0.16)
input.PlaceholderText = "Até quanto contar?"
input.TextScaled = true
input.Font = Enum.Font.Gotham
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input).CornerRadius = UDim.new(0,10)

-- ================= START =================
local startBtn = Instance.new("TextButton", content)
startBtn.Size = UDim2.fromScale(0.85, 0.16)
startBtn.Text = "INICIAR"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,10)

-- ================= APENAS PULAR ==========
local apenas_pular = Instance.new("TextButton", content)
apenas_pular.Size = UDim2.fromScale(0.85, 0.16)
apenas_pular.Text = "APENAS PULAR"
apenas_pular.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
apenas_pular.TextScaled = true
apenas_pular.Font = Enum.Font.GothamBold
Instance.new("UICorner", apenas_pular).CornerRadius = UDim.new(0,10)

-- ================= BOTTOM BAR =================
local bottomBar = Instance.new("Frame", frame)
bottomBar.Size = UDim2.new(1, -20, 0, 60)
bottomBar.Position = UDim2.new(0, 10, 1, -70)
bottomBar.BackgroundTransparency = 1

local stopBtn = Instance.new("TextButton", bottomBar)
stopBtn.Size = UDim2.new(0.48, 0, 1, 0)
stopBtn.Position = UDim2.new(0, 0, 0, 0)
stopBtn.Text = "PARAR"
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextScaled = true
stopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,10)

local pular = Instance.new("TextButton", bottomBar)
pular.Size = UDim2.new(0.48, 0, 1, 0)
pular.Position = UDim2.new(0.52, 0, 0, 0)
pular.Text = "PULAR"
pular.BackgroundColor3 = Color3.fromRGB(8,8,170)
pular.TextScaled = true
pular.Font = Enum.Font.GothamBold
Instance.new("UICorner", pular).CornerRadius = UDim.new(0,10)

-- ================= ICON =================
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.07, 0.1)
icon.Position = UDim2.fromScale(0.02, 0.8)
icon.Text = "🔢"
icon.TextScaled = true
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.TextColor3 = Color3.new(1,1,1)
icon.Font = Enum.Font.GothamBold
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- ================= DRAG =================
local dragging, dragStart, startPos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function()
	dragging = false
end)

-- ================= APENAS PULAR ================
apenas_pular.MouseButton1Click:Connect(function()
	if (apenas_jump == true) then
		apenas_jump = false
		apenas_pular.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
	else
		apenas_jump = true
		apenas_pular.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end)

-- ================= PULAR TOGGLE =================
pular.MouseButton1Click:Connect(function()
	jump = not jump
	pular.BackgroundColor3 = jump
		and Color3.fromRGB(170,0,0)
		or Color3.fromRGB(8,8,170)
end)

-- ================= MINIMIZE =================
minimizeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	frame.Visible = true
	icon.Visible = false
end)

-- ================= LÓGICA =================
local unidades = {"ZERO","UM","DOIS","TRÊS","QUATRO","CINCO","SEIS","SETE","OITO","NOVE"}
local especiais = {"DEZ","ONZE","DOZE","TREZE","QUATORZE","QUINZE","DEZESSEIS","DEZESSETE","DEZOITO","DEZENOVE"}
local dezenas = {"","","VINTE","TRINTA","QUARENTA","CINQUENTA","SESSENTA","SETENTA","OITENTA","NOVENTA"}
local centenas = {"","CENTO","DUZENTOS","TREZENTOS","QUATROCENTOS","QUINHENTOS","SEISCENTOS","SETECENTOS","OITOCENTOS","NOVECENTOS"}

local function porExtenso(n)
	if n == 100 then return "CEM" end
	if n < 10 then return unidades[n+1] end
	if n < 20 then return especiais[n-9] end
	if n < 100 then
		local d = dezenas[math.floor(n/10)+1]
		local u = n % 10
		return u > 0 and d.." E "..unidades[u+1] or d
	end
	if n < 1000 then
		local c = centenas[math.floor(n/100)+1]
		local r = n % 100
		return r > 0 and c.." E "..porExtenso(r) or c
	end
	return tostring(n)
end

local function pular_jump()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

local function enviarChat(msg)
	TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
end

local function pular_vezes(quantidade)
	if (apenas_jump == true) then
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")

		for i = 1, quantidade do
			if (apenas_jump == false or rodando == false) then
				break
				
			end
			if (pular_jump == true) then
				apenas_pular.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
			end
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.5)
		end
		apenas_pular.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
		
	end
	
	
end

startBtn.MouseButton1Click:Connect(function()
	local limite = tonumber(input.Text)
	if not limite then return end
	rodando = true
	
	if (apenas_jump == true) then
		if (jump == true) then
			jump = false
			pular.BackgroundColor3 = Color3.fromRGB(8,8, 170)
			local quantidade = tonumber(input.Text)
			pular_vezes(quantidade)
		else
			local quantidade = tonumber(input.Text)
			pular_vezes(quantidade)
		end
	
	else
		task.spawn(function()
			for i = 1, limite do
				if not rodando then break end
				enviarChat(porExtenso(i).."!")
				if jump then pular_jump() end
				if (apenas_jump == true) then
					apenas_jump = false
					apenas_pular.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
				end
				task.wait(3)
			end
		end)
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	rodando = false
	jump = false
	apenas_jump = false
	pular.BackgroundColor3 = Color3.fromRGB(8,8,170)
	apenas_pular.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
end)
