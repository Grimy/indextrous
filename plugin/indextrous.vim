" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

augroup Indextrous | augroup END

" No errors when search wraps
set shortmess+=s

" Enable highlighting after any search
nnoremap <silent> *  :autocmd! Indextrous<CR>*: call indextrous#after()<CR>
nnoremap <silent> #  :autocmd! Indextrous<CR>#: call indextrous#after()<CR>
nnoremap <silent> n  :autocmd! Indextrous<CR>n: call indextrous#after()<CR>
nnoremap <silent> N  :autocmd! Indextrous<CR>N: call indextrous#after()<CR>
nnoremap <silent> g* :autocmd! Indextrous<CR>g*:call indextrous#after()<CR>
nnoremap <silent> g# :autocmd! Indextrous<CR>g#:call indextrous#after()<CR>
cnoremap <CR> <C-R>=getcmdtype()=~#'[?/]'&&feedkeys(":call indextrous#after()\n", 'n')<CR><BS><CR>

" Ctrl-L clears the screen in all modes
onoremap <silent> <C-L> <Esc>@=indextrous#redraw() . v:operator<CR>
nnoremap <silent> <C-L> @=indextrous#redraw()<CR>
vnoremap <silent> <C-L> @=indextrous#redraw()<CR>
cnoremap <expr> <C-L> "\<C-C>:call indextrous#redraw()\n" . getcmdtype() . "\<Up>"
inoremap <C-L> <C-O>:call indextrous#redraw()<CR>
