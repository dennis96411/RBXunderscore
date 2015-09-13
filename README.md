# RBXunderscore
Object wrapper and utility functions for ROBLOX Lua

<b>I'm too lazy to write up a long read me, so this is all you're getting.</b>

# What is it?
This is essentially an object wrapper that provides functions and methods for different objects.
* Functionalities
  * Method/function chaining
    * Input: _({1, 2, 3}):Reverse():Trim(2):Each(print)
    * Output: 2 1
  * Detailed tostring
    * Input: 
    * Output:

# Why did you create this?
I liked how versatile JavaScript is. Everything had methods and made life a lot easier. I'm attempting to copy some similar functionalities over from JavaScript.

# How do I use this?
Simple. Just copy the content of the ModuleScript file into a ModuleScript instance, and in the script you would like to use this in, put <b>_ = require(--location of script--)</b> at the top.

# Examples
* Print every property of Workspace: <b>print(_(Workspace):GetAllMembers("Properties"))</b>
* Print every class of Workspace.BasePlate: <b>print(_(Workspace.BasePlate):GetAllClasses())</b>
