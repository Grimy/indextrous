" Copyright © 2015 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

" Disable auto-highlighting when switching to another mode
function! indextrous#after()
	normal! `'
	let before = indextrous#count_matches(@/ . '\V\%>''''\@!')
	let after  = indextrous#count_matches(@/ . '\V\%>''''')
	call indextrous#report_matches(before + 1, before + after)
	set hlsearch
	autocmd Indextrous InsertEnter,CursorMoved * set nohlsearch | echo | autocmd! Indextrous
	normal! `'zx
endfunction

function! indextrous#redraw()
	set nohlsearch
	diffupdate
	redraw!
	return ''
endfunction

function! indextrous#count_matches(pattern)
	redir => _
	execute 'keepjumps keeppatterns silent! %s/' . a:pattern . '/&/en' . (&gdefault ? '' : 'g')
	redir END
	return str2nr(_[1:])
endfunction

let s:suffixes = ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th']

function! indextrous#report_matches(i, total)
	if a:total == 1
		echo 'Only match'
	elseif a:i == a:total
		echo 'Last of' a:total 'matches'
	elseif a:total != 0
		echo a:i . s:suffixes[a:i % 100 / 10 == 1 ? 0 : a:i % 10] 'of' a:total 'matches'
	endif
endfunction
