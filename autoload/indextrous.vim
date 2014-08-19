" Copyright © 2014 Grimy <Victor.Adam@derpymail.org>
" This work is free software. You can redistribute it and/or modify it under
" the terms of the Do What The Fuck You Want To Public License, Version 2, as
" published by Sam Hocevar. See the LICENCE file for more details.

function! indextrous#after_search()
	let after  = indextrous#count_matches(@/ . '\V\%<''m\@!')
	let before = indextrous#count_matches(@/ . '\V\%<''m')
	call indextrous#set_hlsearch(1)
	call indextrous#report_matches(before + 1, before + after)
endfunction

function! indextrous#redraw()
	call indextrous#set_hlsearch(0)
	diffupdate
	redraw!
	return ''
endfunction

function! indextrous#set_hlsearch(val)
	let &hlsearch = a:val
	augroup Indextrous
		autocmd! Indextrous
		if &hlsearch
			" Disable auto-highlighting when switching to another mode
			autocmd InsertEnter,CursorMoved * call indextrous#set_hlsearch(0)
		endif
	augroup END
endfunction

function! indextrous#count_matches(pattern)
	keepjumps normal! mm
	redir => _
	execute 'keepjumps keeppatterns silent %s/' . a:pattern . '/&/gen'
	redir END
	keepjumps normal! `m
	return str2nr(_[1:])
endfunction

function! indextrous#report_matches(index, total)
	if a:total == 1
		echo 'Only match'
	elseif a:index == a:total
		echo 'Last of' a:total 'matches'
	elseif a:total != 0
		echo indextrous#ordinal(a:index) 'of' a:total 'matches'
	endif
endfunction

function! indextrous#ordinal(n)
	return a:n . (a:n % 100 / 10 == 1 ? 'th' :
				\ a:n % 10 == 1 ? 'st' :
				\ a:n % 10 == 2 ? 'nd' :
				\ a:n % 10 == 3 ? 'rd' : 'th')
endfunction
