set scrolloff=8
set sidescrolloff=8
set number
set relativenumber
set ignorecase
set smartcase
set incsearch
set hlsearch
set history=10000
set showcmd
set showmode
set notimeout

set ideajoin
set idearefactormode=select
set ideamarks
set ideawrite=all
set ideastatusicon=enabled

" Clipboard: ideaput enables IDE paste with automatic import insertion
set clipboard+=unnamed
set clipboard+=unnamedplus
set clipboard+=ideaput

let g:highlightedyank_highlight_duration = "300"

" argtextobj: extend to all bracket types (matches mini.ai scope)
let g:argtextobj_pairs="(:),{:},[:],<:>"

" EasyMotion: disable auto-mappings; defined explicitly below
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

let mapleader = " "
