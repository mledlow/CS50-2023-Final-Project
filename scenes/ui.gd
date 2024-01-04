extends CanvasLayer
var is_item_selected: bool = false
var red: Color = Color("fe3c53")
var green: Color = Color("59a900")
var yellow: Color = Color("cd7c00")
var dark_blue: Color = Color("3299ff")
var mid_blue: Color = Color("6499e0")
var light_blue: Color = Color("8299b7")
	
@onready var wizard_health_bar: ProgressBar = $MarginContainer/WizardHPBar
@onready var wizard_mana_bar: ProgressBar = $MarginContainer3/WizardMPBar
@onready var battle_menu: VBoxContainer = $BattleMenu

@onready var defeat_menu: VBoxContainer = $DefeatMenu
@onready var defeat_text_label: LabelSettings = $DefeatMenu/Label.label_settings
@onready var retry_button: Button = $DefeatMenu/Retry
@onready var defeat_quit_button: Button = $DefeatMenu/Quit

@onready var victory_menu: VBoxContainer = $VictoryMenu
@onready var victory_text_label: LabelSettings = $VictoryMenu/Label.label_settings
@onready var play_again_button: Button = $VictoryMenu/PlayAgain
@onready var victory_quit_button: Button = $VictoryMenu/Quit

@onready var main_menu: VBoxContainer = $MainMenu
@onready var main_menu_start_button: Button = $MainMenu/StartGame
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var attack_button: Button = $BattleMenu/AttackButton
@onready var magic_button: Button = $BattleMenu/MagicButton
@onready var defend_button: Button = $BattleMenu/DefendButton

func _ready():
	Globals.connect("wizard_health_change", update_wizard_health_text)
	Globals.connect("wizard_action_signal", update_wizard_menu_text)
	Globals.connect("wizard_mana_change", update_wizard_mana_text)
	Globals.connect('wizard_turn_begins', start_wizard_turn_graphics)
	Globals.connect('ending_screen_signal', start_battle_ending_screen)
	Globals.connect("go_to_battle", start_battle_scene)
	Globals.connect("go_to_title", go_back_to_start_screen)
	Globals.connect("start_battle_over", start_battle_from_main_menu)
	update_wizard_health_text()
	update_wizard_mana_text()

func _on_attack_button_button_up():
	Globals.wizard_attack()

func _on_magic_button_button_up():
	Globals.wizard_magic()
	
func _on_defend_button_button_up():
	Globals.wizard_defend()
	
func _on_thunder_button_button_up():
	Globals.wizard_thunder()

func _on_cure_button_button_up():
	Globals.wizard_cure()

func hide_menu():
	battle_menu.hide()

func update_wizard_health_text():
	wizard_health_bar.value = Globals.wizard_health
	if wizard_health_bar.value < 667:
		wizard_health_bar.self_modulate = red
	elif wizard_health_bar.value < 1334:
		wizard_health_bar.self_modulate = yellow
	else:
		wizard_health_bar.self_modulate = green
	
func update_wizard_mana_text():
	wizard_mana_bar.value = Globals.wizard_mana
	if wizard_mana_bar.value < 334:
		wizard_mana_bar.self_modulate = light_blue
	elif wizard_mana_bar.value < 667:
		wizard_mana_bar.self_modulate = mid_blue
	else:
		wizard_mana_bar.self_modulate = dark_blue

func update_wizard_menu_text(action):
	if action == 'magic':
		hide_menu()
		$MagicMenu.show()
	elif action == 'thunder' || action == 'cure':
		$MagicMenu.hide()
	else:
		hide_menu()

func start_wizard_turn_graphics():
	$BattleMenu.show()
	if Globals.wizard_mana < 100:
		$BattleMenu/MagicButton.set_disabled(true)
	else:
		$BattleMenu/MagicButton.set_disabled(false)

func start_battle_ending_screen(outcome):
	animation_player.play('fade_to_black')
	await animation_player.animation_finished
	if outcome == 'dragon_death':
		play_again_button.set_disabled(false)
		victory_quit_button.set_disabled(false)
		adjust_victory_visibility(255)
		
	else:
		defeat_quit_button.set_disabled(false)
		retry_button.set_disabled(false)
		adjust_defeat_visibility(255)
		
	
func _on_play_again_button_up():
	Globals.reset_battle()

func _on_quit_button_up():
	Globals.quit_to_title()


func _on_retry_button_up():
	Globals.reset_battle()

func start_battle_scene(outcome):
	remove_end_screen_outcome(outcome)
	animation_player.play_backwards('fade_to_black')
	await animation_player.animation_finished
	start_wizard_turn_graphics()

func go_back_to_start_screen(outcome):
	await remove_end_screen_outcome(outcome)
	await adjust_main_menu_visibility(255)
	main_menu_start_button.set_disabled(false)

func remove_end_screen_outcome(outcome):
	if outcome == 'victory':
		await adjust_victory_visibility(0)
		play_again_button.set_disabled(true)
		victory_quit_button.set_disabled(true)
	else:
		await adjust_defeat_visibility(0)
		defeat_quit_button.set_disabled(true)
		retry_button.set_disabled(true)
	
func adjust_victory_visibility(value: int):
	var tween = get_tree().create_tween()
	tween.tween_property(victory_menu, 'modulate:a', value, 0.5)
	await tween.finished

func adjust_defeat_visibility(value: int):
	var tween = get_tree().create_tween()
	tween.tween_property(defeat_menu, 'modulate:a', value, 0.5)
	await tween.finished


func _on_start_game_button_up():
	Globals.begin_battle_from_start()

func start_battle_from_main_menu():
	adjust_main_menu_visibility(0)
	animation_player.play_backwards('fade_to_black')
	await animation_player.animation_finished
	attack_button.set_disabled(false)
	magic_button.set_disabled(false)
	defend_button.set_disabled(false)
	play_again_button.set_disabled(true)
	victory_quit_button.set_disabled(true)
	defeat_quit_button.set_disabled(true)
	retry_button.set_disabled(true)
	main_menu_start_button.set_disabled(true)

func adjust_main_menu_visibility(value):
	var tween = get_tree().create_tween()
	tween.tween_property(main_menu, 'modulate:a', value, 0.5)
	await tween.finished
