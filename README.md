# Map_Popup_Window-VXAce
_Author: Heirukichi_


## DESCRIPTION
This script was commissioned by JosephSeraph from RPGMakerWeb community.

This script adds a popup window to your Scene_Map. This allows you to show help messages while the player is walking around.
Messages can be manually removed or they can have a timer.
The script gives you the freedom to decide if you want to handle your popup window with variables using event commands or using script calls.

## TABLE OF CONTENTS
* [Installation](#installation)
* [Usage](#usage)
  * [Compatibility](#compatibility)
* [License](#license)
  * [Important Notice](#important-notice)

## INSTALLATION
**- READ THIS PART CAREFULLY BEFORE USING THIS SCRIPT -**
To use this script add it in your project below Materials. It should not have any compatibility issue provided you paste it BELOW any other script that OVERWRITES methods that are aliased in this script.

To configure this script detailed instructions are written below. Be sure to follow them.

## USAGE
If you decide to use event commands to control map popup window then changing the variable with ID set in TIMER_VARIABLE sets a timer for the next message.
That timer resets automatically when its related message is displayed.
At the same time changing the value of variable with ID set in TEXT_VARIABLE makes your popup window visible (when that value is different than 0) or invisible (if you set that value back to 0).

If you want to handle your popup window using script calls you can use the following:
- `set_popup_timer(time)` time is the number of frames next message will be	visible. This timer only starts when you actually	show your window.
- `hide_popup_window`	makes your popup window invisible. You have to use
							show_popup_text again if you want to show it again.
- `show_popup_text(text, time)`	shows text string in popup window using time as timer frames (optional).
- `show_popup_text(text)` same as the previous one but without a timer.
- `clear_popup_window` clears your popup window and hides it.

Popup window can be activated from any event. A timed window however DOES NOT prevent the player from walking. This means you can set up a timer and a text message without having to use parallel process events. Just setting them up is enough and the wait command in the end is not needed at all.

Here is a little example (this might be a script call in an action button or player touch triggered event):
`show_popup_text("This is a test.", 120)`

If you copy/paste this in your event you will see that the message stays on top of the screen for 120 frames (2 seconds) while the player is still able to walk because the event is actually completed.

------------------------------------------------------------------

#### COMPATIBILITY
The list below is a collection of all methods used. Methods are marked with different symbols. Each symbol has its own meaning.
Be sure to keep this in mind when considering compatibility with other scripts.
 
Symbol | Meaning
-------|--------
\* | aliased methods
\+ | new methods
! | overwritten methods
 
------------------------------------------------------------------
 
 _Scene_Map_
* \* `create_all_windows`
* \+ `create_map_popup_window	`
* \+ `show_popup_window`
* \+ `hide_popup_window`
* \+ `show_popup_text`
* \+ `hide_popup_window`
* \+ `clear_popup_text`

_Game_Interpreter_
* \* `operate_variable`
* \+ `set_popup_timer`
* \+ `show_popup_text`
* \+ `hide_popup_window`
* \+ `clear_popup_window`

_Window_MapPopup_ (new class, methods with "!" overwrite parent class methods)
- \+ `timer`
- \+ `timed?`
- \! `initialize`
- \! `update`
- \+ `hmpw_show_text`
- \+ `decrease_timer`
- \! `hide`
- \! `standard_padding`
- \+ `clear_popup_text`

------------------------------------------------------------------

## LICENSE
The code is under the GNU General Public License v3.0. You can review the complete GNU General Public License v3.0 in the LICENSE file or at this [link](https://www.gnu.org/licenses/gpl-3.0.html).

To sum up things you are free to use this material in any commercial and non commercial project as long as _ALL_ the following conditions are satisfied:
- proper credit is given to me (Heirukichi);
- a link to my website is provided (I recommend adding it to a credits.txt file in your project, but any other mean is fine);
- if you modify anything, you still provide credit and properly mark the parts you have modified.

In addition, I would like to be notified if you use this in any project.
You can send me a message containing a link to the finished product using the contact form on my website (check my profile for the link).
The link is not supposed to contain a free copy of the finished product.
The sole purpose of the link is to help me keeping track of where my work is being used.

#### IMPORTANT NOTICE:
 If you want to share this script, post a link to my website instead.
