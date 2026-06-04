class_name Card
extends TextureRect

# https://www.reddit.com/r/godot/comments/13pm5o5/comment/ktmmqp0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
static var scene: PackedScene = preload("res://scenes/card.tscn")
static var all_selected: int = 0

enum Suit { Clubs, Diamonds, Hearts, Spades }

var rank: int
var suit: Suit

@export var selected: bool


static func create(new_suit: Suit, new_rank: int) -> Card:
	var new_card: Card = scene.instantiate()
	new_card.suit = new_suit
	new_card.rank = new_rank
	new_card.texture = load("res://assets/cards/card%s.png" % new_card)
	return new_card


func destroy() -> void:
	all_selected -= 1
	self.queue_free()


func _to_string() -> String:
	var proper_suit: String
	var proper_rank: String

	proper_suit = Suit.find_key(self.suit)

	match self.rank:
		11:
			proper_rank = "J"
		12:
			proper_rank = "Q"
		13:
			proper_rank = "K"
		14:
			proper_rank = "A"
		_:
			proper_rank = str(self.rank)

	return proper_suit + proper_rank


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
