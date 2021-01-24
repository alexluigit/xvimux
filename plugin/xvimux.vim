if exists("g:loaded_global_navigator") | finish | endif
let g:loaded_global_navigator = 1

function! s:GlobalAwareNavigate(direction)
  call system('rm ~/.cache/xvimux')
  let nr = winnr()
  execute 'wincmd ' . a:direction
  let at_tab_page_edge = (nr == winnr())
  if at_tab_page_edge
    if a:direction ==? 'h'
        let tmux_check = 'left' | let wm_dir = 'west'
    elseif a:direction ==? 'j'
        let tmux_check = 'bottom' | let wm_dir = 'south'
    elseif a:direction ==? 'k'
        let tmux_check = 'top' | let wm_dir = 'north'
    elseif a:direction ==? 'l'
        let tmux_check = 'right' | let wm_dir = 'east'
    endif
    if !empty($TMUX)
      let tmux_b = system('tmux display -p \#{pane_at_' .tmux_check. '}')
      call system('xvimux ' .wm_dir. ' true')
      let tmux_a = system('tmux display -p \#{pane_at_' .tmux_check. '}')
      if tmux_a == 1 && tmux_b == 1
        call system('echo 1 > ~/.cache/xvimux')
      else | return | endif
    endif
    call system('echo 1 > ~/.cache/xvimux')
  endif
endfunction

command! -nargs=? GlobalNavigate call s:GlobalAwareNavigate(<f-args>)
