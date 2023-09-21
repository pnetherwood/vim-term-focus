vim-term-focus
==============

Report focus events in Vim for supported terminal emulators. 

Focus change events are reported in gvim but not in terminal vim by default. This plugin used the Focus Reporting feature available in some
terminal emulators to capture focus change events that can be used by vim autocmd.

For example you could create an autocmd to save all files when focus changes:

```vim
autocmd FocusLost * :wa
```
or perhaps redraw the screen on focus gained:

```vim
autocmd FocusGained * :redraw!
```
Installation and Usage
----------------------

Use you favourite plugin manager to install e.g.:

```vim
Plug 'pnetherwood/vim-term-focus'
```

Supported Terminals
-------------------

Focus Reporting events are (sadly) not reported on all terminals. To test if Focus Reporting is available on your favourite terminal
emulator run this  command in your shell:

    echo -e "Focus Reporting \033[?1004hcheck ..." && read -N 3 -s -t 10; if [ "${REPLY:1:2}" == "[O" ] || [ "${REPLY:1:2}" == "[I" ]; then echo "Focus reporting supported"; else echo "No focus reporting"; fi; echo -ne '\e[?1004l' 

You may need to switch focus for the terminal to report the change. You'll either get a message the "Focus reporting supported" or after 10
seconds of waiting that there is "No focus reporting".

vim-term-focus has been tested and is working on the following terminal emulators:

* Windows (i.e. Cygwin/MSYS2 and WSL):
  - Mintty
  - WSLtty
* Linux:
  - Gnome
  - xterm
* OS X:
  - iterm2

It does not work in the following terminals:

* Windows:
  - Cmd
  - Cmder 1.3.14
  - ConEmu 19.10.12.0
  - Windows Terminal 0.10.781.0
  - MobaXTerm 20.1.0
  - Terminus 1.0.105
  - Alacritty 0.4.1
  - Fluent Terminal 0.6.1.0

Let me know of you find any others that it works in.

Tmux
----

It also works in Tmux. For tmux to work `focus events` need to be turned on using

    set -g focus-events on

in your `.tmux.conf`. Don't forget to restart the session for it to take effect.

Other Plugins
-------------

There are a few other plugins that do a similar job such as [Vitality](https://github.com/sjl/vitality.vim), [vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events) and [Terminus](https://github.com/wincent/terminus). However they tend to do other things or be based on a single terminal. This plugin aims to do just one job which is just handling terminal events. The other plugins may work better for you. The code was shamelessly ripped off from Steve Losh's Vitality plugin so thanks Steve.


License
-------

MIT/X11
