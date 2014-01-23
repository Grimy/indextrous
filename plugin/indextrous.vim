" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" Auto-escape '/' in search
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Smart search highlighting
" Enable highlighting before any search
Map n <silent> *   *:call AfterSearch()<CR>
Map n <silent> #   #:call AfterSearch()<CR>
Map n <silent> n   n:call AfterSearch()<CR>
Map n <silent> N   N:call AfterSearch()<CR>
Map n <silent> g* g*:call AfterSearch()<CR>
Map n <silent> g# g#:call AfterSearch()<CR>

augroup NoHlSearch
augroup END
augroup HlSearch
augroup END


function! AfterSearch()
	let &hlsearch = strlen(substitute(@/, '\\zs', '', 'g')) > 1

	" Disable auto-highlighting when switching to another mode
	autocmd HlSearch InsertEnter,CursorHold * call SetHlSearch(1)

	normal! mm

	let after  = CountMatches(@/ . "\\%>'m")
	let before = CountMatches(@/ . "\\%<'m")
	call ReportMatches(before + 1, before + after)

	normal! `m
endfunction

function! SetHlSearch(val)
	let &hlsearch = a:val
	autocmd! NoHlSearch
	autocmd! HlSearch
	if &hlsearch
		autocmd NoHlSearch InsertEnter,CursorHold * call SetHlSearch(0)
	endif
endfunction
function! CountMatches(pattern)
	let save = @/
	let @/ = a:pattern

	redir => _
	silent %s//&/gen
	redir END

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

let g:last_cmd_type = ':'
nnoremap : :call CommandLineEnter(':')<CR>:
nnoremap / :call CommandLineEnter('/')<CR>/
nnoremap ? :call CommandLineEnter('?')<CR>?

function! CommandLineEnter(type)
	let g:last_cmd_type = a:type
	call SetHlSearch(0)
	if a:type !=# ':'
		autocmd HlSearch CursorMoved * call AfterSearch()
	endif
endfunction

Map nov <expr> t SearchOne(0, 0)
Map nov <expr> f SearchOne(0, 1)
Map nov <expr> T SearchOne(1, 0)
Map nov <expr> F SearchOne(1, 1)

function! SearchOne(backward, inclusive)
	let @/ = GetChar() . (a:inclusive ? '\zs' : '')
	return a:backward ? 'N' : 'n'
endfunction

Map nv <nosilent> <expr> <C-P> g:last_cmd_type . "\<Up>"

" Clear screen
Map o  <C-L> <C-\><C-N>:call Redraw()<CR>:call feedkeys(v:operator, 'n')<CR>
Map nv <C-L> @=Redraw() ? '' : '' <CR>
Map c  <C-L> <C-C>:call Redraw()<CR>@=g:last_cmd_type<CR><Up>
Map i  <C-L> <C-O>:call Redraw()<CR>

function! Redraw()
	call SetHlSearch(0)
	diffupdate
	redraw!
endfunction

