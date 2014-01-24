" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Smart search highlighting
" Enable highlighting before any search
nnoremap <silent> *   *:call <SID>after_search()<CR>
nnoremap <silent> #   #:call <SID>after_search()<CR>
nnoremap <silent> n   n:call <SID>after_search()<CR>
nnoremap <silent> N   N:call <SID>after_search()<CR>
nnoremap <silent> g* g*:call <SID>after_search()<CR>
nnoremap <silent> g# g#:call <SID>after_search()<CR>

function! s:after_search()
	if s:did_after_search
		return
	endif
	let s:did_after_search = 1

	let after  = CountMatches(@/ . "\\%>'m")
	let before = CountMatches(@/ . "\\%<'m")
	call SetHlSearch(after + before < line('$'))
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
	if a:total == 0
		" Don’t print anything
	elseif a:total == 1
		echo 'Only match'
	elseif a:index == a:total
		echo 'Last of' a:total 'matches'
	else
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
	let s:did_after_search = a:type ==# ':'
endfunction

" TODO: suppress error messages, limit search range
function! SearchOne(backward, inclusive, mode)
	let c = escape(GetChar(), '\')
	let @/ = '\V' . (a:inclusive ? c : a:backward ? c . '\zs' : '\.\ze' . c)
	return (a:mode ==# 'no' ? 'v' : '') . (a:backward ? 'N' : 'n')
endfunction

let g:last_cmd_type = ':'
nnoremap : :call CommandLineEnter(':')<CR>:
nnoremap / :call CommandLineEnter('/')<CR>/
nnoremap ? :call CommandLineEnter('?')<CR>?
cnoremap <silent> <CR> <CR>:call <SID>after_search()<CR>

noremap <silent> <expr> t SearchOne(0, 0, mode(1))
noremap <silent> <expr> f SearchOne(0, 1, mode(1))
noremap <silent> <expr> T SearchOne(1, 0, mode(1))
noremap <silent> <expr> F SearchOne(1, 1, mode(1))

" Never map printable charcarters in select mode
sunmap t
sunmap f
sunmap T
sunmap F

noremap <expr> <C-P> g:last_cmd_type . "\<Up>"

" Better Redraw
function! Redraw()
	call SetHlSearch(0)
	diffupdate
	redraw!
	return ''
endfunction

" Ctrl-L clears search highlighting in all modes
onoremap <silent> <C-L> <Esc>@=Redraw() . v:operator<CR>
nnoremap <silent> <C-L> @=Redraw()<CR>
vnoremap <silent> <C-L> @=Redraw()<CR>
cnoremap <C-L> <C-C>:call Redraw()<CR>@=g:last_cmd_type<CR><Up>
inoremap <C-L> <C-O>:call Redraw()<CR>

