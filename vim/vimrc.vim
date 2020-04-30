" vim:set expandtab shiftwidth=2 tabstop=8 textwidth=72:

let mapleader = "\<space>"

if has('autocmd')
  au!
endif

if has('gui_running')
  set guifont=DejaVuSansMonoPowerline:h14
  set guifontwide=DejaVuSansMonoPowerline:h14
  set guioptions+=T

  " Don't lazy load menu (before source $VIMRUNTIME/vimrc_example.vim)
  let do_syntax_sel_menu = 1
  let do_no_lazyload_menus = 1
endif

set encoding=utf-8
source $VIMRUNTIME/vimrc_example.vim

source $VIMRUNTIME/ftplugin/man.vim

set completeopt=menuone
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
set fileencodings=ucs-bom,utf-8,gb18030,latin1
set formatoptions+=mM
set ignorecase smartcase
set keywordprg=:Man
set nobackup
set scrolloff=1
set spelllang+=cjk
set tags=./tags;,tags,/usr/local/etc/systags

if v:version >= 800
  packadd! editexisting
endif

if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undodir
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
endif

if has('mouse')
  if has('gui_running') || (&term =~ 'xterm' && !has('mac'))
    set mouse=a
  else
    set mouse=nvi
  endif
endif

if !has('gui_running')
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <Leader>m :emenu <C-Z>
  endif

  " Use true color of terminal if possible.
  if has('termguicolors') &&
    \ ($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
    set termguicolors
  endif
endif

set directory=~/.vim/swap//
if !isdirectory(&directory)
  call mkdir(&directory, 'p', 0700)
endif

nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

nnoremap <Up>        gk
inoremap <Up>   <C-O>gk
nnoremap <Down>      gj
inoremap <Down> <C-O>gj

nnoremap <C-Tab>   <C-W>w
inoremap <C-Tab>   <C-O><C-W>w
nnoremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W

nnoremap <Leader>v viw"0p
vnoremap <Leader>v "0p

" Expand %% to buffer directory in command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Use & to repeat substitution.
nnoremap & :&&<CR>

nnoremap <Leader>qo :copen<CR>
nnoremap <Leader>qc :cclose<CR>
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>

function! GoToFirstNonBlankOrFirstColumn()
  let cur_col = col('.')
  normal! ^
  if cur_col != 1 && cur_col == col('.')
    normal! 0
  endif
  return ''
endfunction
nnoremap <silent> <Home> :call GoToFirstNonBlankOrFirstColumn()<CR>
inoremap <silent> <Home> <C-R>=GoToFirstNonBlankOrFirstColumn()<CR>

" C highlight
let g:c_space_errors = 1
let g:c_gnu = 1
let g:c_no_cformat = 1
let g:c_no_curly_error = 1
if exists('g:c_comment_strings')
  unlet g:c_comment_strings
endif

if has('autocmd')
  function! SetMakeprg()
    let makeprg = ''
    let filetypes = ['sh', 'bash', 'zsh', 'dart', 'ruby']
    if index(filetypes, &ft) >= 0
      let &l:makeprg = &ft . ' ' . expand('%:p')
    elseif &ft == 'go'
      let &l:makeprg = 'go run ' . expand('%:p')
    endif
  endfunction

  function! RunBind()
    if &ft == 'dart'
      exec 'nnoremap <silent> <buffer> ' '<Leader>r'  ":FlutterRun<CR>"
    endif
  endfunction

  function! GnuIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
  endfunction

  " Set height of asyncrun quickfix window.
  let g:asyncrun_open = 10

  au FileType c,cpp setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=:0,g0,(0,w1
  au FileType sh,bash,zsh,dart,json,python,ruby,vim setlocal expandtab shiftwidth=2 softtabstop=2

  au FileType help nnoremap <buffer> q <C-W>c

  au FileType * call SetMakeprg()
  au FileType * call RunBind()

  au BufRead /usr/include/* call GnuIndent()

  aug QFClose
    au!
    au WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | q | endif
  aug END
endif

nnoremap <Leader>rt :RainbowToggle<CR>

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#overflow_marker = '…'
let g:airline#extensions#tabline#show_tab_nr = 0

let g:LargeFile = 100

set background=dark
colorscheme PaperColor

nnoremap <Leader>sa :call SyntaxAttr()<CR>

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']

nnoremap <Leader>tt :TagbarToggle<CR>

if exists('$PRIVATE_GITLAB_DOMAIN')
  let g:fugitive_gitlab_domains = [ $PRIVATE_GITLAB_DOMAIN ]
endif

nnoremap <F5> :if g:asyncrun_status != 'running'<bar>
                \if &modifiable<bar>
                  \update<bar>
                \endif<bar>
                \exec 'Make'<bar>
              \else<bar>
                \AsyncStop<bar>
              \endif<CR>

let g:pymode_rope = !empty(finddir('.git', '.;'))
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 0
let g:pymode_syntax_print_as_function = 1
let g:pymode_syntax_string_format = 0
let g:pymode_syntax_string_templates = 0

" clang_complete support
let s:clang_library_path=""
if has('mac')
  let s:clang_library_path=glob("/usr/local/opt/llvm/lib/libclang.dylib")
else
  let s:clang_library_path=glob("/usr/lib/x86_64-linux-gnu/libclang*.so*")
endif
if !empty(s:clang_library_path)
  let g:clang_library_path=s:clang_library_path
endif
unlet s:clang_library_path

nnoremap <Leader>d  :YcmCompleter GetDoc<CR>
nnoremap <Leader>]  :YcmCompleter GoTo<CR>
nnoremap <Leader>gt :YcmCompleter GoTo<CR>
nnoremap <Leader>fi :YcmCompleter FixIt<CR>
nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <Leader>gh :YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>
nmap     <Leader>ho <plug>(YCMHover)
let g:ycm_use_clangd = 1
let g:ycm_auto_hover = ''
let g:ycm_complete_in_comments = 1
let g:ycm_goto_buffer_command = 'split-or-existing-window'
let g:ycm_key_invoke_completion = '<C-Z>'
let g:ycm_filetype_whitelist = {
  \ 'sh': 1,
  \ 'bash': 1,
  \ 'zsh': 1,
  \ 'c': 1,
  \ 'cpp': 1,
  \ 'dart': 1,
  \ 'go': 1,
  \ 'python' : 1,
  \ 'ruby': 1,
  \ 'vim': 1,
  \ }
let g:ycm_semantic_triggers = {
  \ 'sh,bash,zsh': ['re!\w{2}'],
  \ 'c,cpp,dart,go': ['re!\w{2}'],
  \ 'python,ruby,vim': ['re!\w{2}'],
  \ }
let s:lsp_generated =
  \ glob('~/.vim/pack/minpac/start/lsp-examples/vimrc.generated')
if !empty(glob(s:lsp_generated))
  exec 'source ' . s:lsp_generated
endif
unlet s:lsp_generated

noremap <Leader>f :Files<CR>

nnoremap <Leader>ut :UndotreeToggle<CR>

if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif

let g:NERDTreeShowBookmarks = 1
let g:NERDTreeHijackNetrw = 0
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>

nnoremap <Leader>af :Autoformat<CR>
vnoremap <Leader>af :Autoformat<CR>

let g:ale_linters = {
  \ 'python': ['pylint'],
  \ 'c': [],
  \ 'cpp': [],
  \ }

if has('mac')
  " <M-p>
  let g:AutoPairsShortcutToggle = 'π'
endif
nnoremap <Leader>pt :call AutoPairsToggle()<CR>
let g:AutoPairsMapCR = 0
imap <silent> <CR> <cR><Plug>AutoPairsReturn

xmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

let g:copy_as_rtf_silence_on_errors = 1

if !has('gui_running')
  let g:NERDMenuMode = 0
endif

if empty(glob('~/.vim/pack/minpac/opt/minpac'))
  silent !git clone https://github.com/k-takata/minpac.git
    \ ~/.vim/pack/minpac/opt/minpac
endif

if has('eval')
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
  command! -nargs=1 RR YcmCompleter RefactorRename <args>
  command! AutoPairsToggle call AutoPairsToggle()
endif

if exists('*minpac#init')
  " Minpac is loaded.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Appearance
  call minpac#add('frazrepo/vim-rainbow')
  call minpac#add('vim-airline/vim-airline')

  " Colors
  call minpac#add('flazz/vim-colorschemes')
  call minpac#add('vim-scripts/ScrollColors')
  call minpac#add('vim-scripts/SyntaxAttr.vim')

  " Snippets
  call minpac#add('SirVer/ultisnips')
  call minpac#add('honza/vim-snippets')

  " Text objects
  call minpac#add('kana/vim-textobj-user')
  call minpac#add('kana/vim-textobj-entire')
  call minpac#add('kana/vim-textobj-function')
  call minpac#add('kana/vim-textobj-indent')
  call minpac#add('sgur/vim-textobj-parameter')

  " Tags
  call minpac#add('ludovicchabant/vim-gutentags')
  call minpac#add('majutsushi/tagbar')
  call minpac#add('mbbill/echofunc')

  " Git
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('shumphrey/fugitive-gitlab.vim')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-rhubarb')

  " Run
  call minpac#add('janko/vim-test')
  call minpac#add('skywind3000/asyncrun.vim')

  " Language support
  call minpac#add('ycm-core/YouCompleteMe')
  call minpac#add('ycm-core/lsp-examples')
  " C-family
  call minpac#add('adah1972/cscope_maps.vim')
  call minpac#add('xavierd/clang_complete')
  call minpac#add('adah1972/ycmconf')
  " Python
  call minpac#add('python-mode/python-mode')
  " Dart
  call minpac#add('dart-lang/dart-vim-plugin')
  call minpac#add('thosakwe/vim-flutter')
  " Ruby
  call minpac#add('vim-ruby/vim-ruby')
  call minpac#add('tpope/vim-endwise')
  call minpac#add('tpope/vim-bundler')

  " Explore
  call minpac#add('easymotion/vim-easymotion')
  call minpac#add('junegunn/fzf', {'do': {-> fzf#install()}})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('mbbill/undotree')
  call minpac#add('mileszs/ack.vim')
  call minpac#add('preservim/nerdtree')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('tpope/vim-vinegar')
  call minpac#add('vim-scripts/BufOnly.vim')
  call minpac#add('yegappan/mru')

  " Edit
  call minpac#add('Chiel92/vim-autoformat')
  call minpac#add('dense-analysis/ale')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('junegunn/vim-easy-align')
  call minpac#add('mg979/vim-visual-multi')
  call minpac#add('preservim/nerdcommenter')
  call minpac#add('qpkorr/vim-renamer')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-obsession')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-surround')

  " Writing
  call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! | call mkdp#util#install()'})
  call minpac#add('junegunn/goyo.vim')
  call minpac#add('adah1972/vim-copy-as-rtf')

  " Others
  call minpac#add('mattn/calendar-vim')
  call minpac#add('rizzatti/dash.vim')
  call minpac#add('uguu-org/vim-matrix-screensaver')
  call minpac#add('vim-scripts/LargeFile')
  call minpac#add('vim/killersheep')
  call minpac#add('yianwillis/vimcdoc', {'type': 'opt'})
endif
