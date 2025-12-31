local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "ContadorGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25, 0.25)
frame.Position = UDim2.fromScale(0.375, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.fromScale(1, 0.2)
topBar.BackgroundTransparency = 1
topBar.Active = true

local title = Instance.new("TextLabel", topBar)
title.Text = "JJs AUTOMÁTICO!"
title.Size = UDim2.fromScale(0.8, 1)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local minimizeBtn = Instance.new("TextButton", topBar)
minimizeBtn.Text = "–"
minimizeBtn.Size = UDim2.fromScale(0.2, 1)
minimizeBtn.Position = UDim2.fromScale(0.8, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true

local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Até quanto contar?"
input.Size = UDim2.fromScale(0.8, 0.2)
input.Position = UDim2.fromScale(0.1, 0.3)
input.TextScaled = true
input.Font = Enum.Font.Gotham
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.TextColor3 = Color3.new(1,1,1)

local startBtn = Instance.new("TextButton", frame)
startBtn.Text = "INICIAR"
startBtn.Size = UDim2.fromScale(0.35, 0.2)
startBtn.Position = UDim2.fromScale(0.1, 0.6)
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Text = "PARAR"
stopBtn.Size = UDim2.fromScale(0.35, 0.2)
stopBtn.Position = UDim2.fromScale(0.55, 0.6)
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextScaled = true
stopBtn.Font = Enum.Font.GothamBold

local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.07, 0.1)
icon.Position = UDim2.fromScale(0.02, 0.8)
icon.Text = "🔢"
icon.TextScaled = true
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- ================= DRAG PC + MOBILE =================
local dragging = false
local dragStart
local startPos

local function iniciarDrag(input)
	dragging = true
	dragStart = input.Position
	startPos = frame.Position

	input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			dragging = false
		end
	end)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		iniciarDrag(input)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ================= MINIMIZAR =================
minimizeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	frame.Visible = true
	icon.Visible = false
end)

-- ================= LÓGICA =================
local rodando = false

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
		if u > 0 then return d.." E "..unidades[u+1] end
		return d
	end
	if n < 1000 then
		local c = centenas[math.floor(n/100)+1]
		local r = n % 100
		if r > 0 then return c.." E "..porExtenso(r) end
		return c
	end
	return tostring(n)
end

local function enviarChat(msg)
	TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
end

startBtn.MouseButton1Click:Connect(function()
	local limite = tonumber(input.Text)
	if not limite then return end
	rodando = true

	task.spawn(function()
		for i = 1, limite do
			if not rodando then break end
			enviarChat(porExtenso(i).."!")
			task.wait(3)
		end
	end)
end)

stopBtn.MouseButton1Click:Connect(function()
	rodando = false
end)
