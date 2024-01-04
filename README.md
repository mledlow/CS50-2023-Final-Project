# Wizard's Quest
#### Description:
To anyone reading this, hello! I made Wizard's Quest over a week's time, using a game engine called Godot. 
My original intent was to use Lua in LOVE, but I found out that it didn't work on my computer due to some issue with its graphical processor.
The goal of the project overall was simple: I set out to recreate the Scratch game I made for Week 0 but with a "higher-tech" engine and
knowledge accumulated over the course. This Scratch game emulated Turn-Based Role Playing Games (better known as RPGs) that I have played in the past.
Specifically, it was similar to a Final Fantasy battle, with a wizard and dragon taking turns fighting each other until one runs out of health and faints.
There's a lot more to them than that, but I only cared about creating the combat part of the game, given the timeframe.

In Scratch, this was fairly simple, but in Godot, I had to actually spend time learning the engine. With this, and various other distractions occupying me,
development started in mid-December and ended on Christmas. Overall, it took a week to build, just as the Scratch game had. Due to this time constraint,
certain aspects of the game are unfinished. There is no sound or music, and one of the dragon's "attacks" in the original Scratch game didn't make it over.
This attack would have them charge up for a turn and then release a fireball that would do a lot of damage, but it was cut, leaving only two attacks left.
It feels a bit unpolished, but the key aspects of the game were replicated were in this project folder. There are other files necessary to run it,
but these are automatically made by Godot and not included in any release, so I just decided to remove them.

First, the globals folder. This contains one file, globals.gd, and .gd files are used for Godot's specific scripting language, GDScript.
Its closest analogue is Python, which makes it easy for a beginner to use, even with limited scripting knowledge. The purpose of globals.gd is simple;
it manages everything that must be accessed by multiple different "scenes" of code, which are essentially partitions for each piece you add to the game.
They are formed out of Nodes, which are component pieces that make up scenes and the building block of Godot as an engine. In any case,
these scenes can communicate with each other through Signals, which each can send out and receive, but it becomes complicated to have scenes converse with each other.
If they are parent and child scenes, then it is easier, but for any file structure more complicated, a "global" hub is much more useful in sending out signals.

Here, the key aspects of the game are stored: the wizard's health and "mana" (another resource), which must be accessed in multiple areas, and the dragon's health.
These each have setter and getter functions, which allows them to be accessed and modified anywhere in any scene, as this .gd file is autoloaded at the start.
It also contains a variety of signals that are necessary to make things function, which trigger off of the wizard's health/mana or dragon's health changing,
one of them getting hit, whose turn it is changing, the battle ending, spells that the wizard uses, the wizard or dragon's action taken, and so on.
There are also signals meant for scene changes, which encompass the Main Menu, the Battle, and the Ending Screen. This makes everything run smoothly,
and saves me the headache of particularly complicated signal relays that would make this a nightmare to create.

Inside of the graphics folder, the Dragon and Magician folders contain all the necessary animations for the two (credit to Cethiel and ruberboy respectively,
for making these and distributing them for free on opengameart.org). These images are compiled into animations in the editor, just as the two spell animations
in FX are (created by Mikodrak at the same website). environment_forest_alt1.png is the background of the fight, made by ramtam (same website).
Lastly, the Medieval Sharp font is used for all text in-game, since it fit the aesthetic I was going for. There's some minor clash with the dragon animation,
but it looked cool, so I went for it anyway. These are all the necessary external graphics used.

Lastly, the scenes folder contains the majority of the game's code. The .gd files, respectively, are all GDScript code like globals.gd was.
dragon.gd contains all the necessary logic for the dragon (playing various animations, like its attacks, death, and hit ones, all of which are in dragon.tscn),
while wizard.gd does the same for the wizard.tscn and its animations. level.gd actually doesn't do much, besides creating instances of Cure and Thunder.
These are the spells encompassed in cure.tscn and thunder.tscn, and their effects are applied in level.gd. ui.gd is likely the most complex piece here,
because it handles the code for all on-screen UI (the wizard's HP, MP, various menus, and going back and forth between Main Menu, Battle Screen, and Ending Screens).
All of these pieces (buttons, labels, bars, menus, etc) are all inside of ui.tscn, along with a black screen that I use to "fade to black" and back. Most notably,
there is an AnimationPlayer node in this .tscn that does that and was meant to do more, until I found it easier to use a Tween (essentially can do an animation, but in code).
Ultimately, the UI was the most complicated part to wrangle in the development of the game and took the most time overall.

Looking back at it now, I'm pretty happy with my choice of project, and it was a great way to get a small taste of what developing a game might be like.
It also helped put in perspective the tradeoff of usability and flexibility; I was able to make something more "complete" in Scratch in the same timeframe,
but you're much more constrained in what you actually can make. Meanwhile, using Godot, which is known as a fairly beginner-friendly engine,
led to all sorts of errors and headaches to correct. However, I had much more freedom in creating what I wanted to make. It was also interesting to see
some of the similarities in the two mechanically, as "signals" feature prominently in both for similar uses.

Altogether, I'm very happy to have taken the course, and if anyone's reading this, I'd like to thank the Harvard CS50 team for putting this together
and offering it for free to anyone. I don't think I would have used Godot at all if not for this course, and although I was always interested in game design,
having to use it for this project showed me more of what that might be like, both as a hobby and a potential career. It's given me a fire to keep aiming higher,
which I am forever grateful for. Again, thank you.
