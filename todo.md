post mvp:

- fix and comment the codebase so you don't lose your mind coming back to it in 2 months.
- fix coupling
- delay puzzle timeout until after all pieces have combo'ed out
- fix things that could be static classes/objects instead of nodes
- fix modifiers checking based on strings instead of an enum
- redo entire ui system

- stat changes decrease by 1 point every turn
- add magic attack and magic def?
- recognize combos (also maybe chains??)
- real enemy ai
- dungeon crawling
- leveling up
- items
- status effects
- multi action attacks (attacking + status + heal)
- crits and weak hits give you more puzzle time
- recruiting by clearing some sort of preset puzzle?

fixes:

general:
- optimize functions and scene trees. most nodes can be instanced within the parent 
- start with the battle/puzzle changes. the ui is kinda seperate and can be touched later on.

puzzle:
- fix match detection to recognize combos 
- lockout adding rows and ending phase while pieces are still falling
- time doesn't countdown during a combo?
- make a line that points a action piece to it's owner for the ui
- GARBAGE BLOCKS:
  - garbage is spawned in when you don't have enough blue points to tank a hit

ui:
- real earthbound backgrounds w shaders
- just redo all of the code for the battleboxes and selection, piggybacking on existing Godot functions might b making things more complicated then they have to be
- change blue placement to be not next to the other two 

battle:
- smart enemy ai
- balance buffs/nerfs (think of somthing)
- lucky crits and targeting weaknesses give you more puzzle time
- garbage blocks only spawn when not enough blue to defend from damage
- multi action attacks (attacking + status + heal)
- blue moves!?
- lose half your blue points at the end of a turn. can't just stock up

new features:
- smt dungeon crawling
- leveling up
- items
- status effects
- recruiting by clearing a generated pdp puzzle

