--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--// PLAYER
local Player = Players.LocalPlayer

--==================================================
-- GUI BASE
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- MAIN CONTAINER
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromScale(0.45, 0.6)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main




--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0.12, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

-- CORREÇÃO VISUAL (cantos inferiores retos)
local Fix = Instance.new("Frame")
Fix.Parent = TopBar
Fix.Position = UDim2.new(0,0,1,-14)
Fix.Size = UDim2.new(1,0,0,14)
Fix.BackgroundColor3 = TopBar.BackgroundColor3
Fix.BorderSizePixel = 0

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar -- ou qualquer aba
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255, 90, 150)
CloseButton.BackgroundColor3 = Color3.fromRGB(15,15,15)
CloseButton.BorderSizePixel = 0

CloseButton.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "By Danivinii"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 60, 150) -- ROSA
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center

--==================================================
-- BODY
--==================================================

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Parent = Main
Body.Position = UDim2.new(0, 0, 0.12, 0)
Body.Size = UDim2.new(1, 0, 0.88, 0)
Body.BackgroundTransparency = 1

--==================================================
-- SIDEBAR (ABAS)
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = Body
Sidebar.Size = UDim2.new(0.22, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Sidebar.BorderSizePixel = 0

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = Sidebar
SideLayout.Padding = UDim.new(0, 8)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local SidePadding = Instance.new("UIPadding")
SidePadding.Parent = Sidebar
SidePadding.PaddingTop = UDim.new(0, 10)

--==================================================
-- CONTENT AREA (PÁGINAS)
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Body
Content.Position = UDim2.new(0.22, 0, 0, 0)
Content.Size = UDim2.new(0.78, 0, 1, 0)
Content.BackgroundTransparency = 1






--==================================================
-- FRAMEWORK
--==================================================

local UI = {}
UI.Tabs = {}

--==================================================
-- FUNÇÃO: CRIAR ABA
--==================================================
-- name: Nome da aba
-- Retorna: Página (ScrollingFrame)
--==================================================

function UI:CreateTab(name)

	-- BOTÃO DA ABA
	local TabButton = Instance.new("TextButton")
	TabButton.Name = name .. "_Tab"
	TabButton.Parent = Sidebar
	TabButton.Size = UDim2.new(0.9, 0, 0, 42)
	TabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	TabButton.Text = name
	TabButton.Font = Enum.Font.Gotham
	TabButton.TextScaled = true
	TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	TabButton.BorderSizePixel = 0

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 8)
	TabCorner.Parent = TabButton

	-- PÁGINA
	local Page = Instance.new("ScrollingFrame")
	Page.Name = name .. "_Page"
	Page.Parent = Content
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.ScrollBarImageTransparency = 1
	Page.Visible = false
	Page.BackgroundTransparency = 1

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Parent = Page
	PageLayout.Padding = UDim.new(0, 10)

	local PagePadding = Instance.new("UIPadding")
	PagePadding.Parent = Page
	PagePadding.PaddingTop = UDim.new(0, 12)
	PagePadding.PaddingLeft = UDim.new(0, 12)

	-- AUTO RESIZE
	PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
	end)

	-- CLICK
	TabButton.MouseButton1Click:Connect(function()
		for _, v in pairs(Content:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = false
			end
		end
		Page.Visible = true
	end)

	UI.Tabs[name] = Page
	return Page
end




--==================================================
-- EXEMPLO DE CRIAÇÃO DE ABAS (SEM FUNÇÕES)
-- APAGUE SE QUISER
--==================================================

local eb = UI:CreateTab("EB")
eb.Visible = true

--# JJS

local jjs = Instance.new("TextButton")
jjs.Parent = eb
jjs.Size = UDim2.new(0.9, 0, 0, 45)
jjs.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
jjs.Text = "JJs AUTOMÁTICO v1.0"
jjs.TextColor3 = Color3.fromRGB(255,255,255)
jjs.Font = Enum.Font.Gotham
jjs.TextScaled = true
jjs.BorderSizePixel = 0

local Corner2 = Instance.new("UICorner")
Corner2.Parent = jjs
Corner2.CornerRadius = UDim.new(0, 8)

jjs.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/formatadousuario-stack/jjs-script/refs/heads/main/main.lua"))()
	Main.Visible = false
end)



local principal = UI:CreateTab("Main")
principal.Visible = true


local aviso = Instance.new("TextLabel")
aviso.Parent = principal
aviso.Size = UDim2.new(0.9, 0, 0, 45)
aviso.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aviso.Text = "Este Mod Menu foi desenvolvido com foco em oferecer praticidade e compatibilidade com diferentes experiências e jogos, facilitando a utilização de diversos scripts em um único lugar."
aviso.TextColor3 = Color3.fromRGB(255,255,255)
aviso.Font = Enum.Font.Gotham
aviso.TextScaled = true
aviso.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.Parent = aviso
Corner.CornerRadius = UDim.new(0, 8)


local aviso2 = Instance.new("TextLabel")
aviso2.Parent = principal
aviso2.Size = UDim2.new(0.9, 0, 0, 45)
aviso2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aviso2.Text = "O projeto encontra-se em constante desenvolvimento, com novos scripts e funcionalidades sendo criados e aprimorados regularmente."
aviso2.TextColor3 = Color3.fromRGB(255,255,255)
aviso2.Font = Enum.Font.Gotham
aviso2.TextScaled = true
aviso2.BorderSizePixel = 0

local Corner2 = Instance.new("UICorner")
Corner2.Parent = aviso2
Corner2.CornerRadius = UDim.new(0, 8)


local aviso3 = Instance.new("TextLabel")
aviso3.Parent = principal
aviso3.Size = UDim2.new(0.9, 0, 0, 45)
aviso3.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aviso3.Text = "Caso encontre qualquer problema, bug ou tenha dúvidas sobre o funcionamento do menu, entre em contato com Danivinii para suporte, feedback ou orientações."
aviso3.TextColor3 = Color3.fromRGB(255,255,255)
aviso3.Font = Enum.Font.Gotham
aviso3.TextScaled = true
aviso3.BorderSizePixel = 0

local Corner3 = Instance.new("UICorner")
Corner3.Parent = aviso2
Corner3.CornerRadius = UDim.new(0, 8)

