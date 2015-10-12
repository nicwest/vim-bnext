" Vimscript Setup: {{{1
let s:save_cpo = &cpo
set cpo&vim

" Private Functions: {{{1
function! s:GetList(modified) abort
  let l:bufnr = bufnr("%")
  let l:winnr = winnr()
  let l:window_list = copy(w:bnext_state.bufs)
  let l:global_list = filter(copy(g:bnext_state.bufs), "index(l:window_list, v:val) == -1")
  let l:list = l:window_list + l:global_list

  if a:modified
    call filter(l:list, "getbufvar(v:val, '&modified')")
  endif

  if g:bnext_five_minute_rule
    if !a:modified || !g:bnext_modified_ignores_five_minute_rule
      let l:five_minutes = localtime() - g:bnext_five_minutes
      call filter(l:list, "getbufvar(v:val, 'bnext_state').time > l:five_minutes")
    endif
  endif

  return l:list
endfunction

function! s:ClearReadOnlyAndUpdate() abort
  augroup bnext_nexting
    au!
  augroup END
  let g:bnext_state.read_only = 0
  execute "set updatetime=".g:bnext_state.updatetime
  call bnext#state#Update()
  execute "norm! \<C-G>"
endfunction

function! s:ChangeBuffer(bufnr) abort
    execute "silent buffer" a:bufnr
    augroup bnext_nexting
      au!
      au CursorHold,WinLeave,InsertEnter,FocusLost * call s:ClearReadOnlyAndUpdate()
    augroup END
endfunction

function! s:SetReadOnly() abort
  if !g:bnext_state.read_only
    let g:bnext_state.read_only = 1
    let g:bnext_state.updatetime = &updatetime
    execute "set updatetime=".g:bnext_confirm_selection_time
  endif
endfunction

" Library Interface: {{{1
function! bnext#Next(modified) abort
  call s:SetReadOnly()

  let l:bufnr = bufnr("%")
  let l:list = s:GetList(a:modified)
  let l:current = index(l:list, l:bufnr)
  let l:next = l:current + 1

  if l:next > len(l:list)-1
    let l:next = 0
  endif
  "echo l:bufnr l:list l:current l:next

  if len(l:list) > 0
    call s:ChangeBuffer(l:list[l:next])
  endif 
endfunction

function! bnext#Previous(modified) abort
  call s:SetReadOnly()

  let l:bufnr = bufnr("%")
  let l:list = s:GetList(a:modified)
  let l:current = index(l:list, l:bufnr)
  let l:previous = l:current - 1

  if l:previous < 0
    let l:previous = len(l:list) - 1
  endif
  "echo l:bufnr l:list l:current l:previous

  if len(l:list) > 0
    call s:ChangeBuffer(l:list[l:previous])
  endif 
endfunction

" Teardown:{{{1
let &cpo = s:save_cpo

" Misc: {{{1
" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:
