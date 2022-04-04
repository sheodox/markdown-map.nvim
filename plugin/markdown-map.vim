if exists('g:loaded_markdownmap') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

lua require('markdownmap')

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_markdownmap = 1
