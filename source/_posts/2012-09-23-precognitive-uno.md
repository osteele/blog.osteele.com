---
title: "Precognitive Uno"
date: '2012-09-23 16:00'
description:
categories: 
type: draft
tags: [fun, games]
---

Precognitive Uno is a variant of the [Uno card game](http://en.wikipedia.org/wiki/Uno_(card_game)). In Precognitive Uno, each player must **precommit** one or more cards, for play on subsequent turns. If the precommited card can’t be played on the next turn, the player takes a penalty (draws a card and forfeits the turn).

# Single-Commit Precognitive Uno
Single-Commit Precognitive Uno follows the <a href="http://en.wikipedia.org/wiki/Uno_(card_game)#Official_rules">rules of standard Uno</a>, except that:

1. Each player has in front of her a **precommit space**. This space is initially empty; it may hold a face down card which is the **precommit card**. A player’s cards not including the precommit card are called the player’s **regular hand**.
2. At the *end* of each turn: The player must place a card from her regular hand face down on the precommit space.
3. At the *beginning* of each turn: If there is a card in the player’s precommit space[^1] and it's legal to play the card under the rules of standard Uno, the player must do so. She must then replace the precommit card by a card from her regular hand (following rule #2).
4. At the beginning of each turn: if there is a card in the precommit space and it *cannot* be played, the player must move the precommit card back to her hand, and draw a card from the deck. She must then replace the precommit card by a card from her hand (following rule #2). The new precommit card may be any card from her hand, including the previous precommit card or the card drawn from the deck.
4. “Uno” is called when a player discards her penultimate card *including the precommit card*.  
5. The first player to discard all her cards *including the precommit card* is the winner.

[^1]: This is always the case, except for each player’s first turn when the precommit space is empty.

## A Worked Example
1. The games starts as normal. The dealer deals for two and starts the discard pile.
![](/assets/media/uno/uno-1.jpg)
2. Player #1 plays a card onto the discard pile, and places a card in the player #1 precommit space.
![](/assets/media/uno/uno-2.jpg)
3. Player #2 plays a card onto the discard pile, and places a card in the player #2 precommit space.
![](/assets/media/uno/uno-3.jpg)
1. Player #1 plays. Her precommit card is valid: she must play this card, and replace it with a card from her regular hand.
![](/assets/media/uno/uno-4.jpg)
1. Player #2 plays. His precommit card is not valid: he moves it back into her regular hand, draws a card, and ends his turn by placing a card in the precommit space. He is not obligated to reveal the invalid precommit card. He cannot play into the discard stack regardless of the contents of his regular hand or the rank and color of the drawn  card: if the precommit card is not a valid play, his opportunity to participate in the underyling standard game is forgeit for that turn.
![](/assets/media/uno/uno-5.jpg)
1. [Time passes, in the form of turns.]
1. Player #1 plays her precommit card and places her final card in the precommit space. This is the point at which she must call “uno”.
1. Player #2 plays his precommit card and places a card in the precommit space.
1. Player #1 is able to play her (final) precommit card, to win the game.

# Two-Commit Precognitive Uno
**Two-commit Precognitive Uno** is similar to Single-Commit Pre-cognitive Uno (above), except that instead of a precommit *space*, there is a **precommit *lane***. The precommit lane has spaces for *two* cards: the precommitted card for the *next* turn, and the precommitted card for the turn *after that*. If at the beginning of a player’s turn her precommitted card is invalid, this **flushes the pipeline**[^2]: she removes *both* cards from her discard lane, draws *one* card, and replaces as many precommit cards as she is able (generally both spaces in the lane; until her hand is reduced to one card).

[^2]: Mixing metaphors.

## A Worked Example
1. Player #1 plays a card, and fills her precommit lane.
1. Player #2 plays a card, and fills his precommit lane.
1. Player #1 plays the *first* card in her precommit lane, moves the *second* card in the lane into the *first* position, and fills the *second* position from her regular hand.
1. Player #2 is unable to play the first card in his precommit lane. He moves both cards into his regular hand, draws from the deck, and fills his precommit lane. His turn is now complete.
2. [Game play goes on.]

# Blind Precognitive Uno
In the easiest form of the game, a player is allowed to look at the cards in her precommit lane. This is **sighted** precognitive Uno.

In a **blind** precognitive game, the player is not allowed to look at her precommitted cards. This doesn’t change the Single-Commit game much, but it makes games with two or more precommits significantly more difficult.[^3]

[^3]: It adds an [n-back](http://en.wikipedia.org/wiki/N-back) task to the game.

# Additional Variants
The number of committed cards can be extended beyond two, to either (1) an arbitrary constant (such as the number of cards initially dealt); or (2) a computed number (such as  half the number in each player’s hand; or the least number of cards in any player's had). I haven’t played with more than two precommits.

In **telepathic** uno, the cards in the precommit lane are placed face up. I haven’t played this either.

## “Precognitive” as a Modifier

Tthe Precognitive modifications can be used to wrap a number of different turn-based games, such as [gin](http://en.wikipedia.org/wiki/Gin_rummy) or [chess](http://en.wikipedia.org/wiki/Chess).

For example, in **Precognitive Chess**, each player at the end of her turn must write down or confide to a referee her next move. If the move is legal at the start of her following turn the player must take it. Otherwise the player forfeits that turn. In either case the player must then precommit one (or more moves) for her *next* turn(s).

# Related
Also see [Stroop](/posts/2012/09/stroop-a-card-game).

---
