indextrous
==========

A Vim plugin improving searches with better highlighting and index indications
(e.g. "3rd of 7 matches").

Highlighting
------------

Highlighting search results is a useful feature. However, the results stay
highlighted forever, which is an annoyance. The :nohlsearch command was
introduced as a workaround, but it has its own limitations. This plugin tries
to turn highlighting on when you need it, and off when you don’t.
More specifically:
* &hlsearch is set by the following: / ? \* # n N g\* g#
* &hlsearch is unset by moving or entering insert mode

Redrawing
---------


Indexing
--------

After each successful search, one of the following messages is displayed:
* Only match
* N(st|nd|rd|th) of M matches
* Last of N matches
The default error messages when searches wrap are suppressed (this is done by adding the 's' flag to &shortmess).

Issues
------

If another plugin uses
