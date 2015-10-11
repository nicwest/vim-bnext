" Vimscript Setup: {{{1
let s:save_cpo = &cpo
set cpo&vim

function! s:NewGenericState() abort
  let l:state = {}
  let l:state.time = localtime()
  let l:state.bufs = []

  function! l:state.AddBuffer(bufnr) dict abort
    call self.RemoveBuffer(a:bufnr)
    if getbufvar(a:bufnr, "&buflisted")
      call insert(self.bufs, a:bufnr)
    endif
  endfunction

  function! l:state.RemoveBuffer(bufnr) dict abort
    call filter(self.bufs, 'v:val != a:bufnr')
  endfunction

  return l:state 
endfunction

" Private Functions: {{{1
function! s:NewBufferState() abort
  let l:state = <SID>NewGenericState()
  return l:state
endfunction

function! s:NewWindowState() abort
  let l:state = <SID>NewGenericState()
  return l:state
endfunction

function! s:NewGlobalState() abort
  let l:state = <SID>NewGenericState()
  let l:state.read_only = 0
  let l:state.updatetime = &updatetime
  return l:state
endfunction

function! s:GetBufferState(bufnr) abort
  return getbufvar(a:bufnr, "bnext_state")
endfunction

function! s:GetWindowState(winnr) abort
  return getwinvar(a:winnr, "bnext_state")
endfunction


" Library Interface: {{{1
function! bnext#state#NewBuffer() abort
  if !exists("b:bnext_state")
    let l:bufnr = bufnr("%")
    call setbufvar(l:bufnr, "bnext_state", <SID>NewBufferState())
  endif

  if !g:bnext_state.read_only
    let b:bnext_state.time = localtime()
  endif
endfunction

function! bnext#state#NewWindow() abort
  if !exists("w:bnext_state")
    let l:winnr = winnr()
    let l:bufnr = winbufnr(l:winnr)
    let l:window_state = <SID>NewWindowState()
    call l:window_state.AddBuffer(l:bufnr)
    call setwinvar(l:winnr, "bnext_state", l:window_state)
  endif
endfunction

function! bnext#state#Update() abort
  if !g:bnext_state.read_only
    let l:bufnr = bufnr("%")
    call w:bnext_state.AddBuffer(l:bufnr)
    call g:bnext_state.AddBuffer(l:bufnr)
  endif
endfunction

function! bnext#state#Setup() abort
  let l:bufnr = bufnr("%")
  let g:bnext_state = <SID>NewGlobalState()
  call g:bnext_state.AddBuffer(l:bufnr)
  let w:bnext_state = <SID>NewWindowState()
  call w:bnext_state.AddBuffer(l:bufnr)
  let b:bnext_state = <SID>NewBufferState()
endfunction

function! bnext#state#ClearReadOnly() abort
  augroup bnext_nexting
    au!
  augroup END
  let g:bnext_state.read_only = 0
endfunction

" Teardown:{{{1
let &cpo = s:save_cpo

" Misc: {{{1
" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:
