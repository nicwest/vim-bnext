" Vimscript Setup: {{{1
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development.
if exists("g:loaded_bnext")
  let &cpo = s:save_cpo
  finish
endif
let g:loaded_bnext = 1

" Options: {{{1
if !exists('g:bnext_state')
  call bnext#state#Setup()
endif

if !exists('g:bnext_five_minute_rule')
  let g:bnext_five_minute_rule = 1
endif

if !exists('g:bnext_confirm_selection_time')
  let g:bnext_confirm_selection_time = 1500
endif

if !exists('g:bnext_modified_ignores_five_minute_rule')
  let g:bnext_modified_ignores_five_minute_rule = 1
endif

if !exists('g:bnext_five_minutes')
  let g:bnext_five_minutes = 300
endif

" Private Functions: {{{1
function! s:Next(modified) abort
    call bnext#Next(a:modified)
endfunction

function! s:Previous(modified) abort
    call bnext#Previous(a:modified)
endfunction

function! s:FiveMinuteRule() abort
  if g:bnext_five_minute_rule
    let g:bnext_five_minute_rule = 0
    echo "Disabled the five minute rule"
  else
    let g:bnext_five_minute_rule = 1
    echo "Enabled the five minute rule"
  endif
endfunction


" Commands: {{{1
command! -nargs=0 -bar -bang Bnext call <SID>Next("<bang>" == "!")
command! -nargs=0 -bar -bang BNext call <SID>Previous("<bang>" == "!")
command! -nargs=0 -bar FiveMinuteRule call <SID>FiveMinuteRule()

" Autocmds: {{{1
augroup bnext_general
  au!
  au VimEnter * call bnext#state#Setup()
  au BufNewFile * call bnext#state#ClearReadOnly()
  au WinEnter * call bnext#state#NewWindow()
  au BufWinEnter * call bnext#state#NewBuffer()
  au BufWinEnter * call bnext#state#Update()
augroup END

" Teardown: {{{1
let &cpo = s:save_cpo

" Misc: {{{1
" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:
