FIDDLERS!
=========

Fiddling is hard, here take these:

How it works
------------

There are (at least) two lists of buffers, one global and one for each window.

```viml
let global_list = ['foo.txt', 'bar.txt']
let window_list = ['bar.txt']
```

When a new listed buffer enters a window it's prepended to both the global list
and it's window list.

```viml
let global_list = ['boo.txt', 'foo.txt', 'bar.txt']
let window_list = ['boo.txt', 'bar.txt']
```

When :Bnext is called (:BNext works in the same way but backwards), it
concatenates  both lists excluding any repeated buffers from the global list 

```viml
let global_list = ['boo.txt', 'foo.txt', 'bar.txt']
let window_list = ['boo.txt', 'bar.txt']
let list = ['boo.txt', 'bar.txt'] + ['foo.txt']
```

Then it finds the index of the current buffer and loads the next item in the
list

```viml
let current_buffer = 'bar.txt'
let list = ['boo.txt', 'bar.txt', 'foo.txt']
let current = 1
let next = 2
buffer next
```

If the user is on the last item of the list then we go back to the start of the
list

```viml
let current_buffer = 'foo.txt'
let list = ['boo.txt', 'bar.txt', 'foo.txt']
let current = 2
let next = 0
buffer next
```

This means that windows can have independent history but fall back to the global
history when they run out of items

```viml
let global_list = ['boo.txt', 'foo.txt', 'bar.txt']
let window_one_list = ['boo.txt', 'bar.txt']
let window_two_list = ['foo.txt']
let list_one = ['boo.txt', 'bar.txt'] + ['foo.txt']
let list_two = ['foo.txt'] + ['boo.txt', 'bar.txt']
```

The tricky bit is that we don't want to mess up the order while the user pages
through. As such when we start paging we set the global state to read only and
ignore new buffers enter windows. This is later cleared with an autogroup that
updates the lists again after a period of inaction (among other things).

```viml

let current_buffer = 'boo.txt'
let global_list = ['boo.txt', 'foo.txt', 'bar.txt']
let window_list = ['boo.txt', 'bar.txt']

" START PAGING 
let read_only = 1
buffer 'bar.txt'

let global_list = ['boo.txt', 'foo.txt', 'bar.txt']
let window_list = ['boo.txt', 'bar.txt']
buffer 'foo.txt'

" AUTOCMD MAGIC AFTER USER HAS STOPPED
let read_only = 0
let global_list = ['foo.txt', 'boo.txt', 'bar.txt']
let window_list = ['foo.txt', 'boo.txt', 'bar.txt']
```

NOTE: The autocmd magic looks for things that probably mean that the user is no
longer paging through buffers. At the moment that is doing nothing for a period
of time (specified by g:bnext_confirm_selection_time), leaving the window,
entering insert mode, or vim loosing focus.  **It's probably not an exhaustive
list**. 
