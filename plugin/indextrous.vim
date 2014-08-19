" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" No errors when search wraps
set shortmess+=s

" Enable highlighting after any search
nnoremap <silent> *   *:call indextrous#after_search()<CR>
nnoremap <silent> #   #:call indextrous#after_search()<CR>
nnoremap <silent> n   n:call indextrous#after_search()<CR>
nnoremap <silent> N   N:call indextrous#after_search()<CR>
nnoremap <silent> g* g*:call indextrous#after_search()<CR>
nnoremap <silent> g# g#:call indextrous#after_search()<CR>
cnoremap <silent><expr> <CR> getcmdtype() =~# '[?/]' ? "\n:call indextrous#after_search()\n" : "\n"

" Ctrl-L clears the screen in all modes
onoremap <silent> <C-L> <Esc>@=indextrous#redraw() . v:operator<CR>
nnoremap <silent> <C-L> @=indextrous#redraw()<CR>
vnoremap <silent> <C-L> @=indextrous#redraw()<CR>
cnoremap <expr> <C-L> "\<C-C>:call indextrous#redraw()\n" . getcmdtype() . "\<Up>"
inoremap <C-L> <C-O>:call indextrous#redraw()<CR>
