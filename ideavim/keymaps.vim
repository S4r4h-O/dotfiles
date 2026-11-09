"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL REMAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap gl $
nnoremap gh _
noremap 0 ^

xnoremap c "_c
xnoremap C "_C
xnoremap s "_s
xnoremap S "_S

snoremap c <C-R>_c
snoremap C <C-R>_C
snoremap s <C-R>_s
snoremap S <C-R>_S

xnoremap p "_dP
xnoremap P "_dP

nnoremap <Esc> :nohlsearch<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NAVIGATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Better up and down
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
xnoremap <Down> gj
xnoremap <Up> gk

" https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
nnoremap <expr> n 'Nn'[v:searchforward]
xnoremap <expr> n 'Nn'[v:searchforward]
onoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]
xnoremap <expr> N 'nN'[v:searchforward]
onoremap <expr> N 'nN'[v:searchforward]

" indentation
xnoremap <       <gv
xnoremap >       >gv
nnoremap <Tab>   >>
xnoremap <Tab>   >gv
nnoremap <S-Tab> <<
xnoremap <S-Tab> <gv

" files
nmap <leader><space> <Action>(GotoFile)
nmap <leader>ff      <Action>(GotoFile)
nmap <leader>fF      <Action>(GotoFile)
nmap <leader>fr      <Action>(RecentFiles)
nmap <leader>fR      <Action>(RenameFile)
nmap <leader>fn      <Action>(NewFile)
nmap <leader>fe      <Action>(ActivateProjectToolWindow)
nmap <leader>fE      <Action>(SelectInProjectView)

" search
nmap  <leader>/   <Action>(FindInPath)
nmap  <leader>sg  <Action>(FindInPath)
nmap  <leader>sG  <Action>(FindInPath)
nmap  <leader>ss  <Action>(GotoSymbol)
nmap  <leader>sS  <Action>(GotoClass)
nmap  <leader>sr  <Action>(ReplaceInPath)
nmap  <leader>sd  <Action>(ShowErrorDescription)
nmap  <leader>sk  <Action>(GotoAction)
nmap  <leader>sn  <Action>(ActivateNotificationsToolWindow)

" flash
"nmap z         <Action>(flash.search)
"xmap z         <Action>(flash.search)
"nmap Z         <Action>(flash.treesitter)
"xmap Z         <Action>(flash.treesitter)
"omap <leader>z <Action>(flash.remote)
"nmap f         <Action>(flash.find)
"xmap f         <Action>(flash.find)
"nmap F         <Action>(flash.find_backward)
"xmap F         <Action>(flash.find_backward)
"nmap t         <Action>(flash.till)
"xmap t         <Action>(flash.till)
"nmap T         <Action>(flash.till_backward)
"xmap T         <Action>(flash.till_backward)
"nmap ;         <Action>(flash.repeat)
"xmap ;         <Action>(flash.repeat)
"nmap ,         <Action>(flash.repeat_backward)
"xmap ,         <Action>(flash.repeat_backward)

""" Better insert mode navigation

" Go to line above/below in insert mode
inoremap <C-n> <C-o>j
inoremap <C-p> <C-o>k

" Insert line down/below
inoremap <C-k> <C-o>O
inoremap <C-j> <C-o>o

" Deletion
inoremap <C-d> <C-o>"_cc
inoremap <C-c> <C-o>"_D

" Left Right in insert mode without arrow keys
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Jump words in insert mode
inoremap <M-.> <C-o>w
inoremap <M-,> <C-o>b
inoremap <M-[> <C-o>W
inoremap <M-]> <C-o>B

" Start/End of line
inoremap <M-1> <C-o>^
inoremap <M-0> <C-o>$

" Paste
inoremap <M-p> <C-o>P

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDITING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Line movement
nmap <A-j> <Action>(MoveLineDown)
nmap <A-k> <Action>(MoveLineUp)
imap <A-j> <Action>(MoveLineDown)
imap <A-k> <Action>(MoveLineUp)
xmap <A-j> <Action>(MoveStatementDown)
xmap <A-k> <Action>(MoveStatementUp)

" Move character in normal mode
nnoremap <C-l> xp
nnoremap <C-h> xhP

" File operations
nnoremap <A-a> ggVG
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>gi
xnoremap <C-s> <Esc>:w<CR>

" Copy
nnoremap <C-y> :%y<CR>
xnoremap <C-y> :%y<CR>
inoremap <C-y> <C-o>:%y<CR>

" Delete operations
nnoremap <A-d>d "_dd
xnoremap <A-d>d "_d
inoremap <A-d>d <Esc>"_ddi
nnoremap <A-d>w "_diw
xnoremap <A-d>w "_d
nnoremap <A-l>  "_dG

" Duplicate lines
nmap <C-d> <Action>(EditorDuplicate)
xmap <C-d> <Action>(EditorDuplicate)

" VimMulticursor (dankinsoid)
" mc/ + search: Add cursors at all occurrences of search regex.
" mcfx, mcFx: Add cursors at all occurrences of character x.
" mcw, mcW, mcb, mcB: Add cursors at words start.
" mce, mcE: Add cursors at words end.
" mcaw: Around word
" mca + bracket: Around bracket, like mca(/mcab, mca{/mcaB, mca", etc
" mci + bracket: Inside bracket, like mci(/mcib, mci{/mciB, mci", etc
" mcaa/mcia: any bracket
" Cursor Management
" mcc: Add or remove a cursor highlight at the current position (preview mode)
" mcr: Convert cursor highlights to active editing cursors
" mcd: Remove all cursors and highlights
" mcia: Place cursors inside any brackets or quotes ((), [], {}, "", '', ``)
" mcaa: Place cursors around any brackets or quotes
" mcaw: Add cursors at word boundaries (at the start and end of current word)
" add cursor
map mm <Plug>(multicursor-mcc)
" enter editing mode
map mi <Plug>(multicursor-mcr)
" remove all cursors
map md <Plug>(multicursor-mcd)

" Surround
nmap gsa ys
nmap gsd ds
nmap gsr cs

nmap yc yy<cmd>normal gcc<CR>p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap gd <Action>(GotoDeclaration)
nmap gD <Action>(GotoTypeDeclaration)
nmap gr <Action>(FindUsages)
nmap gI <Action>(GotoImplementation)
nmap gy <Action>(GotoTypeDeclaration)
nmap gK <Action>(ParameterInfo)
nmap K  <Action>(QuickJavaDoc)

nmap ]d <Action>(GotoNextError)
nmap [d <Action>(GotoPreviousError)
nmap ]e <Action>(GotoNextError)
nmap [e <Action>(GotoPreviousError)
nmap ]w <Action>(GotoNextWarning)
nmap [w <Action>(GotoPreviousWarning)

" code+refactor
nmap <leader>ca <Action>(ShowIntentionActions)
xmap <leader>ca <Action>(ShowIntentionActions)
nmap <leader>cr <Action>(RenameElement)
nmap <leader>cf <Action>(ReformatCode)
xmap <leader>cf <Action>(ReformatCode)
nmap <leader>cF <Action>(OptimizeImports)
nmap <leader>cs <Action>(FileStructurePopup)
nmap <leader>cS <Action>(GotoSymbol)
nmap <leader>cd <Action>(ShowErrorDescription)
nmap <leader>cn <Action>(Generate)
nmap <leader>ci <Action>(ToggleInlayHintsGloballyAction)
nmap <leader>ch <Action>(ReformatCode)
nmap <leader>cg <Action>(Generate)
nmap <leader>co <Action>(OverrideMethods)
nmap <leader>cO <Action>(ImplementMethods)
nmap <leader>cP <Action>(QuickActionPopup)
nmap <leader>cR <Action>(Refactorings.QuickListPopupAction)
xmap <leader>cR <Action>(Refactorings.QuickListPopupAction)
nmap <leader>cx <Action>(ExtractMethod)
xmap <leader>cx <Action>(ExtractMethod)
nmap <leader>cX <Action>(ExtractFunction)
xmap <leader>cX <Action>(ExtractFunction)
nmap <leader>cv <Action>(IntroduceVariable)
xmap <leader>cv <Action>(IntroduceVariable)
nmap <leader>cI <Action>(Inline)
nmap <leader>cC <Action>(ChangeSignature)
nmap <leader>cp <Action>(IntroduceParameter)
nmap <leader>ck <Action>(IntroduceConstant)

" Diagnostics
nmap <leader>xx <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xd <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xl <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xq <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xt <Action>(ActivateTODOToolWindow)
nmap <leader>xT <Action>(ActivateTODOToolWindow)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDITOR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" buffers
nmap <leader>,  <Action>(Switcher)
nmap <leader>fb <Action>(Switcher)
nmap <leader>bb <Action>(Switcher)
nmap <leader>bd <Action>(CloseContent)
"nmap <C-x>      <Action>(CloseContent)
nmap <leader>bD <Action>(CloseAllEditors)
nmap <leader>bo <Action>(CloseAllEditorsButActive)
nmap <leader>bp <Action>(PinActiveTabToggle)

nmap <leader>wv <Action>(SplitVertically)
nmap <leader>ws <Action>(SplitHorizontally)

nmap <C-Right> <C-w>>
nmap <C-Left>  <C-w><
nmap <C-Up>    <C-w>+
nmap <C-Down>  <C-w>-

nmap H <Action>(PreviousTab)
nmap L <Action>(NextTab)

" version control
nmap <leader>gg <Action>(ActivateVersionControlToolWindow)
nmap <leader>gb <Action>(Annotate)
nmap <leader>gB <Action>(Git.Branches)
nmap <leader>gl <Action>(Git.Log)
nmap <leader>gL <Action>(Vcs.ShowTabbedFileHistory)
nmap <leader>gs <Action>(Vcs.QuickListPopupAction)
nmap <leader>gp <Action>(Git.Pull)
nmap <leader>gP <Action>(Vcs.Push)
nmap <leader>gc <Action>(CheckinProject)
nmap <leader>gr <Action>(Vcs.RollbackChangedLines)
nmap <leader>gS <Action>(Git.Stash)
nmap <leader>gU <Action>(Git.Unstash)
nmap <leader>gh <Action>(Vcs.RollbackChangedLines)

nmap ]h <Action>(VcsShowNextChangeMarker)
nmap [h <Action>(VcsShowPrevChangeMarker)

" Explorer
nmap <leader>e <Action>(ActivateProjectToolWindow)
nmap <leader>E <Action>(SelectInProjectView)

" quit/session
nmap <leader>qq <Action>(Exit)
nmap <leader>qQ <Action>(Exit)
nmap <leader>ql <Action>(ManageRecentProjects)
nmap <leader>qs <Action>(SaveAll)
nmap <leader>qr <Action>(IdeaVim.ReloadVimRc)

" UI
nmap <leader>ud <Action>(ToggleDistractionFreeMode)
nmap <leader>uf <Action>(ToggleFullScreen)
nmap <leader>ul <Action>(EditorToggleShowLineNumbers)
nmap <leader>uw <Action>(EditorToggleUseSoftWraps)
nmap <leader>uz <Action>(ToggleZenMode)
nmap <leader>ui <Action>(ToggleInlayHintsGloballyAction)

" terminal
nmap <leader>tt <Action>(ActivateTerminalToolWindow)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" run
nmap <leader>rR <Action>(RunClass)
nmap <leader>rr <Action>(Run)
nmap <leader>rl <Action>(Rerun)
nmap <leader>rs <Action>(Stop)
nmap <leader>ro <Action>(ActivateRunToolWindow)
nmap <leader>rc <Action>(ChooseRunConfiguration)
"nmap <leader>rc <Action>(RedesignedRunConfigurationSelector)

" debug
nmap <leader>db <Action>(ToggleLineBreakpoint)
nmap <leader>dB <Action>(EditBreakpoint)
nmap <leader>dc <Action>(Resume)
nmap <leader>dC <Action>(RunToCursor)
nmap <leader>dd <Action>(Debug)
nmap <leader>di <Action>(StepInto)
nmap <leader>do <Action>(StepOut)
nmap <leader>dj <Action>(StepOver)
nmap <leader>dk <Action>(Debugger.PopFrame)
nmap <leader>ds <Action>(Stop)
nmap <leader>dw <Action>(Debugger.AddToWatch)
nmap <leader>du <Action>(ActivateDebugToolWindow)
nmap <leader>dv <Action>(ViewBreakpoints)
