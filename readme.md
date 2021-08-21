+# **DK Coach** #

## A MAME plugin to assist with Donkey Kong gameplay 

Tested with latest MAME version 0.234
(Compatible with MAME and WolfMAME versions from 0.196 upwards)

At the moment,  the plugin only helps you with the springs stage.  I plan to add help to other stages.

### Springs Stage

The helper visualises the safe zones and danger zones on DK's girder.  Information about generated springs helps you make quick decisions on when to make a run and when to sit tight or retreat back to safety.

 - 2 fixed safe zones appear in green on DK's girder
 - 3 variable danger zones appear in red on DK's girder.  These zones mark the location of the bouncing springs.
 - All generated springs are assigned a "spring type" of between 0 and 15 depending on their length.  The shortest spring has type 0,  the longest has type 15.
 - The spring type appears in the top-left of screen, close to where the springs are released.
 - An alert appears for short (0-6) and long (12-15) springs.  Helping you to identify these springs so you can react quickly.

Use "P2 Start" to toggle the helpfulness setting between 2 (Max Help), 1 (Min Help) and 0 (No Help)


![Screenshot](https://github.com/10yard/dkcoach/blob/master/screenshot.png)


#### Process for progressing on the springs stage level 4+

 - Navigate Jumpman to the first green safe spot on the far right of DK's girder.
 - Move to the left edge of the safe spot, ensuring that Jumpman's feet remain inside the box.
 - Wait for a short spring to come.  When you see it, move "slightly" to the left so you are closer to the 2nd safe spot,  ensuring the spring does not hit you.  When it goes over, you need to run quickly to the 2nd safe spot.
 - Breathe.  That's the first part done.
 - Move to the right edge of the 2nd safe spot, ensuring that Jumpman's feet remain inside the box.
 - Wait for a long spring to come.  When you see it,  make a run for the ladder,  keeping your eye on the next generated spring, it must be a short spring if you are to make it up the ladder.  If it is not short then you must retreat back to the safe spot quickly. 
 - Get used to watching the springs and recogising their types as they appear from the left.
 - As you become more confident on the springs stage,  you should reduce helpers by pressing "P2 Start" button.  See "Help Settings" below.
 

### Help Settings

The default setting is "Max Help".  Toggle the setting by pressing "P2 Start".
  - Max Help: All of the available helpers are displayed.
  - Min Help: Only basic helpers are displayed
  - No Help: No help is displayed.

As you become more confident with your gameplay,  you should reduce help features by pressing "P2 Start" button.  Switching from "Max Help" to "Min Help" to "No Help".
   
 
### Installing
 
The Plugin is installed by copying the "dkcoach" folder into your MAME plugins folder.

The Plugin is activated by adding `-plugin dkcoach` to your mame arguments e.g.

```mame dkong -plugin dkcoach```  

### Next up

Addition of barrel stage helper
 - safe zones from wild barrels
 - wild barrel alert 
 - probability of steering barrels down ladders % 
 - hammer timer countdown
 - Max jump distance markers (maybe)