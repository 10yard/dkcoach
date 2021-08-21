+# **DK Coach** #

## A MAME plugin to assist with Donkey Kong gameplay 

Compatible with MAME and WolfMAME versions 0.196 and above.

At the moment,  the plugin only helps you with the springs stage.

### Springs Stage

The helper visualises zones and provide you with information about the generated springs to help you navigate on DK's girder and climb the ladder safely.

 - Fixed safe zones appear in translucent green on DK's girder
 - Variable danger zones appear in translucent red on DK's girder.  Danger zones update progressively more quickly as you progress from level 1 to level 4.  Level 4 to level 22 are the same.
 - All generated springs are assigned a "spring type" of between 0 and 15 depending on their length.  The shortest spring has type 0,  the longest has type 15.
 - The spring type appears in the top-left of screen, close to where the springs are released.
 - An alert appears for short (0-6) and long (12-15) springs.  Helping you to identify these springs so you can react quickly.

![Screenshot](https://github.com/10yard/dkcoach/blob/master/screenshot.png)

#### Process for progressing on the springs stage.

 - Navigate Jumpman to the first green safe spot on the far right of DK's girder.
 - Move to the left edge of the safe spot, ensuring that Jumpman's feet remain inside the box.
 - Wait for a short spring to come.  When you see it, move "slightly" to the left so you are closer to the 2nd safe spot,  ensuring the spring does not hit you.  When it goes over, you need to run quickly to the 2nd safe spot.
 - Breathe.  That's the first part done.
 - Move to the right edge of the 2nd safe spot, ensuring that Jumpman's feet remain inside the box.
 - Wait for a long spring to come.  When you see it,  make a run for the ladder,  keeping your eye on the next generated spring, it must be short spring if you are to make it up the ladder.  If it is not short then you must retreat to the safe spot quickly. 
 - Get used to watching the springs and recogising their types as they appear from the left
 - As you get more confident on the stage,  you can remove some of the helpers by pressing "P2 Start" button.
 
### Installing
 
The Plugin is installed by copying the "dkcoach" folder into your MAME plugins folder.

The Plugin is activated by adding `-plugin dkcoach` to your mame arguments e.g.

```mame dkong -plugin dkcoach```  
