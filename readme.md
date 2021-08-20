# **DK Coach** #

## A MAME plugin to assist with Donkey Kong gameplay 

At the moment,  the plugin only helps you with the elevator/springs stage.
 - The type of spring being generated is displayed at the top-right near to where the springs are released.  Springs have a type between 0 and 15.  0 being the shortest,  15 being the longest.
 - An alert also appears for short (0-6) and long (12-15) springs.  Helping you to identify them quickly while learning about their behaviour.
 - Fixed safe zones appear in transparent green on DK's girder
 - Variable danger zones appear in red on DK's girder

Compatible with MAME and WolfMAME versions 0.200 and above.
The Plugin is installed by copying the "dkcoach" folder into your MAME plugins folder.

The Plugin is activated by adding `-plugin dkcoach` to your mame arguments e.g.
`mame dkong -plugin dkcoach`  
