extends Node2D

# Variabler för "click" systemet samt vilket läge den är i (Red, Green, Blue eller Yellow)
var storageNUM = []
var coincount = 0
var timerrounds = 0
var TOTALCPS = 0
var ColorMode = null
var TimeDone = false
var RNG = RandomNumberGenerator.new()
var BuildingNumbre = null
var YellowPressed = false

var WheelResult = null
# Change WheelTimerDone to false when you release the code right now it is true for bugg fixing
var WheelTimerDone = true
# För att man ska kunna uppdradera hur mycket man får per "click"
var mouseValue = 10000000000

# Variabler till lottery Wheel
var lotteryPrise = 15
var lotteryAmount = 0
var lotteryCPS = 0
var lotteryCPSAmount = 0.1

# Variabler till lottery Booth
var lotteryBoothPrise = 100
var lotteryBoothAmount = 0 
var lotteryBoothCPS = 0
var lotteryBoothCPSAmount = 1

# Variabler till carnival Games
var carnivalGamesPrise = 1100
var carnivalGamesAmount = 0 
var carnivalGamesCPS = 0 
var carnivalGamesCPSAmount = 8

# Variabler till Cotton Candy Booth
var cottonCandyBoothPrise = 12000
var cottonCandyBoothAmount = 0
var cottonCandyBoothCPS = 0 
var cottonCandyBoothCPSAmount = 47

# Variabler till FunFair
var funFariPrise = 130000
var funFariAmount = 0
var funFariCPS = 0
var funFariCPSAmount = 260

# Variabler till Amusement Park
var amusementParkPrise = 1400000
var amusementParkAmount = 0
var amusementParkCPS = 0
var amusementParkCPSAmount = 1400

# Variabler till Amusement City
var amusementCityPrise = 20000000
var amusementCityAmount = 0
var amusementCityCPS = 0
var amusementCityCPSAmount = 7800

# Variabler till Amusement Nation
var amusementNationPrise = 330000000
var amusementNationAmount = 0 
var amusementNationCPS = 0
var amusementNationCPSAmount = 44000

const amusementNationBaseCost = 330000000
const amusementCityBaseCost = 20000000
const amusementParkBaseCost = 1400000
const funFariBaseCost = 130000
const cottonCandyBoothBaseCost = 12000
const carnivalGamesBaseCost = 1100
const lotteryBoothBaseCost = 100
const mousespriteSPEED = 25
const lotteryBaseCost = 15

@onready var ColorTimer = $ColorTimer
@onready var MoneyLable = $ClickerManager/Money
@onready var CPSLable = $ClickerManager/CPS

@onready var LotteryWheelAmountLable = $Shop/TabSelector/Attractions/LotteryWheel/LotteryWheelAmount
@onready var LotteryWheelCostLable = $Shop/TabSelector/Attractions/LotteryWheel/LotteryWheelCost

@onready var LotteryBoothAmountLable = $Shop/TabSelector/Attractions/LotteryBooth/LotteryBoothAmount
@onready var LotteryBoothCostLable = $Shop/TabSelector/Attractions/LotteryBooth/LotteryBoothCost

@onready var CarnivalGamesAmountLable = $Shop/TabSelector/Attractions/CarnivalGames/CarnivalGamesAmount
@onready var CarnivalGamesCostLable = $Shop/TabSelector/Attractions/CarnivalGames/CarnivalGamesCost

@onready var CottonCandyBoothAmountLable = $Shop/TabSelector/Attractions/CottonCandyBooth/CottonCandyBoothAmount
@onready var CottonCandyBoothCostLable = $Shop/TabSelector/Attractions/CottonCandyBooth/CottonCandyBoothCost

@onready var FunfairAmountLable = $Shop/TabSelector/Attractions/Funfair/FunfairAmount
@onready var FunfairCostLable = $Shop/TabSelector/Attractions/Funfair/FunfairCost

@onready var AmusementParkAmountLable = $Shop/TabSelector/Attractions/AmusementPark/AmousementParkAmount
@onready var AmusementParkCostLable = $Shop/TabSelector/Attractions/AmusementPark/AmousementParkCost

@onready var AmusementCityAmountLable = $Shop/TabSelector/Attractions/AmusementCity/AmusementCityAmount
@onready var AmusementCityCostLable = $Shop/TabSelector/Attractions/AmusementCity/AmusementCityCost

@onready var AmusementNationAmountLable = $Shop/TabSelector/Attractions/AmusementNation/AmusementNationAmount
@onready var AmusementNationCostLable = $Shop/TabSelector/Attractions/AmusementNation/AmusementNationCost

# Bara så att man inte behöver vänta 1 sek för att texten ska komma fram
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	MoneyLable.text = str("Tickets: ", round(coincount))
	CPSLable.text = str("This is your TPS ", TOTALCPS)
	
	LotteryWheelAmountLable.text = str("Amount: ", lotteryAmount)
	LotteryWheelCostLable.text = str("Cost: ", round(lotteryPrise))
	
	LotteryBoothAmountLable.text = str("Amount: ",lotteryBoothAmount)
	LotteryBoothCostLable.text = str("Cost: ", round(lotteryBoothPrise))
	
	CarnivalGamesAmountLable.text = str("Amount: ",carnivalGamesAmount)
	CarnivalGamesCostLable.text = str("Cost: ", round(carnivalGamesPrise))
	
	CottonCandyBoothAmountLable.text = str("Amount: ", cottonCandyBoothAmount)
	CottonCandyBoothCostLable.text = str("Cost: ", round(cottonCandyBoothPrise))
	
	FunfairAmountLable.text = str("Amount: ", funFariAmount)
	FunfairCostLable.text = str("Cost: ", round(funFariPrise))
	
	AmusementParkAmountLable.text = str("Amount: ", amusementParkAmount)
	AmusementParkCostLable.text = str("Cost: ", round(amusementParkPrise))
	
	AmusementCityAmountLable.text = str("Amount: ", amusementCityAmount)
	AmusementCityCostLable.text = str("Cost: ", round(amusementCityPrise))
	
	AmusementNationAmountLable.text = str("Amount: ", amusementNationAmount)
	AmusementNationCostLable.text = str("Cost: ", round(amusementNationPrise))

# Funktion för att skapa en cirkel som varierar i färg som följer efter musen
func _physics_process(delta):
	var mouse_pos = get_local_mouse_position()
	$ColorSprite.position = $ColorSprite.position.lerp(mouse_pos, delta * mousespriteSPEED)

#///////////////////////////////////////////////////////

#area VÄNSTER UPP
func _on_area_vu_mouse_entered():
	storageNUM.append(1)
	$ColorSprite.texture = load("res://Silly Pictures/MouseRed.png")

#area HÖGER UPP
func _on_area_hu_mouse_entered():
	storageNUM.append(4)
	check_array()
	$ColorSprite.texture = load("res://Silly Pictures/MouseYellow.png")


#area VÄNSTER NER 
func _on_area_vn_mouse_entered():
	storageNUM.append(2)
	$ColorSprite.texture = load("res://Silly Pictures/MouseGreen.png")

#area HÖGER NER
func _on_area_hn_mouse_entered():
	storageNUM.append(3)
	$ColorSprite.texture = load("res://Silly Pictures/MouseBlue.png")

func _on_button_pressed():
	storageNUM.clear()

#///////////////////////////////////////////////////////

# Detta är den viktigaste func varje secund kommer det in "timeout" från timern och då kan vi kalla många functios
func _on_timer_timeout():
	Cps()
	timerrounds = timerrounds + 1
	print(timerrounds)
	check_color()
	printlables()

# The func printlables could technikly only be called every time a button is clicked
func printlables():
	
	MoneyLable.text = str("Tickets: ", round(coincount))
	CPSLable.text = str("This is your TPS ", TOTALCPS)
	
	LotteryWheelAmountLable.text = str("Amount: ", lotteryAmount)
	LotteryWheelCostLable.text = str("Cost: ", round(lotteryPrise))
	
	LotteryBoothAmountLable.text = str("Amount: ",lotteryBoothAmount)
	LotteryBoothCostLable.text = str("Cost: ", round(lotteryBoothPrise))
	
	CarnivalGamesAmountLable.text = str("Amount: ",carnivalGamesAmount)
	CarnivalGamesCostLable.text = str("Cost: ", round(carnivalGamesPrise))
	
	CottonCandyBoothAmountLable.text = str("Amount: ", cottonCandyBoothAmount)
	CottonCandyBoothCostLable.text = str("Cost: ", round(cottonCandyBoothPrise))
	
	FunfairAmountLable.text = str("Amount: ", funFariAmount)
	FunfairCostLable.text = str("Cost: ", round(funFariPrise))
	
	AmusementParkAmountLable.text = str("Amount: ", amusementParkAmount)
	AmusementParkCostLable.text = str("Cost: ", round(amusementParkPrise))
	
	AmusementCityAmountLable.text = str("Amount: ", amusementCityAmount)
	AmusementCityCostLable.text = str("Cost: ", round(amusementCityPrise))
	
	AmusementNationAmountLable.text = str("Amount: ", amusementNationAmount)
	AmusementNationCostLable.text = str("Cost: ", round(amusementNationPrise))


func Cps():
	TOTALCPS = lotteryCPS + lotteryBoothCPS + carnivalGamesCPS + cottonCandyBoothCPS + funFariCPS + amusementParkCPS + amusementCityCPS + amusementNationCPS
	coincount = coincount + TOTALCPS 

# Jag behöver addera lotteri hjulet (Grön Blå) och alla buildings för att Yellow ska ha random numgenerator
func check_color():
	if TimeDone == true:
		if ColorMode == "ColorRed":
			TOTALCPS = TOTALCPS * 1.01
		if ColorMode == "ColorGreen":
			pass
		if ColorMode == "ColorBlue":
			pass
		if ColorMode == "ColorYellow":
			if YellowPressed == true:
				if BuildingNumbre == 1:
					lotteryPrise = lotteryPrise * 0.9
				if BuildingNumbre == 2:
					lotteryBoothPrise = lotteryBoothPrise * 0.9
				if BuildingNumbre == 3:
					carnivalGamesPrise = carnivalGamesPrise * 0.9
				if BuildingNumbre == 4:
					cottonCandyBoothPrise = cottonCandyBoothPrise * 0.9
				if BuildingNumbre == 5:
					funFariPrise = funFariPrise * 0.9
				if BuildingNumbre == 6:
					amusementParkPrise = amusementParkPrise * 0.9
				if BuildingNumbre == 7:
					amusementCityPrise = amusementCityPrise * 0.9
				if BuildingNumbre == 8:
					amusementNationPrise = amusementNationPrise * 0.9
			YellowPressed = false

func check_array():
	if storageNUM.size() >= 4:
		coincount = coincount + mouseValue
		MoneyLable.text = str("Tickets: ", round(coincount))
		storageNUM.clear()

#///////////////////////////////////////////////////////

# Kod för lotteri hjulet
func _on_lottery_wheel_pressed():
	if coincount >= lotteryPrise:
		lotteryPrise = lotteryCalcul(lotteryAmount)
		lotteryAmount = lotteryAmount + 1
		coincount = coincount - lotteryPrise
		lotteryCPS = lotteryCPS + lotteryCPSAmount

# Funktion för att öka priset
func lotteryCalcul(x):
	return lotteryBaseCost * pow(1.15, x)

#/////////////////////////////////////////////////////////

# För att lottery Booth ska fungera
func _on_lottery_booth_pressed():
	if coincount >= lotteryBoothPrise:
		lotteryBoothPrise = lotteryBoothCalc(lotteryBoothAmount)
		lotteryBoothAmount = lotteryBoothAmount + 1
		coincount = coincount - lotteryBoothPrise
		lotteryBoothCPS = lotteryBoothCPS + lotteryBoothCPSAmount

func lotteryBoothCalc(x):
	return lotteryBoothBaseCost * pow(1.15, x)

#///////////////////////////////////////////////////////

# För att carnival games ska fungera
func _on_carnival_games_pressed():
	if coincount >= carnivalGamesPrise:
		carnivalGamesPrise = carnivalGamesCalc(carnivalGamesAmount)
		carnivalGamesAmount = carnivalGamesAmount + 1
		coincount = coincount - carnivalGamesPrise
		carnivalGamesCPS = carnivalGamesCPS + carnivalGamesCPSAmount

func carnivalGamesCalc(x):
	return carnivalGamesBaseCost * pow(1.15, x)

#///////////////////////////////////////////////////////

func _on_cotton_candy_booth_pressed():
	if coincount >= cottonCandyBoothPrise:
		cottonCandyBoothPrise = cottonCandyBoothCalc(cottonCandyBoothAmount)
		cottonCandyBoothAmount = cottonCandyBoothAmount + 1
		coincount = coincount - cottonCandyBoothPrise
		cottonCandyBoothCPS = cottonCandyBoothCPS + cottonCandyBoothCPSAmount

func cottonCandyBoothCalc(x):
	return cottonCandyBoothBaseCost * pow(1.15, x)

#///////////////////////////////////////////////////////

func _on_funfair_pressed():
	if coincount >= funFariPrise:
		funFariPrise = funFairCalc(funFariAmount)
		funFariAmount = funFariAmount + 1
		coincount = coincount - funFariPrise
		funFariCPS = funFariCPS + funFariCPSAmount

func funFairCalc(x):
	return funFariBaseCost * pow(1.15, x)

#///////////////////////////////////////////////////////

func _on_amusement_park_pressed():
	if coincount >= amusementParkPrise:
		amusementParkPrise = amusementParkCalc(amusementParkAmount)
		amusementParkAmount = amusementParkAmount + 1
		coincount = coincount - amusementParkPrise
		amusementParkCPS = amusementParkCPS + amusementParkCPSAmount

func amusementParkCalc(x):
	return amusementParkBaseCost * pow(1.15, x)

#///////////////////////////////////////////////////////

func _on_amusement_city_pressed():
	if coincount >= amusementCityPrise:
		amusementCityPrise = amusementCityCalc(amusementCityAmount)
		amusementCityAmount = amusementCityAmount + 1
		coincount = coincount - amusementCityPrise
		amusementCityCPS = amusementCityCPS + amusementCityCPSAmount

func amusementCityCalc(x):
	return amusementCityBaseCost * pow(1.15, x)

#///////////////////////////////////////////////////////

func _on_amusement_nation_pressed():
	if coincount >= amusementNationPrise:
		amusementNationPrise = amusementNationCalc(amusementNationAmount)
		amusementNationAmount = amusementNationAmount + 1 
		coincount = coincount - amusementNationPrise
		amusementNationCPS = amusementNationCPS + amusementNationCPSAmount

func amusementNationCalc(x):
	return amusementNationBaseCost * pow(1.15, x)

#////////////////////////////////////////////////////////

func _on_red_button_pressed():
	ColorMode = "ColorRed"
	ColorTimer.start()

func _on_green_button_pressed():
	ColorMode = "ColorGreen"
	ColorTimer.start()

func _on_blue_button_pressed():
	ColorMode = "ColorBlue"
	ColorTimer.start()

func _on_yellow_button_pressed():
	YellowPressed = true
	ColorMode = "ColorYellow"
	BuildingNumbre = RNG.randi_range(int(1.0), int(8.0))
	ColorTimer.start()

func _on_color_timer_timeout():
	TimeDone = true

#////////////////////////////////////////////////////////

func _on_wheel_button_pressed():
	if WheelTimerDone == true:
		if ColorMode == "ColorGreen":
			WheelResult = RNG.randf_range(0.0, 1.0)
			if WheelResult < 0.55:
				print("You got the good part")
			if WheelResult > 0.55:
				print("you got the bad part")
		else:
			WheelResult = RNG.randi_range(int(1.0), int(8.0))
			if WheelResult % 2 == 1:
				# Add another RNG.randi_range() here but let it choose from an good array (good options)
				print("Odd Numbre")
			if WheelResult % 2 == 0:
				# Add another RNG.randi_range() here but let it choose from an bad array (bad options)
				print("Even Numbre")

func _on_wheel_timer_timeout():
	WheelTimerDone = true

#////////////////////////////////////////////////////////
