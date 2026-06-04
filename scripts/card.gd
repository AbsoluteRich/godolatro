class_name Card
extends TextureRect

# https://www.reddit.com/r/godot/comments/13pm5o5/comment/ktmmqp0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
static var scene: PackedScene = preload("res://scenes/card.tscn")
static var all_selected: int = 0

enum Suits { Clubs, Diamonds, Hearts, Spades }

var rank: int
var suit: Suits

@export var selected: bool


static func create(new_suit: Suits, new_rank: int) -> Card:
	var new_card: Card = scene.instantiate()
	new_card.suit = new_suit
	new_card.rank = new_rank
	new_card.texture = load("res://assets/cards/card%s.png" % new_card)
	return new_card


func _to_string() -> String:
	var properSuit: String
	var properRank: String

	properSuit = Suits.find_key(self.suit)

	match self.rank:
		11:
			properRank = "J"
		12:
			properRank = "Q"
		13:
			properRank = "K"
		14:
			properRank = "A"
		_:
			properRank = str(self.rank)

	return properSuit + properRank


# https://www.reddit.com/r/godot/comments/1gfl4m7/comment/luigfzf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if all_selected >= 5 and self.selected == false:
				return

			self.selected = not self.selected

			if self.selected:
				all_selected += 1
				self.modulate = Color.YELLOW
			else:
				all_selected -= 1
				self.modulate = Color.WHITE
