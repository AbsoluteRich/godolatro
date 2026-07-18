extends Control

var deck: Array[Card] = []
enum HandType {
	RoyalFlush,
	StraightFlush,
	FourOfAKind,
	FullHouse,
	Flush,
	Straight,
	ThreeOfAKind,
	TwoPair,
	Pair,
	HighCard
}


func _ready() -> void:
	Events.card_selected.connect(display_hand)
	construct_deck()
	draw_cards(7)
	sort_cards()


# Poker logic
func construct_deck() -> void:
	for suit in Card.Suit.values():
		for rank in range(2, 15):
			# Behind the scenes, Enums are technically just an array of ints
			# Therefore, something that accepts an Enum as a parameter needs a int, not a String
			deck.append(Card.create(suit, rank))
	deck.shuffle()
	assert(deck.size() == 52)


func draw_cards(count: int) -> void:
	for i in range(count):
		var new_card: Card

		if not deck.is_empty():
			new_card = deck[0]
			deck.pop_at(0)
			%Cards.add_child(new_card)


func evaluate_hand(hand: Array[Node]) -> HandType:
	var card_frequencies: Dictionary

	var has_three_of_a_kind: bool
	var pair_count: int = 0
	var is_flush: bool = false  # Todo
	var is_straight: bool = false  # Todo, and account for wheels and Broadways somehow

	for first_card in hand:
		var running_count: int = 0

		for card in hand:
			if card.rank == first_card.rank:
				running_count += 1

		card_frequencies[first_card.rank] = running_count
		running_count = 0

	for rank in card_frequencies:
		if card_frequencies[rank] == 4:
			return HandType.FourOfAKind
		elif card_frequencies[rank] == 3:
			has_three_of_a_kind = true
		elif card_frequencies[rank] == 2:
			pair_count += 1

	if is_flush and is_straight:
		return HandType.StraightFlush
	elif has_three_of_a_kind and pair_count == 1:
		return HandType.FullHouse
	elif is_flush:
		return HandType.Flush
	elif is_straight:
		return HandType.Straight
	elif has_three_of_a_kind:
		return HandType.ThreeOfAKind
	elif pair_count == 2:
		return HandType.TwoPair
	elif pair_count == 1:
		return HandType.Pair
	return HandType.HighCard


# Game logic
func sort_cards() -> void:
	var sorted_cards: Array[Node] = %Cards.get_children().duplicate()
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
			# Because there can't be duplicate suits (at least for now), this always produces a definitively sorted list
			# Exploit the fact that enums are fancy ints
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


func get_readable_hand(hand: HandType):
	return HandType.find_key(hand)


# Event handlers
func display_hand() -> void:
	var played_hand: Array[Node]

	for child in %Cards.get_children():
		if child.selected:
			played_hand.append(child)

	if played_hand:
		%Hand.text = get_readable_hand(evaluate_hand(played_hand))
	else:
		%Hand.text = ""


func _on_discard_button_pressed() -> void:
	for child in %Cards.get_children():
		if child.selected:
			child.destroy()
			draw_cards(1)


func _on_sort_button_pressed() -> void:
	sort_cards()
