extends Control

var deck: Array[Card] = []


func construct_deck() -> void:
	for suit in Card.Suits.values():
		for rank in range(2, 15):
			# Behind the scenes, Enums are technically just an array of ints
			# Therefore, something that accepts an Enum as a parameter needs a int, not a String
			deck.append(Card.create(suit, rank))
	deck.shuffle()
	assert(deck.size() == 52)


func sort_cards() -> void:
	var sorted_cards = %Cards.get_children().duplicate()
	var list_length: int = len(sorted_cards)

	for i in range(list_length):
		var swapped: bool = false

		for j in range(0, list_length - i - 1):
			# Swap is set to true if the FIRST card is "more" than the SECOND card
			var swap: bool = false

			# Rank sorting
			if sorted_cards[j].rank > sorted_cards[j + 1].rank:
				swap = true

			# Suit sorting (uses the rule Clubs > Diamonds > Hearts > Spades)
			# Because there can't be duplicate suits (at least for now), this always produces a definitely sorted list
			elif sorted_cards[j].rank == sorted_cards[j + 1].rank:
				if sorted_cards[j].suit > sorted_cards[j + 1].suit:
					swap = true

			if swap:
				var temp: Card = sorted_cards[j]
				sorted_cards[j] = sorted_cards[j + 1]
				sorted_cards[j + 1] = temp
				swapped = true

		if swapped == false:
			break

	for i in len(sorted_cards):
		%Cards.move_child(sorted_cards[i], i)


func draw_cards(count: int) -> void:
	for i in range(count):
		var new_card: Card

		if not deck.is_empty():
			new_card = deck[0]
			deck.pop_at(0)
			%Cards.add_child(new_card)


func _ready() -> void:
	construct_deck()
	draw_cards(7)
	sort_cards()


func _on_play_button_pressed() -> void:
	for child in %Cards.get_children():
		if child.selected:
			print(child)


func _on_discard_button_pressed() -> void:
	for child in %Cards.get_children():
		if child.selected:
			child.destroy()
			draw_cards(1)


func _on_sort_button_pressed() -> void:
	sort_cards()
