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

    nnoremap <silent> <f24> :silent doautocmd FocusLost %<cr>
    nnoremap <silent> <f25> :silent doautocmd FocusGained %<cr>

    onoremap <silent> <f24> <esc>:silent doautocmd FocusLost %<cr>
    onoremap <silent> <f25> <esc>:silent doautocmd FocusGained %<cr>

    vnoremap <silent> <f24> <esc>:silent doautocmd FocusLost %<cr>gv
    vnoremap <silent> <f25> <esc>:silent doautocmd FocusGained %<cr>gv

    inoremap <silent> <f24> <c-\><c-o>:silent doautocmd FocusLost %<cr>
    inoremap <silent> <f25> <c-\><c-o>:silent doautocmd FocusGained %<cr>

    cnoremap <silent> <f24> <c-\>e<SID>DoCmdFocusLost()<cr>
    cnoremap <silent> <f25> <c-\>e<SID>DoCmdFocusGained()<cr>
endfunction

function s:DoCmdFocusLost()
    let cmd = getcmdline()
    let pos = getcmdpos()

    silent doautocmd FocusLost %

    call setcmdpos(pos)
    return cmd
endfunction

function s:DoCmdFocusGained()
    let cmd = getcmdline()
    let pos = getcmdpos()

    silent doautocmd FocusGained %
    
    call setcmdpos(pos)
    return cmd
endfunction

call s:FocusReporting()

let &cpo = s:save_cpo
unlet s:save_cpo
