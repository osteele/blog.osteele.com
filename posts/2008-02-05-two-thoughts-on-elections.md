---
date: '2008-02-05 10:47:01'
layout: post
slug: two-thoughts-on-elections
status: publish
title: Two Thoughts on Elections
wordpress_id: '243'
categories: [Math Education]
tags: math
---

What follow are some notes from talking about the elections and the presidential primaries with my children, and some metaphors that I found helpful in thinking about the topics.  They're not otherwise related to each other, except that they all came up over the last couple of days.

<!-- more -->

## 1. Votes are Agents

The [wikipedia article about voting systems](http://en.wikipedia.org/wiki/Voting_system), and the Newsweek article [When Math Warps Elections](http://www.newsweek.com/id/105586) describe a number of different systems: in particular, the America [plurality system](http://en.wikipedia.org/wiki/Plurality_voting_system)  where you casts only one vote (presumably for your favored candidate, unless you're [voting strategically](http://en.wikipedia.org/wiki/Tactical_voting)); [approval voting](http://en.wikipedia.org/wiki/Approval_voting), where you vote for all the candidates your find acceptable (again, unless you're voting strategically); and ranked-choice or [instance-runoff voting](http://en.wikipedia.org/wiki/Instant-runoff_voting), where you rank the candidates, and the candidate who was highest on the smallest number of ballots is removed from all of them until only one candidate remains.

It can be hard to compare these systems.  The wikipedia lists [some criteria](http://en.wikipedia.org/wiki/Voting_system#Criteria_in_evaluating_single_winner_voting_systems), but it's a few hours time to learn enough about the theory in this area to apply them.

So here's a less formal way to think about this, using a metaphor that's more familiar to most of us (including kids) than the language of the economic theories:

You're building a robot.  The job of the robot is to vote for a candidate, on your behalf.  Your robot may need to vote several times: the real election may be built out of a number of micro-elections with different sets of candidates.  The reason you're delegating this to a robot instead of doing this yourself is that it's logistically easier, and faster, to get each voter to build a robot[^1] once than to get each voter to show up for each micro-election.

One way the voting systems differ is in how much you get to tell your robot; and, therefore, what your robot does in the elections where your first-choice candidate isn't on the ballot[^2].  In a plurality system, you can only tell the robot your first-choice candidate; your robot has to sit out the micro-elections where your candidate isn't on the ballot.  In an approval system, where you've selected several unranked candidates, your robot doesn't have enough information to vote in those elections where more than one of your candidates is on the ballot.  In an instant-runoff system, your robot always knows how to vote the same way as you.

Kids seem to have a sense that there's something a bit off about strategic voting; and, therefore, about systems that require it.  (Among other problems, strategic voting is a bit like learning test-taking skills for the SAT: it provides an advantage for those who have thought of it, which may bias the election.)  In the robot metaphor, strategic voting comes about only when your robot is too stupid to do what you want it to in every micro-election, so you have to decide what to tell it in order to get it to vote right in the micro-elections that you think are more likely to come up, or more likely to matter.

## 2. Primaries and Decision Theory

[This is unrelated to the first topic, except that they're both about elections.]

Let's say you want to run for president.  To do this effectively, you need a certain amount of *manna* (money, endorsements, and organizational backing); each bit of manna increases your chances of winning.

There's a *mana provider* with a lot of huge amount of manna, who's willing to make a deal with you: after you accept the terms of the deal (and only after), they'll decide whether to *anoint* you (this is the process by which they give you all their manna); and if you don't, you agree to drop out of the race.

This deal has a up side -- that you've got more manna, and therefore you've increased your chances of winning the election if you're anointed -- and a huge down side -- that if you accept the deal and the manna provider doesn't anoint you, you've decreased your chances of winning the election to zero (because then you've promised not to run).

Let's say you have a 20% chance of winning the election on your own, and that being anointed increases your chances by 20%.   Then the payoff matrix looks like this:

|             | anointed | not anointed |
| ---         | ---      | ---          |
| reject deal | 0.2      | 0.2          |
| accept deal | 0.4      | 0.0          |

Now let's say you have only a 50% chance of being anointed.  Then your chance of winning the election if you reject the deal is 20% (in this case it doesn't matter whether you would have been anointed not), and your average chance of winning the election if you accept the deal is also 20%.  It's not obvious whether you should accept the deal or not; it depends on your risk tolerance.

But now let's throw a couple of other factors into the mix.  Both of these factors have the effect that your chance of being anointed is _correlated_ with your chance of winning the election.

First, the manna provider could attempt to anoint you exactly when your chances of winning are greater anyway (by using some tool, such as polls or an interim election, to estimate these chances).  If instead of having a 20% chance of winning the election without anointment, you either have a 30% chance or a 10% chance (you don't know which when you make the deal), and you'll be anointed if it turns out (after you make the deal) that it was closer to 30%, then the matrix looks like this:

|             | anointment-worthy | not anointment-worthy |
| ---         | ---               | ---                   |
| reject deal | 0.3               | 0.1                   |
| accept deal | 0.5               | 0.0                   |

The other factor that increases the correlation between being anointed and winning the election is that if _you_ are not anointed, someone _else_ is, and this _decreases_ your chances of winning the election, say by 20% (but not to less than 1%).

Then the matrix looks like this:

|             | anointment-worthy | not anointment-worthy |
| ---         | ---               | ---                   |
| reject deal | 0.1               | 0.01                  |
| accept deal | 0.5               | 0.0                   |

The mana providers, of course, are political parties; and this is why candidates join parties.

What's in it for the manna providers?  This is just [strategic nomination](http://en.wikipedia.org/wiki/Strategic_nomination), to avoid splitting the vote in a plurality voting system.  Interestingly, strategic nomination is analogous to [strategic voting](http://en.wikipedia.org/wiki/Tactical_voting), only proactive, and aggregated at the level of the political party.

---

[^1]: These are really simple robots, and we can build them all by putting checkboxes or numbers on a paper ballot.

[^2]: The other ways they differ are in how they many micro-elections there are; how they determine who runs in each of those; and how the results of the micro-elections are aggregated to determine the winner of the overall election.
