" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" TODO: separate autoload file

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Smart search highlighting
" Enable highlighting before any search
nnoremap <silent> *   *:call g:after_search()<CR>
nnoremap <silent> #   #:call g:after_search()<CR>
nnoremap <silent> n   n:call g:after_search()<CR>
nnoremap <silent> N   N:call g:after_search()<CR>
nnoremap <silent> g* g*:call g:after_search()<CR>
nnoremap <silent> g# g#:call g:after_search()<CR>

function! g:after_search()
	let after  = CountMatches(@/ . '\V\%<''m\@!')
	let before = CountMatches(@/ . '\V\%<''m')
	call SetHlSearch(1)
	call ReportMatches(before + 1, before + after)
endfunction

function! SetHlSearch(val)
	let &hlsearch = a:val
	augroup Indextrous
		autocmd! Indextrous
		if &hlsearch
			" Disable auto-highlighting when switching to another mode
			autocmd InsertEnter,CursorMoved * call SetHlSearch(0)
		endif
	augroup END
endfunction

function! CountMatches(pattern)
	let save = @/
	let @/ = a:pattern
	normal! mm

	redir => _
	silent %s//&/gen
	redir END

	normal! `m
	let @/ = save
	return str2nr(_[1:])
endfunction

function! ReportMatches(index, total)
	if a:total == 1
		echo 'Only match'
	elseif a:index == a:total
		echo 'Last of' a:total 'matches'
	elseif a:total != 0
		echo Ordinal(a:index) 'of' a:total 'matches'
	endif
endfunction

function! Ordinal(n)
	return a:n . (a:n % 100 / 10 == 1 ? 'th' :
				\ a:n % 10 == 1 ? 'st' :
				\ a:n % 10 == 2 ? 'nd' :
				\ a:n % 10 == 3 ? 'rd' : 'th')
endfunction

function! CommandLineEnter(type)
	let g:last_cmd_type = a:type
	call SetHlSearch(0)
endfunction

let g:last_cmd_type = ':'
nnoremap : :call CommandLineEnter(':')<CR>:
nnoremap / :call CommandLineEnter('/')<CR>/
nnoremap ? :call CommandLineEnter('?')<CR>?
cnoremap <silent><expr> <CR> getcmdtype() ==# ':' ? "\n" : "\n:call g:after_search()\n"

noremap <expr> <C-P> g:last_cmd_type . "\<Up>"

" Ctrl-L clears search highlighting in all modes
function! Redraw()
	call SetHlSearch(0)
	diffupdate
	redraw!
	return ''
endfunction

onoremap <silent> <C-L> <Esc>@=Redraw() . v:operator<CR>
nnoremap <silent> <C-L> @=Redraw()<CR>
vnoremap <silent> <C-L> @=Redraw()<CR>
cnoremap <C-L> <C-C>:call Redraw()<CR>@=g:last_cmd_type<CR><Up>
inoremap <C-L> <C-O>:call Redraw()<CR>

