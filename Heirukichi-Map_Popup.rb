#==============================================================================
# HEIRUKICHI MAP POP-UP WINDOWS
#==============================================================================
# Version 1.1.2
# - Last update: 07-04-2018 [MM-DD-YYYY]
# - Author: Heirukichi
#==============================================================================
# TERMS OF USE
#------------------------------------------------------------------------------
# You can use this script for both commercial and non commercial games as long
# as proper credit is given to me (Heirukichi).
# You can edit this script as much as you like as long as you do not pretend to
# have written the whole script and you distribute it under the same license.
# The scirpt is licensed under the GNU General Public License v3.0. You can
# review the complete license in the LICENSE or check it at the following link.
#
# GNU GPL 3.0: https://www.gnu.org/licenses/gpl-3.0.html
#
# In addition to this I would like to be notified when this script is used in a
# commercial game. The script is free of charge, but I would like to keep track
# of where my work is being used.
#
# You can contact me using the contact form on my website (check my profile for
# the link). While doing this is not mandatory please do not forget about it.
# It helps a lot.
# Of course feel free to notify me when you use it for non-commercial games as
# well. It is highly appreciated
#
# IMPORTANT NOTICE:
# If you want to share this script, post a link to my website instead.
#==============================================================================
# DESCRIPTION
#------------------------------------------------------------------------------
# This script was commissioned by JosephSeraph from RPGMakerWeb community.
#
# This script adds a popup window to your Scene_Map. This allows you to show
# help messages while the player is walking around.
# Messages can be manually removed or they can have a timer.
# The script gives you the freedom to decide if you want to handle your popup
# window with variables using event commands or using script calls.
#==============================================================================
# INSTRUCTIONS
#------------------------------------------------------------------------------
# - READ THIS PART CAREFULLY BEFORE USING THIS SCRIPT -
# To use this script add it in your project below Materials. It should not have
# any compatibility issue provided you paste it BELOW any other script that
# OVERWRITES methods that are aliased in this script.
#
# To configure this script detailed instructions are written below. Be sure to
# follow them.
#
# If you decide to use event commands to control map popup window then changing
# the variable with ID set in TIMER_VARIABLE sets a timer for the next message.
# That timer resets automatically when its related message is displayed.
# At the same time changing the value of variable with ID set in TEXT_VARIABLE
# makes your popup window visible (when that value is different than 0) or
# invisible (if you set that value back to 0).
#
# If you want to handle your popup window using script calls you can use the
# following:
#
# - set_popup_timer(time)<- time is the number of frames next message will be
#							visible. This timer only starts when you actually
#							show your window.
#
# - hide_popup_window	 <-	makes your popup window invisible. You have to use
#							show_popup_text again if you want to show it again.
#
# - show_popup_text(text, time)	 <-	shows text string in popup window using
#									time as timer frames (optional).
#
# - show_popup_text(text)<-	same as the previous one but without a timer.
#
# - clear_popup_window	 <- clears your popup window and hides it.
#
# Popup window can be activated from any event. A timed window however DOES NOT
# prevent the player from walking. This means you can set up a timer and a text
# message without having to use parallel process events. Just setting them up
# is enough and the wait command in the end is not needed at all.
#
# Here is a little example (this might be a script call in an action button or
# player touch triggered event):
# 
# show_popup_text("This is a test.", 120)
#
# If you copy/paste this in your event you will see that the message stays on
# top of the screen for 120 frames (2 seconds) while the player is still able
# to walk because the event is actually completed.
#==============================================================================
# METHODS LIST
#------------------------------------------------------------------------------
# The list below is a collection of all used methods. Methods are marked with
# different symbols. Each symbol has its own meaning:
# * = aliased methods
# + = new methods
# ! = overwritten methods
#------------------------------------------------------------------------------
# Scene_Map
#	* create_all_windows
#	+ create_map_popup_window	
#	+ show_popup_window
#	+ hide_popup_window
#	+ show_popup_text
#	+ hide_popup_window
#	+ clear_popup_text
#------------------------------------------------------------------------------
# Game_Interpreter
#	* operate_variable
#	+ set_popup_timer
#	+ show_popup_text
#	+ hide_popup_window
#	+ clear_popup_window
#------------------------------------------------------------------------------
# Window_MapPopup (new class, methods with "!" overwrite parent class methods)
#	+ timer
#	+ timed?
#	! initialize
#	! update
#	+ hmpw_show_text
#	+ decrease_timer
#	! hide
#	! standard_padding
#	+ clear_popup_text
#==============================================================================
# CHANGES LOG
#------------------------------------------------------------------------------
# - Version 1.1.2 (07-04-2019)
#   * Minor internal changes to HMPW module methods.
#
# - Version 1.1.1 (10-12-2018)
#	  * Added customizable window padding (window paddin is different from text
#	    padding. It represents the distance between window and screen border).
#==============================================================================

$imported = {}if $imported.nil?
$imported["Heirukichi_MapPopupWindow"] = true
#==============================================================================
# ** HMPW module
#==============================================================================
module HMPW
  #============================================================================
  # ** Config module
  #============================================================================
  module Config
    #==========================================================================
    # TEXT CONTROL SETTINGS
    #==========================================================================
    # This value tells the engine if you are going to store your text in a
    # variable or not. Default is true.
    VARIABLE_CONTROL = true
    #--------------------------------------------------------------------------
    # Set the following value to be the ID of the variable you want to use
    # to display your text. Default is 35.
    # No need to change this value if the previous is set to false.
    TEXT_VARIABLE = 35
    #--------------------------------------------------------------------------
    # Set the following value to true if you want your window to disappear
    # automatically after a certain amount of time or to false if you do
    # not want it to disappear automatically. Default is true.
    AUTO_HIDE = true
    #--------------------------------------------------------------------------
    # The following value is the ID of the variable used to store timer
    # frames. When this variable reaches 0 your popup window disappears.
    # If the variable is 0 when message is displayed then your popup window
    # does not automatically disappear. Default is 36.
    TIMER_VARIABLE = 36
    #==========================================================================
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #==========================================================================
    # WINDOW SETTINGS
    #==========================================================================
    # These values are used to auto-adjust window size. You can customize
    # them as much as you want. Their names are self-explanatory but if you
    # are not sure each one is explained in commends.
    #--------------------------------------------------------------------------
    # Total height of your popup window. Default is 96 (2 normal lines).
    WINDOW_HEIGHT = 72
    #--------------------------------------------------------------------------
    # Window width mode. It tells the engine to obtain window width from
    # window padding or window width. 0 - Window Width, 1 - Window Padding.
    # Default is 0.
    WINDOW_WIDTH_MODE = 0
    #--------------------------------------------------------------------------
    # Total width of your popup window. Default is 0 (whole screen width).
    WINDOW_WIDTH = 0
    #--------------------------------------------------------------------------
    # Window horizontal and vertical padding (first value for horizontal,
    # second value for vertical). Default is 12 for both of them. 
    # NOTE: values are in pixels, they are not related to grid squares.
    WINDOW_PADDING = [12, 12]
    #--------------------------------------------------------------------------
    # Your custom padding (distance between window border and text rect).
    # Default is 12 (same as default padding in RPG Maker VX Ace).
    CUSTOM_PADDING = 12
    #--------------------------------------------------------------------------
    # Window position: 0 - bottom, 1 - top, 2 - middle. Default is 0.
    WINDOW_POSITION = 0
    #==========================================================================
  end # end of Config module
  #============================================================================
  # - - - - - - - - - - - - - ! WARNING ! - - - - - - - - - - - - - - - - - - -
  #----------------------------------------------------------------------------
  # Any modification after this point might compromise this script. Do not
  # modify anything written below unless you know exactly what you are doing.
  #============================================================================
  # * Text Stored in a Variable?
  #----------------------------------------------------------------------------
  def self.variable_control?
    return Config::VARIABLE_CONTROL
  end
  #----------------------------------------------------------------------------
  # * ID of the Variable containing text
  #----------------------------------------------------------------------------
  def self.id
    return Config::TEXT_VARIABLE
  end
  #----------------------------------------------------------------------------
  # * Popup activated or not
  #----------------------------------------------------------------------------
  def self.popup_activated?(var_id)
    return (variable_control? && (var_id == id))
  end
  #----------------------------------------------------------------------------
  # * Text Padding
  #----------------------------------------------------------------------------
  def self.padding
    return Config::CUSTOM_PADDING
  end
  #----------------------------------------------------------------------------
  # * Width Mode is Padding?
  #----------------------------------------------------------------------------
  def self.window_padding?
    return (Config::WINDOW_WIDTH_MODE == 1)
  end
  #----------------------------------------------------------------------------
  # * Window Horizontal Padding
  #----------------------------------------------------------------------------
  def self.window_padding_horz
    return 0 unless window_padding?
    return Config::WINDOW_PADDING[0]
  end
  #----------------------------------------------------------------------------
  # * Window Vertical Padding
  #----------------------------------------------------------------------------
  def self.window_padding_vert
    return 0 unless window_padding?
    return Config::WINDOW_PADDING[1]
  end
  #----------------------------------------------------------------------------
  # * Window Height
  #----------------------------------------------------------------------------
  def self.height
    return Config::WINDOW_HEIGHT
  end
  #----------------------------------------------------------------------------
  # * Window Width
  #----------------------------------------------------------------------------
  def self.width
    return (Graphics.width - 2 * window_padding_horz) if window_padding?
    return (Config::WINDOW_WIDTH == 0 ? Graphics.width : Config::WINDOW_WIDTH)
  end
  #----------------------------------------------------------------------------
  # * Window X Position
  #----------------------------------------------------------------------------
  def self.wx
    return ((Graphics.width - width) / 2)
  end
  #----------------------------------------------------------------------------
  # * Window Y Position
  #----------------------------------------------------------------------------
  def self.wy
    y_pos = case Config::WINDOW_POSITION
    when 1
      0 + window_padding_vert
    when 2
      (Graphics.height - height) / 2
    else
      Graphics.height - height - window_padding_vert
    end
    return y_pos
  end
  #----------------------------------------------------------------------------
  # * Window Hides Automatically?
  #----------------------------------------------------------------------------
  def self.auto_hide?
    return Config::AUTO_HIDE
  end
  #----------------------------------------------------------------------------
  # * ID of Variable used as a Timer
  #----------------------------------------------------------------------------
  def self.timer_id
    return Config::TIMER_VARIABLE
  end
  #----------------------------------------------------------------------------
  # * Variable used as a Timer
  #----------------------------------------------------------------------------
  def self.timer_variable
    return $game_variables[timer_id]
  end
end # end of HMPW module
#==============================================================================
# * Scene Map
#==============================================================================
class Scene_Map < Scene_Base
  #----------------------------------------------------------------------------
  # * Aliased method: create_all_windows
  #----------------------------------------------------------------------------
  alias hmpw_create_all_windows_old  create_all_windows
  def create_all_windows
    hmpw_create_all_windows_old
    create_map_popup_window
  end
  #----------------------------------------------------------------------------
  # + New method:create_map_popup_window
  #----------------------------------------------------------------------------
  def create_map_popup_window
    @popup_window = Window_MapPopup.new
    @popup_window.viewport = @viewport
  end
  #----------------------------------------------------------------------------
  # + New method: show_popup_window
  #----------------------------------------------------------------------------
  def show_popup_window
    @popup_window.show
  end
  #----------------------------------------------------------------------------
  # + New method: hide_popup_window
  #----------------------------------------------------------------------------
  def hide_popup_window
    @popup_window.hide
  end
  #----------------------------------------------------------------------------
  # + New method: show_popup_text
  #----------------------------------------------------------------------------
  def show_popup_text(text, time = 0)
    time = HMPW.timer_variable if ((time == 0) && HMPW.auto_hide?)
    @popup_window.hmpw_show_text(text, time)
    $game_variables[HMPW.timer_id] = 0 if HMPW.auto_hide?
  end
  #----------------------------------------------------------------------------
  # + New method: hide_popup_window
  #----------------------------------------------------------------------------
  def hide_popup_window
    @popup_window.hide
  end
  #----------------------------------------------------------------------------
  # + New method: clear_popup_text
  #----------------------------------------------------------------------------
  def clear_popup_text
    @popup_window.clear_popup_text
    hide_popup_window
  end
end # end of SceneMap class
#==============================================================================
# * Game Interpreter
#==============================================================================
class Game_Interpreter
  #----------------------------------------------------------------------------
  # * Aliased method: operate_variable
  #----------------------------------------------------------------------------
  alias hmpw_operate_variable_old  operate_variable
  def operate_variable(variable_id, operation_type, value)
    hmpw_operate_variable_old(variable_id, operation_type, value)
    if HMPW.popup_activated?(variable_id)
      if value != 0
        show_popup_text(value)
      else
        clear_popup_window
      end
    end
  end
  #----------------------------------------------------------------------------
  # + New method: set_popup_timer
  #----------------------------------------------------------------------------
  def set_popup_timer(time)
    time = 0 if time < 0
    $game_variables[HMPW.timer_id] = time
  end
  #----------------------------------------------------------------------------
  # + New method: show_popup_text
  #----------------------------------------------------------------------------
  def show_popup_text(text, timer = 0)
    SceneManager.scene.show_popup_text(text, timer)
  end
  #----------------------------------------------------------------------------
  # + New method: hide_popup_window
  #----------------------------------------------------------------------------
  def hide_popup_window
    SceneManager.scene.hide_popup_window
  end
  #----------------------------------------------------------------------------
  # + New method: clear_popup_window
  #----------------------------------------------------------------------------
  def clear_popup_window
    SceneManager.scene.clear_popup_text
  end
end # end of Game_Interpreter class
#==============================================================================
# * Window Map Popup (new class)
#==============================================================================
class Window_MapPopup < Window_Base
  #----------------------------------------------------------------------------
  # * Read-only attributes
  #----------------------------------------------------------------------------
  attr_reader    :timer
  #----------------------------------------------------------------------------
  # * Timed?
  #----------------------------------------------------------------------------
  def timed?;      @timed;      end;
  #----------------------------------------------------------------------------
  # * Initialize
  #----------------------------------------------------------------------------
  def initialize
    super(HMPW.wx, HMPW.wy, HMPW.width, HMPW.height)
    @timer = 0
    @timed = false
    self.hide
  end
  #----------------------------------------------------------------------------
  # * Frame Update
  #----------------------------------------------------------------------------
  def update
    super
    decrease_timer if timed?
  end
  #----------------------------------------------------------------------------
  # * Show text (also makes the window visible)
  #----------------------------------------------------------------------------
  def hmpw_show_text(text, time = 0)
    contents.clear
    draw_text_ex(0, 0, text)
    if (time > 0)
      @timer = time
      @timed = true
    end
    self.show
  end
  #----------------------------------------------------------------------------
  # * Decrease Timer
  #----------------------------------------------------------------------------
  def decrease_timer
    @timer -= 1
    self.hide if (timer == 0)
  end
  #----------------------------------------------------------------------------
  # * Hide (also pauses the timer)
  #----------------------------------------------------------------------------
  def hide
    @timed = false
    super
  end
  #----------------------------------------------------------------------------
  # * Standard Padding (depends on HMPW configuration)
  #----------------------------------------------------------------------------
  def standard_padding
    HMPW.padding
  end
  #----------------------------------------------------------------------------
  # * Clear Pop-up text
  #----------------------------------------------------------------------------
  def clear_popup_text
    contents.clear
  end
end # end of Window_MapPopup class
