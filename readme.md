# **DK Coach** #

## A MAME plugin to assist with Donkey Kong gameplay 

Compatible with MAME and WolfMAME versions 0.227 and above.  I may backport it to earlier versions.

At the moment,  the plugin only helps you with the elevator/springs stage.
 - All generated springs are assigned a "spring type" of between 0 and 15 dependant on their length.  The shortest spring has length 0,  the longest has length 15.
 - The spring type appears in the top-left of screen, close to where the springs are released.
 - An alert appears for short (0-6) and long (12-15) springs.  Helping you to identify these springs so you can react quickly.
 - Fixed safe zones appear in transparent green on DK's girder
 - Variable danger zones appear in red on DK's girder.  Danger zones update progressively more quickly as you progress from level 1 to level 4.  Level 4 to level 22 are the same.

Process for progressing on the springs stage.
 - Get yourself to the first green safe spot on DK's girder.
 - Move to the left of the 1st safe spot, ensuring that Jumpman's feet remain inside the box.
 - Wait for a short spring.  When you see it, move "slightly" to the left so you are closer to the 2nd safe spot,  ensuring the springdoes not hit you.  When it goes over,  you should run quickly to the 2nd safe spot.
 - Breathe.  That's the first bit done.
 - Move to the right og the 2nd safe spot, ensuring that Jumpman's feet remain inside the box.
 - Wait for a long spring.  When you see it,  make a run for the ladder,  keeping your eye on the next generated spring, it must be short if you are to make it up the ladder.  If it is not short then you must retreat to the safe spot quickly. 
 - Well done if you made it up the ladder
 
The Plugin is installed by copying the "dkcoach" folder into your MAME plugins folder.

The Plugin is activated by adding `-plugin dkcoach` to your mame arguments e.g.
`mame dkong -plugin dkcoach`  
