lualint performs luac-based static analysis of global variable usage in Lua
source code.

`Usage: lualint [-r|-s] filename.lua [ [-r|-s] [filename.lua] ...]`

## Description

lualint uses luac's bytecode listing. It reports all accesses to undeclared
global variables, which catches many typing errors in variable names. For
example:

    local really_aborting
    local function abort() os.exit(1) end
    if not os.getenv("HOME") then
      realy_aborting = true
      abortt()
    end
    reports:

    /tmp/example.lua:4: *** global SET of realy_aborting
    /tmp/example.lua:5: global get of abortt

It is primarily designed for use on LTN7-style modules, where each source file
only exports one global symbol. (A module contained in the file "foobar.lua"
should only export the symbol "foobar".)

A "relaxed" mode is available for source not in LTN7 style. It only detects
reads from globals that were never set. The switch "-r" puts lualint into
relaxed mode for the following files; "-s" switches back to strict.

Required packages are tracked, although not recursively. If you call
"myext.process()" you should require "myext", and not depend on other
dependencies to load it. LUA_PATH is followed as usual to find requirements.

Some (not strictly LTN7) modules may wish to export other variables into the
global environment. To do so, use the declare function:

    declare "xpairs"
    function xpairs(node)
      [...]

Similarly, to quiet warnings about reading global variables you are aware may
be unavailable:

    lint_ignore "lua_fltk_version"
    if lua_fltk_version then print("fltk loaded") end

One way of defining these is in a module "declare.lua":

    function declare(s)
    end
    declare "lint_ignore"
    function lint_ignore(s)
    end

(Setting declare is OK, because it's in the "declare" module.) These functions
don't have to do anything, or in fact actually exist! They can be in dead code:

    if false then declare "xpairs" end

This is because lualint only performs a rather primitive and cursory scan of
the bytecode. Perhaps declarations should only be allowed in the main chunk.

## TODO

The errors don't come out in any particular order.

Should switch to RiciLake's parser, which should do a much better job of this
and allow detection of some other common situations.

## CREDITS

JayCarlson (nop@nop.com)

This is all Ben Jackson's (ben@ben.com) fault, who did some similar tricks in
MOO.
