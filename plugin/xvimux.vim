if exists("g:loaded_global_navigator") | finish | endif
let g:loaded_global_navigator = 1

function! s:GlobalAwareNavigate(direction)
  call system('rm ~/.cache/xvimux')
  let nr = winnr()
  execute 'wincmd ' . a:direction
  let at_tab_page_edge = (nr == winnr())
  if at_tab_page_edge
    if a:direction ==? 'h'
        let tmux_check = 'left'
    elseif a:direction ==? 'j'
        let tmux_check = 'bottom'
    elseif a:direction ==? 'k'
        let tmux_check = 'top'
    elseif a:direction ==? 'l'
        let tmux_check = 'right'
    endif
    if !empty($TMUX)
      let tmux_b = system('tmux display -p \#{pane_at_' .tmux_check. '}')
      call system('xvimux ' .a:direction. ' true')
      let tmux_a = system('tmux display -p \#{pane_at_' .tmux_check. '}')
      if tmux_a == 1 && tmux_b == 1
        call system('echo 1 > ~/.cache/xvimux')
      else | return | endif
    endif
    call system('echo 1 > ~/.cache/xvimux')
  endif
endfunction

command! -nargs=? GlobalNavigate call s:GlobalAwareNavigate(<f-args>)
