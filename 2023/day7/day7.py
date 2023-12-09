# BOILERPLATE
import os
import time

example = False
if example:
    path = os.path.dirname(__file__) + "\example.txt"
else:
    path = os.path.dirname(__file__) + "\input.txt"
start = time.perf_counter()


# IMPLEMENTATION
from collections import Counter
from itertools import groupby


def replace_jokers(hand):
    # Takes the hand with face cards already converted to values
    J_val = facecards["J"]
    if J_val not in hand:
        return hand
    else:
        # Remove jokers first so we don't replace like for like!
        no_jokers = [c for c in hand if c != J_val]
        if len(set(hand)) == 1:
            # Hand is all jokers
            new_val = facecards["A"]
        elif len(set(no_jokers)) == len(no_jokers):
            # Remaining cards are all unique, take the highest one to make a pair
            new_val = max(no_jokers)
        else:
            # Find the most common card, taking the most valuable if there is a tie
            freqs = groupby(Counter(no_jokers).most_common(), lambda x: x[1])
            new_val = max([val for val, count in next(freqs)[1]])

    new_hand = [c if c != J_val else new_val for c in hand]
    return new_hand


def cards_to_vals(card):
    if card in facecards:
        return facecards[card]
    else:
        return int(card)


def parse(data, jokers=False):
    hands = []
    bids = []
    strengths = []
    for line in data:
        hand, bid = line.split(" ")
        hand = [cards_to_vals(c) for c in hand]

        if jokers:
            # Hand strength is based off the hand without jokers
            # But the jokers are still counted in ranking high cards in a tie, but with the lowest value
            hand_no_jokers = replace_jokers(hand)
            strengths.append(get_hand_strength(hand_no_jokers))
            hands.append([c if c != facecards["J"] else 1 for c in hand])
        else:
            strengths.append(get_hand_strength(hand))
            hands.append(hand)

        bids.append(int(bid))

    return hands, bids, strengths


def get_hand_strength(hand):
    n_uniq = len(set(hand))
    n = len(hand)
    if n_uniq == n:
        # High card
        return 1
    elif n_uniq == n - 1:
        # Pair
        return 2
    elif n_uniq == n - 2:
        # 2 Pair or 3 of a kind
        strength = 3 if max(Counter(hand).values()) == 2 else 4
        return strength
    elif n_uniq == n - 3:
        # Full house or 4 Kind
        strength = 5 if max(Counter(hand).values()) == 3 else 6
        return strength
    elif n_uniq == 1:
        # 5 of a kind
        return 7


def calc_winnings(data, jokers=False):
    hands, bids, strengths = parse(data, jokers)

    # Sort bids by strength, then by cards in hands
    # This appears to be correctly sorting by 1st card then 2nd card
    # [bids, strengths, hands]
    ranked = sorted(zip(bids, strengths, hands), key=lambda x: (x[1], x[2]))

    winnings = 0
    for i, rank in enumerate(ranked):
        winnings += (i + 1) * rank[0]

    return winnings


with open(path) as f:
    data = f.read().splitlines()

facecards = {
    "A": 14,
    "K": 13,
    "Q": 12,
    "J": 11,
    "T": 10,
}

sol = (calc_winnings(data), calc_winnings(data, jokers=True))

# OUTPUT
end = time.perf_counter()
print(f"Solution = {sol}")
print(f"Time = {(end-start)*1000:.3f} ms")
