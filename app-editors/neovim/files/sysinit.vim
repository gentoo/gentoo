" Default Gentoo configuration file for neovim
" Based on the default vimrc shipped by Gentoo with app-editors/vim-core
" $Id$

" You can override any of these settings on a global basis via the
" "/etc/vim/nvimrc.local" file, and on a per-user basis via "~/.nvimrc".
" You may need to create these.

" Neovim comes with sensible defaults, see:
" https://github.com/neovim/neovim/issues/2676
" Most of the general settings from Gentoo's vimrc have been dropped here.
" We add only some necessary fixes and a few Gentoo specific settings.

" {{{ Locale settings
" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  " If we have to add this, the default encoding is not Unicode.
  let g:added_fenc_utf8 = 1
  set fileencodings+=utf-8
endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
  if executable("/bin/bash")
    set shell=/bin/bash
  elseif executable("/bin/sh")
    set shell=/bin/sh
  endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

  " In text files, limit the width of text to 78 characters, but be careful
  " that we don't override the user's setting.
  autocmd BufNewFile,BufRead *.txt
        \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
        \   setlocal textwidth=78 |
        \ endif

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if ! exists("g:leave_my_cursor_position_alone") |
        \   if line("'\"") > 0 && line ("'\"") <= line("$") |
        \     exe "normal g'\"" |
        \   endif |
        \ endif

  " When editing a crontab file, set backupcopy to yes rather than auto. See
  " :help crontab and bug #53437.
  autocmd FileType crontab set backupcopy=yes

  " If we previously detected that the default encoding is not UTF-8
  " (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
  " characters at all) isn't a Unicode file, but is in the default encoding.
  " Except of course if a byte-order mark is in effect.
  autocmd BufReadPost *
        \ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" &&
        \   ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
        \     set fileencoding= |
        \ endif

  " Strip trailing spaces on write
  autocmd BufWritePre *.e{build,class}
        \ if ! exists("g:leave_my_trailing_space_alone") |
        \   :%s/\s\+$//e |
        \ endif

augroup END

endif " has("autocmd")
" }}}

" {{{ nvimrc.local
if filereadable("/etc/vim/nvimrc.local")
  source /etc/vim/nvimrc.local
endif
" }}}

" vim: set tw=80 sw=2 sts=2 et foldmethod=marker :
