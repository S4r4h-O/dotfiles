" General motions
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-u> <C-u>zz
nnoremap <leader>h :nohlsearch<CR>
xnoremap < <gv
xnoremap > >gv

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Buffer/tab navigation (LazyVim parity: H/L)
nmap H <Action>(PreviousTab)
nmap L <Action>(NextTab)
nmap [b <Action>(PreviousTab)
nmap ]b <Action>(NextTab)

" Line movement (LazyVim parity: Alt+j/k)
nmap <A-j> <Action>(MoveLineDown)
nmap <A-k> <Action>(MoveLineUp)
xmap <A-j> <Action>(MoveStatementDown)
xmap <A-k> <Action>(MoveStatementUp)

" File operations
nnoremap <A-a> ggVG
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>gi
xnoremap <C-s> <Esc>:w<CR>

" Scrolling/Copy logic
nnoremap <C-y> "+yy
xnoremap <C-y> "+y
inoremap <C-y> <Esc>"+yyi

" Delete operations (LazyVim parity: Black hole register)
nnoremap <A-d>d "_dd
xnoremap <A-d>d "_d
inoremap <A-d>d <Esc>"_ddi
nnoremap <A-d>w "_diw
xnoremap <A-d>w "_d
nnoremap <A-l>  "_dG

" Duplicate lines
nmap <C-d> <Action>(EditorDuplicate)
xmap <C-d> <Action>(EditorDuplicate)

" Flash
nmap s <Action>(flash.search)
xmap s <Action>(flash.search)
nmap S <Action>(flash.search)
xmap S <Action>(flash.search)
omap r <Action>(flash.remote)

" EasyMotion
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>J <Plug>(easymotion-bd-jk)

" Surround
nmap gsa ys
nmap gsd ds
nmap gsr cs
vmap gsa S

" VimMulticursor (dankinsoid)
map q <Plug>(multicursor-ms/)
map z <Plug>(multicursor-mcc)
map Z <Plug>(multicursor-mci)
map <leader>w <Plug>(multicursor-msw)
map <leader>b <Plug>(multicursor-msb)

" LSP / Navigation (LazyVim parity)
nmap gd <Action>(GotoDeclaration)
nmap gD <Action>(GotoTypeDeclaration)
nmap gr <Action>(FindUsages)
nmap gI <Action>(GotoImplementation)
nmap gy <Action>(GotoTypeDeclaration)
nmap gK <Action>(ParameterInfo)
nmap K  <Action>(QuickJavaDoc)

" Diagnostics (LazyVim parity: [d / ]d)
nmap ]d <Action>(GotoNextError)
nmap [d <Action>(GotoPreviousError)
nmap ]e <Action>(GotoNextError)
nmap [e <Action>(GotoPreviousError)
nmap ]w <Action>(GotoNextWarning)
nmap [w <Action>(GotoPreviousWarning)

" Git Hunks (LazyVim parity: [h / ]h)
nmap ]h <Action>(VcsShowNextChangeMarker)
nmap [h <Action>(VcsShowPrevChangeMarker)

" Leader: files (<leader>f)
nmap <leader><space> <Action>(GotoFile)
nmap <leader>ff      <Action>(GotoFile)
nmap <leader>fF      <Action>(GotoFile)
nmap <leader>fr      <Action>(RecentFiles)
nmap <leader>fR      <Action>(RenameFile)
nmap <leader>fn      <Action>(NewFile)
nmap <leader>fe      <Action>(ActivateProjectToolWindow)
nmap <leader>fE      <Action>(SelectInProjectView)

" Leader: search (<leader>s)
nmap <leader>/  <Action>(FindInPath)
nmap <leader>sg <Action>(FindInPath)
nmap <leader>sG <Action>(FindInPath)
nmap <leader>ss <Action>(GotoSymbol)
nmap <leader>sS <Action>(GotoClass)
nmap <leader>sr <Action>(ReplaceInPath)
nmap <leader>sd <Action>(ShowErrorDescription)
nmap <leader>sk <Action>(GotoAction)
nmap <leader>sn <Action>(ActivateNotificationsToolWindow)

" Leader: buffers (<leader>b / <leader>,)
nmap <leader>,  <Action>(Switcher)
nmap <leader>fb <Action>(Switcher)
nmap <leader>bb <Action>(Switcher)
nmap <leader>bd <Action>(CloseContent)
nmap <leader>bD <Action>(CloseAllEditors)
nmap <leader>bo <Action>(CloseAllEditorsButActive)
nmap <leader>bp <Action>(PinActiveTabToggle)

" Leader: windows (<leader>w)
nmap <leader>ww <Action>(NextSplitter)
nmap <leader>wd <Action>(Unsplit)
nmap <leader>wD <Action>(UnsplitAll)
nmap <leader>wm <Action>(MoveEditorToOppositeTabGroup)
nmap <leader>|  <Action>(SplitVertically)
nmap <leader>-  <Action>(SplitHorizontally)

" Leader: code + refactor (<leader>c)
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

" Leader: refactoring (<leader>r)
nmap <leader>r  <Action>(Refactorings.QuickListPopupAction)
xmap <leader>r  <Action>(Refactorings.QuickListPopupAction)
nmap <leader>rf <Action>(ExtractMethod)
xmap <leader>rf <Action>(ExtractMethod)
nmap <leader>rv <Action>(IntroduceVariable)
xmap <leader>rv <Action>(IntroduceVariable)
nmap <leader>ri <Action>(Inline)
nmap <leader>rs <Action>(ChangeSignature)
nmap <leader>rp <Action>(IntroduceParameter)
nmap <leader>rc <Action>(IntroduceConstant)
nmap <leader>rn <Action>(RenameElement)
nmap <leader>rF <Action>(ExtractFunction)

" Leader: git (<leader>g)
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

" Leader: explorer
nmap <leader>e <Action>(ActivateProjectToolWindow)
nmap <leader>E <Action>(SelectInProjectView)

" Leader: diagnostics (<leader>x)
nmap <leader>xx <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xd <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xl <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xq <Action>(ActivateProblemsViewToolWindow)
nmap <leader>xt <Action>(ActivateTODOToolWindow)
nmap <leader>xT <Action>(ActivateTODOToolWindow)

" Leader: run (<leader>r)
nmap <leader>rr <Action>(RunClass)
nmap <leader>rR <Action>(Run)
nmap <leader>rl <Action>(Rerun)
nmap <leader>rs <Action>(Stop)
nmap <leader>ro <Action>(ActivateRunToolWindow)

" Leader: debug (<leader>d)
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

" Leader: REST (<leader>R)
" nmap <leader>Rr <Action>(HTTPClient.RunAll)
" nmap <leader>Rs <Action>(ActivateServicesToolWindow)
" nmap <leader>Ri <Action>(ActivateServicesToolWindow)
" nmap <leader>Re <Action>(HTTPClient.RunAll)

" Leader: quit/session (<leader>q)
nmap <leader>qq <Action>(Exit)
nmap <leader>qQ <Action>(Exit)
nmap <leader>ql <Action>(ManageRecentProjects)
nmap <leader>qs <Action>(SaveAll)

" Leader: UI toggles (<leader>u)
nmap <leader>ud <Action>(ToggleDistractionFreeMode)
nmap <leader>uf <Action>(ToggleFullScreen)
nmap <leader>ul <Action>(EditorToggleShowLineNumbers)
nmap <leader>uw <Action>(EditorToggleUseSoftWraps)
nmap <leader>uz <Action>(ToggleZenMode)
nmap <leader>ui <Action>(ToggleInlayHintsGloballyAction)

" Reload
nmap <leader>sv <Action>(IdeaVim.ReloadVimRc.reload)
