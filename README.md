Bnext
=====

Yet another buffer management tool!

Bnext is an enhancement of the built-in :bnext and :bNext commands that
remembers what buffers you previously had open, in what window, and what
order you opened them in.

Install
-------

Use you favourite plugin manager.

I like vim-plug and would recomend it over vundle, pathogen, etc:

```viml
Plug 'nicwest/bnext.vim'
```

Commands
--------

```viml
:Bnext           " Goes to the next buffer
:BNext           " Goes to the previous buffer
:Bnext!          " Goes to the next modified buffer
:BNext!          " Goes to the previous modified buffer
:FiveMinuteRule  " Toggles the five minute rule
```

Options
-------

```viml
" Is the five minute rule enabled. 0 = No, 1 = Yes

g:bnext_five_minute_rule = 1


" Amount of time spent (in Milliseconds) on a buffer without doing anything that
" counts as a selection (i.e. it will enter Bnexts global and window history) 

g:bnext_confirm_selection_time = 1500


" When doing :Bnext! and :BNext should this respect the five minute rule?
" 0 = No, 1 = Yes

g:bnext_modified_ignores_five_minute_rule = 1


" Five minutes in seconds. This can be changed if you disagree with this
" assertion

g:bnext_five_minutes = 300

```

Five Minute Rule
----------------

The five minute rule is fairly simple. It keeps track of things that you have
looked at in the last five minutes and will filter results based on that.

This can be useful to filter out results that you aren't likely to be looking
for like that CSS file you looked at 3 hours ago.


