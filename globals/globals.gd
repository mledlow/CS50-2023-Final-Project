extends Node

var wizard_defending: bool = false
var dragon_action: String

signal wizard_health_change
signal dragon_health_change
signal dragon_hit
signal wizard_hit
signal wizard_mana_change
signal wizard_turn_begins
signal battle_end(outcome)
signal wizard_cure_anim
signal wizard_thunder_anim
signal wizard_back_to_idle
signal wizard_action_signal(action)
signal dragon_action_signal(action)
signal ending_screen_signal(outcome)
signal go_to_battle(outcome)
signal go_to_title(outcome)
signal start_battle_over

var wizard_health: int = 2000:
	get:
		return wizard_health
	set(value):
		if value > wizard_health:
			if value > 2000:
				wizard_health = 2000
			else:
				wizard_health = value
			wizard_health_change.emit()
		else:
			if value <= 0:
				wizard_health = 0
				wizard_health_change.emit()
				battle_end.emit('wizard_death')
			else:
				wizard_health = value
				wizard_health_change.emit()
				wizard_hit.emit()

var dragon_health: int = 9999:
	get:
		return dragon_health
	set(value):
		if value <= 0:
			dragon_health = 0
			dragon_health_change.emit()
			battle_end.emit('dragon_death')
		else:
			dragon_health = value
			dragon_health_change.emit()
			dragon_hit.emit()
		

var wizard_mana: int = 1000:
	get:
		return wizard_mana
	set(value):
		wizard_mana = value
		wizard_mana_change.emit()

func start_wizard_turn():
	wizard_turn_begins.emit()

func wizard_attack():
	wizard_action_signal.emit('attack')
	
func wizard_magic():
	wizard_action_signal.emit('magic')
	
func wizard_defend():
	wizard_action_signal.emit('defend')
	
func wizard_thunder():
	wizard_action_signal.emit('thunder')

func wizard_cure():
	wizard_action_signal.emit('cure')

func start_dragon_turn():
	var dragon_action_number = randi_range(1, 100)
	if dragon_action_number < 61:
		dragon_action = 'attack'
	else:
		dragon_action = 'bite'
	dragon_action_signal.emit(dragon_action)

func deal_damage_to_wizard(amount):
	if Globals.wizard_defending:
		Globals.wizard_health -= (int(amount / 2))
	else:
		Globals.wizard_health -= amount

func heal_wizard(amount):
	Globals.wizard_health += amount

func play_cure_anim():
	wizard_cure_anim.emit()
	

func play_thunder_anim():
	wizard_thunder_anim.emit()
	
func return_wizard_to_idle():
	wizard_back_to_idle.emit()
	
func start_ending_screen(outcome):
	ending_screen_signal.emit(outcome)
	
func quit_to_title():
	var outcome = check_outcome()
	go_to_title.emit(outcome)
	
func reset_battle():
	var outcome = check_outcome()
	Globals.wizard_health = 2000
	Globals.dragon_health = 9999
	Globals.wizard_mana = 1000
	go_to_battle.emit(outcome)

func begin_battle_from_start():
	Globals.wizard_health = 2000
	Globals.dragon_health = 9999
	Globals.wizard_mana = 1000
	start_battle_over.emit()

func check_outcome():
	var outcome
	if dragon_health <= 0:
		outcome = 'victory'
	else:
		outcome = 'defeat'
	return outcome
