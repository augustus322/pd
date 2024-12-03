extends TabContainer

onready var spawnMenu = get_parent().get_node("BottomPanelMenus/SpawnMenu")
onready var timeMenu = get_parent().get_node("BottomPanelMenus/TimeMenu")

func _on_BottomPanel_tab_changed(tab):
	if tab == 0:
		spawnMenu.visible = true
		timeMenu.visible = false
	if tab == 1:
		spawnMenu.visible = false
		timeMenu.visible = true
