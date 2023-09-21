if has('gui_running')
    finish
endif

if (exists('loaded_term_focus') || &cp)
    finish
endif

let loaded_term_focus = 1

let s:save_cpo = &cpo
set cpo&vim

let s:inside_tmux = exists('$TMUX')

function! s:FocusReporting()
    let save_screen = "\<Esc>[?1049h"
    let restore_screen = "\<Esc>[?1049l"
    let enable_focus_reporting  = "\<Esc>[?1004h"
    let disable_focus_reporting = "\<Esc>[?1004l"

    if s:inside_tmux
      let tmux_start = "\<Esc>Ptmux;"
      let tmux_end = "\<Esc>\\"

      let enable_focus_reporting = tmux_start
              \ . "\<Esc>" . enable_focus_reporting
              \ . tmux_end
              \ . enable_focus_reporting
    endif

    let &t_ti = enable_focus_reporting . save_screen . &t_ti
    let &t_te = disable_focus_reporting . restore_screen

    execute "set <f24>=\<Esc>[O"
    execute "set <f25>=\<Esc>[I"

    nnoremap <silent> <f24> :call <SID>DoFocusLost()<cr>
    nnoremap <silent> <f25> :call <SID>DoFocusGained()<cr>

    onoremap <silent> <f24> <esc>:call <SID>DoFocusLost()<cr>
    onoremap <silent> <f25> <esc>:call <SID>DoFocusGained()<cr>

    vnoremap <silent> <f24> <esc>:call <SID>DoFocusLost()<cr>gv
    vnoremap <silent> <f25> <esc>:call <SID>DoFocusGained()<cr>gv

    inoremap <silent> <f24> <c-\><c-o>:call <SID>DoFocusLost()<cr>
    inoremap <silent> <f25> <c-\><c-o>:call <SID>DoFocusGained()<cr>

    tnoremap <silent> <f24> <c-\><c-n>:call <SID>DoFocusLost()<cr>i
    tnoremap <silent> <f25> <c-\><c-n>:call <SID>DoFocusGained()<cr>i

    cnoremap <silent> <f24> <c-\>e<SID>DoCmdFocusLost()<cr>
    cnoremap <silent> <f25> <c-\>e<SID>DoCmdFocusGained()<cr>
endfunction

function! s:DoFocusLost()
  doautocmd FocusLost
endfunction

function! s:DoFocusGained()
  doautocmd FocusGained
endfunction

function! s:DoCmdFocusLost()
    let cmd = getcmdline()
    let pos = getcmdpos()

    call <SID>DoFocusLost()

    call setcmdpos(pos)
    return cmd
endfunction

function! s:DoCmdFocusGained()
    let cmd = getcmdline()
    let pos = getcmdpos()

    call <SID>DoFocusGained()
    
    call setcmdpos(pos)
    return cmd
endfunction

call s:FocusReporting()

let &cpo = s:save_cpo
unlet s:save_cpo
